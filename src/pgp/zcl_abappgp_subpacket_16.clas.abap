CLASS zcl_abappgp_subpacket_16 DEFINITION
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
        !iv_key TYPE xstring .
  PROTECTED SECTION.

    DATA mv_key TYPE xstring .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_16 IMPLEMENTATION.


  METHOD constructor.

    ASSERT xstrlen( iv_key ) = 8.

    mv_key = iv_key.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~dump.

    rv_dump = |\tSub - { get_name( ) }(sub { get_type( ) })({
      to_stream( )->get_length( ) } bytes)\n\t\tKey\t\t{
      mv_key }\n|.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~from_stream.

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_subpacket_16
      EXPORTING
        iv_key = io_stream->get_data( ).

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_name.

    rv_name = 'Issuer'.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_type.

    rv_type = zif_abappgp_constants=>c_sub_type-issuer.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~to_stream.

    CREATE OBJECT ro_stream.
    ro_stream->write_octets( mv_key ).

  ENDMETHOD.
ENDCLASS.
