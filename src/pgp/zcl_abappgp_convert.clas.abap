CLASS zcl_abappgp_convert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS base64_decode
      IMPORTING
        !iv_encoded   TYPE string
      RETURNING
        VALUE(rv_bin) TYPE xstring .
    CLASS-METHODS base64_encode
      IMPORTING
        !iv_bin           TYPE xstring
      RETURNING
        VALUE(rv_encoded) TYPE string .
    CLASS-METHODS bits_to_big_integer
      IMPORTING
        !iv_bits          TYPE string
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    CLASS-METHODS bits_to_integer
      IMPORTING
        !iv_bits      TYPE string
      RETURNING
        VALUE(rv_int) TYPE i .
    CLASS-METHODS string_to_utf8
      IMPORTING
        !iv_data       TYPE string
      RETURNING
        VALUE(rv_data) TYPE xstring .
    CLASS-METHODS to_bits
      IMPORTING
        !iv_data       TYPE xsequence
      RETURNING
        VALUE(rv_bits) TYPE string .
    CLASS-METHODS utf8_to_string
      IMPORTING
        !iv_data       TYPE xstring
      RETURNING
        VALUE(rv_data) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_CONVERT IMPLEMENTATION.


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


  METHOD base64_encode.

    CALL FUNCTION 'SSFC_BASE64_ENCODE'
      EXPORTING
        bindata                  = iv_bin
      IMPORTING
        b64data                  = rv_encoded
      EXCEPTIONS
        ssf_krn_error            = 1
        ssf_krn_noop             = 2
        ssf_krn_nomemory         = 3
        ssf_krn_opinv            = 4
        ssf_krn_input_data_error = 5
        ssf_krn_invalid_par      = 6
        ssf_krn_invalid_parlen   = 7
        OTHERS                   = 8.
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD bits_to_big_integer.

    DATA: lv_bits  TYPE string,
          lo_multi TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_multi
      EXPORTING
        iv_integer = 1.

    CREATE OBJECT ro_integer
      EXPORTING
        iv_integer = 0.

    lv_bits = reverse( iv_bits ).

    WHILE strlen( lv_bits ) > 0.
      CASE lv_bits(1).
        WHEN '0'.
        WHEN '1'.
          ro_integer = ro_integer->add( lo_multi ).
        WHEN OTHERS.
          ASSERT 0 = 1.
      ENDCASE.
      lv_bits = lv_bits+1.
      lo_multi = lo_multi->multiply_int( 2 ).
    ENDWHILE.

  ENDMETHOD.


  METHOD bits_to_integer.

    DATA: lv_bits  TYPE string,
          lv_multi TYPE i VALUE 1.


    lv_bits = reverse( iv_bits ).

    WHILE strlen( lv_bits ) > 0.
      CASE lv_bits(1).
        WHEN '0'.
        WHEN '1'.
          rv_int = rv_int + lv_multi.
        WHEN OTHERS.
          ASSERT 0 = 1.
      ENDCASE.
      lv_bits = lv_bits+1.
      lv_multi = lv_multi * 2.
    ENDWHILE.

  ENDMETHOD.


  METHOD string_to_utf8.

    DATA: lo_obj TYPE REF TO cl_abap_conv_out_ce.


    TRY.
        lo_obj = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).

        lo_obj->convert( EXPORTING data = iv_data
                         IMPORTING buffer = rv_data ).

      CATCH cx_parameter_invalid_range
            cx_sy_codepage_converter_init
            cx_sy_conversion_codepage
            cx_parameter_invalid_type.                  "#EC NO_HANDLER
    ENDTRY.

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


  METHOD utf8_to_string.

    DATA: lv_len TYPE i,
          lo_obj TYPE REF TO cl_abap_conv_in_ce.


    TRY.
        lo_obj = cl_abap_conv_in_ce=>create(
            input    = iv_data
            encoding = 'UTF-8' ).
        lv_len = xstrlen( iv_data ).

        lo_obj->read( EXPORTING n    = lv_len
                      IMPORTING data = rv_data ).

      CATCH cx_parameter_invalid_range
            cx_sy_codepage_converter_init
            cx_sy_conversion_codepage
            cx_parameter_invalid_type.                  "#EC NO_HANDLER
    ENDTRY.

  ENDMETHOD.
ENDCLASS.