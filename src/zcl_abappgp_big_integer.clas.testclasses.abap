
CLASS ltcl_add DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      add1 FOR TESTING,
      add2 FOR TESTING.

ENDCLASS.       "ltcl_Add

CLASS ltcl_add IMPLEMENTATION.

  METHOD add1.

    DATA: lo_var1 TYPE REF TO zcl_abappgp_big_integer,
          lo_var2 TYPE REF TO zcl_abappgp_big_integer.

    CREATE OBJECT lo_var1
      EXPORTING
        iv_integer = '1'.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = '1'.

    lo_var1 = lo_var1->add( lo_var2 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_var1->get( )
      exp = '2' ).

  ENDMETHOD.

  METHOD add2.

    DATA: lo_var1 TYPE REF TO zcl_abappgp_big_integer,
          lo_var2 TYPE REF TO zcl_abappgp_big_integer.

    CREATE OBJECT lo_var1
      EXPORTING
        iv_integer = '1'.

    CREATE OBJECT lo_var2
      EXPORTING
        iv_integer = '0'.

    lo_var1 = lo_var1->add( lo_var2 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_var1->get( )
      exp = '1' ).

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