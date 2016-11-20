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

  methods CONSTRUCTOR
    importing
      !IV_VERSION type ZIF_ABAPPGP_CONSTANTS=>TY_VERSION
      !IV_TIME type I
      !IV_ALGORITHM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_PUB
      !IO_N type ref to ZCL_ABAPPGP_INTEGER
      !IO_E type ref to ZCL_ABAPPGP_INTEGER
      !IV_SYM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_SYM
      !IO_S2K type ref to ZCL_ABAPPGP_STRING_TO_KEY .
protected section.

  data MO_E type ref to ZCL_ABAPPGP_INTEGER .
  data MO_N type ref to ZCL_ABAPPGP_INTEGER .
  data MV_ALGORITHM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_PUB .
  data MV_TIME type I .
  data MV_VERSION type ZIF_ABAPPGP_CONSTANTS=>TY_VERSION .
  data MV_SYM type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_SYM .
  data MO_S2K type ref to ZCL_ABAPPGP_STRING_TO_KEY .
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

* todo

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
      mo_s2k->dump( ) }\ttodo\n|.

  ENDMETHOD.


  METHOD zif_abappgp_packet~from_stream.

    DATA: lv_version TYPE zif_abappgp_constants=>ty_version,
          lv_pub     TYPE zif_abappgp_constants=>ty_algorithm_pub,
          lv_sym     TYPE zif_abappgp_constants=>ty_algorithm_sym,
          lv_time    TYPE i,
          lv_usage   TYPE x LENGTH 1,
          lo_s2k     TYPE REF TO zcl_abappgp_string_to_key,
          lo_n       TYPE REF TO zcl_abappgp_integer,
          lo_e       TYPE REF TO zcl_abappgp_integer.


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

* todo, IV
    ENDIF.

* todo

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_packet_05
      EXPORTING
        iv_version   = lv_version
        iv_time      = lv_time
        iv_algorithm = lv_pub
        io_n         = lo_n
        io_e         = lo_e
        iv_sym       = lv_sym
        io_s2k       = lo_s2k.

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
* todo

  ENDMETHOD.
ENDCLASS.