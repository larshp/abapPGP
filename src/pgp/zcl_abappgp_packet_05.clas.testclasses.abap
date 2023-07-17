CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      get_stream RETURNING VALUE(ro_stream) TYPE REF TO zcl_abappgp_stream,
      decrypt01 FOR TESTING RAISING zcx_abappgp_invalid_key,
      decrypt02 FOR TESTING,
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_stream.

    CREATE OBJECT ro_stream.
    ro_stream->write_octets( '04582DBEEA010400DD3915AA1CB8D3DE711B86CB' ).
    ro_stream->write_octets( 'AD6E825E745BD8EF95AD7E2DA6C0750DCB5B0889' ).
    ro_stream->write_octets( 'DA3317D82E921875DA43B626B9252DAE5EDD55EC' ).
    ro_stream->write_octets( '8D03466CEB47BD26C2E753A0E7BEC40DB8C6891C' ).
    ro_stream->write_octets( '00B0C387A49CD3225508BD53444026CB18786BB4' ).
    ro_stream->write_octets( '56A3DF3DDB67C02727B5C57EB8391622A6A6EA5E' ).
    ro_stream->write_octets( 'EE8920C63842A2A9630D69C037929EF300110100' ).
    ro_stream->write_octets( '01FE0903085B6474F1397A257D60A18EC1C3FE10' ).
    ro_stream->write_octets( '6848789192F04472FB1F55FE57DDBC27559FE086' ).
    ro_stream->write_octets( '6C449C53E8060C79D838618E4A22794B9235AAB4' ).
    ro_stream->write_octets( 'DCA2ED901353831B9535717D037EB17BA9060D3A' ).
    ro_stream->write_octets( '31421C00D51856824C619012ABF3E809E9F2A145' ).
    ro_stream->write_octets( '43F4E275CA3E76B4EAFE215AC6CC5A28A2280B80' ).
    ro_stream->write_octets( '2B56CF60D43FACADC668F8479377486E67D78BB9' ).
    ro_stream->write_octets( 'FF60E4291DAD99DD6656D2DD5777C27824551467' ).
    ro_stream->write_octets( 'BA39EBF8BD77E24FE4061E772D82F8751F4DFA6A' ).
    ro_stream->write_octets( 'E79F20CC838B230AC0E17E71BF5A09558E9CEFD8' ).
    ro_stream->write_octets( '78E8BBEDE0C66340EBCAD6369C00CECE8713F00A' ).
    ro_stream->write_octets( '39C1DB9C8DDBBC580FD50CE868947BFAE631D9DC' ).
    ro_stream->write_octets( 'DDBF90EB0092D61B1E5E0AC6D9F1F80D5E1A9139' ).
    ro_stream->write_octets( '73C2BA522C3E746E927A36BC39CA5BE6F4502BE0' ).
    ro_stream->write_octets( '4201635A076B630E5B5F3575F0A529694342675E' ).
    ro_stream->write_octets( 'BD35F289783A85E5638DCBAAB709E429ABC67E18' ).
    ro_stream->write_octets( '03FDBF55383A6FA27FC1CAA435D5D0C0DA2947A4' ).
    ro_stream->write_octets( '07C614BBA7729EF5F5AC6754CC41796B1C9AA82D' ).
    ro_stream->write_octets( 'A80B4C64E6F14C8873E2C5DC2D1B96A69DB8' ).

  ENDMETHOD.

  METHOD decrypt01.

    DATA lo_packet05 TYPE REF TO zcl_abappgp_packet_05.


    lo_packet05 ?= zcl_abappgp_packet_05=>from_stream( get_stream( ) ).
    lo_packet05->decrypt( 'testtest' ).

  ENDMETHOD.

  METHOD decrypt02.

    DATA lo_packet05 TYPE REF TO zcl_abappgp_packet_05.


    lo_packet05 ?= zcl_abappgp_packet_05=>from_stream( get_stream( ) ).
    TRY.
        lo_packet05->decrypt( 'wrong' ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_abappgp_invalid_key ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.

  METHOD test.

    DATA lo_stream TYPE REF TO zcl_abappgp_stream.


    lo_stream = get_stream( ).

    zcl_abappgp_unit_test=>packet_identity(
      io_data = lo_stream
      iv_tag  = zif_abappgp_constants=>c_tag-secret_key ).

  ENDMETHOD.

ENDCLASS.
