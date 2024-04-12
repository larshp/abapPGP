CLASS ltcl_sha1 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING.

ENDCLASS.

CLASS ltcl_sha1 IMPLEMENTATION.

  METHOD test01.

    DATA lv_hash TYPE xstring.

    lv_hash = zcl_abappgp_hash=>sha1( '1122334455' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = '2A01053FFA80ACCD0D54173688232FDFB5F17775' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_sha256 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS test
      IMPORTING iv_input    TYPE string
                iv_expected TYPE xstring.

    METHODS test01 FOR TESTING.

ENDCLASS.       "ltcl_Sha256

CLASS ltcl_sha256 IMPLEMENTATION.

  METHOD test.

    DATA lv_hash TYPE xstring.


    lv_hash = zcl_abappgp_hash=>sha256( zcl_abappgp_convert=>string_to_utf8( iv_input ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = iv_expected ).

  ENDMETHOD.

  METHOD test01.

    test( iv_input    = 'abc'
          iv_expected = 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_crc24 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS test
      IMPORTING iv_input    TYPE xstring
                iv_expected TYPE xstring.

    METHODS:
      test01 FOR TESTING,
      test02 FOR TESTING.

ENDCLASS.       "ltcl_Crc24

CLASS ltcl_crc24 IMPLEMENTATION.

  METHOD test.

    DATA lv_hash TYPE xstring.


    lv_hash = zcl_abappgp_hash=>crc24( iv_input ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = iv_expected ).

  ENDMETHOD.

  METHOD test01.

    test( iv_input    = '3F214365876616AB15387D5D59'
          iv_expected = 'BA0568' ).

  ENDMETHOD.

  METHOD test02.

    DATA lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( 'C68D04582DBEEA010400DD3915AA1CB8D3DE711B' ).
    lo_stream->write_octets( '86CBAD6E825E745BD8EF95AD7E2DA6C0750DCB5B' ).
    lo_stream->write_octets( '0889DA3317D82E921875DA43B626B9252DAE5EDD' ).
    lo_stream->write_octets( '55EC8D03466CEB47BD26C2E753A0E7BEC40DB8C6' ).
    lo_stream->write_octets( '891C00B0C387A49CD3225508BD53444026CB1878' ).
    lo_stream->write_octets( '6BB456A3DF3DDB67C02727B5C57EB8391622A6A6' ).
    lo_stream->write_octets( 'EA5EEE8920C63842A2A9630D69C037929EF30011' ).
    lo_stream->write_octets( '010001CD11466F6F203C666F6F406261722E636F' ).
    lo_stream->write_octets( '6D3EC2B50410010800290502582DBEEA060B0908' ).
    lo_stream->write_octets( '070302091065DA02B5E3CA1DE1041508020A0316' ).
    lo_stream->write_octets( '0201021901021B03021E010000EDA803FF7838CD' ).
    lo_stream->write_octets( 'A4D7A5F9F3BA035A69D198BBF49DAD4B7403214E' ).
    lo_stream->write_octets( 'A1363330C3A8D495D7332F23E0538F03C147676F' ).
    lo_stream->write_octets( '7446162D655C630F22CBFEB95BFAC827DB606E6D' ).
    lo_stream->write_octets( 'A56AB5C17CE206B844B75118AF69FE69526FDD58' ).
    lo_stream->write_octets( '3BFD03593A92519875EAC5C88621AE4B421C6272' ).
    lo_stream->write_octets( 'F039FA24D804FA91AF465B05DBC6DADE34DF7489' ).
    lo_stream->write_octets( 'FECC882273CE8D04582DBEEA010400B9249A7307' ).
    lo_stream->write_octets( '024FC83472036EE40E0B7E6966BFE0C6C1D209AC' ).
    lo_stream->write_octets( '51B6CB48E0EF389946E6E91A8F266086F2C5936A' ).
    lo_stream->write_octets( '9120CA8579C9968DEB9E5700D89A12A21F5270CA' ).
    lo_stream->write_octets( 'BEB59B20490D183BBD5D8A859E3501668DD567BD' ).
    lo_stream->write_octets( 'AB15BC15C737A8849518A809C3BC7519B5C27222' ).
    lo_stream->write_octets( '0FACF923E7CC0113A0A6221FC49CBD8F4BE0B8E0' ).
    lo_stream->write_octets( 'A6498B0011010001C29F0418010800130502582D' ).
    lo_stream->write_octets( 'BEEA091065DA02B5E3CA1DE1021B0C0000C26803' ).
    lo_stream->write_octets( 'FF7C8B964E89B7008A11CA1602791762DCE20107' ).
    lo_stream->write_octets( '0D1BC5CB16ACE9EBBA3FFCC0AAC6B305E064D486' ).
    lo_stream->write_octets( '3D01ED0B8E991E86B9617C97B5FAA8D7E04542E0' ).
    lo_stream->write_octets( '2CFDB1F6DE808E9B0ADD4976DDF1241285D2FCE3' ).
    lo_stream->write_octets( '0B9BB1FD20AA4C0A954A367C432B899DA5366B30' ).
    lo_stream->write_octets( '1C5BCBE61709E5A31FA3D68CC9BDBAF59DD6C4C9' ).
    lo_stream->write_octets( 'DE7400CB27D08E708E' ).

    test( iv_input    = lo_stream->get_data( )
          iv_expected = 'F34315' ).

  ENDMETHOD.

ENDCLASS.
