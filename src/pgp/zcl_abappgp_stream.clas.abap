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
  methods WRITE_LENGTH
    importing
      !IV_LENGTH type I .
  methods WRITE_MPI
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER .
  methods WRITE_OCTET
    importing
      !IV_OCTET type XSEQUENCE .
  methods WRITE_OCTETS
    importing
      !IV_OCTETS type XSEQUENCE .
  methods WRITE_STREAM
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM .
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

    rv_length = eat_octet( ).

    IF rv_length <= 191.
      RETURN.
    ELSEIF rv_length <= 223.
      rv_length = ( rv_length - 192 ) * 256 + eat_octet( ) + 192.
    ELSEIF rv_length = 255.
      ASSERT eat_octet( ) = '00'. " will overflow in ABAP integer, as it is signed
      rv_length = eat_octet( ) * 65536 + eat_octet( ) * 256 +  eat_octet( ).
    ELSE.
      ASSERT 0 = 1.
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


  METHOD write_length.

    DATA: lv_octet  TYPE x LENGTH 1,
          lv_octet4 TYPE x LENGTH 4.


    ASSERT iv_length > 0.

    IF iv_length <= 191.
      lv_octet = iv_length.
      write_octet( lv_octet ).
    ELSEIF iv_length <= 8383.
      lv_octet = ( iv_length DIV 256 ) + 192 - 1.
      write_octet( lv_octet ).
      lv_octet = ( iv_length - 192 ) MOD 256.
      write_octet( lv_octet ).
    ELSE.
      write_octet( 'FF' ).
      lv_octet4 = iv_length.
      write_octets( lv_octet4 ).
    ENDIF.

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


  METHOD write_stream.

    write_octets( io_stream->get_data( ) ).

  ENDMETHOD.


  METHOD write_time.

    DATA: lv_hex TYPE x LENGTH 4.

    lv_hex = iv_time.

    CONCATENATE mv_data lv_hex INTO mv_data IN BYTE MODE.

  ENDMETHOD.
ENDCLASS.