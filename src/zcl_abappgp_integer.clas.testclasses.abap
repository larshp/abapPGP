CLASS ltcl_mod_inverse DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      mod_inverse1 FOR TESTING,
      mod_inverse2 FOR TESTING,
      mod_inverse3 FOR TESTING.

    METHODS:
      test IMPORTING iv_value         TYPE string
                     iv_mod           TYPE string
           RETURNING VALUE(rv_result) TYPE string.

ENDCLASS.

CLASS ltcl_mod_inverse IMPLEMENTATION.

  METHOD test.

    DATA: lo_value TYPE REF TO zcl_abappgp_integer,
          lo_mod   TYPE REF TO zcl_abappgp_integer.


    lo_value = zcl_abappgp_integer=>from_string( iv_value ).
    lo_mod = zcl_abappgp_integer=>from_string( iv_mod ).

    rv_result = lo_value->mod_inverse( lo_mod )->to_string( ).

  ENDMETHOD.

  METHOD mod_inverse1.

    DATA: lv_result TYPE string.

    lv_result = test( iv_value = '42'
                      iv_mod   = '2017' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '1969' ).

  ENDMETHOD.

  METHOD mod_inverse2.

    DATA: lv_result TYPE string.

    lv_result = test( iv_value = '40'
                      iv_mod   = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '0' ).

  ENDMETHOD.

  METHOD mod_inverse3.

    DATA: lv_result TYPE string.

    lv_result = test( iv_value = '256'
                      iv_mod   = '25' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '21' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_divide_by_2 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      divide1 FOR TESTING,
      divide2 FOR TESTING,
      divide3 FOR TESTING,
      divide4 FOR TESTING.

    METHODS:
      test IMPORTING iv_value      TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_divide_by_2 IMPLEMENTATION.

  METHOD test.

    ro_int = zcl_abappgp_integer=>from_string( iv_value ).
    ro_int->divide_by_2( ).

  ENDMETHOD.

  METHOD divide1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD divide2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD divide3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( '22' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '11' ).

  ENDMETHOD.

  METHOD divide4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( '111222333' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '55611166' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_modular_pow DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      modular_pow1 FOR TESTING,
      modular_pow2 FOR TESTING,
      modular_pow3 FOR TESTING,
      modular_pow4 FOR TESTING.

    METHODS:
      test IMPORTING iv_base       TYPE string
                     iv_exp        TYPE string
                     iv_mod        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_modular_pow IMPLEMENTATION.

  METHOD test.

    DATA: lo_mod   TYPE REF TO zcl_abappgp_integer,
          lo_check TYPE REF TO zcl_abappgp_integer,
          lo_exp   TYPE REF TO zcl_abappgp_integer.


    ro_int = zcl_abappgp_integer=>from_string( iv_base ).
    lo_exp = zcl_abappgp_integer=>from_string( iv_exp ).
    lo_mod = zcl_abappgp_integer=>from_string( iv_mod ).

    ro_int->modular_pow(
      io_exponent = lo_exp
      io_modulus  = lo_mod ).

    IF lo_mod->is_even( ) = abap_false.
      lo_check = zcl_abappgp_integer=>from_string( iv_base ).

      lo_check = lo_check->modular_pow_montgomery(
        io_exponent = lo_exp
        io_modulus  = lo_mod ).

      cl_abap_unit_assert=>assert_equals(
        act = ro_int->to_string( )
        exp = lo_check->to_string( ) ).
    ENDIF.

  ENDMETHOD.

  METHOD modular_pow1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_base = '1'
                   iv_exp = '1'
                   iv_mod = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD modular_pow2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_base = '4'
                   iv_exp = '13'
                   iv_mod = '497' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '445' ).

  ENDMETHOD.

  METHOD modular_pow3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_base = '3'
                   iv_exp = '7'
                   iv_mod = '4' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '3' ).

  ENDMETHOD.

  METHOD modular_pow4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_base = '4578'
                   iv_exp  = '100'
                   iv_mod  = '25' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_mod DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      mod1 FOR TESTING,
      mod2 FOR TESTING,
      mod3 FOR TESTING,
      mod4 FOR TESTING,
      mod5 FOR TESTING,
      mod6 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_mod IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.


    ro_int = zcl_abappgp_integer=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer=>from_string( iv_op2 ).

    ro_int->mod( lo_var2 ).

  ENDMETHOD.

  METHOD mod1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD mod2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD mod3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '9999'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD mod4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10009'
                   iv_op2 = '10' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '9' ).

  ENDMETHOD.

  METHOD mod5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10'
                   iv_op2 = '100000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '10' ).

  ENDMETHOD.

  METHOD mod6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '30558784'
                   iv_op2 = '44449' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '22321' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_divide DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      divide1 FOR TESTING,
      divide2 FOR TESTING,
      divide3 FOR TESTING,
      divide4 FOR TESTING,
      divide5 FOR TESTING,
      divide6 FOR TESTING,
      divide7 FOR TESTING,
      divide8 FOR TESTING,
      divide9 FOR TESTING,
      divide10 FOR TESTING,
      divide11 FOR TESTING,
      divide_generic FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_divide IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.

    ro_int = zcl_abappgp_integer=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer=>from_string( iv_op2 ).

    ro_int->divide( lo_var2 ).

  ENDMETHOD.

  METHOD divide1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD divide2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '123456'
                   iv_op2 = '123456' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD divide3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '2' ).

  ENDMETHOD.

  METHOD divide4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '555555'
                   iv_op2 = '111111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '5' ).

  ENDMETHOD.

  METHOD divide5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '2' ).

  ENDMETHOD.

  METHOD divide6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '100' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD divide7.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '30558784'
                   iv_op2 = '44449' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '687' ).

  ENDMETHOD.

  METHOD divide8.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '30558784'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '30558784' ).

  ENDMETHOD.

  METHOD divide9.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1000'
                   iv_op2 = '7' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '142' ).

  ENDMETHOD.

  METHOD divide10.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5827800983498960781124740512078744256512'
                   iv_op2 = '48112959837082048697' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '121127467593613023351' ).

  ENDMETHOD.

  METHOD divide11.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '7382888'
                   iv_op2 = '9' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '820320' ).

  ENDMETHOD.

  METHOD divide_generic.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer,
          lv_op1 TYPE string,
          lv_op2 TYPE string,
          lv_expected TYPE i.


    DO 100 TIMES.
      lv_op1 = sy-index.
      DO 100 TIMES.
        lv_op2 = sy-index.

        lv_expected = lv_op1 DIV lv_op2.

        lo_res = test( iv_op1 = condense( lv_op1 )
                       iv_op2 = condense( lv_op2 ) ).

        cl_abap_unit_assert=>assert_equals(
          act = lo_res->to_string( )
          exp = lv_expected ).

      ENDDO.
    ENDDO.

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_gt DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      gt1 FOR TESTING,
      gt2 FOR TESTING,
      gt3 FOR TESTING,
      gt4 FOR TESTING,
      gt5 FOR TESTING,
      gt6 FOR TESTING,
      gt7 FOR TESTING,
      gt8 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1         TYPE string
                     iv_op2         TYPE string
           RETURNING VALUE(rv_bool) TYPE abap_bool.

