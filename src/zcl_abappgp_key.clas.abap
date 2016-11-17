class ZCL_ABAPPGP_KEY definition
  public
  final
  create public .

public section.

  class-methods FROM_STRING
    importing
      !IV_STRING type STRING .
  methods TO_STRING
    returning
      value(RV_STRING) type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_KEY IMPLEMENTATION.


  METHOD from_string.

    DATA: lt_string  TYPE TABLE OF string,
          lv_encoded TYPE string,
          lv_start   TYPE abap_bool,
          lv_string  TYPE string.


    SPLIT iv_string AT cl_abap_char_utilities=>newline INTO TABLE lt_string.

    LOOP AT lt_string INTO lv_string.
      IF sy-tabix = lines( lt_string ) OR sy-tabix = lines( lt_string ) - 1.
        CONTINUE.
      ELSEIF lv_string IS INITIAL.
        lv_start = abap_true.
      ELSEIF lv_start = abap_true.
        CONCATENATE lv_encoded lv_string INTO lv_encoded.
      ENDIF.
    ENDLOOP.

*CALL FUNCTION 'SSFC_BASE64_DECODE'
*  EXPORTING
*    b64data                        =
**   B64LENG                        =
**   B_CHECK                        =
** IMPORTING
**   BINDATA                        =
** EXCEPTIONS
**   SSF_KRN_ERROR                  = 1
**   SSF_KRN_NOOP                   = 2
**   SSF_KRN_NOMEMORY               = 3
**   SSF_KRN_OPINV                  = 4
**   SSF_KRN_INPUT_DATA_ERROR       = 5
**   SSF_KRN_INVALID_PAR            = 6
**   SSF_KRN_INVALID_PARLEN         = 7
**   OTHERS                         = 8
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.


    BREAK-POINT.

  ENDMETHOD.


  method TO_STRING.
  endmethod.
ENDCLASS.