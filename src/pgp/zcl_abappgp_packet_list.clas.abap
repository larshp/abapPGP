class ZCL_ABAPPGP_PACKET_LIST definition
  public
  create public .

public section.

  class-methods FROM_STREAM
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RT_PACKETS) type ZIF_ABAPPGP_CONSTANTS=>TY_PACKET_LIST .
  class-methods TO_STREAM
    importing
      !IT_PACKETS type ZIF_ABAPPGP_CONSTANTS=>TY_PACKET_LIST
    returning
      value(RO_STREAM) type ref to ZCL_ABAPPGP_STREAM .
protected section.

  class-methods DETERMINE_TAG
    importing
      !IV_STRING type STRING
    returning
      value(RV_TAG) type I .
  class-methods PACKET_HEADER
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RV_TAG) type ZIF_ABAPPGP_CONSTANTS=>TY_TAG .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_LIST IMPLEMENTATION.


  METHOD DETERMINE_TAG.

    ASSERT strlen( iv_string ) = 6.

    CASE iv_string.
      WHEN '000001'. " Public-Key Encrypted Session Key Packet
        rv_tag = zif_abappgp_constants=>c_tag-public_key_enc.
      WHEN '000010'. " Signature Packet
        rv_tag = zif_abappgp_constants=>c_tag-signature.
      WHEN '000011'. " Symmetric-Key Encrypted Session Key Packet
        rv_tag = zif_abappgp_constants=>c_tag-symmetric_key_enc.
      WHEN '000100'. " One-Pass Signature Packet
        rv_tag = zif_abappgp_constants=>c_tag-one_pass.
      WHEN '000101'. " Secret-Key Packet
        rv_tag = zif_abappgp_constants=>c_tag-secret_key.
      WHEN '000110'. " Public-Key Packet
        rv_tag = zif_abappgp_constants=>c_tag-public_key.
      WHEN '000111'. " Secret-Subkey Packet
        rv_tag = zif_abappgp_constants=>c_tag-secret_subkey.
      WHEN '001000'. " Compressed Data Packet
        rv_tag = zif_abappgp_constants=>c_tag-compressed_data.
      WHEN '001001'. " Symmetrically Encrypted Data Packet
        rv_tag = zif_abappgp_constants=>c_tag-symmetrical_enc.
      WHEN '001010'. " Marker Packet
        rv_tag = zif_abappgp_constants=>c_tag-marker.
      WHEN '001011'. " Literal Data Packet
        rv_tag = zif_abappgp_constants=>c_tag-literal.
      WHEN '001100'. " Trust Packet
        rv_tag = zif_abappgp_constants=>c_tag-trust.
      WHEN '001101'. " User ID Packet
        rv_tag = zif_abappgp_constants=>c_tag-user_id.
      WHEN '001110'. " Public-Subkey Packet
        rv_tag = zif_abappgp_constants=>c_tag-public_subkey.
      WHEN '010001'. " User Attribute Packet
        rv_tag = zif_abappgp_constants=>c_tag-user_attribute.
      WHEN '010010'. " Sym. Encrypted and Integrity Protected Data Packet
        rv_tag = zif_abappgp_constants=>c_tag-symmetrical_inte.
      WHEN '010011'. " Modification Detection Code Packet
        rv_tag = zif_abappgp_constants=>c_tag-modification_detection.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.


  METHOD from_stream.

    DATA: lo_data TYPE REF TO zcl_abappgp_stream,
          lv_tag  TYPE zif_abappgp_constants=>ty_tag,
          li_pkt  TYPE REF TO zif_abappgp_packet.


    WHILE io_stream->get_length( ) > 0.
      lv_tag = packet_header( io_stream ).
      lo_data = io_stream->eat_stream( io_stream->eat_length( ) ).

      li_pkt = zcl_abappgp_packet_factory=>create( io_data = lo_data
                                                   iv_tag  = lv_tag ).

      APPEND li_pkt TO rt_packets.
    ENDWHILE.

  ENDMETHOD.


  METHOD packet_header.

    DATA: lv_bits TYPE string.


    lv_bits = zcl_abappgp_convert=>to_bits( io_stream->eat_octet( ) ).
    ASSERT lv_bits(2) = '11'.
    lv_bits = lv_bits+2.
    rv_tag = determine_tag( lv_bits ).

  ENDMETHOD.


  METHOD to_stream.

* todo

  ENDMETHOD.
ENDCLASS.