class ZCL_ABAPPGP_PACKET_02 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_PACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_PACKET~FROM_STREAM .

  types TY_SUBPACKETS type standard table of ref to zif_abappgp_subpacket with default key .
protected section.

  types TY_SUB_TYPE type I .

  constants:
    BEGIN OF c_sub_type,
               signature_creation_time   TYPE ty_sub_type VALUE 2,
               signature_expiration_time TYPE ty_sub_type VALUE 3,
               exportable_certification  TYPE ty_sub_type VALUE 4,
               trust_signature           TYPE ty_sub_type VALUE 5,
               regular_expression        TYPE ty_sub_type VALUE 6,
               revocable                 TYPE ty_sub_type VALUE 7,
               key_expiration_time       TYPE ty_sub_type VALUE 9,
               placeholder_for_backward  TYPE ty_sub_type VALUE 10,
               preferred_symmetric       TYPE ty_sub_type VALUE 11,
               revocation_key            TYPE ty_sub_type VALUE 12,
               issuer                    TYPE ty_sub_type VALUE 16,
               notation_data             TYPE ty_sub_type VALUE 20,
               preferred_hash_algorithms TYPE ty_sub_type VALUE 21,
               preferred_compression     TYPE ty_sub_type VALUE 22,
               key_server_preferences    TYPE ty_sub_type VALUE 23,
               preferred_key_server      TYPE ty_sub_type VALUE 24,
               primary_user_id           TYPE ty_sub_type VALUE 25,
               policy_uri                TYPE ty_sub_type VALUE 26,
               key_flags                 TYPE ty_sub_type VALUE 27,
               signers_user_id           TYPE ty_sub_type VALUE 28,
               reason_for_revocation     TYPE ty_sub_type VALUE 29,
               features                  TYPE ty_sub_type VALUE 30,
               signature_target          TYPE ty_sub_type VALUE 31,
               embedded_signature        TYPE ty_sub_type VALUE 32,
             END OF c_sub_type .

  class-methods HASHED_SUBPACKETS
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RT_SUBPACKETS) type TY_SUBPACKETS .
  class-methods UNHASHED_SUBPACKETS
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RT_SUBPACKETS) type TY_SUBPACKETS .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_02 IMPLEMENTATION.


  METHOD hashed_subpackets.

    DATA: lv_length   TYPE i,
          lo_data     TYPE REF TO zcl_abappgp_stream,
          li_sub      TYPE REF TO zif_abappgp_subpacket,
          lv_sub_type TYPE x LENGTH 1.


    WHILE io_stream->get_length( ) > 0.
      lv_length = zcl_abappgp_convert=>read_length( io_stream ) - 1.
      lv_sub_type = zcl_abappgp_convert=>bits_to_integer(
        zcl_abappgp_convert=>to_bits( io_stream->eat_octet( ) ) ).
      lo_data = io_stream->eat_stream( lv_length ).

      CASE lv_sub_type.
        WHEN c_sub_type-signature_creation_time.
          li_sub = zcl_abappgp_subpacket_02=>from_stream( lo_data ).
        WHEN c_sub_type-signature_expiration_time.
          li_sub = zcl_abappgp_subpacket_03=>from_stream( lo_data ).
        WHEN c_sub_type-exportable_certification.
          li_sub = zcl_abappgp_subpacket_04=>from_stream( lo_data ).
        WHEN c_sub_type-trust_signature.
          li_sub = zcl_abappgp_subpacket_05=>from_stream( lo_data ).
        WHEN c_sub_type-regular_expression.
          li_sub = zcl_abappgp_subpacket_06=>from_stream( lo_data ).
        WHEN c_sub_type-revocable.
          li_sub = zcl_abappgp_subpacket_07=>from_stream( lo_data ).
        WHEN c_sub_type-key_expiration_time.
          li_sub = zcl_abappgp_subpacket_09=>from_stream( lo_data ).
        WHEN c_sub_type-placeholder_for_backward.
          li_sub = zcl_abappgp_subpacket_10=>from_stream( lo_data ).
        WHEN c_sub_type-preferred_symmetric.
          li_sub = zcl_abappgp_subpacket_11=>from_stream( lo_data ).
        WHEN c_sub_type-revocation_key.
          li_sub = zcl_abappgp_subpacket_12=>from_stream( lo_data ).
        WHEN c_sub_type-issuer.
          li_sub = zcl_abappgp_subpacket_16=>from_stream( lo_data ).
        WHEN c_sub_type-notation_data.
          li_sub = zcl_abappgp_subpacket_20=>from_stream( lo_data ).
        WHEN c_sub_type-preferred_hash_algorithms.
          li_sub = zcl_abappgp_subpacket_21=>from_stream( lo_data ).
        WHEN c_sub_type-preferred_compression.
          li_sub = zcl_abappgp_subpacket_22=>from_stream( lo_data ).
        WHEN c_sub_type-key_server_preferences.
          li_sub = zcl_abappgp_subpacket_23=>from_stream( lo_data ).
        WHEN c_sub_type-preferred_key_server.
          li_sub = zcl_abappgp_subpacket_24=>from_stream( lo_data ).
        WHEN c_sub_type-primary_user_id.
          li_sub = zcl_abappgp_subpacket_25=>from_stream( lo_data ).
        WHEN c_sub_type-policy_uri.
          li_sub = zcl_abappgp_subpacket_26=>from_stream( lo_data ).
        WHEN c_sub_type-key_flags.
          li_sub = zcl_abappgp_subpacket_27=>from_stream( lo_data ).
        WHEN c_sub_type-signers_user_id.
          li_sub = zcl_abappgp_subpacket_28=>from_stream( lo_data ).
        WHEN c_sub_type-reason_for_revocation.
          li_sub = zcl_abappgp_subpacket_29=>from_stream( lo_data ).
        WHEN c_sub_type-features.
          li_sub = zcl_abappgp_subpacket_30=>from_stream( lo_data ).
        WHEN c_sub_type-signature_target.
          li_sub = zcl_abappgp_subpacket_31=>from_stream( lo_data ).
        WHEN c_sub_type-embedded_signature.
          li_sub = zcl_abappgp_subpacket_32=>from_stream( lo_data ).
        WHEN OTHERS.
          ASSERT 0 = 1.
      ENDCASE.

      APPEND li_sub TO rt_subpackets.

    ENDWHILE.

    ASSERT io_stream->get_length( ) = 0.

  ENDMETHOD.


  METHOD unhashed_subpackets.

    BREAK-POINT.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_version   TYPE x LENGTH 1,
          lv_signature TYPE x LENGTH 1,
          lv_pk_algo   TYPE x LENGTH 1,
          lv_left      TYPE x LENGTH 2,
          lv_hash_algo TYPE x LENGTH 1,
          lt_hashed    TYPE ty_subpackets,
          lt_unhashed  TYPE ty_subpackets,
          lo_integer   TYPE REF TO zcl_abappgp_integer,
          lv_count     TYPE i.


    lv_version = io_stream->eat_octet( ).
    ASSERT lv_version = '04'.
    lv_signature = io_stream->eat_octet( ).
    lv_pk_algo = io_stream->eat_octet( ).
    lv_hash_algo = io_stream->eat_octet( ).

    lv_count = zcl_abappgp_convert=>bits_to_integer(
      zcl_abappgp_convert=>to_bits( io_stream->eat_octets( 2 ) ) ).
    IF lv_count > 0.
      lt_hashed = hashed_subpackets( io_stream->eat_stream( lv_count ) ).
    ENDIF.

    lv_count = zcl_abappgp_convert=>bits_to_integer(
      zcl_abappgp_convert=>to_bits( io_stream->eat_octets( 2 ) ) ).
    IF lv_count > 0.
      lt_unhashed = unhashed_subpackets( io_stream->eat_stream( lv_count ) ).
    ENDIF.

    lv_left = io_stream->eat_octets( 2 ).

* todo, one or more MPI, algorithm specific
    lo_integer = zcl_abappgp_convert=>read_mpi( io_stream ).

    BREAK-POINT.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_PACKET~GET_TAG.

    BREAK-POINT.

  ENDMETHOD.


  METHOD ZIF_ABAPPGP_PACKET~TO_STREAM.

    BREAK-POINT.

  ENDMETHOD.
ENDCLASS.