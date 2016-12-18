CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '01B4D759EDA9DA85EE582E22EC6F6A7A31860ACB' ).
    lo_stream->write_octets( '985473F933FA4C2378024F138F8F08E6152E0E0C' ).
    lo_stream->write_octets( 'E4F5B1378CD196213E82A1B7253CFECFED2D7FC1' ).
    lo_stream->write_octets( '5AC281F6619E82DA8742DBC233741D531A9F4F08' ).
    lo_stream->write_octets( '5BC28B8CABBAB8C2C07FD420C96DEF28F24FAAC1' ).
    lo_stream->write_octets( '1136A64D80FCC2CA87E6B9B1DC77DC88703DB476' ).
    lo_stream->write_octets( '6635B809A5DA0E89C7765E239E5AE4318EEF1C2E' ).
    lo_stream->write_octets( 'BF12DC5C78DF95648C0AEEEA958F8FC52CA2AF31' ).
    lo_stream->write_octets( 'D4E0169E1190A8A33B22C03B41B866C96F706D3A' ).
    lo_stream->write_octets( 'BA4BA409E54834C0E1653FCF9D2B8ACC6A49BF57' ).
    lo_stream->write_octets( 'B5B6D04E00217723174748A5F8ADDA7E7CEE176A' ).
    lo_stream->write_octets( '3F03867E25F62058CB78510183382AD186A055B0' ).
    lo_stream->write_octets( 'C4DD' ).

    zcl_abappgp_unit_test=>packet_identity( io_data = lo_stream
      iv_tag = zif_abappgp_constants=>c_tag-symmetrical_inte ).

  ENDMETHOD.

ENDCLASS.