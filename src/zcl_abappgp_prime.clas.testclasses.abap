
CLASS ltcl_prime DEFINITION FOR TESTING
    DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      check5 FOR TESTING,
      check6 FOR TESTING.

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


    CREATE OBJECT lo_integer
      EXPORTING
        iv_integer = iv_str.

    lv_bool = zcl_abappgp_prime=>check( lo_integer ).

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

  METHOD check5.

    test_true( '5' ).

  ENDMETHOD.

  METHOD check6.

    test_false( '6' ).

  ENDMETHOD.

ENDCLASS.