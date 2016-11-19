
CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA: mv_data TYPE xstring.

    METHODS:
      add IMPORTING iv_string TYPE string,
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD add.

    DATA: lv_xstring TYPE xstring.

    lv_xstring = iv_string.

    CONCATENATE mv_data lv_xstring INTO mv_data IN BYTE MODE.

  ENDMETHOD.

  METHOD test.

    DATA: li_packet TYPE REF TO zif_abappgp_packet,
          lv_result TYPE xstring,
          lo_stream TYPE REF TO zcl_abappgp_stream.


    add( '0410010800290502582DBEEA060B090807030209' ).
    add( '1065DA02B5E3CA1DE1041508020A031602010219' ).
    add( '01021B03021E010000EDA803FF7838CDA4D7A5F9' ).
    add( 'F3BA035A69D198BBF49DAD4B7403214EA1363330' ).
    add( 'C3A8D495D7332F23E0538F03C147676F7446162D' ).
    add( '655C630F22CBFEB95BFAC827DB606E6DA56AB5C1' ).
    add( '7CE206B844B75118AF69FE69526FDD583BFD0359' ).
    add( '3A92519875EAC5C88621AE4B421C6272F039FA24' ).
    add( 'D804FA91AF465B05DBC6DADE34DF7489FECC882273' ).

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = mv_data.

    li_packet = zcl_abappgp_packet_02=>from_stream( lo_stream ).

    lv_result = li_packet->to_stream( )->get_data( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = mv_data ).

  ENDMETHOD.

ENDCLASS.