
CLASS ltcl_multiply DEFINITION FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test IMPORTING iv_x             TYPE string
                     iv_y             TYPE string
                     iv_mod           TYPE string
           RETURNING VALUE(rv_result) TYPE string.

    METHODS:
      multiply1 FOR TESTING,
      multiply2 FOR TESTING,
      multiply3 FOR TESTING.

ENDCLASS.       "ltcl_Multiply

CLASS ltcl_multiply IMPLEMENTATION.

  METHOD test.

    DATA: lo_x    TYPE REF TO zcl_abappgp_integer,
          lo_y    TYPE REF TO zcl_abappgp_integer,
          lo_mod  TYPE REF TO zcl_abappgp_integer,
          lo_mont TYPE REF TO zcl_abappgp_montgomery,
          lo_mx   TYPE REF TO zcl_abappgp_montgomery_integer,
          lo_my   TYPE REF TO zcl_abappgp_montgomery_integer,
          lo_mres TYPE REF TO zcl_abappgp_montgomery_integer.


    lo_x = zcl_abappgp_integer=>from_string( iv_x ).
    lo_y = zcl_abappgp_integer=>from_string( iv_y ).
    lo_mod = zcl_abappgp_integer=>from_string( iv_mod ).

    CREATE OBJECT lo_mont
      EXPORTING
        io_modulus = lo_mod.

    lo_mx = lo_mont->build( lo_x ).
    lo_my = lo_mont->build( lo_y ).

    lo_mres = lo_mont->multiply( io_x = lo_mx
                                 io_y = lo_my ).

    rv_result = lo_mont->unbuild( lo_mres )->to_string( ).

  ENDMETHOD.

  METHOD multiply1.

    DATA: lv_result TYPE string.

    lv_result = test( iv_x   = '124'
                      iv_y   = '154'
                      iv_mod = '13' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '12' ).

  ENDMETHOD.

  METHOD multiply2.

    DATA: lv_result TYPE string.

    lv_result = test( iv_x   = '1334'
                      iv_y   = '1234'
                      iv_mod = '25' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '6' ).

  ENDMETHOD.

  METHOD multiply3.

    DATA: lv_result TYPE string.

    lv_result = test( iv_x   = '45454545'
                      iv_y   = '3232323'
                      iv_mod = '125' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '35' ).

  ENDMETHOD.

ENDCLASS.