class ZCL_ABAPPGP_PACKET_01 definition
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

  methods CONSTRUCTOR
    importing
      !IV_KEY_ID type XSEQUENCE
      !IV_ALGO type XSEQUENCE
      !IV_ENCRYPTED type XSTRING .
protected section.
private section.

  data MV_KEY_ID type XSTRING .
  data MV_ALGO type XSTRING .
  data MV_ENCRYPTED type XSTRING .
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_01 IMPLEMENTATION.


  METHOD constructor.

    mv_key_id    = iv_key_id.
    mv_algo      = iv_algo.
    mv_encrypted = iv_encrypted.

  ENDMETHOD.


  METHOD zif_abappgp_packet~dump.

    rv_dump = |{ get_name( ) }(tag { get_tag( ) })({ to_stream( )->get_length( )
      } bytes)\n\tKey\t{ mv_key_id
      }\n\tAlgo\t{ mv_algo
      }\n\tData\t{ xstrlen( mv_encrypted ) } bytes\n|.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.
* https://tools.ietf.org/html/rfc4880#section-5.1

    DATA: lv_key_id    TYPE x LENGTH 8,
          lv_algo      TYPE x LENGTH 1,
          lv_encrypted TYPE xstring.


    ASSERT io_stream->eat_octet( ) = zif_abappgp_constants=>c_version-version03.

    lv_key_id    = io_stream->eat_octets( 8 ).
    lv_algo      = io_stream->eat_octet( ).
    lv_encrypted = io_stream->get_data( ).

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_01
      EXPORTING
        iv_key_id    = lv_key_id
        iv_algo      = lv_algo
        iv_encrypted = lv_encrypted.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'Public-Key Encrypted Session Key Packet'(001).

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-public_key_enc.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

    CREATE OBJECT ro_stream.
    ro_stream->write_octets( zif_abappgp_constants=>c_version-version03 ).
    ro_stream->write_octets( mv_key_id ).
    ro_stream->write_octets( mv_algo ).
    ro_stream->write_octets( mv_encrypted ).

  ENDMETHOD.
ENDCLASS.