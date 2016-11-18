class ZCL_ABAPPGP_PACKET_06 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_PACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_PACKET~FROM_STREAM .

  methods CONSTRUCTOR
    importing
      !IV_VERSION type XSEQUENCE
      !IV_TIME type XSEQUENCE
      !IV_ALGORITHM type XSEQUENCE
      !IO_N type ref to ZCL_ABAPPGP_INTEGER
      !IO_E type ref to ZCL_ABAPPGP_INTEGER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_06 IMPLEMENTATION.


  METHOD CONSTRUCTOR.

* todo, change types of IV_VERSION + IV_TIME + IV_ALGORITHM ?

* todo

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_version   TYPE x LENGTH 1,
          lv_algorithm TYPE x LENGTH 1,
          lv_time      TYPE x LENGTH 4,
          lo_n         TYPE REF TO zcl_abappgp_integer,
          lo_e         TYPE REF TO zcl_abappgp_integer.


    lv_version = io_stream->eat_octet( ).
    ASSERT lv_version = '04'.

    lv_time = io_stream->eat_octets( 4 ).

    lv_algorithm = io_stream->eat_octet( ).
    ASSERT lv_algorithm = zif_abappgp_constants=>c_algorithm-rsa.

    lo_n = zcl_abappgp_convert=>read_mpi( io_stream ).

    lo_e = zcl_abappgp_convert=>read_mpi( io_stream ).

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_06
      EXPORTING
        iv_version   = lv_version
        iv_time      = lv_time
        iv_algorithm = lv_algorithm
        io_n         = lo_n
        io_e         = lo_e.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_PACKET~GET_TAG.

    BREAK-POINT.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_PACKET~TO_STREAM.

    BREAK-POINT.

  ENDMETHOD.
ENDCLASS.