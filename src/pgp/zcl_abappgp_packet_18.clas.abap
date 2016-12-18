class ZCL_ABAPPGP_PACKET_18 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_PACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_PACKET~FROM_STREAM .
  aliases GET_NAME
    for ZIF_ABAPPGP_PACKET~GET_NAME .
  aliases GET_TAG
    for ZIF_ABAPPGP_PACKET~GET_TAG .
  aliases TO_STREAM
    for ZIF_ABAPPGP_PACKET~TO_STREAM .

  methods CONSTRUCTOR
    importing
      !IV_VERSION type XSEQUENCE
      !IV_DATA type XSTRING .
protected section.

  data MV_VERSION type XSTRING .
  data MV_DATA type XSTRING .
private section.
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