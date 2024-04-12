CLASS zcl_abappgp_subpacket_30 DEFINITION
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
        !iv_modification_detection TYPE abap_bool .
  PROTECTED SECTION.

    DATA mv_modification_detection TYPE abap_bool .
  PRIVATE SECTION.
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

    DATA lv_flag TYPE abap_bool.


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
