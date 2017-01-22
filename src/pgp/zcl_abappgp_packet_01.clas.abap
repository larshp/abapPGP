CLASS zcl_abappgp_packet_01 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abappgp_packet .

    ALIASES from_stream
      FOR zif_abappgp_packet~from_stream .
    ALIASES get_name
      FOR zif_abappgp_packet~get_name .
    ALIASES get_tag
      FOR zif_abappgp_packet~get_tag .
    ALIASES to_stream
      FOR zif_abappgp_packet~to_stream .

    METHODS constructor
      IMPORTING
        !iv_key_id    TYPE xsequence
        !iv_algo      TYPE xsequence
        !iv_encrypted TYPE xstring .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_key_id TYPE xstring .
    DATA mv_algo TYPE xstring .
    DATA mv_encrypted TYPE xstring .
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
