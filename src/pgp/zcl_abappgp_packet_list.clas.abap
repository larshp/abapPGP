CLASS zcl_abappgp_packet_list DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS from_stream
      IMPORTING
        !io_stream        TYPE REF TO zcl_abappgp_stream
      RETURNING
        VALUE(rt_packets) TYPE zif_abappgp_constants=>ty_packet_list .
    CLASS-METHODS to_stream
      IMPORTING
        !it_packets      TYPE zif_abappgp_constants=>ty_packet_list
      RETURNING
        VALUE(ro_stream) TYPE REF TO zcl_abappgp_stream .
  PROTECTED SECTION.

    TYPES:
      BEGIN OF ty_map,
        binary TYPE string,
        tag    TYPE i,
      END OF ty_map .
    TYPES
      ty_map_tt TYPE STANDARD TABLE OF ty_map WITH DEFAULT KEY .

    CONSTANTS c_new_packet_format TYPE string VALUE '11' ##NO_TEXT.

    CLASS-METHODS build_packet_header
      IMPORTING
        !iv_tag          TYPE zif_abappgp_constants=>ty_tag
      RETURNING
        VALUE(rv_header) TYPE xstring .
    CLASS-METHODS get_tag_mapping
      RETURNING
        VALUE(rt_map) TYPE ty_map_tt .
    CLASS-METHODS tag_to_binary
      IMPORTING
        !iv_tag          TYPE i
      RETURNING
        VALUE(rv_string) TYPE string .
    CLASS-METHODS binary_to_tag
      IMPORTING
        !iv_string    TYPE string
      RETURNING
        VALUE(rv_tag) TYPE i .
    CLASS-METHODS read_packet_header
      IMPORTING
        !io_stream    TYPE REF TO zcl_abappgp_stream
      RETURNING
        VALUE(rv_tag) TYPE zif_abappgp_constants=>ty_tag .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abappgp_packet_list IMPLEMENTATION.


  METHOD binary_to_tag.

    DATA lt_map TYPE ty_map_tt.

    FIELD-SYMBOLS <ls_map> LIKE LINE OF lt_map.


    ASSERT strlen( iv_string ) = 6.

    lt_map = get_tag_mapping( ).

    READ TABLE lt_map WITH KEY binary = iv_string ASSIGNING <ls_map>.
    ASSERT sy-subrc = 0.

    rv_tag = <ls_map>-tag.

