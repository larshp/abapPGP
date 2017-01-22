CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PUBLIC SECTION.
    METHODS:
      base64 FOR TESTING,
      utf8 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD base64.

    DATA: lv_original TYPE xstring,
          lv_encoded  TYPE string,
          lv_result   TYPE xstring.


    lv_original = '00112233445566778899'.
    lv_encoded = zcl_abappgp_convert=>base64_encode( lv_original ).
    lv_result = zcl_abappgp_convert=>base64_decode( lv_encoded ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = lv_original ).

  ENDMETHOD.

  METHOD utf8.

    DATA: lv_original TYPE string,
          lv_result   TYPE string,
          lv_encoded  TYPE xstring.


    lv_original = 'Hello World'.
    lv_encoded = zcl_abappgp_convert=>string_to_utf8( lv_original ).
    lv_result = zcl_abappgp_convert=>utf8_to_string( lv_encoded ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = lv_original ).

  ENDMETHOD.

ENDCLASS.
