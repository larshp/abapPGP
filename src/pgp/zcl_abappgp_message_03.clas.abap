class ZCL_ABAPPGP_MESSAGE_03 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_MESSAGE .

  aliases FROM_ARMOR
    for ZIF_ABAPPGP_MESSAGE~FROM_ARMOR .
  aliases GET_TYPE
    for ZIF_ABAPPGP_MESSAGE~GET_TYPE .

  methods CONSTRUCTOR
    importing
      !IT_PACKET_LIST type ZIF_ABAPPGP_CONSTANTS=>TY_PACKET_LIST .
protected section.

  data MT_PACKET_LIST type ZIF_ABAPPGP_CONSTANTS=>TY_PACKET_LIST .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_MESSAGE_03 IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    super->constructor( ).

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


    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = io_armor->get_data( ).

    lt_packets = zcl_abappgp_packet_list=>from_stream( lo_stream ).

    CREATE OBJECT ri_message
      TYPE zcl_abappgp_message_03
      EXPORTING
        it_packet_list = lt_packets.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_MESSAGE~GET_TYPE.

* todo

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_MESSAGE~TO_ARMOR.

* todo

  ENDMETHOD.
ENDCLASS.