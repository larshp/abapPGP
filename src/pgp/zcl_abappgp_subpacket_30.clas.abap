class ZCL_ABAPPGP_SUBPACKET_30 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_SUBPACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_SUBPACKET~FROM_STREAM .
  aliases GET_NAME
    for ZIF_ABAPPGP_SUBPACKET~GET_NAME .
  aliases GET_TYPE
    for ZIF_ABAPPGP_SUBPACKET~GET_TYPE .
  aliases TO_STREAM
    for ZIF_ABAPPGP_SUBPACKET~TO_STREAM .

  methods CONSTRUCTOR
    importing
      !IV_MODIFICATION_DETECTION type ABAP_BOOL .
protected section.

  data MV_MODIFICATION_DETECTION type ABAP_BOOL .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_30 IMPLEMENTATION.


  METHOD constructor.

    mv_modification_detection = iv_modification_detection.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~dump.

    rv_dump = |\tSub - { get_name( ) }(sub { get_type( ) })({
      to_stream( )->get_length( ) } bytes)\n\t\tMod detect\t{
      mv_modification_detection }\n|.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~from_stream.

    DATA: lv_flag TYPE abap_bool.


    IF io_stream->eat_octet( ) = '01'.
      lv_flag = abap_true.
    ENDIF.

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_subpacket_30
      EXPORTING
        iv_modification_detection = lv_flag.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_name.

    rv_name = 'Features'.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_type.

    rv_type = zif_abappgp_constants=>c_sub_type-features.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~to_stream.

    CREATE OBJECT ro_stream.
    IF mv_modification_detection = abap_true.
      ro_stream->write_octet( '01' ).
    ELSE.
      ro_stream->write_octet( '00' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.