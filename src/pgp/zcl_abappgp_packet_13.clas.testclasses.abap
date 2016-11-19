
CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lv_hex    TYPE xstring,
          lo_stream TYPE REF TO zcl_abappgp_stream,
          li_packet TYPE REF TO zif_abappgp_packet,
          lv_result TYPE xstring.


    lv_hex = '466F6F203C666F6F406261722E636F6D3E'.

    CREATE OBJECT lo_stream EXPORTING iv_data = lv_hex.

    li_packet = zcl_abappgp_packet_13=>from_stream( lo_stream ).

    lv_result = li_packet->to_stream( )->get_data( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = lv_hex ).

  ENDMETHOD.

ENDCLASS.