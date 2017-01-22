CLASS zcl_abappgp_subpacket_25 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abappgp_subpacket .

    ALIASES from_stream
      FOR zif_abappgp_subpacket~from_stream .
    ALIASES get_name
      FOR zif_abappgp_subpacket~get_name .
    ALIASES get_type
      FOR zif_abappgp_subpacket~get_type .
    ALIASES to_stream
      FOR zif_abappgp_subpacket~to_stream .

    METHODS constructor
      IMPORTING
        !iv_flag TYPE abap_bool .
  PROTECTED SECTION.

    DATA mv_flag TYPE abap_bool .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_25 IMPLEMENTATION.


  METHOD constructor.

    mv_flag = iv_flag.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~dump.

    rv_dump = |\tSub - { get_name( ) }(sub { get_type( ) })({
      to_stream( )->get_length( ) } bytes)\n\t\tFlag\t\t{
      mv_flag }\n|.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~from_stream.

    DATA: lv_value TYPE x LENGTH 1,
          lv_flag  TYPE abap_bool.


    lv_value = io_stream->eat_octet( ).
    CASE lv_value.
      WHEN '00'.
        lv_flag = abap_false.
      WHEN '01'.
        lv_flag = abap_true.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_subpacket_25
      EXPORTING
        iv_flag = lv_flag.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_name.

    rv_name = 'Primary User ID'.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_type.

    rv_type = zif_abappgp_constants=>c_sub_type-primary_user_id.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~to_stream.

    CREATE OBJECT ro_stream.
    IF mv_flag = abap_true.
      ro_stream->write_octet( '01' ).
    ELSE.
      ro_stream->write_octet( '00' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