ENDCLASS.

CLASS ltcl_gt IMPLEMENTATION.

  METHOD test.

    DATA: lo_var1 TYPE REF TO zcl_abappgp_integer,
          lo_var2 TYPE REF TO zcl_abappgp_integer.


    lo_var1 = zcl_abappgp_integer=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer=>from_string( iv_op2 ).

    rv_bool = lo_var1->is_gt( lo_var2 ).

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

  METHOD gt5.

    DATA: lv_gt TYPE bool.


    lv_gt = test( iv_op1 = '30514335'
                  iv_op2 = '44449' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_true ).

  ENDMETHOD.

  METHOD gt6.

    DATA: lv_gt TYPE bool.


    lv_gt = test( iv_op1 = '-30514335'
                  iv_op2 = '44449' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_false ).

  ENDMETHOD.

  METHOD gt7.

    DATA: lv_gt TYPE bool.


    lv_gt = test( iv_op1 = '-44449'
                  iv_op2 = '-30514335' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_gt
      exp = abap_true ).

  ENDMETHOD.

  METHOD gt8.

    DATA: lv_gt TYPE bool.


    lv_gt = test( iv_op1 = '-30514335'
                  iv_op2 = '-44449' ).

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


    ro_int = zcl_abappgp_integer=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer=>from_string( iv_op2 ).

    ro_int->power( lo_var2 ).

  ENDMETHOD.

  METHOD power1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD power2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD power3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '100'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '100' ).

  ENDMETHOD.

  METHOD power4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '100'
                   iv_op2 = '2' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '10000' ).

  ENDMETHOD.

  METHOD power5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '99'
                   iv_op2 = '3' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '970299' ).

  ENDMETHOD.

  METHOD power6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '99'
                   iv_op2 = '9' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
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
      multiply6 FOR TESTING,
      multiply7 FOR TESTING,
      multiply8 FOR TESTING,
      multiply9 FOR TESTING,
      multiply10 FOR TESTING,
      multiply11 FOR TESTING,
      multiply12 FOR TESTING,
      multiply13 FOR TESTING,
      multiply14 FOR TESTING,
      multiply15 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_multiply IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.


    ro_int = zcl_abappgp_integer=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer=>from_string( iv_op2 ).

    ro_int->multiply( lo_var2 ).

  ENDMETHOD.

  METHOD multiply1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD multiply2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD multiply3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD multiply4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '2'
                   iv_op2 = '3' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '6' ).

  ENDMETHOD.

  METHOD multiply5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1234321' ).

  ENDMETHOD.

  METHOD multiply6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '9999'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '99980001' ).

  ENDMETHOD.

  METHOD multiply7.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '500'
                   iv_op2 = '50000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '25000000' ).

  ENDMETHOD.

  METHOD multiply8.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '30558784'
                   iv_op2 = '44449' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1358307390016' ).

  ENDMETHOD.

  METHOD multiply9.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '100000'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD multiply10.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '7777777777'
                   iv_op2 = '6666666666' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '51851851841481481482' ).

  ENDMETHOD.

  METHOD multiply11.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '-77'
                   iv_op2 = '66' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '-5082' ).

  ENDMETHOD.

  METHOD multiply12.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '-77'
                   iv_op2 = '-66' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '5082' ).

  ENDMETHOD.

  METHOD multiply13.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '77'
                   iv_op2 = '-66' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '-5082' ).

  ENDMETHOD.

  METHOD multiply14.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '999999999999999'
                   iv_op2 = '999999999999999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '999999999999998000000000000001' ).

  ENDMETHOD.

  METHOD multiply15.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.

    lo_res = test( iv_op1 = '9999999999999990'
                   iv_op2 = '9999999999999990' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '99999999999999800000000000000100' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_subtract DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      subtract1 FOR TESTING,
      subtract2 FOR TESTING,
      subtract3 FOR TESTING,
      subtract4 FOR TESTING,
      subtract5 FOR TESTING,
      subtract6 FOR TESTING,
      subtract7 FOR TESTING,
      subtract8 FOR TESTING,
      subtract9 FOR TESTING,
      subtract10 FOR TESTING,
      subtract11 FOR TESTING,
      subtract12 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.

CLASS ltcl_subtract IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.


    ro_int = zcl_abappgp_integer=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer=>from_string( iv_op2 ).

    ro_int = ro_int->subtract( lo_var2 ).

  ENDMETHOD.

  METHOD subtract1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '0'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '9' ).

  ENDMETHOD.

  METHOD subtract4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10000'
                   iv_op2 = '10000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '0' ).

  ENDMETHOD.

  METHOD subtract5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10000'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '9999' ).

  ENDMETHOD.

  METHOD subtract6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '10' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '-5' ).

  ENDMETHOD.

  METHOD subtract7.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '-5'
                   iv_op2 = '-10' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '5' ).

  ENDMETHOD.

  METHOD subtract8.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '999999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '-999994' ).

  ENDMETHOD.

  METHOD subtract9.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '-5'
                   iv_op2 = '5' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '-10' ).

  ENDMETHOD.

  METHOD subtract10.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '5'
                   iv_op2 = '-5' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '10' ).

  ENDMETHOD.

  METHOD subtract11.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '-3'
                   iv_op2 = '7' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '-10' ).

  ENDMETHOD.

  METHOD subtract12.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '3'
                   iv_op2 = '-7' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '10' ).

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
      add9 FOR TESTING,
      add10 FOR TESTING.

    METHODS:
      test IMPORTING iv_op1        TYPE string
                     iv_op2        TYPE string
           RETURNING VALUE(ro_int) TYPE REF TO zcl_abappgp_integer.

