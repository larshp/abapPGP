CLASS zcl_abappgp_packet_18 DEFINITION
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
        !iv_version TYPE xsequence
        !iv_data    TYPE xstring .
  PROTECTED SECTION.

    DATA mv_version TYPE xstring .
    DATA mv_data TYPE xstring .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_18 IMPLEMENTATION.


  METHOD constructor.

    ASSERT iv_version = '01'.

    mv_version = iv_version.
    mv_data = iv_data.

  ENDMETHOD.


  METHOD zif_abappgp_packet~dump.

    rv_dump = |{ get_name( ) }(tag { get_tag( ) })({ to_stream( )->get_length( )
      } bytes)\n\tVersion\t{
      mv_version }\n\tData\t\t{
      xstrlen( mv_data ) } bytes\n|.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_version TYPE x LENGTH 1,
          lv_data    TYPE xstring.


    lv_version = io_stream->eat_octet( ).
    lv_data = io_stream->get_data( ).

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_18
      EXPORTING
        iv_version = lv_version
        iv_data    = lv_data.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'Sym. Encrypted and Integrity Protected Data Packet'(001).

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-symmetrical_inte.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

    CREATE OBJECT ro_stream.
    ro_stream->write_octet( mv_version ).
    ro_stream->write_octets( mv_data ).

  ENDMETHOD.
ENDCLASS.