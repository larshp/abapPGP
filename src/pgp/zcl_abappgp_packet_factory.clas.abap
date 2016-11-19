class ZCL_ABAPPGP_PACKET_FACTORY definition
  public
  create public .

public section.

  class-methods CREATE
    importing
      !IO_DATA type ref to ZCL_ABAPPGP_STREAM
      !IV_TAG type ZIF_ABAPPGP_CONSTANTS=>TY_TAG
    returning
      value(RI_PKT) type ref to ZIF_ABAPPGP_PACKET .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_FACTORY IMPLEMENTATION.


  METHOD create.

    CASE iv_tag.
      WHEN zif_abappgp_constants=>c_tag-public_key_enc.
        ri_pkt = zcl_abappgp_packet_01=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-signature.
        ri_pkt = zcl_abappgp_packet_02=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-symmetric_key_enc.
        ri_pkt = zcl_abappgp_packet_03=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-one_pass.
        ri_pkt = zcl_abappgp_packet_04=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-secret_key.
        ri_pkt = zcl_abappgp_packet_05=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-public_key.
        ri_pkt = zcl_abappgp_packet_06=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-secret_subkey.
        ri_pkt = zcl_abappgp_packet_07=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-compressed_data.
        ri_pkt = zcl_abappgp_packet_08=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-symmetrical_enc.
        ri_pkt = zcl_abappgp_packet_09=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-marker.
        ri_pkt = zcl_abappgp_packet_10=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-literal.
        ri_pkt = zcl_abappgp_packet_11=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-trust.
        ri_pkt = zcl_abappgp_packet_12=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-user_id.
        ri_pkt = zcl_abappgp_packet_13=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-public_subkey.
        ri_pkt = zcl_abappgp_packet_14=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-user_attribute.
        ri_pkt = zcl_abappgp_packet_17=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-symmetrical_inte.
        ri_pkt = zcl_abappgp_packet_18=>from_stream( io_data ).
      WHEN zif_abappgp_constants=>c_tag-modification_detection.
        ri_pkt = zcl_abappgp_packet_19=>from_stream( io_data ).
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.