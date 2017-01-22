CLASS zcl_abappgp_subpacket_22 DEFINITION
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
        !it_algorithms TYPE zif_abappgp_constants=>ty_algorithms .
  PROTECTED SECTION.

    DATA mt_algorithms TYPE zif_abappgp_constants=>ty_algorithms .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_22 IMPLEMENTATION.


  METHOD constructor.

    mt_algorithms = it_algorithms.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~dump.

    DATA: lv_algorithm LIKE LINE OF mt_algorithms.


    rv_dump = |\tSub - { get_name( ) }(sub { get_type( ) })({ to_stream( )->get_length( ) } bytes)\n|.

    LOOP AT mt_algorithms INTO lv_algorithm.
      rv_dump = |{ rv_dump }\t\tAlgorithm\t{ lv_algorithm }\n|.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~from_stream.

    DATA: lt_algorithms TYPE zif_abappgp_constants=>ty_algorithms.


    WHILE io_stream->get_length( ) > 0.
      APPEND io_stream->eat_octet( ) TO lt_algorithms.
    ENDWHILE.

    ASSERT lines( lt_algorithms ) > 0.

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_subpacket_22
      EXPORTING
        it_algorithms = lt_algorithms.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_name.

    rv_name = 'Preferred Compression Algorithms'.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_type.

    rv_type = zif_abappgp_constants=>c_sub_type-preferred_compression.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~to_stream.

    DATA: lv_algorithm LIKE LINE OF mt_algorithms.


    CREATE OBJECT ro_stream.
    LOOP AT mt_algorithms INTO lv_algorithm.
      ro_stream->write_octet( lv_algorithm ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
