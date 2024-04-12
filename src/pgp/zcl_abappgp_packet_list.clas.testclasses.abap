CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS identity FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD identity.

    DATA: lo_stream   TYPE REF TO zcl_abappgp_stream,
          lt_packets  TYPE zif_abappgp_constants=>ty_packet_list,
          lv_actual   TYPE xstring,
          lv_expected TYPE xstring.


    CREATE OBJECT lo_stream.
    lo_stream->write_octets( 'C29C0401010800100502584D663E091065DA02B5' ).
    lo_stream->write_octets( 'E3CA1DE10000C8ED03FF65BA78165C89E3EA5826' ).
    lo_stream->write_octets( '17DBF01B6B4F20F0FBD24A4E9426F8E4C4408721' ).
    lo_stream->write_octets( 'C71F02CF5F78099A2DC52AE7BFE5207B0606DFB3' ).
    lo_stream->write_octets( '6892B5C01B0FFDD825C09D8F022F14B99E4563EE' ).
    lo_stream->write_octets( 'EAA6D36F34AE2637CFA73DB41E3C990139D52829' ).
    lo_stream->write_octets( '25739D67A5F087283763AEEA436908A93ECB33F3' ).
    lo_stream->write_octets( '6A98BCE60A848DE082F747DF2C3E010AF9F4' ).

    lv_expected = lo_stream->get_data( ).

    lt_packets = zcl_abappgp_packet_list=>from_stream( lo_stream ).

    lv_actual = zcl_abappgp_packet_list=>to_stream( lt_packets )->get_data( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).

  ENDMETHOD.

ENDCLASS.
