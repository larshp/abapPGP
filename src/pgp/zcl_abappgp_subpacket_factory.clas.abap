CLASS zcl_abappgp_subpacket_factory DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS create
      IMPORTING
        !iv_data      TYPE xstring
        !iv_type      TYPE zif_abappgp_constants=>ty_sub_type
      RETURNING
        VALUE(ri_sub) TYPE REF TO zif_abappgp_subpacket .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_FACTORY IMPLEMENTATION.


  METHOD create.

    DATA: lo_data TYPE REF TO zcl_abappgp_stream.


    ASSERT xstrlen( iv_data ) > 0.

    CREATE OBJECT lo_data EXPORTING iv_data = iv_data.

    CASE iv_type.
      WHEN zif_abappgp_constants=>c_sub_type-signature_creation_time.
        ri_sub = zcl_abappgp_subpacket_02=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-signature_expiration_time.
        ri_sub = zcl_abappgp_subpacket_03=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-exportable_certification.
        ri_sub = zcl_abappgp_subpacket_04=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-trust_signature.
        ri_sub = zcl_abappgp_subpacket_05=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-regular_expression.
        ri_sub = zcl_abappgp_subpacket_06=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-revocable.
        ri_sub = zcl_abappgp_subpacket_07=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-key_expiration_time.
        ri_sub = zcl_abappgp_subpacket_09=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-placeholder_for_backward.
        ri_sub = zcl_abappgp_subpacket_10=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-preferred_symmetric.
        ri_sub = zcl_abappgp_subpacket_11=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-revocation_key.
        ri_sub = zcl_abappgp_subpacket_12=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-issuer.
        ri_sub = zcl_abappgp_subpacket_16=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-notation_data.
        ri_sub = zcl_abappgp_subpacket_20=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-preferred_hash_algorithms.
        ri_sub = zcl_abappgp_subpacket_21=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-preferred_compression.
        ri_sub = zcl_abappgp_subpacket_22=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-key_server_preferences.
        ri_sub = zcl_abappgp_subpacket_23=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-preferred_key_server.
        ri_sub = zcl_abappgp_subpacket_24=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-primary_user_id.
        ri_sub = zcl_abappgp_subpacket_25=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-policy_uri.
        ri_sub = zcl_abappgp_subpacket_26=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-key_flags.
        ri_sub = zcl_abappgp_subpacket_27=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-signers_user_id.
        ri_sub = zcl_abappgp_subpacket_28=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-reason_for_revocation.
        ri_sub = zcl_abappgp_subpacket_29=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-features.
        ri_sub = zcl_abappgp_subpacket_30=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-signature_target.
        ri_sub = zcl_abappgp_subpacket_31=>from_stream( lo_data ).
      WHEN zif_abappgp_constants=>c_sub_type-embedded_signature.
        ri_sub = zcl_abappgp_subpacket_32=>from_stream( lo_data ).
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
