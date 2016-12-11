CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '03ACFBD37A2CBEE0180104008A014E2819E43A31' ).
    lo_stream->write_octets( '44BD0B0F45D7E4CD7A24B85C063F5F4281530080' ).
    lo_stream->write_octets( 'ADD692B3E25C120F6979CBE1608E0F5BE0306322' ).
    lo_stream->write_octets( 'EEADD2412B9C5FFDAC96737AD4E0999616ADAB7E' ).
    lo_stream->write_octets( '50594830112E6389328FA557F393DE599F8CB3D5' ).
    lo_stream->write_octets( '3FCDF011413502F09ABCA5E5D9B6278C19D19CD7' ).
    lo_stream->write_octets( '587AD442C7181B1CE73D19CABC24D7C056EEA418' ).

    zcl_abappgp_unit_test=>packet_identity(
      io_data = lo_stream
      iv_tag  = zif_abappgp_constants=>c_tag-public_key_enc ).

  ENDMETHOD.

ENDCLASS.