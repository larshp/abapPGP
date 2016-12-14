CLASS ltcl_sign DEFINITION FOR TESTING DURATION MEDIUM RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      sign01 FOR TESTING RAISING zcx_abappgp_invalid_key.

ENDCLASS.       "ltcl_Test

CLASS ltcl_sign IMPLEMENTATION.

  METHOD sign01.

    DATA: lo_private     TYPE REF TO zcl_abappgp_rsa_private_key,
          lv_text        TYPE string,
          lv_actual      TYPE xstring,
          lv_expected    TYPE xstring,
          lo_stream      TYPE REF TO zcl_abappgp_stream,
          lo_msg_private TYPE REF TO zcl_abappgp_message_03,
          lo_packet      TYPE REF TO zcl_abappgp_packet_02,
          lo_private_key TYPE REF TO zcl_abappgp_rsa_private_key,
          li_message     TYPE REF TO zif_abappgp_message.


    CONCATENATE
      '-----BEGIN PGP PRIVATE KEY BLOCK-----'
      'Version: OpenPGP.js v2.0.0'
      'Comment: http://openpgpjs.org'
      ''
      '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'
      'yd50AMsn0I5wjg=='
      '=USF2'
      '-----END PGP PRIVATE KEY BLOCK-----'
      INTO lv_text
      SEPARATED BY cl_abap_char_utilities=>newline.

    lo_msg_private ?= zcl_abappgp_message_03=>from_armor(
      zcl_abappgp_armor=>from_string( lv_text ) ).

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
    METHODS:
      test01 FOR TESTING,
      test02 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test01.

    DATA: lo_stream TYPE REF TO zcl_abappgp_stream.


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

    DATA: lo_stream TYPE REF TO zcl_abappgp_stream.


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