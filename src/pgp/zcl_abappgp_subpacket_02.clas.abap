class ZCL_ABAPPGP_SUBPACKET_02 definition
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

  data MV_TIME type I .

  methods CONSTRUCTOR
    importing
      !IV_TIME type I .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_02 IMPLEMENTATION.


  METHOD constructor.

    mv_time = iv_time.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~dump.

    rv_dump = |\tSub - { get_name( ) }(sub { get_type( ) })({
      to_stream( )->get_length( ) } bytes)\n\t\tTime\t\t{
      zcl_abappgp_time=>format_unix( mv_time ) }\n|.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~from_stream.

    DATA: lv_time TYPE i.


    lv_time = io_stream->eat_time( ).

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_subpacket_02
      EXPORTING
        iv_time = lv_time.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_name.

    rv_name = 'Signature Creation Time'.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_type.

    rv_type = zif_abappgp_constants=>c_sub_type-signature_creation_time.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~to_stream.

    CREATE OBJECT ro_stream.
    ro_stream->write_time( mv_time ).

  ENDMETHOD.
ENDCLASS.