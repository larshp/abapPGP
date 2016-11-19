class ZCL_ABAPPGP_STREAM definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_DATA type XSTRING optional .
  methods EAT_LENGTH
    returning
      value(RV_LENGTH) type I .
  methods EAT_MPI
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods EAT_OCTET
    returning
      value(RV_OCTET) type XSTRING .
  methods EAT_OCTETS
    importing
      !IV_COUNT type I
    returning
      value(RV_OCTETS) type XSTRING .
  methods EAT_STREAM
    importing
      !IV_OCTETS type I
    returning
      value(RO_STREAM) type ref to ZCL_ABAPPGP_STREAM .
  methods EAT_TIME
    returning
      value(RV_TIME) type I .
  methods GET_DATA
    returning
      value(RV_DATA) type XSTRING .
  methods GET_LENGTH
    returning
      value(RV_LENGTH) type I .
  methods WRITE_MPI
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER .
  methods WRITE_OCTET
    importing
      !IV_OCTET type XSEQUENCE .
  methods WRITE_OCTETS
    importing
      !IV_OCTETS type XSEQUENCE .
  methods WRITE_TIME
    importing
      !IV_TIME type I .
protected section.

  data MV_DATA type XSTRING .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_STREAM IMPLEMENTATION.


  METHOD constructor.

    mv_data = iv_data.

  ENDMETHOD.


  METHOD eat_length.
* https://tools.ietf.org/html/rfc4880#section-4.2.2

    DATA: lv_octet TYPE x LENGTH 1,
          lv_bits  TYPE string.


    lv_octet = eat_octet( ).
    lv_bits = zcl_abappgp_convert=>to_bits( lv_octet ).
    rv_length = zcl_abappgp_convert=>bits_to_integer( lv_bits ).

    IF rv_length > 191.
      BREAK-POINT.
    ENDIF.

  ENDMETHOD.


  METHOD eat_mpi.

    DATA: lv_length TYPE i,
          lv_octets TYPE i.


    lv_length = eat_octets( 2 ).

    lv_octets = lv_length DIV 8.
    IF lv_length MOD 8 <> 0.
      lv_octets = lv_octets + 1.
    ENDIF.

    ro_integer = zcl_abappgp_convert=>bits_to_big_integer(
      zcl_abappgp_convert=>to_bits(
      eat_octets( lv_octets ) ) ).

  ENDMETHOD.


  METHOD eat_octet.
    rv_octet = eat_octets( 1 ).
  ENDMETHOD.


  METHOD eat_octets.

    ASSERT iv_count > 0.

    rv_octets = mv_data(iv_count).

    mv_data = mv_data+iv_count.

  ENDMETHOD.


  METHOD eat_stream.

    DATA: lv_data TYPE xstring.


    lv_data = eat_octets( iv_octets ).

    CREATE OBJECT ro_stream
      EXPORTING
        iv_data = lv_data.

  ENDMETHOD.


  METHOD eat_time.

    rv_time = eat_octets( 4 ).

  ENDMETHOD.


  METHOD get_data.

    rv_data = mv_data.

  ENDMETHOD.


  METHOD get_length.

    rv_length = xstrlen( mv_data ).

  ENDMETHOD.


  METHOD write_mpi.

    DATA: lv_hex    TYPE xstring,
          lv_length TYPE x LENGTH 2.


    lv_length = io_integer->get_binary_length( ).
    lv_hex = io_integer->to_hex( ).

    CONCATENATE mv_data lv_length lv_hex INTO mv_data IN BYTE MODE.

  ENDMETHOD.


  METHOD write_octet.

    ASSERT xstrlen( iv_octet ) >= 1.

    CONCATENATE mv_data iv_octet(1) INTO mv_data IN BYTE MODE.

  ENDMETHOD.


  METHOD write_octets.

    CONCATENATE mv_data iv_octets INTO mv_data IN BYTE MODE.

  ENDMETHOD.


  METHOD write_time.

    DATA: lv_hex TYPE x LENGTH 4.

    lv_hex = iv_time.

    CONCATENATE mv_data lv_hex INTO mv_data IN BYTE MODE.

  ENDMETHOD.
ENDCLASS.