ENDCLASS.       "ltcl_Add

CLASS ltcl_add IMPLEMENTATION.

  METHOD test.

    DATA: lo_var2 TYPE REF TO zcl_abappgp_integer.


    ro_int = zcl_abappgp_integer=>from_string( iv_op1 ).
    lo_var2 = zcl_abappgp_integer=>from_string( iv_op2 ).

    ro_int = ro_int->add( lo_var2 ).

  ENDMETHOD.

  METHOD add1.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '2' ).

  ENDMETHOD.

  METHOD add2.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '0' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '1' ).

  ENDMETHOD.

  METHOD add3.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '2222' ).

  ENDMETHOD.

  METHOD add4.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '111111'
                   iv_op2 = '1111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '112222' ).

  ENDMETHOD.

  METHOD add5.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1111'
                   iv_op2 = '111111' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '112222' ).

  ENDMETHOD.

  METHOD add6.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '1'
                   iv_op2 = '9999' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '10000' ).

  ENDMETHOD.

  METHOD add7.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '99980001'
                   iv_op2 = '1' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '99980002' ).

  ENDMETHOD.

  METHOD add8.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '-5'
                   iv_op2 = '-5' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '-10' ).

  ENDMETHOD.

  METHOD add9.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '-5'
                   iv_op2 = '10' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '5' ).

  ENDMETHOD.

  METHOD add10.

    DATA: lo_res TYPE REF TO zcl_abappgp_integer.


    lo_res = test( iv_op1 = '10'
                   iv_op2 = '-5' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_res->to_string( )
      exp = '5' ).

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
      id7 FOR TESTING.

    METHODS: test IMPORTING iv_string TYPE string.

ENDCLASS.       "ltcl_Add

CLASS ltcl_identity IMPLEMENTATION.

  METHOD test.

    DATA: lo_var1   TYPE REF TO zcl_abappgp_integer,
          lv_result TYPE string.


    lo_var1 = zcl_abappgp_integer=>from_string( iv_string ).

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

  METHOD id7.

    test( '-100' ).

  ENDMETHOD.

ENDCLASS.