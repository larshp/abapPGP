CLASS zcl_abappgp_armor DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF c_header,
        message   TYPE string VALUE '-----BEGIN PGP MESSAGE-----',
        public    TYPE string VALUE '-----BEGIN PGP PUBLIC KEY BLOCK-----',
        private   TYPE string VALUE '-----BEGIN PGP PRIVATE KEY BLOCK-----',
        messagexx TYPE string VALUE '-----BEGIN PGP MESSAGE, PART +*/+*-----',
        messagex  TYPE string VALUE '-----BEGIN PGP MESSAGE, PART +*-----',
        signature TYPE string VALUE '-----BEGIN PGP SIGNATURE-----',
        signed    TYPE string VALUE '-----BEGIN PGP SIGNED MESSAGE-----',
      END OF c_header.

    CONSTANTS:
      BEGIN OF c_tail,
        message   TYPE string VALUE '-----END PGP MESSAGE-----',
        public    TYPE string VALUE '-----END PGP PUBLIC KEY BLOCK-----',
        private   TYPE string VALUE '-----END PGP PRIVATE KEY BLOCK-----',
        messagexx TYPE string VALUE '-----END PGP MESSAGE, PART +*/+*-----',
        messagex  TYPE string VALUE '-----END PGP MESSAGE, PART +*-----',
        signature TYPE string VALUE '-----END PGP SIGNATURE-----',
        signed    TYPE string VALUE '-----END PGP SIGNED MESSAGE-----',
      END OF c_tail.

    CLASS-METHODS from_string
      IMPORTING
        !iv_armor       TYPE string
      RETURNING
        VALUE(ro_armor) TYPE REF TO zcl_abappgp_armor .
    METHODS constructor
      IMPORTING
        !iv_armor_header TYPE string
        !it_headers      TYPE string_table
        !iv_data         TYPE xstring
        !iv_armor_tail   TYPE string .
    METHODS get_armor_header
      RETURNING
        VALUE(rv_header) TYPE string .
    METHODS get_armor_tail
      RETURNING
        VALUE(rv_tail) TYPE string .
    METHODS get_data
      RETURNING
        VALUE(rv_data) TYPE xstring .
    METHODS get_headers
      RETURNING
        VALUE(rt_headers) TYPE string_table .
    METHODS to_string
      RETURNING
        VALUE(rv_armor) TYPE string .
  PROTECTED SECTION.

    DATA mv_armor_header TYPE string .
    DATA mt_headers TYPE string_table .
    DATA mv_data TYPE xstring .
    DATA mv_armor_tail TYPE string .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_ARMOR IMPLEMENTATION.


  METHOD constructor.

    ASSERT NOT iv_armor_header IS INITIAL.
    ASSERT NOT iv_data IS INITIAL.
    ASSERT NOT iv_armor_tail IS INITIAL.

    mv_armor_header = iv_armor_header.
    mt_headers      = it_headers.
    mv_data         = iv_data.
    mv_armor_tail   = iv_armor_tail.

  ENDMETHOD.


  METHOD from_string.

    DEFINE _next_mode.
      lv_mode = lv_mode + 1.
    END-OF-DEFINITION.

    CONSTANTS: BEGIN OF c_mode,
                 armor_header TYPE i VALUE 1,
                 headers      TYPE i VALUE 2,
                 data         TYPE i VALUE 3,
                 checksum     TYPE i VALUE 4,
                 armor_tail   TYPE i VALUE 5,
               END OF c_mode.

    DATA: lv_armor_header TYPE string,
          lt_headers      TYPE string_table,
          lv_data         TYPE string,
          lv_xdata        TYPE xstring,
          lv_checksum     TYPE xstring,
          lv_armor_tail   TYPE string,
          lt_string       TYPE TABLE OF string,
          lv_mode         TYPE i VALUE c_mode-armor_header,
          lv_string       TYPE string.


    lv_string = iv_armor.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN lv_string
      WITH cl_abap_char_utilities=>newline.
    SPLIT lv_string AT cl_abap_char_utilities=>newline INTO TABLE lt_string.

    LOOP AT lt_string INTO lv_string.
      CASE lv_mode.
        WHEN c_mode-armor_header.
          lv_armor_header = lv_string.
          _next_mode.
        WHEN c_mode-headers.
          IF lv_string IS INITIAL.
            _next_mode.
          ELSE.
            APPEND lv_string TO lt_headers.
          ENDIF.
        WHEN c_mode-data.
          CONCATENATE lv_data lv_string INTO lv_data.
          IF sy-tabix = lines( lt_string ) - 2.
            _next_mode.
          ENDIF.
        WHEN c_mode-checksum.
          ASSERT lv_string(1) = '='.
          lv_string = lv_string+1.
          lv_xdata = zcl_abappgp_convert=>base64_decode( lv_data ).
          lv_checksum = zcl_abappgp_convert=>base64_decode( lv_string ).
          ASSERT lv_checksum = zcl_abappgp_hash=>crc24( lv_xdata ).
          _next_mode.
        WHEN c_mode-armor_tail.
          lv_armor_tail = lv_string.
          _next_mode.
        WHEN OTHERS.
          ASSERT 0 = 1.
      ENDCASE.

    ENDLOOP.

    CREATE OBJECT ro_armor
      EXPORTING
        iv_armor_header = lv_armor_header
        it_headers      = lt_headers
        iv_data         = lv_xdata
        iv_armor_tail   = lv_armor_tail.

  ENDMETHOD.


  METHOD get_armor_header.

    rv_header = mv_armor_header.

  ENDMETHOD.


  METHOD get_armor_tail.

    rv_tail = mv_armor_tail.

  ENDMETHOD.


  METHOD get_data.

    rv_data = mv_data.

  ENDMETHOD.


  METHOD get_headers.

    rt_headers = mt_headers.

  ENDMETHOD.


  METHOD to_string.

    CONSTANTS: lc_length TYPE i VALUE 60.

    DATA: lv_header LIKE LINE OF mt_headers,
          lv_data   TYPE string.


    rv_armor = |{ mv_armor_header }\n|.

    LOOP AT mt_headers INTO lv_header.
      rv_armor = |{ rv_armor }{ lv_header }\n|.
    ENDLOOP.

    rv_armor = |{ rv_armor }\n|.

    lv_data = zcl_abappgp_convert=>base64_encode( mv_data ).
    WHILE strlen( lv_data ) > lc_length.
      rv_armor = |{ rv_armor }{ lv_data(lc_length) }\n|.
      lv_data = lv_data+lc_length.
    ENDWHILE.
    rv_armor = |{ rv_armor }{ lv_data }\n|.

    rv_armor = |{ rv_armor }={ zcl_abappgp_convert=>base64_encode(
      zcl_abappgp_hash=>crc24( mv_data ) ) }\n|.

    rv_armor = |{ rv_armor }{ mv_armor_tail }|.

  ENDMETHOD.
ENDCLASS.
