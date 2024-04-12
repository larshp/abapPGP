CLASS zcl_abappgp_packet_02 DEFINITION
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

    TYPES
      ty_subpackets TYPE STANDARD TABLE OF REF TO zif_abappgp_subpacket WITH DEFAULT KEY .
    TYPES
      ty_integers TYPE STANDARD TABLE OF REF TO zcl_abappgp_integer WITH DEFAULT KEY .

    CLASS-METHODS sign
      IMPORTING
        !iv_data            TYPE xstring
        !iv_time            TYPE i OPTIONAL
        !iv_issuer          TYPE xstring
        !io_private         TYPE REF TO zcl_abappgp_rsa_private_key
      RETURNING
        VALUE(ro_signature) TYPE REF TO zcl_abappgp_packet_02 .
    METHODS constructor
      IMPORTING
        !iv_version   TYPE zif_abappgp_constants=>ty_version
        !iv_signature TYPE zif_abappgp_constants=>ty_signature
        !iv_pk_algo   TYPE zif_abappgp_constants=>ty_algorithm_pub
        !iv_hash_algo TYPE zif_abappgp_constants=>ty_algorithm_hash
        !it_hashed    TYPE ty_subpackets
        !it_unhashed  TYPE ty_subpackets OPTIONAL
        !iv_left      TYPE xsequence
        !it_integers  TYPE ty_integers .
  PROTECTED SECTION.

    DATA mv_version TYPE zif_abappgp_constants=>ty_version .
    DATA mv_signature TYPE zif_abappgp_constants=>ty_signature .
    DATA mv_pk_algo TYPE zif_abappgp_constants=>ty_algorithm_pub .
    DATA mv_hash_algo TYPE zif_abappgp_constants=>ty_algorithm_hash .
    DATA mt_hashed TYPE ty_subpackets .
    DATA mt_unhashed TYPE ty_subpackets .
    DATA
      mv_left      TYPE x LENGTH 2 .
    DATA mt_integers TYPE ty_integers .

    CLASS-METHODS write_subpackets
      IMPORTING
        !io_stream  TYPE REF TO zcl_abappgp_stream
        !it_packets TYPE ty_subpackets .
    CLASS-METHODS eat_subpackets
      IMPORTING
        !io_stream           TYPE REF TO zcl_abappgp_stream
      RETURNING
        VALUE(rt_subpackets) TYPE ty_subpackets .
  PRIVATE SECTION.
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


  METHOD eat_subpackets.

    DATA: lv_length   TYPE i,
          lv_data     TYPE xstring,
          li_sub      TYPE REF TO zif_abappgp_subpacket,
          lv_sub_type TYPE zif_abappgp_constants=>ty_sub_type.


    WHILE io_stream->get_length( ) > 0.
      lv_length = io_stream->eat_length( ) - 1.
      lv_sub_type = io_stream->eat_octet( ).
      lv_data = io_stream->eat_octets( lv_length ).

      li_sub = zcl_abappgp_subpacket_factory=>create(
        iv_data = lv_data
        iv_type = lv_sub_type ).

      APPEND li_sub TO rt_subpackets.
    ENDWHILE.

    ASSERT io_stream->get_length( ) = 0.

  ENDMETHOD.


  METHOD sign.

    DATA: lt_hashed     TYPE ty_subpackets,
          lo_stream     TYPE REF TO zcl_abappgp_stream,
          li_subpacket  TYPE REF TO zif_abappgp_subpacket,
          lv_left       TYPE xstring,
          lv_hash       TYPE xstring,
          lv_em         TYPE xstring,
          lv_hashed     TYPE xstring,
          lv_time       LIKE iv_time,
          lo_em_integer TYPE REF TO zcl_abappgp_integer,
          lo_sign       TYPE REF TO zcl_abappgp_integer,
          lv_length     TYPE x LENGTH 4,
          lt_integers   TYPE ty_integers.


    lv_time = iv_time.
    IF lv_time IS INITIAL.
      lv_time = zcl_abappgp_time=>get_unix( ).
    ENDIF.
    CREATE OBJECT li_subpacket
      TYPE zcl_abappgp_subpacket_02
      EXPORTING
        iv_time = lv_time.
    APPEND li_subpacket TO lt_hashed.

