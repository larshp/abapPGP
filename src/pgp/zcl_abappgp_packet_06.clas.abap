class ZCL_ABAPPGP_PACKET_06 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_PACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_PACKET~FROM_STREAM .

  methods CONSTRUCTOR
    importing
      !IV_VERSION type ZIF_ABAPPGP_CONSTANTS=>TY_VERSION
      !IV_TIME type I
      !IV_ALGORITHM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_PUB
      !IO_N type ref to ZCL_ABAPPGP_INTEGER
      !IO_E type ref to ZCL_ABAPPGP_INTEGER .
protected section.

  data MO_E type ref to ZCL_ABAPPGP_INTEGER .
  data MO_N type ref to ZCL_ABAPPGP_INTEGER .
  data MV_ALGORITHM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_PUB .
  data MV_TIME type I .
  data MV_VERSION type ZIF_ABAPPGP_CONSTANTS=>TY_VERSION .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_06 IMPLEMENTATION.


  METHOD constructor.

    mo_e         = io_e.
    mo_n         = io_n.
    mv_algorithm = iv_algorithm.
    mv_time      = iv_time.
    mv_version   = iv_version.

  ENDMETHOD.


  METHOD zif_abappgp_packet~dump.

    BREAK-POINT.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_version   TYPE x LENGTH 1,
          lv_algorithm TYPE x LENGTH 1,
          lv_time      TYPE i,
          lo_n         TYPE REF TO zcl_abappgp_integer,
          lo_e         TYPE REF TO zcl_abappgp_integer.


    lv_version = io_stream->eat_octet( ).
    ASSERT lv_version = zif_abappgp_constants=>c_version-version04.

    lv_time = io_stream->eat_octets( 4 ).

    lv_algorithm = io_stream->eat_octet( ).
    ASSERT lv_algorithm = zif_abappgp_constants=>c_algorithm_pub-rsa.

    lo_n = io_stream->eat_mpi( ).
    lo_e = io_stream->eat_mpi( ).

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_06
      EXPORTING
        iv_version   = lv_version
        iv_time      = lv_time
        iv_algorithm = lv_algorithm
        io_n         = lo_n
        io_e         = lo_e.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'Public-Key Packet'.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-public_key.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_PACKET~TO_STREAM.

    BREAK-POINT.

  ENDMETHOD.
ENDCLASS.