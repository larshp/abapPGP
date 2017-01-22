CLASS zcl_abappgp_packet_06 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abappgp_packet .

    ALIASES from_stream
      FOR zif_abappgp_packet~from_stream .
    ALIASES get_name
      FOR zif_abappgp_packet~get_name .
    ALIASES get_tag
      FOR zif_abappgp_packet~get_tag .
    ALIASES to_stream
      FOR zif_abappgp_packet~to_stream .

    METHODS constructor
      IMPORTING
        !iv_version   TYPE zif_abappgp_constants=>ty_version
        !iv_time      TYPE i
        !iv_algorithm TYPE zif_abappgp_constants=>ty_algorithm_pub
        !io_key       TYPE REF TO zcl_abappgp_rsa_public_key .
  PROTECTED SECTION.

    DATA mo_key TYPE REF TO zcl_abappgp_rsa_public_key .
    DATA mv_algorithm TYPE zif_abappgp_constants=>ty_algorithm_pub .
    DATA mv_time TYPE i .
    DATA mv_version TYPE zif_abappgp_constants=>ty_version .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_06 IMPLEMENTATION.


  METHOD constructor.

    mo_key       = io_key.
    mv_algorithm = iv_algorithm.
    mv_time      = iv_time.
    mv_version   = iv_version.

  ENDMETHOD.


  METHOD zif_abappgp_packet~dump.

    rv_dump = |{ get_name( )
      }(tag { get_tag( )
      })({ to_stream( )->get_length( ) } bytes)\n\tVersion\t{
      mv_version }\n\tTime\t\t{
      zcl_abappgp_time=>format_unix( mv_time ) }\n\tAlgorithm\t{
      mv_algorithm }\n\tRSA n\t\t{
      mo_key->get_n( )->get_binary_length( ) } bits\n\tRSA e\t\t{
      mo_key->get_e( )->get_binary_length( ) } bits\n|.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_version   TYPE x LENGTH 1,
          lv_algorithm TYPE x LENGTH 1,
          lv_time      TYPE i,
          lo_key       TYPE REF TO zcl_abappgp_rsa_public_key,
          lo_n         TYPE REF TO zcl_abappgp_integer,
          lo_e         TYPE REF TO zcl_abappgp_integer.


    lv_version = io_stream->eat_octet( ).
    ASSERT lv_version = zif_abappgp_constants=>c_version-version04.

    lv_time = io_stream->eat_time( ).

    lv_algorithm = io_stream->eat_octet( ).
    ASSERT lv_algorithm = zif_abappgp_constants=>c_algorithm_pub-rsa.

    lo_n = io_stream->eat_mpi( ).
    lo_e = io_stream->eat_mpi( ).

    CREATE OBJECT lo_key
      EXPORTING
        io_n = lo_n
        io_e = lo_e.

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_06
      EXPORTING
        iv_version   = lv_version
        iv_time      = lv_time
        iv_algorithm = lv_algorithm
        io_key       = lo_key.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'Public-Key Packet'(001).

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-public_key.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

    CREATE OBJECT ro_stream.
    ro_stream->write_octet( mv_version ).
    ro_stream->write_time( mv_time ).
    ro_stream->write_octet( mv_algorithm ).
    ro_stream->write_mpi( mo_key->get_n( ) ).
    ro_stream->write_mpi( mo_key->get_e( ) ).

  ENDMETHOD.
ENDCLASS.
