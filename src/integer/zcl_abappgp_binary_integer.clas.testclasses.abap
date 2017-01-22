CLASS ltcl_and DEFINITION FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS
    FINAL.

  PRIVATE SECTION.
    METHODS:
      and1 FOR TESTING,
      and2 FOR TESTING,
      and3 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1           TYPE string
                     iv_op2           TYPE string
           RETURNING VALUE(rv_result) TYPE string.

ENDCLASS.       "ltcl_Get

CLASS ltcl_and IMPLEMENTATION.

  METHOD test.

    DATA: lo_binary1  TYPE REF TO zcl_abappgp_binary_integer,
          lo_binary2  TYPE REF TO zcl_abappgp_binary_integer.


    lo_binary1 = zcl_abappgp_binary_integer=>from_string( iv_op1 ).
    lo_binary2 = zcl_abappgp_binary_integer=>from_string( iv_op2 ).

    rv_result = lo_binary1->and( lo_binary2 )->to_string( ).

  ENDMETHOD.

  METHOD and1.

    DATA: lv_result TYPE string.

    lv_result = test( iv_op1 = '16'
                      iv_op2 = '16' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '16' ).

  ENDMETHOD.

  METHOD and2.

    DATA: lv_result TYPE string.

    lv_result = test( iv_op1 = '32'
                      iv_op2 = '16' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '0' ).

  ENDMETHOD.

  METHOD and3.

    DATA: lv_result TYPE string.

    lv_result = test( iv_op1 = '48'
                      iv_op2 = '16' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '16' ).

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_mod DEFINITION FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS
    FINAL.

  PRIVATE SECTION.
    METHODS:
      mod1 FOR TESTING.

    METHODS:
      test IMPORTING iv_str           TYPE string
           RETURNING VALUE(rv_result) TYPE i.

ENDCLASS.       "ltcl_Get

CLASS ltcl_mod IMPLEMENTATION.

  METHOD test.

    DATA: lo_binary  TYPE REF TO zcl_abappgp_binary_integer.


    lo_binary = zcl_abappgp_binary_integer=>from_string( iv_str ).
    rv_result = lo_binary->mod_2( ).

  ENDMETHOD.

  METHOD mod1.

    DATA: lv_result TYPE i.

    lv_result = test( '3' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = 1 ).

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_shift_right DEFINITION FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS
    FINAL.

  PRIVATE SECTION.
    METHODS:
      shift1 FOR TESTING.

    METHODS:
      test IMPORTING iv_str        TYPE string
           RETURNING VALUE(rv_str) TYPE string.

ENDCLASS.       "ltcl_Get

CLASS ltcl_shift_right IMPLEMENTATION.

  METHOD test.

    DATA: lo_binary TYPE REF TO zcl_abappgp_binary_integer.


    lo_binary = zcl_abappgp_binary_integer=>from_string( iv_str ).
    lo_binary->shift_right( ).
    rv_str = lo_binary->to_string( ).

  ENDMETHOD.

  METHOD shift1.

    DATA: lv_result TYPE string.

    lv_result = test( '16' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '8' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_identity DEFINITION FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS
    FINAL.

  PRIVATE SECTION.
    METHODS:
      identity1 FOR TESTING,
      identity2 FOR TESTING,
      identity3 FOR TESTING,
      identity4 FOR TESTING.

    METHODS: test IMPORTING iv_input TYPE string.

ENDCLASS.       "ltcl_Get

CLASS ltcl_identity IMPLEMENTATION.

  METHOD test.

    DATA: lo_binary  TYPE REF TO zcl_abappgp_binary_integer.


    lo_binary = zcl_abappgp_binary_integer=>from_string( iv_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_binary->to_string( )
      exp = iv_input ).

  ENDMETHOD.

  METHOD identity1.
    test( '16' ).
  ENDMETHOD.

  METHOD identity2.
    test( '8191' ).
  ENDMETHOD.

  METHOD identity3.
    test( '8192' ).
  ENDMETHOD.

  METHOD identity4.
    test( '123456789' ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_to_binary_string DEFINITION FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS
    FINAL.

  PRIVATE SECTION.
    METHODS:
      get1 FOR TESTING,
      get2 FOR TESTING,
      get3 FOR TESTING,
      get4 FOR TESTING,
      get5 FOR TESTING,
      get6 FOR TESTING,
      get7 FOR TESTING,
      get8 FOR TESTING.

    METHODS: test IMPORTING iv_str           TYPE string
                  RETURNING VALUE(rv_binary) TYPE string.

ENDCLASS.       "ltcl_Get

CLASS ltcl_to_binary_string IMPLEMENTATION.

  METHOD test.

    DATA: lo_binary TYPE REF TO zcl_abappgp_binary_integer.


    lo_binary = zcl_abappgp_binary_integer=>from_string( iv_str ).
    rv_binary = lo_binary->to_binary_string( ).

  ENDMETHOD.

  METHOD get1.

    DATA: lv_binary TYPE string.

    lv_binary = test( '16' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_binary
      exp = '10000' ).

  ENDMETHOD.

  METHOD get2.

    DATA: lv_binary TYPE string.

    lv_binary = test( '1234' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_binary
      exp = '10011010010' ).

  ENDMETHOD.

  METHOD get3.

    DATA: lv_binary TYPE string.

    lv_binary = test( '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_binary
      exp = '1' ).

  ENDMETHOD.

  METHOD get4.

    DATA: lv_binary TYPE string.

    lv_binary = test( '8191' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_binary
      exp = '1111111111111' ).

  ENDMETHOD.

  METHOD get5.

    DATA: lv_binary TYPE string.

    lv_binary = test( '8192' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_binary
      exp = '10000000000000' ).

  ENDMETHOD.

  METHOD get6.

    DATA: lv_binary TYPE string.

    lv_binary = test( '8193' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_binary
      exp = '10000000000001' ).

  ENDMETHOD.

  METHOD get7.

    DATA: lv_binary TYPE string.

    lv_binary = test( '9000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_binary
      exp = '10001100101000' ).

  ENDMETHOD.

  METHOD get8.

    DATA: lv_binary TYPE string.

    lv_binary = test( '10000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_binary
      exp = '10011100010000' ).

  ENDMETHOD.

ENDCLASS.
