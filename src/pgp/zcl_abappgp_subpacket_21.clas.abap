class ZCL_ABAPPGP_SUBPACKET_21 definition
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
      !IT_ALGORITHMS type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHMS .
protected section.

  data MT_ALGORITHMS type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHMS .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_21 IMPLEMENTATION.


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
      TYPE zcl_abappgp_subpacket_21
      EXPORTING
        it_algorithms = lt_algorithms.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_name.

    rv_name = 'Preferred Hash Algorithms'.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_type.

    rv_type = zif_abappgp_constants=>c_sub_type-preferred_hash_algorithms.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~to_stream.

    DATA: lv_algorithm LIKE LINE OF mt_algorithms.


    CREATE OBJECT ro_stream.
    LOOP AT mt_algorithms INTO lv_algorithm.
      ro_stream->write_octet( lv_algorithm ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.