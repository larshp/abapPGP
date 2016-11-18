class ZCL_ABAPPGP_PACKET_PUBLIC_KEY definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_PACKET .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_PUBLIC_KEY IMPLEMENTATION.


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

    BREAK-POINT.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

* todo

  ENDMETHOD.
ENDCLASS.