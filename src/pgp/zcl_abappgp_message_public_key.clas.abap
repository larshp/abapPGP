class ZCL_ABAPPGP_MESSAGE_PUBLIC_KEY definition
  public
  inheriting from ZCL_ABAPPGP_MESSAGE
  create public .

public section.

  class-methods FROM_STRING
    importing
      !IV_STRING type STRING
    returning
      value(RO_MESSAGE) type ref to ZCL_ABAPPGP_MESSAGE_PUBLIC_KEY .
  methods CONSTRUCTOR
    importing
      !IT_PACKET_LIST type TY_PACKET_LIST .
  methods DUMP
    returning
      value(RV_STRING) type STRING .
protected section.

  data MT_PACKET_LIST type TY_PACKET_LIST .

  class-methods FIND_ENCODED_DATA
    importing
      !IV_STRING type STRING
    returning
      value(RV_DATA) type STRING .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_MESSAGE_PUBLIC_KEY IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    mt_packet_list = it_packet_list.

  ENDMETHOD.


  METHOD dump.

    DATA: li_packet LIKE LINE OF mt_packet_list.


    LOOP AT mt_packet_list INTO li_packet.
      rv_string = rv_string && li_packet->dump( ).
    ENDLOOP.

  ENDMETHOD.


  METHOD find_encoded_data.

    DATA: lt_string TYPE TABLE OF string,
          lv_start  TYPE abap_bool,
          lv_string TYPE string.


    lv_string = iv_string.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN lv_string
      WITH cl_abap_char_utilities=>newline.
    SPLIT lv_string AT cl_abap_char_utilities=>newline INTO TABLE lt_string.

    LOOP AT lt_string INTO lv_string.
      IF sy-tabix = lines( lt_string ) OR sy-tabix = lines( lt_string ) - 1.
        CONTINUE.
      ELSEIF lv_string IS INITIAL.
        lv_start = abap_true.
      ELSEIF lv_start = abap_true.
        CONCATENATE rv_data lv_string INTO rv_data.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD from_string.

    DATA: lo_stream  TYPE REF TO zcl_abappgp_stream,
          lt_packets TYPE ty_packet_list,
          lv_bin     TYPE xstring.


    lv_bin = zcl_abappgp_convert=>base64_decode( find_encoded_data( iv_string ) ).

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = lv_bin.

    lt_packets = from_stream( lo_stream ).

    CREATE OBJECT ro_message
      EXPORTING
        it_packet_list = lt_packets.

  ENDMETHOD.
ENDCLASS.