class ZCL_ABAPPGP_PACKET_07 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_PACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_PACKET~FROM_STREAM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_07 IMPLEMENTATION.


  METHOD ZIF_ABAPPGP_PACKET~DUMP.

    BREAK-POINT.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_PACKET~FROM_STREAM.

    BREAK-POINT.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'Secret-Subkey Packet'.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-secret_subkey.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_PACKET~TO_STREAM.

    BREAK-POINT.

  ENDMETHOD.
ENDCLASS.