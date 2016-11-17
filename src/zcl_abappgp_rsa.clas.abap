class ZCL_ABAPPGP_RSA definition
  public
  create public .

public section.

  class-methods GENERATE_KEYS
    importing
      !IO_PRIME1 type ref to ZCL_ABAPPGP_INTEGER
      !IO_PRIME2 type ref to ZCL_ABAPPGP_INTEGER
    exporting
      !EO_N type ref to ZCL_ABAPPGP_INTEGER
      !EO_E type ref to ZCL_ABAPPGP_INTEGER
      !EO_D type ref to ZCL_ABAPPGP_INTEGER .
protected section.

  class-methods FIND_COPRIME
    importing
      !IO_INPUT type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_COPRIME) type ref to ZCL_ABAPPGP_INTEGER .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_RSA IMPLEMENTATION.


  METHOD find_coprime.
* https://en.wikipedia.org/wiki/Coppersmith%27s_attack
* http://crypto.stackexchange.com/questions/3110/impacts-of-not-using-rsa-exponent-of-65537

    DATA: lo_one    TYPE REF TO zcl_abappgp_integer,
          lo_result TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_one
      EXPORTING
        iv_integer = 1.

    ro_coprime = zcl_abappgp_integer=>from_string( '65537' ).
    IF ro_coprime->is_gt( io_input ).
      ro_coprime = zcl_abappgp_integer=>from_string( '2' ).
    ENDIF.

    DO 99999 TIMES.
      lo_result = io_input->clone( )->gcd( ro_coprime ).
      IF lo_result->is_one( ).
        RETURN.
      ENDIF.
      ro_coprime = ro_coprime->add( lo_one ).
    ENDDO.

    ASSERT 0 = 1.

  ENDMETHOD.


  METHOD generate_keys.

    DATA: lo_one TYPE REF TO zcl_abappgp_integer,
          lo_m   TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_one
      EXPORTING
        iv_integer = 1.

    eo_n = io_prime1->clone( )->multiply( io_prime2 ).
    lo_m = io_prime1->clone( )->subtract( lo_one )->multiply( io_prime2->clone( )->subtract( lo_one ) ).

    eo_e = find_coprime( lo_m ).

    zcl_abappgp_integer=>extended_gcd(
      EXPORTING
        io_a      = eo_e
        io_b      = lo_m
      IMPORTING
        eo_coeff1 = eo_d ).
    IF eo_d->is_negative( ) = abap_true.
      eo_d = eo_d->add( lo_m ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.