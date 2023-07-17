CLASS zcl_abappgp_stream DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_data TYPE xstring OPTIONAL .
    METHODS eat_length
      RETURNING
        VALUE(rv_length) TYPE i .
    METHODS eat_mpi
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS eat_octet
      RETURNING
        VALUE(rv_octet) TYPE xstring .
    METHODS eat_octets
      IMPORTING
        !iv_count        TYPE i
      RETURNING
        VALUE(rv_octets) TYPE xstring .
    METHODS eat_s2k
      RETURNING
        VALUE(ro_s2k) TYPE REF TO zcl_abappgp_string_to_key .
    METHODS eat_stream
      IMPORTING
        !iv_octets       TYPE i
      RETURNING
        VALUE(ro_stream) TYPE REF TO zcl_abappgp_stream .
    METHODS eat_time
      RETURNING
        VALUE(rv_time) TYPE i .
    METHODS get_data
      RETURNING
        VALUE(rv_data) TYPE xstring .
    METHODS get_length
      RETURNING
        VALUE(rv_length) TYPE i .
    METHODS write_length
      IMPORTING
        !iv_length TYPE i .
    METHODS write_mpi
      IMPORTING
        !io_integer TYPE REF TO zcl_abappgp_integer .
    METHODS write_octet
      IMPORTING
        !iv_octet TYPE xsequence .
    METHODS write_octets
      IMPORTING
        !iv_octets TYPE xsequence .
    METHODS write_s2k
      IMPORTING
        !io_s2k TYPE REF TO zcl_abappgp_string_to_key .
    METHODS write_stream
      IMPORTING
        !io_stream TYPE REF TO zcl_abappgp_stream .
    METHODS write_time
      IMPORTING
        !iv_time TYPE i .
  PROTECTED SECTION.

    DATA mv_data TYPE xstring .
  PRIVATE SECTION.
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
      rv_length = eat_octet( ) * 65536 + eat_octet( ) * 256 + eat_octet( ).
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


  METHOD eat_s2k.

    ro_s2k = zcl_abappgp_string_to_key=>from_stream( me ).

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
* https://tools.ietf.org/html/rfc4880#section-4.2.2

    DATA: lv_octet  TYPE x LENGTH 1,
          lv_octet4 TYPE x LENGTH 4.


    ASSERT iv_length > 0.

    IF iv_length <= 191.
      lv_octet = iv_length.
      write_octet( lv_octet ).
    ELSEIF iv_length <= 8383.
      lv_octet = ( ( iv_length - 192 ) DIV 256 ) + 192.
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


  METHOD write_s2k.

    write_stream( io_s2k->to_stream( ) ).

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
