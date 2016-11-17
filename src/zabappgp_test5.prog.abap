REPORT zabappgp_test5.

PARAMETERS: p_prime1 TYPE text100 OBLIGATORY,
            p_prime2 TYPE text100 OBLIGATORY.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lo_one    TYPE REF TO zcl_abappgp_integer,
        lo_prime1 TYPE REF TO zcl_abappgp_integer,
        lo_prime2 TYPE REF TO zcl_abappgp_integer,
        lo_n      TYPE REF TO zcl_abappgp_integer,
        lo_e      TYPE REF TO zcl_abappgp_integer,
        lo_m      TYPE REF TO zcl_abappgp_integer.


  CREATE OBJECT lo_one
    EXPORTING
      iv_integer = 1.

  lo_prime1 = zcl_abappgp_integer=>from_string( p_prime1 ).
  lo_prime2 = zcl_abappgp_integer=>from_string( p_prime2 ).

  lo_n = lo_prime1->clone( )->multiply( lo_prime2 ).
  lo_m = lo_prime1->clone( )->subtract( lo_one )->multiply( lo_prime2->clone( )->subtract( lo_one ) ).

  PERFORM coprime USING lo_m CHANGING lo_e.

  WRITE: / 'n:', lo_n->to_string( ).
  WRITE: / 'm:', lo_m->to_string( ).
  WRITE: / 'e:', lo_e->to_string( ).

ENDFORM.

FORM coprime USING io_input TYPE REF TO zcl_abappgp_integer
          CHANGING co_coprime TYPE REF TO zcl_abappgp_integer.

  DATA: lo_one    TYPE REF TO zcl_abappgp_integer,
        lo_result TYPE REF TO zcl_abappgp_integer.


  CREATE OBJECT lo_one
    EXPORTING
      iv_integer = 1.

  CREATE OBJECT co_coprime
    EXPORTING
      iv_integer = 2.

  DO 99999 TIMES.
    lo_result = io_input->clone( )->gcd( co_coprime ).
    IF lo_result->is_one( ).
      RETURN.
    ENDIF.
    co_coprime = co_coprime->add( lo_one ).
  ENDDO.

  ASSERT 0 = 1.

ENDFORM.