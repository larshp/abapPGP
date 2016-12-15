class ZCL_ABAPPGP_MESSAGE_02 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_MESSAGE .

  aliases FROM_ARMOR
    for ZIF_ABAPPGP_MESSAGE~FROM_ARMOR .

  methods CONSTRUCTOR
    importing
      !IT_PACKET_LIST type ZIF_ABAPPGP_CONSTANTS=>TY_PACKET_LIST .
protected section.

  data MT_PACKET_LIST type ZIF_ABAPPGP_CONSTANTS=>TY_PACKET_LIST .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_MESSAGE_02 IMPLEMENTATION.


  METHOD constructor.

    mt_packet_list = it_packet_list.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_MESSAGE~DUMP.

    DATA: li_packet LIKE LINE OF mt_packet_list.


    LOOP AT mt_packet_list INTO li_packet.
      rv_dump = rv_dump && li_packet->dump( ).
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_abappgp_message~from_armor.

    DATA: lo_stream  TYPE REF TO zcl_abappgp_stream,
          lt_packets TYPE zif_abappgp_constants=>ty_packet_list.


    ASSERT io_armor->get_armor_header( ) = zcl_abappgp_armor=>c_header-public.
    ASSERT io_armor->get_armor_tail( ) = zcl_abappgp_armor=>c_tail-public.

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = io_armor->get_data( ).

    lt_packets = zcl_abappgp_packet_list=>from_stream( lo_stream ).

    CREATE OBJECT ri_message
      TYPE zcl_abappgp_message_02
      EXPORTING
        it_packet_list = lt_packets.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_MESSAGE~TO_ARMOR.

* todo

  ENDMETHOD.
ENDCLASS.