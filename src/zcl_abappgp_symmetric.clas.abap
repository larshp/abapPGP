class ZCL_ABAPPGP_SYMMETRIC definition
  public
  create public .

public section.

  class-methods AES256_ENCRYPT
    importing
      !IV_PLAIN type XSTRING
      !IV_KEY type XSTRING
      !IV_IVECTOR type XSTRING
    returning
      value(RV_CIPHERTEXT) type XSTRING .
  class-methods AES256_DECRYPT
    importing
      !IV_CIPHERTEXT type XSTRING
      !IV_KEY type XSTRING
      !IV_IVECTOR type XSTRING
    returning
      value(RV_PLAIN) type XSTRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_SYMMETRIC IMPLEMENTATION.


  METHOD aes256_decrypt.
* CFB mode, https://tools.ietf.org/html/rfc4880#section-13.9

    CONSTANTS: lc_block_size TYPE i VALUE 16,
               lc_resync     TYPE abap_bool VALUE abap_false,
               lc_zero       TYPE x LENGTH 1 VALUE '00'.

    DATA: lv_index    TYPE i,
          lv_hex      TYPE x LENGTH 1,
          lo_rijndael TYPE REF TO zcl_rijndael_utility,
          lv_ablock   TYPE xstring,
          lv_n        TYPE i,
          lv_tmp      TYPE xstring,
          lv_iblock   TYPE xstring.


    CREATE OBJECT lo_rijndael
      EXPORTING
        i_key_length_in_bit   = xstrlen( iv_key ) * 8
        i_block_length_in_bit = lc_block_size * 8.

    DO lc_block_size TIMES.
      CONCATENATE lv_iblock lc_zero INTO lv_iblock IN BYTE MODE.
    ENDDO.

    lo_rijndael->encrypt_xstring(
      EXPORTING
        i_key  = iv_key
        i_data = lv_iblock
      IMPORTING
        e_data = lv_iblock ).

    lv_ablock = iv_ciphertext(lc_block_size).
    DO lc_block_size TIMES.
      lv_index = sy-index - 1.
      lv_hex = lv_iblock+lv_index(1) BIT-XOR lv_ablock+lv_index(1).
      CONCATENATE lv_tmp lv_hex INTO lv_tmp IN BYTE MODE.
    ENDDO.
    lv_iblock = lv_tmp.

    lo_rijndael->encrypt_xstring(
      EXPORTING
        i_key  = iv_key
        i_data = lv_ablock
      IMPORTING
        e_data = lv_ablock ).

    lv_hex = lv_ablock(1) BIT-XOR iv_ciphertext+lc_block_size(1).
    lv_index = lc_block_size - 2.
    IF lv_iblock+lv_index(1) <> lv_hex.
      BREAK-POINT. " invalid key
    ENDIF.

    lv_index = lc_block_size + 1.
    lv_hex = lv_ablock+1(1) BIT-XOR iv_ciphertext+lv_index(1).
    lv_index = lc_block_size - 1.
    IF lv_iblock+lv_index(1) <> lv_hex.
      BREAK-POINT. " invalid key
    ENDIF.

* todo, resync?

    lv_iblock = iv_ciphertext(lc_block_size).
    lv_n = lc_block_size.
    WHILE lv_n < xstrlen( iv_ciphertext ).
      lo_rijndael->encrypt_xstring(
        EXPORTING
          i_key  = iv_key
          i_data = lv_iblock
        IMPORTING
          e_data = lv_ablock ).

      lv_iblock = iv_ciphertext+lv_n.
      IF xstrlen( lv_iblock ) > 16.
        lv_iblock = lv_iblock(16).
      ENDIF.

      DO lc_block_size TIMES.
        lv_index = sy-index - 1.
        IF lv_index >= xstrlen( lv_iblock ).
          EXIT. " current loop
        ENDIF.
        lv_hex = lv_ablock+lv_index(1) BIT-XOR lv_iblock+lv_index(1).
        CONCATENATE rv_plain lv_hex INTO rv_plain IN BYTE MODE.
      ENDDO.

      lv_n = lv_n + lc_block_size.
    ENDWHILE.

    rv_plain = rv_plain+2.

*if lc_resync = abap_true.
*else.
*endif.
*
*    BREAK-POINT.

  ENDMETHOD.


  METHOD aes256_encrypt.
* CFB mode, https://tools.ietf.org/html/rfc4880#section-13.9

    CONSTANTS: lc_block_size TYPE i VALUE 16,
               lc_resync     TYPE abap_bool VALUE abap_false,
               lc_zero       TYPE x LENGTH 1 VALUE '00'.

    DATA: lv_fr       TYPE xstring,
          lv_prefix   TYPE xstring,
          lv_index    TYPE i,
          lv_index2   TYPE i,
          lv_n        TYPE i,
          lv_hex      TYPE x LENGTH 1,
          lv_tmp      TYPE xstring,
          lv_offset   TYPE i,
          lo_rijndael TYPE REF TO zcl_rijndael_utility,
          lv_fre      TYPE xstring.


    IF lc_resync = abap_true.
      lv_offset = 0.
    ELSE.
      lv_offset = 2.
    ENDIF.

    CREATE OBJECT lo_rijndael
      EXPORTING
        i_key_length_in_bit   = xstrlen( iv_key ) * 8
        i_block_length_in_bit = lc_block_size * 8.

*   OpenPGP CFB mode uses an initialization vector (IV) of all zeros, and
*   prefixes the plaintext with BS+2 octets of random data, such that
*   octets BS+1 and BS+2 match octets BS-1 and BS.  It does a CFB
*   resynchronization after encrypting those BS+2 octets
    lv_prefix = iv_ivector.
    lv_index = lc_block_size - 2.
    CONCATENATE lv_prefix iv_ivector+lv_index(2) INTO lv_prefix IN BYTE MODE.

