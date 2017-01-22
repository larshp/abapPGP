
CLASS ltcl_prime DEFINITION FOR TESTING
    DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      check1 FOR TESTING,
      check2 FOR TESTING,
      check3 FOR TESTING,
      check4 FOR TESTING,
      check5 FOR TESTING,
      check6 FOR TESTING,
      check7 FOR TESTING,
      check8 FOR TESTING,
      check9 FOR TESTING,
      check10 FOR TESTING.

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
      iv_iterations = 20
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

  METHOD check1.
    test_false( '0' ).
  ENDMETHOD.

  METHOD check2.
    test_false( '1' ).
  ENDMETHOD.

  METHOD check3.
    test_true( '5' ).
  ENDMETHOD.

  METHOD check4.
    test_false( '6' ).
  ENDMETHOD.

  METHOD check5.
    test_true( '97' ).
  ENDMETHOD.

  METHOD check6.
    test_false( '99' ).
  ENDMETHOD.

  METHOD check7.
    test_false( '44377' ).
  ENDMETHOD.

  METHOD check8.
    test_true( '44449' ).
  ENDMETHOD.

  METHOD check9.
    test_true( '5915587277' ).
  ENDMETHOD.

  METHOD check10.
    test_true( '48112959837082048697' ).
  ENDMETHOD.

ENDCLASS.
