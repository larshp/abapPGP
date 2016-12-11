CLASS ltcl_aes256 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
*      identity FOR TESTING,
      encrypt01 FOR TESTING,
      encrypt02 FOR TESTING.

ENDCLASS.       "ltcl_Aes256

CLASS ltcl_aes256 IMPLEMENTATION.

  METHOD encrypt01.

    DATA: lv_enc TYPE xstring,
          lv_exp TYPE xstring.


    lv_enc = zcl_abappgp_symmetric=>aes256_encrypt(
      iv_plain   = zcl_abappgp_convert=>string_to_utf8( 'hello' )
      iv_key     = 'AE72C97FD7C885AE63EC878AD267D9B29D1B0AF0BC264FBC3B7F8290D4BD45B2'
      iv_ivector = '86DDC1BE164449EF586A1E42C94633EA' ).

    lv_exp = '1462EE073B051AA7212254B7333BBAA65723C3FCFE414E'.

    cl_abap_unit_assert=>assert_equals(
      act = lv_enc
      exp = lv_exp ).

  ENDMETHOD.

  METHOD encrypt02.

    DATA: lv_enc TYPE xstring,
          lv_exp TYPE xstring.


    lv_enc = zcl_abappgp_symmetric=>aes256_encrypt(
      iv_plain   = zcl_abappgp_convert=>string_to_utf8( 'hellohellohellohello' )
      iv_key     = 'AE72C97FD7C885AE63EC878AD267D9B29D1B0AF0BC264FBC3B7F8290D4BD45B2'
      iv_ivector = '86DDC1BE164449EF586A1E42C94633EA' ).

    lv_exp = '1462EE073B051AA7212254B7333BBAA65723C3FCFE414E0EA7F6929EC7662A432B1E61461565'.

    cl_abap_unit_assert=>assert_equals(
      act = lv_enc
      exp = lv_exp ).

  ENDMETHOD.

*  METHOD identity.
*
*    DATA: lv_key       TYPE xstring,
*          lv_ivector   TYPE xstring,
*          lv_plain     TYPE xstring,
*          lv_result    TYPE xstring,
*          lv_encrypted TYPE xstring,
*          lv_hex       TYPE x LENGTH 1.
*
*
*    lv_hex = 'AA'.
*    DO 304 TIMES.
*      CONCATENATE lv_plain lv_hex INTO lv_plain IN BYTE MODE.
*    ENDDO.
*
*    lv_key = '6AAF4172CF8B4CE14E979E642008D71AA14BDF7A9382D37CE4BB7B5F55EB5A9D'.
*    lv_ivector = 'A18EC1C3FE106848789192F04472FB1F'.
*
*    lv_encrypted = zcl_abappgp_symmetric=>aes256_encrypt(
*      iv_plain   = lv_plain
*      iv_key     = lv_key
*      iv_ivector = lv_ivector ).
*
*    lv_result = zcl_abappgp_symmetric=>aes256_decrypt(
*      iv_data    = lv_encrypted
*      iv_key     = lv_key
*      iv_ivector = lv_ivector ).
*
*    cl_abap_unit_assert=>assert_differs(
*      act = lv_encrypted
*      exp = lv_result ).
*
*    cl_abap_unit_assert=>assert_equals(
*      act = lv_result
*      exp = lv_plain ).
*
*  ENDMETHOD.

ENDCLASS.