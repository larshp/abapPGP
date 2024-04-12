CLASS zcl_abappgp_subpacket_02 DEFINITION
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

    DATA mv_time TYPE i .

    METHODS constructor
      IMPORTING
        !iv_time TYPE i .
  PROTECTED SECTION.
  PRIVATE SECTION.
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

    DATA lv_time TYPE i.


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
