class ZCL_ABAPPGP_PACKET_03 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_PACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_PACKET~FROM_STREAM .
  aliases GET_NAME
    for ZIF_ABAPPGP_PACKET~GET_NAME .
  aliases GET_TAG
    for ZIF_ABAPPGP_PACKET~GET_TAG .
  aliases TO_STREAM
    for ZIF_ABAPPGP_PACKET~TO_STREAM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_03 IMPLEMENTATION.


  METHOD zif_abappgp_packet~dump.

    rv_dump = |{ get_name( ) }(tag { get_tag( ) })({ to_stream( )->get_length( ) } bytes)\n\ttodo\n|.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

* todo

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_03.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'Symmetric-Key Encrypted Session Key Packet'(001).

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-symmetric_key_enc.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

* todo

    CREATE OBJECT ro_stream.

  ENDMETHOD.
ENDCLASS.