class ZCL_ABAPPGP_RSA definition
  public
  create public .

public section.

  class-methods GENERATE_KEY_PAIR
    importing
      !IO_P type ref to ZCL_ABAPPGP_INTEGER
      !IO_Q type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_PAIR) type ref to ZCL_ABAPPGP_RSA_KEY_PAIR .
  class-methods ENCRYPT
    importing
      !IO_PLAIN type ref to ZCL_ABAPPGP_INTEGER
      !IO_PUBLIC type ref to ZCL_ABAPPGP_RSA_PUBLIC_KEY
    returning
      value(RO_ENCRYPTED) type ref to ZCL_ABAPPGP_INTEGER .
  class-methods DECRYPT
    importing
      !IO_ENCRYPTED type ref to ZCL_ABAPPGP_INTEGER
      !IO_PRIVATE type ref to ZCL_ABAPPGP_RSA_PRIVATE_KEY
    returning
      value(RO_PLAIN) type ref to ZCL_ABAPPGP_INTEGER .
protected section.

  class-methods FIND_COPRIME
    importing
      !IO_INPUT type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_COPRIME) type ref to ZCL_ABAPPGP_INTEGER .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_RSA IMPLEMENTATION.


  METHOD decrypt.

    ro_plain = io_encrypted->clone( )->modular_pow_montgomery(
      io_exponent = io_private->get_d( )
      io_modulus  = io_private->get_n( ) ).

  ENDMETHOD.


  METHOD encrypt.

    ro_encrypted = io_plain->clone( )->modular_pow_montgomery(
      io_exponent = io_public->get_e( )
      io_modulus  = io_public->get_n( ) ).

  ENDMETHOD.


  METHOD find_coprime.
* https://en.wikipedia.org/wiki/Coppersmith%27s_attack
* http://crypto.stackexchange.com/questions/3110/impacts-of-not-using-rsa-exponent-of-65537

    DATA: lo_one    TYPE REF TO zcl_abappgp_integer,
          lo_result TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_one
      EXPORTING
        iv_integer = 1.

    ro_coprime = zcl_abappgp_integer=>from_string( '65537' ).
    IF ro_coprime->is_gt( io_input ) = abap_true.
      ro_coprime = zcl_abappgp_integer=>from_string( '2' ).
    ENDIF.

    DO 99999 TIMES.
      lo_result = io_input->clone( )->gcd( ro_coprime ).
      IF lo_result->is_one( ) = abap_true.
        RETURN.
      ENDIF.
      ro_coprime = ro_coprime->add( lo_one ).
    ENDDO.

    ASSERT 0 = 1.

  ENDMETHOD.


  METHOD generate_key_pair.

    DATA: lo_one     TYPE REF TO zcl_abappgp_integer,
          lo_m       TYPE REF TO zcl_abappgp_integer,
          lo_n       TYPE REF TO zcl_abappgp_integer,
          lo_u       TYPE REF TO zcl_abappgp_integer,
          lo_e       TYPE REF TO zcl_abappgp_integer,
          lo_d       TYPE REF TO zcl_abappgp_integer,
          lo_private TYPE REF TO zcl_abappgp_rsa_private_key,
          lo_public  TYPE REF TO zcl_abappgp_rsa_public_key.


    ASSERT io_p->is_lt( io_q ).

    CREATE OBJECT lo_one
      EXPORTING
        iv_integer = 1.

    lo_n = io_p->clone( )->multiply( io_q ).
* totient:
    lo_m = io_p->clone( )->subtract( lo_one )->multiply(
      io_q->clone( )->subtract( lo_one ) ).

    lo_e = find_coprime( lo_m ).

    zcl_abappgp_integer=>extended_gcd(
      EXPORTING
        io_a      = lo_e
        io_b      = lo_m
      IMPORTING
        eo_coeff1 = lo_d ).
    IF lo_d->is_negative( ) = abap_true.
      lo_d = lo_d->add( lo_m ).
    ENDIF.

    zcl_abappgp_integer=>extended_gcd(
      EXPORTING
        io_a      = io_p
        io_b      = io_q
      IMPORTING
        eo_coeff1 = lo_u ).
    IF lo_u->is_negative( ) = abap_true.
      lo_u = lo_u->add( io_q ).
    ENDIF.

* todo:
* q (p < q)

    CREATE OBJECT lo_private
      EXPORTING
        io_d = lo_d
        io_p = io_p
        io_q = io_q
        io_u = lo_u.

    CREATE OBJECT lo_public
      EXPORTING
        io_n = lo_n
        io_e = lo_e.

    CREATE OBJECT ro_pair
      EXPORTING
        io_private = lo_private
        io_public  = lo_public.

  ENDMETHOD.
ENDCLASS.