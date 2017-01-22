CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '466F6F203C666F6F406261722E636F6D3E' ).

    zcl_abappgp_unit_test=>packet_identity( io_data = lo_stream
      iv_tag = zif_abappgp_constants=>c_tag-user_id ).

  ENDMETHOD.

ENDCLASS.
