CLASS zcl_abappgp_time DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS format_unix
      IMPORTING
        !iv_unix            TYPE i
      RETURNING
        VALUE(rv_formatted) TYPE string .
    CLASS-METHODS get_unix
      RETURNING
        VALUE(rv_time) TYPE i .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_TIME IMPLEMENTATION.


  METHOD format_unix.

    DATA: lv_date TYPE sy-datum,
          lv_time TYPE sy-uzeit.


    lv_date = '19700101'.
    lv_date = lv_date + iv_unix DIV 86400.
    lv_time = iv_unix MOD 86400.

    rv_formatted = |{ lv_date } { lv_time }|.

  ENDMETHOD.


  METHOD get_unix.

    CONSTANTS: c_epoch TYPE datum VALUE '19700101'.

    DATA: lv_i       TYPE i,
          lv_tz      TYPE tznzone,
          lv_utcdiff TYPE tznutcdiff,
          lv_utcsign TYPE tznutcsign.


    lv_i = sy-datum - c_epoch.
    lv_i = lv_i * 86400.
    lv_i = lv_i + sy-uzeit.

    CALL FUNCTION 'TZON_GET_OS_TIMEZONE'
      IMPORTING
        ef_timezone = lv_tz.

    CALL FUNCTION 'TZON_GET_OFFSET'
      EXPORTING
        if_timezone      = lv_tz
        if_local_date    = sy-datum
        if_local_time    = sy-uzeit
      IMPORTING
        ef_utcdiff       = lv_utcdiff
        ef_utcsign       = lv_utcsign
      EXCEPTIONS
        conversion_error = 1
        OTHERS           = 2.
    ASSERT sy-subrc = 0.

    CASE lv_utcsign.
      WHEN '+'.
        lv_i = lv_i - lv_utcdiff.
      WHEN '-'.
        lv_i = lv_i + lv_utcdiff.
    ENDCASE.

    rv_time = lv_i.

  ENDMETHOD.
ENDCLASS.
