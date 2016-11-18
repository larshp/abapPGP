class ZCL_ABAPPGP_SUBPACKET_32 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_SUBPACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_SUBPACKET~FROM_STREAM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_32 IMPLEMENTATION.


  METHOD zif_abappgp_subpacket~from_stream.

* todo

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_subpacket_32.

  ENDMETHOD.
ENDCLASS.