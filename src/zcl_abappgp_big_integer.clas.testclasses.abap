
CLASS ltcl_subtract DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      subtract1 FOR TESTING,
      subtract2 FOR TESTING,
      subtract3 FOR TESTING,
      subtract4 FOR TESTING,
      subtract5 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_big_integer.

ENDCLASS.

CLASS ltcl_subtract IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_big_integer.

    CREATE OBJECT ro_int
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    ro_int->subtract( lo_var2 ).

  ENDMETHOD.

  METHOD subtract1.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract2.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract3.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '10'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '9' ).

  ENDMETHOD.

  METHOD subtract4.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '10000'
                   iv_op2 = '10000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract5.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '10000'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '9999' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_add DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      add1 FOR TESTING,
      add2 FOR TESTING,
      add3 FOR TESTING,
      add4 FOR TESTING,
      add5 FOR TESTING,
      add6 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_big_integer.

ENDCLASS.       "ltcl_Add

CLASS ltcl_add IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_big_integer.

    CREATE OBJECT ro_int
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    ro_int->add( lo_var2 ).

  ENDMETHOD.

  METHOD add1.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '2' ).

  ENDMETHOD.

  METHOD add2.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1' ).

  ENDMETHOD.

  METHOD add3.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '2222' ).

  ENDMETHOD.

  METHOD add4.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '111111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '112222' ).

  ENDMETHOD.

  METHOD add5.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '111111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '112222' ).

  ENDMETHOD.

  METHOD add6.

    DATA: lo_res TYPE REF TO zcl_abappgp_big_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '10000' ).

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_identity DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      id1 FOR TESTING,
      id2 FOR TESTING,
      id3 FOR TESTING,
      id4 FOR TESTING,
      id5 FOR TESTING,
      id6 FOR TESTING.

    METHODS: test IMPORTING iv_string TYPE string.

ENDCLASS.       "ltcl_Add

CLASS ltcl_identity IMPLEMENTATION.

  METHOD test.

    DATA: lo_var1   TYPE REF TO zcl_abappgp_big_integer,
          lv_result TYPE string.

    CREATE OBJECT lo_var1
      EXPORTING
        iv_integer = iv_string.

    lv_result = lo_var1->get( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = iv_string ).

  ENDMETHOD.

  METHOD id1.

    test( '1' ).

  ENDMETHOD.

  METHOD id2.

    test( '0' ).

  ENDMETHOD.

  METHOD id3.

    test( '123456789123456789' ).

  ENDMETHOD.

  METHOD id4.

    test( '1000000000000000000000000009' ).

  ENDMETHOD.

  METHOD id5.

    test( '10000000000000000000000000009' ).

  ENDMETHOD.

  METHOD id6.

    test( '12345678' ).

  ENDMETHOD.

ENDCLASS.