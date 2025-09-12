CLASS ltcl_sign DEFINITION FOR TESTING DURATION MEDIUM RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS
      sign01 FOR TESTING RAISING zcx_abappgp_invalid_key.

ENDCLASS.       "ltcl_Test

CLASS ltcl_sign IMPLEMENTATION.

  METHOD sign01.

    DATA: lv_text        TYPE string,
          lv_actual      TYPE xstring,
          lv_expected    TYPE xstring,
          lo_stream      TYPE REF TO zcl_abappgp_stream,
          lo_msg_private TYPE REF TO zcl_abappgp_message_03,
          lo_packet      TYPE REF TO zcl_abappgp_packet_02,
          lo_private_key TYPE REF TO zcl_abappgp_rsa_private_key,
          li_message     TYPE REF TO zif_abappgp_message.


    lv_text = zcl_abappgp_unit_test=>get_private_key( ).

    lo_msg_private ?= zcl_abappgp_message_03=>from_armor( zcl_abappgp_armor=>from_string( lv_text ) ).

    lo_private_key = lo_msg_private->decrypt( 'testtest' ).

    lo_packet = zcl_abappgp_packet_02=>sign(
      iv_data    = zcl_abappgp_convert=>string_to_utf8( 'Hello, World!' )
      iv_issuer  = '65DA02B5E3CA1DE1'
      iv_time    = 1481467454
      io_private = lo_private_key ).

    lv_actual = lo_packet->to_stream( )->get_data( ).

    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '0401010800100502584D663E091065DA02B5E3CA' ).
    lo_stream->write_octets( '1DE10000C8ED03FF65BA78165C89E3EA582617DB' ).
    lo_stream->write_octets( 'F01B6B4F20F0FBD24A4E9426F8E4C4408721C71F' ).
    lo_stream->write_octets( '02CF5F78099A2DC52AE7BFE5207B0606DFB36892' ).
    lo_stream->write_octets( 'B5C01B0FFDD825C09D8F022F14B99E4563EEEAA6' ).
    lo_stream->write_octets( 'D36F34AE2637CFA73DB41E3C990139D528292573' ).
    lo_stream->write_octets( '9D67A5F087283763AEEA436908A93ECB33F36A98' ).
    lo_stream->write_octets( 'BCE60A848DE082F747DF2C3E010AF9F4' ).
    lv_expected = lo_stream->get_data( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING RAISING cx_static_check.
    METHODS test02 FOR TESTING RAISING cx_static_check.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test01.

    DATA lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '0410010800290502582DBEEA060B090807030209' ).
    lo_stream->write_octets( '1065DA02B5E3CA1DE1041508020A031602010219' ).
    lo_stream->write_octets( '01021B03021E010000EDA803FF7838CDA4D7A5F9' ).
    lo_stream->write_octets( 'F3BA035A69D198BBF49DAD4B7403214EA1363330' ).
    lo_stream->write_octets( 'C3A8D495D7332F23E0538F03C147676F7446162D' ).
    lo_stream->write_octets( '655C630F22CBFEB95BFAC827DB606E6DA56AB5C1' ).
    lo_stream->write_octets( '7CE206B844B75118AF69FE69526FDD583BFD0359' ).
    lo_stream->write_octets( '3A92519875EAC5C88621AE4B421C6272F039FA24' ).
    lo_stream->write_octets( 'D804FA91AF465B05DBC6DADE34DF7489FECC882273' ).

    zcl_abappgp_unit_test=>packet_identity( io_data = lo_stream
      iv_tag = zif_abappgp_constants=>c_tag-signature ).

  ENDMETHOD.

  METHOD test02.

    DATA lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '0401010800100502584D663E091065DA02B5E3CA' ).
    lo_stream->write_octets( '1DE10000C8ED03FF65BA78165C89E3EA582617DB' ).
    lo_stream->write_octets( 'F01B6B4F20F0FBD24A4E9426F8E4C4408721C71F' ).
    lo_stream->write_octets( '02CF5F78099A2DC52AE7BFE5207B0606DFB36892' ).
    lo_stream->write_octets( 'B5C01B0FFDD825C09D8F022F14B99E4563EEEAA6' ).
    lo_stream->write_octets( 'D36F34AE2637CFA73DB41E3C990139D528292573' ).
    lo_stream->write_octets( '9D67A5F087283763AEEA436908A93ECB33F36A98' ).
    lo_stream->write_octets( 'BCE60A848DE082F747DF2C3E010AF9F4' ).

    zcl_abappgp_unit_test=>packet_identity( io_data = lo_stream
      iv_tag = zif_abappgp_constants=>c_tag-signature ).

  ENDMETHOD.

ENDCLASS.
