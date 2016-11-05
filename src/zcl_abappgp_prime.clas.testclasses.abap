
CLASS ltcl_prime DEFINITION FOR TESTING
    DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      check0 FOR TESTING,
      check1 FOR TESTING,
      check5 FOR TESTING,
      check6 FOR TESTING,
      check97 FOR TESTING,
      check99 FOR TESTING,
      check44377 FOR TESTING,
      check44449 FOR TESTING,
      check5915587277 FOR TESTING.

    METHODS:
      test IMPORTING iv_str      TYPE string
                     iv_expected TYPE abap_bool,
      test_true IMPORTING iv_str TYPE string,
      test_false IMPORTING iv_str TYPE string.

ENDCLASS.       "ltcl_Prime

CLASS ltcl_prime IMPLEMENTATION.

  METHOD test.

    DATA: lv_bool    TYPE abap_bool,
          lo_integer TYPE REF TO zcl_abappgp_integer.


    lo_integer = zcl_abappgp_integer=>from_string( iv_str ).

    lv_bool = zcl_abappgp_prime=>check(
      iv_iterations = 10
      io_integer    = lo_integer ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_bool
      exp = iv_expected ).

  ENDMETHOD.

  METHOD test_true.

    test( iv_str      = iv_str
          iv_expected = abap_true ).

  ENDMETHOD.

  METHOD test_false.

    test( iv_str      = iv_str
          iv_expected = abap_false ).

  ENDMETHOD.

  METHOD check0.
    test_false( '0' ).
  ENDMETHOD.

  METHOD check1.
    test_false( '1' ).
  ENDMETHOD.

  METHOD check5.
    test_true( '5' ).
  ENDMETHOD.

  METHOD check6.
    test_false( '6' ).
  ENDMETHOD.

  METHOD check97.
    test_true( '97' ).
  ENDMETHOD.

  METHOD check99.
    test_false( '99' ).
  ENDMETHOD.

  METHOD check44377.
    test_false( '44377' ).
  ENDMETHOD.

  METHOD check44449.
    test_true( '44449' ).
  ENDMETHOD.

  METHOD check5915587277.
    test_true( '5915587277' ).
  ENDMETHOD.

ENDCLASS.