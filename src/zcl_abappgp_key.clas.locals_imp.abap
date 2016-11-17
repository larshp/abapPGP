*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_convert DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
      base64_decode
        IMPORTING iv_encoded    TYPE string
        RETURNING VALUE(rv_bin) TYPE xstring,
      bits_to_integer
        IMPORTING iv_bits       TYPE string
        RETURNING VALUE(rv_int) TYPE i,
      to_bits
        IMPORTING iv_data        TYPE xsequence
        RETURNING VALUE(rv_bits) TYPE string.

ENDCLASS.

CLASS lcl_convert IMPLEMENTATION.

  METHOD bits_to_integer.

    DATA: lv_bits  TYPE string,
          lv_power TYPE i VALUE 1.


    lv_bits = reverse( iv_bits ).

    WHILE strlen( lv_bits ) > 0.
      CASE lv_bits(1).
        WHEN '0'.
        WHEN '1'.
          rv_int = rv_int + lv_power.
        WHEN OTHERS.
          ASSERT 0 = 1.
      ENDCASE.
      lv_bits = lv_bits+1.
      lv_power = lv_power * 2.
    ENDWHILE.

  ENDMETHOD.

  METHOD base64_decode.

    CALL FUNCTION 'SSFC_BASE64_DECODE'
      EXPORTING
        b64data                  = iv_encoded
      IMPORTING
        bindata                  = rv_bin
      EXCEPTIONS
        ssf_krn_error            = 1
        ssf_krn_noop             = 2
        ssf_krn_nomemory         = 3
        ssf_krn_opinv            = 4
        ssf_krn_input_data_error = 5
        ssf_krn_invalid_par      = 6
        ssf_krn_invalid_parlen   = 7
        OTHERS                   = 8.
    IF sy-subrc <> 0.
      BREAK-POINT.
    ENDIF.

  ENDMETHOD.

  METHOD to_bits.

    DATA: lv_char   TYPE c LENGTH 1,
          lv_length TYPE i.


    lv_length = xstrlen( iv_data ) * 8.

    DO lv_length TIMES.
      GET BIT sy-index OF iv_data INTO lv_char.
      CONCATENATE rv_bits lv_char INTO rv_bits.
    ENDDO.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_stream IMPLEMENTATION.

  METHOD constructor.
    mv_data = iv_data.
  ENDMETHOD.

  METHOD eat_octet.
    rv_octet = mv_data.
    mv_data = mv_data+1.
  ENDMETHOD.

  METHOD eat_octets.
    rv_octets = mv_data.
    mv_data = mv_data+iv_count.
  ENDMETHOD.

ENDCLASS.