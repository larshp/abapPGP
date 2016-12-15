class ZCL_ABAPPGP_MESSAGE_01 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_MESSAGE .

  aliases FROM_ARMOR
    for ZIF_ABAPPGP_MESSAGE~FROM_ARMOR .

  methods CONSTRUCTOR
    importing
      !IT_PACKET_LIST type ZIF_ABAPPGP_CONSTANTS=>TY_PACKET_LIST
      !IT_HEADERS type STRING_TABLE optional .
protected section.

  data MT_PACKET_LIST type ZIF_ABAPPGP_CONSTANTS=>TY_PACKET_LIST .
  data MT_HEADERS type STRING_TABLE .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_MESSAGE_01 IMPLEMENTATION.


  METHOD constructor.

    mt_packet_list = it_packet_list.

  ENDMETHOD.


  METHOD zif_abappgp_message~dump.

    DATA: li_packet LIKE LINE OF mt_packet_list.


    LOOP AT mt_packet_list INTO li_packet.
      rv_dump = rv_dump && li_packet->dump( ).
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_abappgp_message~from_armor.

    DATA: lo_stream  TYPE REF TO zcl_abappgp_stream,
          lt_packets TYPE zif_abappgp_constants=>ty_packet_list.


    ASSERT io_armor->get_armor_header( ) = zcl_abappgp_armor=>c_header-message.
    ASSERT io_armor->get_armor_tail( ) = zcl_abappgp_armor=>c_tail-message.

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = io_armor->get_data( ).

    lt_packets = zcl_abappgp_packet_list=>from_stream( lo_stream ).

    CREATE OBJECT ri_message
      TYPE zcl_abappgp_message_01
      EXPORTING
        it_packet_list = lt_packets
        it_headers     = io_armor->get_headers( ).

  ENDMETHOD.


  METHOD zif_abappgp_message~to_armor.

    CREATE OBJECT ro_armor
      EXPORTING
        iv_armor_header = zcl_abappgp_armor=>c_header-message
        it_headers      = mt_headers
        iv_data         = zcl_abappgp_packet_list=>to_stream( mt_packet_list )->get_data( )
        iv_armor_tail   = zcl_abappgp_armor=>c_tail-message.

  ENDMETHOD.
ENDCLASS.