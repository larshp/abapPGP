CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

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

ENDCLASS.