CLASS zcl_abappgp_message_03 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abappgp_message .

    ALIASES from_armor
      FOR zif_abappgp_message~from_armor .

    METHODS constructor
      IMPORTING
        !it_packet_list TYPE zif_abappgp_constants=>ty_packet_list .
    METHODS decrypt
      IMPORTING
        !iv_key           TYPE string
      RETURNING
        VALUE(ro_private) TYPE REF TO zcl_abappgp_rsa_private_key
      RAISING
        zcx_abappgp_invalid_key .
  PROTECTED SECTION.

    DATA mt_packet_list TYPE zif_abappgp_constants=>ty_packet_list .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_MESSAGE_03 IMPLEMENTATION.


  METHOD constructor.

    mt_packet_list = it_packet_list.

  ENDMETHOD.


  METHOD decrypt.

    DATA: li_packet     TYPE REF TO zif_abappgp_packet,
          lo_secret_key TYPE REF TO zcl_abappgp_packet_05.


    LOOP AT mt_packet_list INTO li_packet.
      IF li_packet->get_tag( ) = zif_abappgp_constants=>c_tag-secret_key.
        EXIT.
      ENDIF.
    ENDLOOP.

    lo_secret_key ?= li_packet.

    ro_private = lo_secret_key->decrypt( iv_key ).

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


    ASSERT io_armor->get_armor_header( ) = zcl_abappgp_armor=>c_header-private.
    ASSERT io_armor->get_armor_tail( ) = zcl_abappgp_armor=>c_tail-private.

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = io_armor->get_data( ).

    lt_packets = zcl_abappgp_packet_list=>from_stream( lo_stream ).

    CREATE OBJECT ri_message
      TYPE zcl_abappgp_message_03
      EXPORTING
        it_packet_list = lt_packets.

  ENDMETHOD.


  METHOD zif_abappgp_message~to_armor.

* todo

  ENDMETHOD.
ENDCLASS.