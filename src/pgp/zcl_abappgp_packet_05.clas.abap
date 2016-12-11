class ZCL_ABAPPGP_PACKET_05 definition
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

  methods DECRYPT
    importing
      !IV_KEY type STRING
    returning
      value(RO_PRIVATE) type ref to ZCL_ABAPPGP_RSA_PRIVATE_KEY
    raising
      ZCX_ABAPPGP_INVALID_KEY .
  methods CONSTRUCTOR
    importing
      !IV_VERSION type ZIF_ABAPPGP_CONSTANTS=>TY_VERSION
      !IV_TIME type I
      !IV_ALGORITHM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_PUB
      !IO_N type ref to ZCL_ABAPPGP_INTEGER
      !IO_E type ref to ZCL_ABAPPGP_INTEGER
      !IV_SYM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_SYM
      !IO_S2K type ref to ZCL_ABAPPGP_STRING_TO_KEY
      !IV_IVECTOR type XSTRING
      !IV_ENCRYPTED type XSTRING .
  methods GET_IVECTOR
    returning
      value(RV_IVECTOR) type XSTRING .
  methods GET_ENCRYPTED
    returning
      value(RV_ENCRYPTED) type XSTRING .
  methods GET_S2K
    returning
      value(RO_S2K) type ref to ZCL_ABAPPGP_STRING_TO_KEY .
protected section.

  data MO_E type ref to ZCL_ABAPPGP_INTEGER .
  data MO_N type ref to ZCL_ABAPPGP_INTEGER .
  data MV_ALGORITHM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_PUB .
  data MV_TIME type I .
  data MV_VERSION type ZIF_ABAPPGP_CONSTANTS=>TY_VERSION .
  data MV_SYM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_SYM .
  data MO_S2K type ref to ZCL_ABAPPGP_STRING_TO_KEY .
  data MV_IVECTOR type XSTRING .
  data MV_ENCRYPTED type XSTRING .
private section.
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


    lv_key = get_s2k( )->build_key( iv_key ).

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

    rv_name = 'Secret-Key Packet'.

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