CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '04582DBEEA010400DD3915AA1CB8D3DE711B86CB' ).
    lo_stream->write_octets( 'AD6E825E745BD8EF95AD7E2DA6C0750DCB5B0889' ).
    lo_stream->write_octets( 'DA3317D82E921875DA43B626B9252DAE5EDD55EC' ).
    lo_stream->write_octets( '8D03466CEB47BD26C2E753A0E7BEC40DB8C6891C' ).
    lo_stream->write_octets( '00B0C387A49CD3225508BD53444026CB18786BB4' ).
    lo_stream->write_octets( '56A3DF3DDB67C02727B5C57EB8391622A6A6EA5E' ).
    lo_stream->write_octets( 'EE8920C63842A2A9630D69C037929EF30011010001' ).

    zcl_abappgp_unit_test=>packet_identity( io_data = lo_stream
      iv_tag = zif_abappgp_constants=>c_tag-public_key ).

  ENDMETHOD.

ENDCLASS.
