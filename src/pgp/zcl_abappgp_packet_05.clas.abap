CLASS zcl_abappgp_packet_05 DEFINITION
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

    METHODS decrypt
      IMPORTING
        !iv_password      TYPE zabappgp_password
      RETURNING
        VALUE(ro_private) TYPE REF TO zcl_abappgp_rsa_private_key
      RAISING
        zcx_abappgp_invalid_key .
    METHODS constructor
      IMPORTING
        !iv_version   TYPE zif_abappgp_constants=>ty_version
        !iv_time      TYPE i
        !iv_algorithm TYPE zif_abappgp_constants=>ty_algorithm_pub
        !io_n         TYPE REF TO zcl_abappgp_integer
        !io_e         TYPE REF TO zcl_abappgp_integer
        !iv_sym       TYPE zif_abappgp_constants=>ty_algorithm_sym
        !io_s2k       TYPE REF TO zcl_abappgp_string_to_key
        !iv_ivector   TYPE xstring
        !iv_encrypted TYPE xstring .
    METHODS get_ivector
      RETURNING
        VALUE(rv_ivector) TYPE xstring .
    METHODS get_encrypted
      RETURNING
        VALUE(rv_encrypted) TYPE xstring .
    METHODS get_s2k
      RETURNING
        VALUE(ro_s2k) TYPE REF TO zcl_abappgp_string_to_key .
  PROTECTED SECTION.

    DATA mo_e TYPE REF TO zcl_abappgp_integer .
    DATA mo_n TYPE REF TO zcl_abappgp_integer .
    DATA mv_algorithm TYPE zif_abappgp_constants=>ty_algorithm_pub .
    DATA mv_time TYPE i .
    DATA mv_version TYPE zif_abappgp_constants=>ty_version .
    DATA mv_sym TYPE zif_abappgp_constants=>ty_algorithm_sym .
    DATA mo_s2k TYPE REF TO zcl_abappgp_string_to_key .
    DATA mv_ivector TYPE xstring .
    DATA mv_encrypted TYPE xstring .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_PACKET_05 IMPLEMENTATION.


  METHOD constructor.

    mo_e         = io_e.
    mo_n         = io_n.
    mv_algorithm = iv_algorithm.
    mv_time      = iv_time.
    mv_version   = iv_version.
    mv_sym       = iv_sym.
    mo_s2k       = io_s2k.
    mv_ivector   = iv_ivector.
    mv_encrypted = iv_encrypted.

  ENDMETHOD.


  METHOD decrypt.

    CONSTANTS: lc_hash_length TYPE i VALUE 20.

    DATA: lv_key    TYPE xstring,
          lv_hash   TYPE xstring,
          lv_offset TYPE i,
          lv_length TYPE i,
          lv_plain  TYPE xstring,
          lo_stream TYPE REF TO zcl_abappgp_stream,
          lo_d      TYPE REF TO zcl_abappgp_integer,
          lo_p      TYPE REF TO zcl_abappgp_integer,
          lo_q      TYPE REF TO zcl_abappgp_integer,
          lo_u      TYPE REF TO zcl_abappgp_integer.


    lv_key = get_s2k( )->build_key( iv_password ).

    lv_plain = zcl_abappgp_symmetric=>aes256_decrypt_normal(
      iv_ciphertext = get_encrypted( )
      iv_key        = lv_key
      iv_ivector    = get_ivector( ) ).

    lv_length = xstrlen( get_encrypted( ) ).
    lv_plain = lv_plain(lv_length).

    lv_offset = xstrlen( lv_plain ) - lc_hash_length.
    lv_hash = lv_plain+lv_offset(lc_hash_length).
    lv_plain = lv_plain(lv_offset).

    IF zcl_abappgp_hash=>sha1( lv_plain ) <> lv_hash.
      RAISE EXCEPTION TYPE zcx_abappgp_invalid_key.
    ENDIF.

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = lv_plain.
    lo_d = lo_stream->eat_mpi( ).
    lo_p = lo_stream->eat_mpi( ).
    lo_q = lo_stream->eat_mpi( ).
    lo_u = lo_stream->eat_mpi( ).

    CREATE OBJECT ro_private
      EXPORTING
        io_d = lo_d
        io_p = lo_p
        io_q = lo_q
        io_u = lo_u.

  ENDMETHOD.


  METHOD get_encrypted.

    rv_encrypted = mv_encrypted.

  ENDMETHOD.


  METHOD get_ivector.

    rv_ivector = mv_ivector.

  ENDMETHOD.


  METHOD get_s2k.

    ro_s2k = mo_s2k.

  ENDMETHOD.


  METHOD zif_abappgp_packet~dump.

    rv_dump = |{ get_name( )
      }(tag { get_tag( )
      })({ to_stream( )->get_length( ) } bytes)\n\tVersion\t{
      mv_version }\n\tTime\t\t{
      zcl_abappgp_time=>format_unix( mv_time ) }\n\tAlgorithm\t{
      mv_algorithm }\n\tRSA n\t\t{
      mo_n->get_binary_length( ) } bits\n\tRSA e\t\t{
      mo_e->get_binary_length( ) } bits\n\tSym\t\t{
      mv_sym }\n{
      mo_s2k->dump( ) }\tIVector\t{
      mv_ivector }\n|.

    rv_dump = |{ rv_dump }\tEnc RSA d\n|.

    rv_dump = |{ rv_dump }\tEnc RSA p\n|.

    rv_dump = |{ rv_dump }\tEnc RSA q\n|.

    rv_dump = |{ rv_dump }\tEnc RSA u\n|.

    rv_dump = |{ rv_dump }\tEnc SHA1\n|.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_version   TYPE zif_abappgp_constants=>ty_version,
          lv_pub       TYPE zif_abappgp_constants=>ty_algorithm_pub,
          lv_sym       TYPE zif_abappgp_constants=>ty_algorithm_sym,
          lv_time      TYPE i,
          lv_usage     TYPE x LENGTH 1,
          lv_ivector   TYPE xstring,
          lv_encrypted TYPE xstring,
          lo_s2k       TYPE REF TO zcl_abappgp_string_to_key,
          lo_n         TYPE REF TO zcl_abappgp_integer,
          lo_e         TYPE REF TO zcl_abappgp_integer.


    lv_version = io_stream->eat_octet( ).
    ASSERT lv_version = zif_abappgp_constants=>c_version-version04.

    lv_time = io_stream->eat_time( ).

    lv_pub = io_stream->eat_octet( ).
    ASSERT lv_pub = zif_abappgp_constants=>c_algorithm_pub-rsa.

    lo_n = io_stream->eat_mpi( ).
    lo_e = io_stream->eat_mpi( ).

    lv_usage = io_stream->eat_octet( ).
    IF lv_usage = 'FF' OR lv_usage = 'FE'.
      lv_sym = io_stream->eat_octet( ).
      ASSERT lv_sym = zif_abappgp_constants=>c_algorithm_sym-aes256.
      lo_s2k = io_stream->eat_s2k( ).
      lv_ivector = io_stream->eat_octets( 16 ).
    ENDIF.

    lv_encrypted = io_stream->get_data( ).

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_05
      EXPORTING
        iv_version   = lv_version
        iv_time      = lv_time
        iv_algorithm = lv_pub
        io_n         = lo_n
        io_e         = lo_e
        iv_sym       = lv_sym
        io_s2k       = lo_s2k
        iv_ivector   = lv_ivector
        iv_encrypted = lv_encrypted.

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_name.

    rv_name = 'Secret-Key Packet'(001).

  ENDMETHOD.


  METHOD zif_abappgp_packet~get_tag.

    rv_tag = zif_abappgp_constants=>c_tag-secret_key.

  ENDMETHOD.


  METHOD zif_abappgp_packet~to_stream.

    CREATE OBJECT ro_stream.
    ro_stream->write_octet( mv_version ).
    ro_stream->write_time( mv_time ).
    ro_stream->write_octet( mv_algorithm ).
    ro_stream->write_mpi( mo_n ).
    ro_stream->write_mpi( mo_e ).
    ro_stream->write_octet( 'FE' ).
    ro_stream->write_octet( mv_sym ).
    ro_stream->write_stream( mo_s2k->to_stream( ) ).
    ro_stream->write_octets( mv_ivector ).
    ro_stream->write_octets( mv_encrypted ).

  ENDMETHOD.
ENDCLASS.