*   1.  The feedback register (FR) is set to the IV, which is all zeros.
    DO lc_block_size TIMES.
      CONCATENATE lv_fr lc_zero INTO lv_fr IN BYTE MODE.
    ENDDO.

*   2.  FR is encrypted to produce FRE (FR Encrypted).  This is the
*       encryption of an all-zero value.
    lo_rijndael->encrypt_xstring(
      EXPORTING
        i_key  = iv_key
        i_data = lv_fr
      IMPORTING
        e_data = lv_fre ).

*   3.  FRE is xored with the first BS octets of random data prefixed to
*       the plaintext to produce C[1] through C[BS], the first BS octets
*       of ciphertext.
    DO lc_block_size TIMES.
      lv_index = sy-index - 1.
      lv_hex = lv_fre+lv_index(1) BIT-XOR lv_prefix+lv_index(1).
      CONCATENATE rv_ciphertext lv_hex INTO rv_ciphertext IN BYTE MODE.
    ENDDO.

*   4.  FR is loaded with C[1] through C[BS].
    lv_fr = rv_ciphertext(lc_block_size).

*   5.  FR is encrypted to produce FRE, the encryption of the first BS
*       octets of ciphertext.
    lo_rijndael->encrypt_xstring(
      EXPORTING
        i_key  = iv_key
        i_data = lv_fr
      IMPORTING
        e_data = lv_fre ).

*   6.  The left two octets of FRE get xored with the next two octets of
*       data that were prefixed to the plaintext.  This produces C[BS+1]
*       and C[BS+2], the next two octets of ciphertext.
    lv_index = lc_block_size.
    lv_hex = lv_fre(1) BIT-XOR lv_prefix+lv_index(1).
    CONCATENATE rv_ciphertext lv_hex INTO rv_ciphertext IN BYTE MODE.

    lv_index = lc_block_size + 1.
    lv_hex = lv_fre+1(1) BIT-XOR lv_prefix+lv_index(1).
    CONCATENATE rv_ciphertext lv_hex INTO rv_ciphertext IN BYTE MODE.

*   7.  (The resynchronization step) FR is loaded with C[3] through
*       C[BS+2].
    IF lc_resync = abap_true.
      BREAK-POINT.
    ELSE.
      lv_fr = rv_ciphertext(lc_block_size).
    ENDIF.

*   8.  FR is encrypted to produce FRE.
    lo_rijndael->encrypt_xstring(
      EXPORTING
        i_key  = iv_key
        i_data = lv_fr
      IMPORTING
        e_data = lv_fre ).

*   9.  FRE is xored with the first BS octets of the given plaintext, now
*       that we have finished encrypting the BS+2 octets of prefixed
*       data.  This produces C[BS+3] through C[BS+(BS+2)], the next BS
*       octets of ciphertext.
    DO lc_block_size TIMES.
      lv_index = sy-index - 1.
      lv_index2 = lv_index + lv_offset.
      IF lv_index2 >= xstrlen( lv_fre ) AND lv_index >= xstrlen( iv_plain ).
        lv_hex = '00'.
      ELSEIF lv_index2 >= xstrlen( lv_fre ).
        lv_hex = iv_plain+lv_index(1).
      ELSEIF lv_index >= xstrlen( iv_plain ).
        lv_hex = lv_fre+lv_index2(1).
      ELSE.
        lv_hex = lv_fre+lv_index2(1) BIT-XOR iv_plain+lv_index(1).
      ENDIF.
      CONCATENATE rv_ciphertext lv_hex INTO rv_ciphertext IN BYTE MODE.
    ENDDO.

    lv_n = lc_block_size.
    WHILE lv_n < xstrlen( iv_plain ) + lv_offset.
*   10. FR is loaded with C[BS+3] to C[BS + (BS+2)] (which is C11-C18 for
*       an 8-octet block).
      lv_index = lv_n + 2 - lv_offset.
      lv_fr = rv_ciphertext+lv_index(lc_block_size).

*   11. FR is encrypted to produce FRE.
      lo_rijndael->encrypt_xstring(
        EXPORTING
          i_key  = iv_key
          i_data = lv_fr
        IMPORTING
          e_data = lv_fre ).

*   12. FRE is xored with the next BS octets of plaintext, to produce
*       the next BS octets of ciphertext.  These are loaded into FR, and
*       the process is repeated until the plaintext is used up.
      CLEAR lv_tmp.
      DO lc_block_size TIMES.
        lv_index = sy-index - 1.
        lv_index2 = lv_n + lv_index - lv_offset.

        IF lv_index >= xstrlen( lv_fre ) AND lv_index2 >= xstrlen( iv_plain ).
          lv_hex = '00'.
        ELSEIF lv_index >= xstrlen( lv_fre ).
          lv_hex = iv_plain+lv_index2(1).
        ELSEIF lv_index2 >= xstrlen( iv_plain ).
          lv_hex = lv_fre+lv_index(1).
        ELSE.
          lv_hex = lv_fre+lv_index(1) BIT-XOR iv_plain+lv_index2(1).
        ENDIF.
        CONCATENATE lv_tmp lv_hex INTO lv_tmp IN BYTE MODE.
      ENDDO.
      lv_index = lc_block_size + lv_n + 2 - lv_offset.
      CONCATENATE rv_ciphertext(lv_index) lv_tmp INTO rv_ciphertext IN BYTE MODE.

      lv_n = lv_n + lc_block_size.
    ENDWHILE.

    lv_index = xstrlen( iv_plain ) + 2 + lc_block_size.
    rv_ciphertext = rv_ciphertext(lv_index).

  ENDMETHOD.
ENDCLASS.