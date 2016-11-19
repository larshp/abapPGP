class ZCL_ABAPPGP_PACKET_02 definition
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

  types:
    TY_SUBPACKETS type standard table of ref to zif_abappgp_subpacket with default key .
  types:
    TY_integers type standard table of ref to zcl_abappgp_integer with default key .

  methods CONSTRUCTOR
    importing
      !IV_VERSION type ZIF_ABAPPGP_CONSTANTS=>TY_VERSION
      !IV_SIGNATURE type ZIF_ABAPPGP_CONSTANTS=>TY_SIGNATURE
      !IV_PK_ALGO type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_PUB
      !IV_HASH_ALGO type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_HASH
      !IT_HASHED type TY_SUBPACKETS
      !IT_UNHASHED type TY_SUBPACKETS
      !IV_LEFT type XSEQUENCE
      !IT_INTEGERS type TY_INTEGERS .
PROTECTED SECTION.

  DATA: mv_version   TYPE zif_abappgp_constants=>ty_version,
        mv_signature TYPE zif_abappgp_constants=>ty_signature,
        mv_pk_algo   TYPE zif_abappgp_constants=>ty_algorithm_pub,
        mv_hash_algo TYPE zif_abappgp_constants=>ty_algorithm_hash,
        mt_hashed    TYPE ty_subpackets,
        mt_unhashed  TYPE ty_subpackets,
        mv_left      TYPE x LENGTH 2,
        mt_integers  TYPE ty_integers.

  CLASS-METHODS hashed_subpackets
    IMPORTING
      !io_stream           TYPE REF TO zcl_abappgp_stream
    RETURNING
      VALUE(rt_subpackets) TYPE ty_subpackets .
  CLASS-METHODS unhashed_subpackets
    IMPORTING
      !io_stream           TYPE REF TO zcl_abappgp_stream
    RETURNING
      VALUE(rt_subpackets) TYPE ty_subpackets .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_02 IMPLEMENTATION.


  METHOD constructor.

    mv_version   = iv_version.
    mv_signature = iv_signature.
    mv_pk_algo   = iv_pk_algo.
    mv_hash_algo = iv_hash_algo.
    mt_hashed    = it_hashed.
    mt_unhashed  = it_unhashed.
    mv_left      = iv_left.
    mt_integers  = it_integers.

  ENDMETHOD.


  METHOD hashed_subpackets.

    DATA: lv_length   TYPE i,
          lo_data     TYPE REF TO zcl_abappgp_stream,
          li_sub      TYPE REF TO zif_abappgp_subpacket,
          lv_sub_type TYPE x LENGTH 1.


    WHILE io_stream->get_length( ) > 0.
      lv_length = io_stream->eat_length( ) - 1.
      lv_sub_type = zcl_abappgp_convert=>bits_to_integer(
        zcl_abappgp_convert=>to_bits( io_stream->eat_octet( ) ) ).
      lo_data = io_stream->eat_stream( lv_length ).

      CASE lv_sub_type.
        WHEN zif_abappgp_constants=>c_sub_type-signature_creation_time.
          li_sub = zcl_abappgp_subpacket_02=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-signature_expiration_time.
          li_sub = zcl_abappgp_subpacket_03=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-exportable_certification.
          li_sub = zcl_abappgp_subpacket_04=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-trust_signature.
          li_sub = zcl_abappgp_subpacket_05=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-regular_expression.
          li_sub = zcl_abappgp_subpacket_06=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-revocable.
          li_sub = zcl_abappgp_subpacket_07=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-key_expiration_time.
          li_sub = zcl_abappgp_subpacket_09=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-placeholder_for_backward.
          li_sub = zcl_abappgp_subpacket_10=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-preferred_symmetric.
          li_sub = zcl_abappgp_subpacket_11=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-revocation_key.
          li_sub = zcl_abappgp_subpacket_12=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-issuer.
          li_sub = zcl_abappgp_subpacket_16=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-notation_data.
          li_sub = zcl_abappgp_subpacket_20=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-preferred_hash_algorithms.
          li_sub = zcl_abappgp_subpacket_21=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-preferred_compression.
          li_sub = zcl_abappgp_subpacket_22=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-key_server_preferences.
          li_sub = zcl_abappgp_subpacket_23=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-preferred_key_server.
          li_sub = zcl_abappgp_subpacket_24=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-primary_user_id.
          li_sub = zcl_abappgp_subpacket_25=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-policy_uri.
          li_sub = zcl_abappgp_subpacket_26=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-key_flags.
          li_sub = zcl_abappgp_subpacket_27=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-signers_user_id.
          li_sub = zcl_abappgp_subpacket_28=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-reason_for_revocation.
          li_sub = zcl_abappgp_subpacket_29=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-features.
          li_sub = zcl_abappgp_subpacket_30=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-signature_target.
          li_sub = zcl_abappgp_subpacket_31=>from_stream( lo_data ).
        WHEN zif_abappgp_constants=>c_sub_type-embedded_signature.
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


  METHOD zif_abappgp_packet~dump.

    DATA: lo_integer TYPE REF TO zcl_abappgp_integer,
          li_sub     TYPE REF TO zif_abappgp_subpacket.


    rv_dump = |{ get_name( ) }(tag { get_tag( ) })({ to_stream( )->get_length( )
      } bytes)\n\tVersion\t{
      mv_version
      }\n\tSignature\t{
      mv_signature
      }\n\tPub\t\t{
      mv_pk_algo
      }\n\tHash\t\t{
      mv_hash_algo }\n|.

    LOOP AT mt_hashed INTO li_sub.
      rv_dump = |{ rv_dump }{ li_sub->dump( ) }|.
    ENDLOOP.

    LOOP AT mt_unhashed INTO li_sub.
      rv_dump = |{ rv_dump }{ li_sub->dump( ) }|.
    ENDLOOP.

    rv_dump = |{ rv_dump }\tLeft\t\t{ mv_left }\n|.

    LOOP AT mt_integers INTO lo_integer.
      rv_dump = |{ rv_dump }\tInteger\t{ lo_integer->get_binary_length( ) } bits\n|.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_version   TYPE x LENGTH 1,
          lv_signature TYPE x LENGTH 1,
          lv_pk_algo   TYPE x LENGTH 1,
          lv_hash_algo TYPE x LENGTH 1,
          lt_hashed    TYPE ty_subpackets,
          lt_unhashed  TYPE ty_subpackets,
          lv_left      TYPE x LENGTH 2,
          lt_integers  TYPE ty_integers,
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
    APPEND io_stream->eat_mpi( ) TO lt_integers.

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_02
      EXPORTING
        iv_version   = lv_version
        iv_signature = lv_signature
        iv_pk_algo   = lv_pk_algo
        iv_hash_algo = lv_hash_algo
        it_hashed    = lt_hashed
        it_unhashed  = lt_unhashed
        iv_left      = lv_left
        it_integers  = lt_integers.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'Signature Packet'.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-signature.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

* todo

    CREATE OBJECT ro_stream.

  ENDMETHOD.
ENDCLASS.