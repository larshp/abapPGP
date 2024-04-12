CLASS ltcl_shift_left DEFINITION FOR TESTING
    DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      shift1 FOR TESTING,
      shift2 FOR TESTING,
      shift3 FOR TESTING.

    METHODS:
      test IMPORTING iv_str   TYPE string
                     iv_exp   TYPE string
                     iv_times TYPE i DEFAULT 1.

ENDCLASS.       "ltcl_Get

CLASS ltcl_shift_left IMPLEMENTATION.

  METHOD test.

    DATA: lv_result TYPE string.


    lv_result = zcl_abappgp_integer2=>from_string( iv_str )->shift_left( iv_times )->to_string( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = iv_exp ).

  ENDMETHOD.

  METHOD shift1.
    test( iv_str = '16'
          iv_exp = '32' ).
  ENDMETHOD.

  METHOD shift2.
    test( iv_str = '5'
          iv_exp = '10' ).
  ENDMETHOD.

  METHOD shift3.
    test( iv_str = '8192'
          iv_exp = '16384' ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_shift_right DEFINITION FOR TESTING
    DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      shift1 FOR TESTING,
      shift2 FOR TESTING,
      shift3 FOR TESTING,
      shift4 FOR TESTING,
      shift5 FOR TESTING.

    METHODS:
      test IMPORTING iv_str   TYPE string
                     iv_exp   TYPE string
                     iv_times TYPE i DEFAULT 1.

ENDCLASS.       "ltcl_Get

CLASS ltcl_shift_right IMPLEMENTATION.

  METHOD test.

    DATA: lv_result TYPE string.


    lv_result = zcl_abappgp_integer2=>from_string( iv_str )->shift_right( iv_times )->to_string( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = iv_exp ).

  ENDMETHOD.

  METHOD shift1.
    test( iv_str = '16'
          iv_exp = '8' ).
  ENDMETHOD.

  METHOD shift2.
    test( iv_str = '5'
          iv_exp = '2' ).
  ENDMETHOD.

  METHOD shift3.
    test( iv_str = '8192'
          iv_exp = '4096' ).
  ENDMETHOD.

  METHOD shift4.
    test( iv_str   = '8192'
          iv_exp = '1'
          iv_times = 13 ).
  ENDMETHOD.

  METHOD shift5.
    test( iv_str   = '8191'
          iv_exp   = '0'
          iv_times = 13 ).
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
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer2.

ENDCLASS.

CLASS ltcl_subtract IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer2.


    ro_int = zcl_abappgp_integer2=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer2=>from_string( iv_op2 ).

    ro_int = ro_int->subtract( lo_var2 ).

  ENDMETHOD.

  METHOD subtract1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '10'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '9' ).

  ENDMETHOD.

  METHOD subtract4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '10000'
                   iv_op2 = '10000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '10000'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '9999' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_gt DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      gt1 FOR TESTING,
      gt2 FOR TESTING,
      gt3 FOR TESTING,
      gt4 FOR TESTING,
      gt5 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1         TYPE string
                     iv_op2         TYPE string
           RETURNING VALUE(rv_bool) TYPE abap_bool.

ENDCLASS.

