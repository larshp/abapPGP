CLASS zcl_abappgp_message_06 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abappgp_message .

    ALIASES from_armor
      FOR zif_abappgp_message~from_armor .
    ALIASES to_armor
      FOR zif_abappgp_message~to_armor .

    METHODS constructor
      IMPORTING
        !it_packet_list TYPE zif_abappgp_constants=>ty_packet_list
        !it_headers     TYPE string_table .
    CLASS-METHODS sign
      IMPORTING
        !iv_data            TYPE xstring
        !iv_time            TYPE i OPTIONAL
        !iv_issuer          TYPE xsequence
        !io_private         TYPE REF TO zcl_abappgp_rsa_private_key
      RETURNING
        VALUE(ro_signature) TYPE REF TO zcl_abappgp_message_06 .
  PROTECTED SECTION.

    DATA mt_headers TYPE string_table .
    DATA mt_packet_list TYPE zif_abappgp_constants=>ty_packet_list .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_MESSAGE_06 IMPLEMENTATION.


  METHOD constructor.

    mt_packet_list = it_packet_list.
    mt_headers = it_headers.

  ENDMETHOD.


  METHOD sign.

    DATA: lt_list    TYPE zif_abappgp_constants=>ty_packet_list,
          lv_time    TYPE i,
          lv_issuer  TYPE xstring,
          lt_headers TYPE string_table,
          li_packet  TYPE REF TO zif_abappgp_packet.


    IF iv_time IS INITIAL.
      lv_time = zcl_abappgp_time=>get_unix( ).
    ELSE.
      lv_time = iv_time.
    ENDIF.

    lv_issuer = iv_issuer.

    li_packet = zcl_abappgp_packet_02=>sign(
      iv_data    = iv_data
      iv_time    = lv_time
      iv_issuer  = lv_issuer
      io_private = io_private ).
    APPEND li_packet TO lt_list.

    APPEND 'Version: abapPGP' TO lt_headers.

    CREATE OBJECT ro_signature
      EXPORTING
        it_packet_list = lt_list
        it_headers     = lt_headers.

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


    ASSERT io_armor->get_armor_header( ) = zcl_abappgp_armor=>c_header-signature.
    ASSERT io_armor->get_armor_tail( ) = zcl_abappgp_armor=>c_tail-signature.

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = io_armor->get_data( ).

    lt_packets = zcl_abappgp_packet_list=>from_stream( lo_stream ).

    CREATE OBJECT ri_message
      TYPE zcl_abappgp_message_06
      EXPORTING
        it_packet_list = lt_packets
        it_headers     = io_armor->get_headers( ).

  ENDMETHOD.


  METHOD zif_abappgp_message~to_armor.

    CREATE OBJECT ro_armor
      EXPORTING
        iv_armor_header = zcl_abappgp_armor=>c_header-signature
        it_headers      = mt_headers
        iv_data         = zcl_abappgp_packet_list=>to_stream( mt_packet_list )->get_data( )
        iv_armor_tail   = zcl_abappgp_armor=>c_tail-signature.

  ENDMETHOD.
ENDCLASS.
