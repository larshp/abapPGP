CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '04582DBEEA010400B9249A7307024FC83472036E' ).
    lo_stream->write_octets( 'E40E0B7E6966BFE0C6C1D209AC51B6CB48E0EF38' ).
    lo_stream->write_octets( '9946E6E91A8F266086F2C5936A9120CA8579C996' ).
    lo_stream->write_octets( '8DEB9E5700D89A12A21F5270CABEB59B20490D18' ).
    lo_stream->write_octets( '3BBD5D8A859E3501668DD567BDAB15BC15C737A8' ).
    lo_stream->write_octets( '849518A809C3BC7519B5C272220FACF923E7CC01' ).
    lo_stream->write_octets( '13A0A6221FC49CBD8F4BE0B8E0A6498B0011010001' ).

    zcl_abappgp_unit_test=>packet_identity( io_data = lo_stream
      iv_tag = zif_abappgp_constants=>c_tag-public_subkey ).

  ENDMETHOD.

ENDCLASS.