CLASS ltcl_gt IMPLEMENTATION.

  METHOD test.

    DATA: lo_var1 TYPE REF TO zcl_abappgp_integer2,
          lo_var2 TYPE REF TO zcl_abappgp_integer2.


    lo_var1 = zcl_abappgp_integer2=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer2=>from_string( iv_op2 ).

    rv_bool = lo_var1->is_gt( lo_var2 ).

  ENDMETHOD.

  METHOD gt1.

    DATA: lv_gt TYPE abap_bool.


    lv_gt = test( iv_op1 = '0'
                  iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_false ).

  ENDMETHOD.

  METHOD gt2.

    DATA: lv_gt TYPE abap_bool.


    lv_gt = test( iv_op1 = '1'
                  iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_true ).

  ENDMETHOD.

  METHOD gt3.

    DATA: lv_gt TYPE abap_bool.


    lv_gt = test( iv_op1 = '10000'
                  iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_true ).

  ENDMETHOD.

  METHOD gt4.

    DATA: lv_gt TYPE abap_bool.


    lv_gt = test( iv_op1 = '10000'
                  iv_op2 = '10000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_false ).

  ENDMETHOD.

  METHOD gt5.

    DATA: lv_gt TYPE abap_bool.


    lv_gt = test( iv_op1 = '30514335'
                  iv_op2 = '44449' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_true ).

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
      multiply6 FOR TESTING,
      multiply7 FOR TESTING,
      multiply8 FOR TESTING,
      multiply9 FOR TESTING,
      multiply10 FOR TESTING,
      multiply14 FOR TESTING,
      multiply15 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer2.

ENDCLASS.

CLASS ltcl_multiply IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer2.


    ro_int = zcl_abappgp_integer2=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer2=>from_string( iv_op2 ).

    ro_int->multiply( lo_var2 ).

  ENDMETHOD.

  METHOD multiply1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD multiply2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD multiply3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD multiply4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '2'
                   iv_op2 = '3' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '6' ).

  ENDMETHOD.

  METHOD multiply5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1234321' ).

  ENDMETHOD.

  METHOD multiply6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '9999'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '99980001' ).

  ENDMETHOD.

  METHOD multiply7.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.

    lo_res = test( iv_op1 = '500'
                   iv_op2 = '50000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '25000000' ).

  ENDMETHOD.

  METHOD multiply8.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.

    lo_res = test( iv_op1 = '30558784'
                   iv_op2 = '44449' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1358307390016' ).

  ENDMETHOD.

  METHOD multiply9.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.

    lo_res = test( iv_op1 = '100000'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD multiply10.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.

    lo_res = test( iv_op1 = '7777777777'
                   iv_op2 = '6666666666' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '51851851841481481482' ).

  ENDMETHOD.


  METHOD multiply14.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.

    lo_res = test( iv_op1 = '999999999999999'
                   iv_op2 = '999999999999999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '999999999999998000000000000001' ).

  ENDMETHOD.

  METHOD multiply15.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.

    lo_res = test( iv_op1 = '9999999999999990'
                   iv_op2 = '9999999999999990' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '99999999999999800000000000000100' ).

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
      add7 FOR TESTING,
      add8 FOR TESTING,
      add9 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer2.

ENDCLASS.       "ltcl_Add

CLASS ltcl_add IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer2.


    ro_int = zcl_abappgp_integer2=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer2=>from_string( iv_op2 ).

    ro_int = ro_int->add( lo_var2 ).

  ENDMETHOD.

  METHOD add1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '2' ).

  ENDMETHOD.

  METHOD add2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD add3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '2222' ).

  ENDMETHOD.

  METHOD add4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '111111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '112222' ).

  ENDMETHOD.

  METHOD add5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '111111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '112222' ).

  ENDMETHOD.

  METHOD add6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '10000' ).

  ENDMETHOD.

  METHOD add7.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '99980001'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '99980002' ).

  ENDMETHOD.

  METHOD add8.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '111111111111111111111'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '111111111111111111112' ).

  ENDMETHOD.

  METHOD add9.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer2.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '111111111111111111111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '111111111111111111112' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_multiply_karatsuba DEFINITION FOR TESTING
    DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      karatsuba1 FOR TESTING,
      karatsuba2 FOR TESTING,
      karatsuba3 FOR TESTING,
      karatsuba4 FOR TESTING,
      karatsuba5 FOR TESTING,
      karatsuba6 FOR TESTING,
      karatsuba7 FOR TESTING,
      karatsuba8 FOR TESTING,
      karatsuba9 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1 TYPE string
                     iv_op2 TYPE string
                     iv_exp TYPE string.

ENDCLASS.

