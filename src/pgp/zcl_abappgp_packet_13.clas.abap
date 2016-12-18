CLASS zcl_abappgp_packet_13 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abappgp_packet .

    ALIASES from_stream
      FOR zif_abappgp_packet~from_stream .
    ALIASES get_name
      FOR zif_abappgp_packet~get_name .
    ALIASES get_tag
      FOR zif_abappgp_packet~get_tag .
    ALIASES to_stream
      FOR zif_abappgp_packet~to_stream .

    METHODS constructor
      IMPORTING
        !iv_user TYPE string .
  PROTECTED SECTION.

    DATA mv_user TYPE string .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_13 IMPLEMENTATION.


  METHOD constructor.

    mv_user = iv_user.

  ENDMETHOD.


  METHOD zif_abappgp_packet~dump.

    rv_dump = |{ get_name( ) }(tag { get_tag( ) })({ to_stream( )->get_length( )
      } bytes)\n\tUser\t\t{ mv_user }\n|.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_user TYPE string.


    lv_user = zcl_abappgp_convert=>utf8_to_string( io_stream->get_data( ) ).

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_13
      EXPORTING
        iv_user = lv_user.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'User ID Packet'(001).

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-user_id.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

    CREATE OBJECT ro_stream.
    ro_stream->write_octets( zcl_abappgp_convert=>string_to_utf8( mv_user ) ).

  ENDMETHOD.
ENDCLASS.