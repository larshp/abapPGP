class ZCL_ABAPPGP_KEY definition
  public
  final
  create public .

public section.

  class-methods FROM_STRING
    importing
      !IV_STRING type STRING .
  methods TO_STRING
    returning
      value(RV_STRING) type STRING .
protected section.

  types TY_TAG type I .

  constants:
    BEGIN OF c_algorithm,
               rsa TYPE x LENGTH 1 VALUE '01',
             END OF c_algorithm .
  constants:
    BEGIN OF c_tag,
      public_key_enc         TYPE ty_tag VALUE 1,
      signature              TYPE ty_tag VALUE 2,
      symmetric_key_enc      TYPE ty_tag VALUE 3,
      one_pass               TYPE ty_tag VALUE 4,
      secret_key             TYPE ty_tag VALUE 5,
      public_key             TYPE ty_tag VALUE 6,
      secret_subkey          TYPE ty_tag VALUE 7,
      compressed_data        TYPE ty_tag VALUE 8,
      symmetrical_enc        TYPE ty_tag VALUE 9,
      marker                 TYPE ty_tag VALUE 10,
      literal                TYPE ty_tag VALUE 11,
      trust                  TYPE ty_tag VALUE 12,
      user_id                TYPE ty_tag VALUE 13,
      public_subkey          TYPE ty_tag VALUE 14,
      user_attribute         TYPE ty_tag VALUE 17,
      symmetrical_inte       TYPE ty_tag VALUE 18,
      modification_detection TYPE ty_tag VALUE 19,
    END OF c_tag .

  class-methods READ_MPI
    importing
      !IO_STREAM type ref to LCL_STREAM
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  class-methods PACKET_PUBLIC_KEY
    importing
      !IO_STREAM type ref to LCL_STREAM .
  class-methods DETERMINE_TAG
    importing
      !IV_STRING type STRING
    returning
      value(RV_TAG) type I .
  class-methods FIND_ENCODED_DATA
    importing
      !IV_STRING type STRING
    returning
      value(RV_DATA) type STRING .
  class-methods PACKET_HEADER
    importing
      !IO_STREAM type ref to LCL_STREAM
    returning
      value(RV_TAG) type TY_TAG .
  class-methods PACKET_LENGTH
    importing
      !IO_STREAM type ref to LCL_STREAM
    returning
      value(RV_LENGTH) type I .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_KEY IMPLEMENTATION.


  METHOD determine_tag.

    ASSERT strlen( iv_string ) = 6.

    CASE iv_string.
      WHEN '000001'. " Public-Key Encrypted Session Key Packet
        rv_tag = c_tag-public_key_enc.
      WHEN '000010'. " Signature Packet
        rv_tag = c_tag-signature.
      WHEN '000011'. " Symmetric-Key Encrypted Session Key Packet
        rv_tag = c_tag-symmetric_key_enc.
      WHEN '000100'. " One-Pass Signature Packet
        rv_tag = c_tag-one_pass.
      WHEN '000101'. " Secret-Key Packet
        rv_tag = c_tag-secret_key.
      WHEN '000110'. " Public-Key Packet
        rv_tag = c_tag-public_key.
      WHEN '000111'. " Secret-Subkey Packet
        rv_tag = c_tag-secret_subkey.
      WHEN '001000'. " Compressed Data Packet
        rv_tag = c_tag-compressed_data.
      WHEN '001001'. " Symmetrically Encrypted Data Packet
        rv_tag = c_tag-symmetrical_enc.
      WHEN '001010'. " Marker Packet
        rv_tag = c_tag-marker.
      WHEN '001011'. " Literal Data Packet
        rv_tag = c_tag-literal.
      WHEN '001100'. " Trust Packet
        rv_tag = c_tag-trust.
      WHEN '001101'. " User ID Packet
        rv_tag = c_tag-user_id.
      WHEN '001110'. " Public-Subkey Packet
        rv_tag = c_tag-public_subkey.
      WHEN '010001'. " User Attribute Packet
        rv_tag = c_tag-user_attribute.
      WHEN '010010'. " Sym. Encrypted and Integrity Protected Data Packet
        rv_tag = c_tag-symmetrical_inte.
      WHEN '010011'. " Modification Detection Code Packet
        rv_tag = c_tag-modification_detection.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.


  METHOD find_encoded_data.

    DATA: lt_string TYPE TABLE OF string,
          lv_start  TYPE abap_bool,
          lv_string TYPE string.


    SPLIT iv_string AT cl_abap_char_utilities=>newline INTO TABLE lt_string.

    LOOP AT lt_string INTO lv_string.
      IF sy-tabix = lines( lt_string ) OR sy-tabix = lines( lt_string ) - 1.
        CONTINUE.
      ELSEIF lv_string IS INITIAL.
        lv_start = abap_true.
      ELSEIF lv_start = abap_true.
        CONCATENATE rv_data lv_string INTO rv_data.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD from_string.

    DATA: lo_stream TYPE REF TO lcl_stream,
          lv_tag    TYPE ty_tag,
          lv_length TYPE i,
          lv_bin    TYPE xstring.


    lv_bin = lcl_convert=>base64_decode( find_encoded_data( iv_string ) ).

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = lv_bin.

    lv_tag = packet_header( lo_stream ).
    lv_length = packet_length( lo_stream ).

    CASE lv_tag.
      WHEN c_tag-public_key.
        packet_public_key( lo_stream ).
      WHEN OTHERS.
        BREAK-POINT.
    ENDCASE.

  ENDMETHOD.


  METHOD packet_header.

    DATA: lv_octet TYPE x LENGTH 1,
          lv_bits  TYPE string.


    lv_octet = io_stream->eat_octet( ).
    lv_bits = lcl_convert=>to_bits( lv_octet ).
    ASSERT lv_bits(2) = '11'.
    lv_bits = lv_bits+2.
    rv_tag = determine_tag( lv_bits ).

  ENDMETHOD.


  METHOD packet_length.
* https://tools.ietf.org/html/rfc4880#section-4.2.2

    DATA: lv_octet TYPE x LENGTH 1,
          lv_bits  TYPE string.


    lv_octet = io_stream->eat_octet( ).
    lv_bits = lcl_convert=>to_bits( lv_octet ).
    rv_length = lcl_convert=>bits_to_integer( lv_bits ).

    IF rv_length > 191.
      BREAK-POINT.
    ENDIF.

  ENDMETHOD.


  METHOD packet_public_key.

    DATA: lv_version   TYPE x LENGTH 1,
          lv_algorithm TYPE x LENGTH 1,
          lv_time      TYPE x LENGTH 4,
          lo_n         TYPE REF TO zcl_abappgp_integer,
          lo_e         TYPE REF TO zcl_abappgp_integer.


    lv_version = io_stream->eat_octet( ).
    ASSERT lv_version = '04'.

    lv_time = io_stream->eat_octets( 4 ).

    lv_algorithm = io_stream->eat_octet( ).
    ASSERT lv_algorithm = c_algorithm-rsa.

    lo_n = read_mpi( io_stream ).

    lo_e = read_mpi( io_stream ).

    BREAK-POINT.

  ENDMETHOD.


  METHOD read_mpi.

* todo

  ENDMETHOD.


  method TO_STRING.
  endmethod.
ENDCLASS.