class ZCL_ABAPPGP_PACKET_13 definition
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

  methods CONSTRUCTOR
    importing
      !IV_USER type STRING .
protected section.

  data MV_USER type STRING .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_13 IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    mv_user = iv_user.

  ENDMETHOD.


  METHOD zif_abappgp_packet~dump.

    rv_dump = |{ get_name( ) }(tag { get_tag( ) })\n\ttodo\n|.

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

    rv_name = 'User ID Packet'.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-user_id.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_PACKET~TO_STREAM.

    BREAK-POINT.

  ENDMETHOD.
ENDCLASS.