CLASS ltcl_aes256 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      identity FOR TESTING,
      encrypt01 FOR TESTING.

ENDCLASS.       "ltcl_Aes256

CLASS ltcl_aes256 IMPLEMENTATION.

  METHOD encrypt01.

    DATA: lv_enc TYPE xstring,
          lv_exp TYPE xstring.


    lv_enc = zcl_abappgp_symmetric=>aes256_encrypt(
      iv_plain   = zcl_abappgp_convert=>string_to_utf8( 'hello' )
      iv_key     = 'DA9F875933146471B9F1CE4DD3DA44BF8CD0194A79E46295E417685DE5AA0021'
      iv_ivector = '347EE5ABDEC6A7E132F329B57E7B6EC4' ).

    lv_exp = 'D769007F03055A011DFAFAC8D57B1F0E4EE5B25DB86A87'.

    cl_abap_unit_assert=>assert_equals(
      act = lv_enc
      exp = lv_exp ).

  ENDMETHOD.

  METHOD identity.

    DATA: lv_key       TYPE xstring,
          lv_ivector   TYPE xstring,
          lv_plain     TYPE xstring,
          lv_result    TYPE xstring,
          lv_encrypted TYPE xstring,
          lv_hex       TYPE x LENGTH 1.


    lv_hex = 'AA'.
    DO 304 TIMES.
      CONCATENATE lv_plain lv_hex INTO lv_plain IN BYTE MODE.
    ENDDO.

    lv_key = '6AAF4172CF8B4CE14E979E642008D71AA14BDF7A9382D37CE4BB7B5F55EB5A9D'.
    lv_ivector = 'A18EC1C3FE106848789192F04472FB1F'.

    lv_encrypted = zcl_abappgp_symmetric=>aes256_encrypt(
      iv_plain   = lv_plain
      iv_key     = lv_key
      iv_ivector = lv_ivector ).

    lv_result = zcl_abappgp_symmetric=>aes256_decrypt(
      iv_data    = lv_encrypted
      iv_key     = lv_key
      iv_ivector = lv_ivector ).

    cl_abap_unit_assert=>assert_differs(
      act = lv_encrypted
      exp = lv_result ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = lv_plain ).

  ENDMETHOD.

ENDCLASS.