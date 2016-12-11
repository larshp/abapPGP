CLASS ltcl_aes256 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    CONSTANTS:
      gc_key     TYPE xstring VALUE
        'AE72C97FD7C885AE63EC878AD267D9B29D1B0AF0BC264FBC3B7F8290D4BD45B2',
      gc_ivector TYPE xstring VALUE '86DDC1BE164449EF586A1E42C94633EA'.

    METHODS:
      test IMPORTING
             iv_plain   TYPE xstring
             iv_exp     TYPE xstring,
      encrypt01 FOR TESTING,
      encrypt02 FOR TESTING,
      encrypt03 FOR TESTING.

ENDCLASS.       "ltcl_Aes256

CLASS ltcl_aes256 IMPLEMENTATION.

  METHOD test.

    DATA: lv_enc       TYPE xstring,
          lv_decrypted TYPE xstring.


    lv_enc = zcl_abappgp_symmetric=>aes256_encrypt(
      iv_plain   = iv_plain
      iv_key     = gc_key
      iv_ivector = gc_ivector ).

    IF NOT iv_exp IS INITIAL.
      cl_abap_unit_assert=>assert_equals(
        act = lv_enc
        exp = iv_exp ).
    ENDIF.

    lv_decrypted = zcl_abappgp_symmetric=>aes256_decrypt(
      iv_ciphertext = lv_enc
      iv_key        = gc_key
      iv_ivector    = gc_ivector ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_decrypted
      exp = iv_plain ).

  ENDMETHOD.

  METHOD encrypt01.

    CONSTANTS:
      lc_exp TYPE xstring VALUE '1462EE073B051AA7212254B7333BBAA65723C3FCFE414E'.

    DATA: lv_plain TYPE xstring.


    lv_plain = zcl_abappgp_convert=>string_to_utf8( 'hello' ).

    test( iv_plain = lv_plain
          iv_exp   = lc_exp ).

  ENDMETHOD.

  METHOD encrypt02.

    CONSTANTS:
      lc_exp TYPE xstring VALUE
        '1462EE073B051AA7212254B7333BBAA65723C3FCFE414E0EA7F6929EC7662A432B1E61461565'.

    DATA: lv_plain TYPE xstring.


    lv_plain = zcl_abappgp_convert=>string_to_utf8( 'hellohellohellohello' ).

    test( iv_plain = lv_plain
          iv_exp   = lc_exp ).

  ENDMETHOD.

  METHOD encrypt03.

    CONSTANTS:
      lc_empty TYPE xstring VALUE '',
      lc_hex   TYPE x LENGTH 1 VALUE 'AA'.

    DATA: lv_plain TYPE xstring.


    DO 304 TIMES.
      CONCATENATE lv_plain lc_hex INTO lv_plain IN BYTE MODE.
    ENDDO.

    test( iv_plain = lv_plain
          iv_exp   = lc_empty ).

  ENDMETHOD.

ENDCLASS.