CLASS ltcl_multiply_karatsuba IMPLEMENTATION.

  METHOD test.

    DATA: lo_var1 TYPE REF TO zcl_abappgp_integer2,
          lo_var2 TYPE REF TO zcl_abappgp_integer2.


    lo_var1 = zcl_abappgp_integer2=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer2=>from_string( iv_op2 ).
    lo_var1->multiply_karatsuba( io_integer  = lo_var2
                                 iv_fallback = 2 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_var1->to_string( )
      exp = iv_exp ).

  ENDMETHOD.

  METHOD karatsuba1.
    test( iv_op1 = '1'
          iv_op2 = '1'
          iv_exp = '1' ).
  ENDMETHOD.

  METHOD karatsuba2.
    test( iv_op1 = '11112222'
          iv_op2 = '33334444'
          iv_exp = '370419741974568' ).
  ENDMETHOD.


  METHOD karatsuba3.
    test( iv_op1 = '1111'
          iv_op2 = '1111'
          iv_exp = '1234321' ).
  ENDMETHOD.

  METHOD karatsuba4.
    test( iv_op1 = '9999'
          iv_op2 = '9999'
          iv_exp = '99980001' ).
  ENDMETHOD.

  METHOD karatsuba5.
    test( iv_op1 = '500'
          iv_op2 = '50000'
          iv_exp = '25000000' ).
  ENDMETHOD.

  METHOD karatsuba6.
    test( iv_op1 = '30558784'
          iv_op2 = '44449'
          iv_exp = '1358307390016' ).
  ENDMETHOD.

  METHOD karatsuba7.
    test( iv_op1 = '100000'
          iv_op2 = '0'
          iv_exp = '0' ).
  ENDMETHOD.

  METHOD karatsuba8.
    test( iv_op1 = '7777777777'
          iv_op2 = '6666666666'
          iv_exp = '51851851841481481482' ).
  ENDMETHOD.

  METHOD karatsuba9.
    test( iv_op1 = '11117777777777'
          iv_op2 = '22226666666666'
          iv_exp = '247111140740716041481481482' ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_and DEFINITION FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS
    FINAL.

  PRIVATE SECTION.
    METHODS:
      and1 FOR TESTING,
      and2 FOR TESTING,
      and3 FOR TESTING,
      and4 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1           TYPE string
                     iv_op2           TYPE string
           RETURNING VALUE(rv_result) TYPE string.

ENDCLASS.       "ltcl_Get

CLASS ltcl_and IMPLEMENTATION.

  METHOD test.

    DATA: lo_binary1  TYPE REF TO zcl_abappgp_integer2,
          lo_binary2  TYPE REF TO zcl_abappgp_integer2.


    lo_binary1 = zcl_abappgp_integer2=>from_string( iv_op1 ).
    lo_binary2 = zcl_abappgp_integer2=>from_string( iv_op2 ).

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

  METHOD and4.

    DATA: lv_result TYPE string.

    lv_result = test( iv_op1 = '8191'
                      iv_op2 = '8192' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '0' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_binary_length DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      length1 FOR TESTING,
      length2 FOR TESTING,
      length3 FOR TESTING.

    METHODS: test
      IMPORTING iv_string TYPE string
      iv_expected TYPE i.

ENDCLASS.

CLASS ltcl_binary_length IMPLEMENTATION.

  METHOD test.

    DATA: lo_var1   TYPE REF TO zcl_abappgp_integer2,
          lv_result TYPE i.


    lo_var1 = zcl_abappgp_integer2=>from_string( iv_string ).
    lv_result = lo_var1->get_binary_length( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = iv_expected ).

  ENDMETHOD.

  METHOD length1.
    test( iv_string   = '8191'
          iv_expected = 13 ).
  ENDMETHOD.

  METHOD length2.
    test( iv_string   = '8192'
          iv_expected = 14 ).
  ENDMETHOD.

  METHOD length3.
    test( iv_string   = '1'
          iv_expected = 1 ).
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
      id6 FOR TESTING,
      id7 FOR TESTING,
      id8 FOR TESTING.

    METHODS: test IMPORTING iv_string TYPE string.

ENDCLASS.

CLASS ltcl_identity IMPLEMENTATION.

  METHOD test.

    DATA: lo_var1   TYPE REF TO zcl_abappgp_integer2,
          lv_result TYPE string.


    lo_var1 = zcl_abappgp_integer2=>from_string( iv_string ).

    lv_result = lo_var1->to_string( ).

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
    test( '8191' ).
  ENDMETHOD.

  METHOD id4.
    test( '8192' ).
  ENDMETHOD.

  METHOD id5.
    test( '123456789123456789' ).
  ENDMETHOD.

  METHOD id6.
    test( '1000000000000000000000000009' ).
  ENDMETHOD.

  METHOD id7.
    test( '10000000000000000000000000009' ).
  ENDMETHOD.

  METHOD id8.
    test( '12345678' ).
  ENDMETHOD.

ENDCLASS.
