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

    DATA: lo_binary  TYPE REF TO zcl_abappgp_binary_integer,
          lo_integer TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT lo_integer
      EXPORTING
        iv_integer = iv_str.

    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = lo_integer.

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

    DATA: lo_binary  TYPE REF TO zcl_abappgp_binary_integer,
          lo_integer TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT lo_integer
      EXPORTING
        iv_integer = iv_str.

    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = lo_integer.

    lo_binary->shift_right( ).

    lo_integer = lo_binary->to_integer( ).

    rv_str = lo_integer->to_string( ).

  ENDMETHOD.

  METHOD shift1.

    DATA: lv_result TYPE string.

    lv_result = test( '16' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '8' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_get DEFINITION FOR TESTING
    DURATION SHORT
    RISK LEVEL HARMLESS
    FINAL.

  PRIVATE SECTION.
    METHODS: get1 FOR TESTING,
      get2 FOR TESTING.

    METHODS: test IMPORTING iv_str           TYPE string
                  RETURNING VALUE(rv_binary) TYPE string.

ENDCLASS.       "ltcl_Get

CLASS ltcl_get IMPLEMENTATION.

  METHOD test.

    DATA: lo_binary  TYPE REF TO zcl_abappgp_binary_integer,
          lo_integer TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT lo_integer
      EXPORTING
        iv_integer = iv_str.

    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = lo_integer.

    rv_binary = lo_binary->to_string( ).

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

ENDCLASS.