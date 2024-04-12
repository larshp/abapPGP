CLASS ltcl_aes256 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    CONSTANTS:
      c_key     TYPE xstring VALUE
        'AE72C97FD7C885AE63EC878AD267D9B29D1B0AF0BC264FBC3B7F8290D4BD45B2',
      c_ivector TYPE xstring VALUE '86DDC1BE164449EF586A1E42C94633EA'.

    METHODS:
      test IMPORTING iv_plain  TYPE xstring
                     iv_exp    TYPE xstring
                     iv_resync TYPE abap_bool
           RAISING   zcx_abappgp_invalid_key,
      encrypt01 FOR TESTING RAISING zcx_abappgp_invalid_key,
      encrypt02 FOR TESTING RAISING zcx_abappgp_invalid_key,
      encrypt03 FOR TESTING RAISING zcx_abappgp_invalid_key,
      encrypt04 FOR TESTING RAISING zcx_abappgp_invalid_key,
      encrypt05 FOR TESTING RAISING zcx_abappgp_invalid_key,
      invalid_key FOR TESTING.

ENDCLASS.       "ltcl_Aes256

CLASS ltcl_aes256 IMPLEMENTATION.

  METHOD test.

    DATA: lv_enc       TYPE xstring,
          lv_decrypted TYPE xstring.


    lv_enc = zcl_abappgp_symmetric=>aes256_encrypt(
      iv_plain   = iv_plain
      iv_key     = c_key
      iv_ivector = c_ivector
      iv_resync  = iv_resync ).

    IF NOT iv_exp IS INITIAL.
      cl_abap_unit_assert=>assert_equals(
        act = lv_enc
        exp = iv_exp ).
    ENDIF.

    lv_decrypted = zcl_abappgp_symmetric=>aes256_decrypt(
      iv_ciphertext = lv_enc
      iv_key        = c_key
      iv_ivector    = c_ivector
      iv_resync     = iv_resync ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_decrypted
      exp = iv_plain ).

  ENDMETHOD.

  METHOD invalid_key.

    CONSTANTS:
      lc_cipher TYPE xstring VALUE
        '1462EE073B051AA7212254B7333BBAA65723C3FCFE414E',
      lc_key    TYPE xstring VALUE
       '1234567897C885AE63EC878AD267D9B29D1B0AF0BC264FBC3B7F8290D4BD45B2'.


    TRY.
        zcl_abappgp_symmetric=>aes256_decrypt(
          iv_ciphertext = lc_cipher
          iv_key        = lc_key
          iv_ivector    = c_ivector
          iv_resync     = abap_true ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_abappgp_invalid_key ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.

  METHOD encrypt01.

    CONSTANTS
      lc_exp TYPE xstring VALUE '1462EE073B051AA7212254B7333BBAA65723C3FCFE414E'.

    DATA lv_plain TYPE xstring.


    lv_plain = zcl_abappgp_convert=>string_to_utf8( 'hello' ).

    test( iv_plain  = lv_plain
          iv_exp    = lc_exp
          iv_resync = abap_false ).

  ENDMETHOD.

  METHOD encrypt02.

    CONSTANTS
      lc_exp TYPE xstring VALUE
        '1462EE073B051AA7212254B7333BBAA65723C3FCFE414E0EA7F6929EC7662A432B1E61461565'.

    DATA lv_plain TYPE xstring.


    lv_plain = zcl_abappgp_convert=>string_to_utf8( 'hellohellohellohello' ).

    test( iv_plain  = lv_plain
          iv_exp    = lc_exp
          iv_resync = abap_false ).

  ENDMETHOD.

  METHOD encrypt03.

    CONSTANTS:
      lc_empty TYPE xstring VALUE '',
      lc_hex   TYPE x LENGTH 1 VALUE 'AA'.

    DATA lv_plain TYPE xstring.


    DO 304 TIMES.
      CONCATENATE lv_plain lc_hex INTO lv_plain IN BYTE MODE.
    ENDDO.

    test( iv_plain  = lv_plain
          iv_exp    = lc_empty
          iv_resync = abap_false ).

  ENDMETHOD.

  METHOD encrypt04.

    CONSTANTS
      lc_exp TYPE xstring VALUE '1462EE073B051AA7212254B7333BBAA65723F9D0E3FED2'.

    DATA lv_plain TYPE xstring.


    lv_plain = zcl_abappgp_convert=>string_to_utf8( 'hello' ).

    test( iv_plain  = lv_plain
          iv_exp    = lc_exp
          iv_resync = abap_true ).

  ENDMETHOD.

  METHOD encrypt05.

    CONSTANTS
      lc_exp TYPE xstring VALUE
        '1462EE073B051AA7212254B7333BBAA65723F9D0E3FED2D9E27B93A69213806C50C7DD969B3F'.

    DATA lv_plain TYPE xstring.


    lv_plain = zcl_abappgp_convert=>string_to_utf8( 'hellohellohellohello' ).

    test( iv_plain  = lv_plain
          iv_exp    = lc_exp
          iv_resync = abap_true ).

  ENDMETHOD.

ENDCLASS.