* todo, move iv_issuer somewhere?
    CREATE OBJECT li_subpacket
      TYPE zcl_abappgp_subpacket_16
      EXPORTING
        iv_key = iv_issuer.
    APPEND li_subpacket TO lt_hashed.

    CREATE OBJECT lo_stream.
    lo_stream->write_octets( '04010108' ).

    write_subpackets( io_stream  = lo_stream
                      it_packets = lt_hashed ).

* trailer
    lv_length = xstrlen( lo_stream->get_data( ) ).
    lo_stream->write_octets( '04FF' ).
    lo_stream->write_octets( lv_length ).

    lv_hash = lo_stream->get_data( ).
    CONCATENATE iv_data lv_hash INTO lv_hash IN BYTE MODE.

    lv_hashed = zcl_abappgp_hash=>sha256( lv_hash ).
    lv_left = lv_hashed(2).

    lv_em = zcl_abappgp_encode=>pkcs1_emse( lv_hash ).
    lo_em_integer = zcl_abappgp_integer=>from_hex( lv_em ).

    lo_sign = zcl_abappgp_rsa=>sign(
      io_m       = lo_em_integer
      io_private = io_private ).
    APPEND lo_sign TO lt_integers.

* todo, use constants instead of hardcoded values:
    CREATE OBJECT ro_signature
      EXPORTING
        iv_version   = '04'
        iv_signature = '01'
        iv_pk_algo   = '01'
        iv_hash_algo = '08'
        it_hashed    = lt_hashed
        iv_left      = lv_left
        it_integers  = lt_integers.

  ENDMETHOD.


  METHOD write_subpackets.

    DATA: li_subpacket TYPE REF TO zif_abappgp_subpacket,
          lv_length    TYPE x LENGTH 1,
          lv_type      TYPE x LENGTH 1,
          lv_count     TYPE x LENGTH 2,
          lo_sub       TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_sub.
    LOOP AT it_packets INTO li_subpacket.
      lv_length = li_subpacket->to_stream( )->get_length( ) + 1.
      lo_sub->write_octet( lv_length ).
      lv_type = li_subpacket->get_type( ).
      lo_sub->write_octet( lv_type ).
      lo_sub->write_stream( li_subpacket->to_stream( ) ).
    ENDLOOP.
    lv_count = lo_sub->get_length( ).
    io_stream->write_octets( lv_count ).
    io_stream->write_stream( lo_sub ).

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
    ASSERT lv_version = zif_abappgp_constants=>c_version-version04.
    lv_signature = io_stream->eat_octet( ).
    lv_pk_algo = io_stream->eat_octet( ).
    lv_hash_algo = io_stream->eat_octet( ).

    lv_count = io_stream->eat_octets( 2 ).
    IF lv_count > 0.
      lt_hashed = eat_subpackets( io_stream->eat_stream( lv_count ) ).
    ENDIF.

    lv_count = io_stream->eat_octets( 2 ).
    IF lv_count > 0.
      lt_unhashed = eat_subpackets( io_stream->eat_stream( lv_count ) ).
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

    rv_name = 'Signature Packet'(001).

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-signature.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

    DATA lo_integer TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT ro_stream.
    ro_stream->write_octet( mv_version ).
    ro_stream->write_octet( mv_signature ).
    ro_stream->write_octet( mv_pk_algo ).
    ro_stream->write_octet( mv_hash_algo ).

    write_subpackets( io_stream  = ro_stream
                      it_packets = mt_hashed ).

    write_subpackets( io_stream  = ro_stream
                      it_packets = mt_unhashed ).

    ro_stream->write_octets( mv_left ).

    LOOP AT mt_integers INTO lo_integer.
      ro_stream->write_mpi( lo_integer ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