*    CASE iv_string.
*      WHEN '000001'. " Public-Key Encrypted Session Key Packet
*        rv_tag = zif_abappgp_constants=>c_tag-public_key_enc.
*      WHEN '000010'. " Signature Packet
*        rv_tag = zif_abappgp_constants=>c_tag-signature.
*      WHEN '000011'. " Symmetric-Key Encrypted Session Key Packet
*        rv_tag = zif_abappgp_constants=>c_tag-symmetric_key_enc.
*      WHEN '000100'. " One-Pass Signature Packet
*        rv_tag = zif_abappgp_constants=>c_tag-one_pass.
*      WHEN '000101'. " Secret-Key Packet
*        rv_tag = zif_abappgp_constants=>c_tag-secret_key.
*      WHEN '000110'. " Public-Key Packet
*        rv_tag = zif_abappgp_constants=>c_tag-public_key.
*      WHEN '000111'. " Secret-Subkey Packet
*        rv_tag = zif_abappgp_constants=>c_tag-secret_subkey.
*      WHEN '001000'. " Compressed Data Packet
*        rv_tag = zif_abappgp_constants=>c_tag-compressed_data.
*      WHEN '001001'. " Symmetrically Encrypted Data Packet
*        rv_tag = zif_abappgp_constants=>c_tag-symmetrical_enc.
*      WHEN '001010'. " Marker Packet
*        rv_tag = zif_abappgp_constants=>c_tag-marker.
*      WHEN '001011'. " Literal Data Packet
*        rv_tag = zif_abappgp_constants=>c_tag-literal.
*      WHEN '001100'. " Trust Packet
*        rv_tag = zif_abappgp_constants=>c_tag-trust.
*      WHEN '001101'. " User ID Packet
*        rv_tag = zif_abappgp_constants=>c_tag-user_id.
*      WHEN '001110'. " Public-Subkey Packet
*        rv_tag = zif_abappgp_constants=>c_tag-public_subkey.
*      WHEN '010001'. " User Attribute Packet
*        rv_tag = zif_abappgp_constants=>c_tag-user_attribute.
*      WHEN '010010'. " Sym. Encrypted and Integrity Protected Data Packet
*        rv_tag = zif_abappgp_constants=>c_tag-symmetrical_inte.
*      WHEN '010011'. " Modification Detection Code Packet
*        rv_tag = zif_abappgp_constants=>c_tag-modification_detection.
*      WHEN OTHERS.
*        ASSERT 0 = 1.
*    ENDCASE

  ENDMETHOD.


  METHOD build_packet_header.

    DATA: lv_bits TYPE string,
          lv_hex  TYPE x LENGTH 1,
          lv_tag  TYPE string.


    lv_tag = tag_to_binary( iv_tag ).

    CONCATENATE c_new_packet_format lv_tag INTO lv_bits.

    lv_hex = zcl_abappgp_convert=>bits_to_integer( lv_bits ).

    rv_header = lv_hex.

  ENDMETHOD.


  METHOD from_stream.

    DATA: lo_data TYPE REF TO zcl_abappgp_stream,
          lv_tag  TYPE zif_abappgp_constants=>ty_tag,
          li_pkt  TYPE REF TO zif_abappgp_packet.


    WHILE io_stream->get_length( ) > 0.
      lv_tag = read_packet_header( io_stream ).
      lo_data = io_stream->eat_stream( io_stream->eat_length( ) ).

      li_pkt = zcl_abappgp_packet_factory=>create( io_data = lo_data
                                                   iv_tag  = lv_tag ).

      APPEND li_pkt TO rt_packets.
    ENDWHILE.

  ENDMETHOD.


  METHOD get_tag_mapping.

    DEFINE _append.
      append initial line to rt_map assigning <ls_map>.
      <ls_map>-binary = &1.
      <ls_map>-tag = &2.
    END-OF-DEFINITION.

    FIELD-SYMBOLS <ls_map> LIKE LINE OF rt_map.


    _append '000001' zif_abappgp_constants=>c_tag-public_key_enc.
    _append '000010' zif_abappgp_constants=>c_tag-signature.
    _append '000011' zif_abappgp_constants=>c_tag-symmetric_key_enc.
    _append '000100' zif_abappgp_constants=>c_tag-one_pass.
    _append '000101' zif_abappgp_constants=>c_tag-secret_key.
    _append '000110' zif_abappgp_constants=>c_tag-public_key.
    _append '000111' zif_abappgp_constants=>c_tag-secret_subkey.
    _append '001000' zif_abappgp_constants=>c_tag-compressed_data.
    _append '001001' zif_abappgp_constants=>c_tag-symmetrical_enc.
    _append '001010' zif_abappgp_constants=>c_tag-marker.
    _append '001011' zif_abappgp_constants=>c_tag-literal.
    _append '001100' zif_abappgp_constants=>c_tag-trust.
    _append '001101' zif_abappgp_constants=>c_tag-user_id.
    _append '001110' zif_abappgp_constants=>c_tag-public_subkey.
    _append '010001' zif_abappgp_constants=>c_tag-user_attribute.
    _append '010010' zif_abappgp_constants=>c_tag-symmetrical_inte.
    _append '010011' zif_abappgp_constants=>c_tag-modification_detection.

  ENDMETHOD.


  METHOD read_packet_header.

    DATA lv_bits TYPE string.


    lv_bits = zcl_abappgp_convert=>to_bits( io_stream->eat_octet( ) ).
    ASSERT lv_bits(2) = c_new_packet_format. " no support for old packet format
    lv_bits = lv_bits+2.
    rv_tag = binary_to_tag( lv_bits ).

  ENDMETHOD.


  METHOD tag_to_binary.

    DATA lt_map TYPE ty_map_tt.

    FIELD-SYMBOLS <ls_map> LIKE LINE OF lt_map.


    lt_map = get_tag_mapping( ).

    READ TABLE lt_map WITH KEY tag = iv_tag ASSIGNING <ls_map>.
    ASSERT sy-subrc = 0.

    rv_string = <ls_map>-binary.

  ENDMETHOD.


  METHOD to_stream.

    DATA: li_packet TYPE REF TO zif_abappgp_packet,
          lv_data   TYPE xstring.


    CREATE OBJECT ro_stream.

    LOOP AT it_packets INTO li_packet.
      ro_stream->write_octets( build_packet_header( li_packet->get_tag( ) ) ).
      lv_data = li_packet->to_stream( )->get_data( ).
      ro_stream->write_length( xstrlen( lv_data ) ).
      ro_stream->write_octets( lv_data ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
