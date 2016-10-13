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