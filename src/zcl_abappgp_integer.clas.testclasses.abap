CLASS ltcl_mod DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      mod1 FOR TESTING,
      mod2 FOR TESTING,
      mod3 FOR TESTING,
      mod4 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_mod IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT ro_int
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    ro_int->mod( lo_var2 ).

  ENDMETHOD.

  METHOD mod1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD mod2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1' ).

  ENDMETHOD.

  METHOD mod3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '9999'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD mod4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10009'
                   iv_op2 = '10' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '9' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_divide DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      divide1 FOR TESTING,
      divide2 FOR TESTING,
      divide3 FOR TESTING,
      divide4 FOR TESTING,
      divide5 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_divide IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT ro_int
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    ro_int->divide( lo_var2 ).

  ENDMETHOD.

  METHOD divide1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1' ).

  ENDMETHOD.

  METHOD divide2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '123456'
                   iv_op2 = '123456' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1' ).

  ENDMETHOD.

  METHOD divide3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '2' ).

  ENDMETHOD.

  METHOD divide4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '555555'
                   iv_op2 = '111111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '5' ).

  ENDMETHOD.

  METHOD divide5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '2' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_gt DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      gt1 FOR TESTING,
      gt2 FOR TESTING,
      gt3 FOR TESTING,
      gt4 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1         TYPE string
                     iv_op2         TYPE string
           RETURNING VALUE(rv_bool) TYPE abap_bool.

ENDCLASS.

CLASS ltcl_gt IMPLEMENTATION.

  METHOD test.

    DATA: lo_var1 TYPE REF TO zcl_abappgp_integer,
          lo_var2 TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT lo_var1
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    rv_bool = lo_var1->gt( lo_var2 ).

  ENDMETHOD.

  METHOD gt1.

    DATA: lv_gt TYPE bool.


    lv_gt = test( iv_op1 = '0'
                  iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_false ).

  ENDMETHOD.

  METHOD gt2.

    DATA: lv_gt TYPE bool.


    lv_gt = test( iv_op1 = '1'
                  iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_true ).

  ENDMETHOD.

  METHOD gt3.

    DATA: lv_gt TYPE bool.


    lv_gt = test( iv_op1 = '10000'
                  iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_true ).

  ENDMETHOD.

  METHOD gt4.

    DATA: lv_gt TYPE bool.


    lv_gt = test( iv_op1 = '10000'
                  iv_op2 = '10000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_false ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_power DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      power1 FOR TESTING,
      power2 FOR TESTING,
      power3 FOR TESTING,
      power4 FOR TESTING,
      power5 FOR TESTING,
      power6 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_power IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT ro_int
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    ro_int->power( lo_var2 ).

  ENDMETHOD.

  METHOD power1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1' ).

  ENDMETHOD.

  METHOD power2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1' ).

  ENDMETHOD.

  METHOD power3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '100'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '100' ).

  ENDMETHOD.

  METHOD power4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '100'
                   iv_op2 = '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '10000' ).

  ENDMETHOD.

  METHOD power5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '99'
                   iv_op2 = '3' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '970299' ).

  ENDMETHOD.

  METHOD power6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '99'
                   iv_op2 = '9' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '913517247483640899' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_multiply DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      multiply1 FOR TESTING,
      multiply2 FOR TESTING,
      multiply3 FOR TESTING,
      multiply4 FOR TESTING,
      multiply5 FOR TESTING,
      multiply6 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_multiply IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT ro_int
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    ro_int->multiply( lo_var2 ).

  ENDMETHOD.

  METHOD multiply1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1' ).

  ENDMETHOD.

  METHOD multiply2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD multiply3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD multiply4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '2'
                   iv_op2 = '3' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '6' ).

  ENDMETHOD.

  METHOD multiply5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1234321' ).

  ENDMETHOD.

  METHOD multiply6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '9999'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '99980001' ).

  ENDMETHOD.

ENDCLASS.

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
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_subtract IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT ro_int
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    ro_int->subtract( lo_var2 ).

  ENDMETHOD.

  METHOD subtract1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '9' ).

  ENDMETHOD.

  METHOD subtract4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10000'
                   iv_op2 = '10000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


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
      add6 FOR TESTING,
      add7 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.       "ltcl_Add

CLASS ltcl_add IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT ro_int
      EXPORTING
        iv_integer = iv_op1.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = iv_op2.

    ro_int->add( lo_var2 ).

  ENDMETHOD.

  METHOD add1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '2' ).

  ENDMETHOD.

  METHOD add2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '1' ).

  ENDMETHOD.

  METHOD add3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '2222' ).

  ENDMETHOD.

  METHOD add4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '111111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '112222' ).

  ENDMETHOD.

  METHOD add5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '111111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '112222' ).

  ENDMETHOD.

  METHOD add6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '10000' ).

  ENDMETHOD.

  METHOD add7.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '99980001'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->get( )
      exp = '99980002' ).

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

    DATA: lo_var1   TYPE REF TO zcl_abappgp_integer,
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