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
      value(RV_DATA) type XSTRING .
  class-methods AES256_DECRYPT
    importing
      !IV_DATA type XSTRING
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

    zcl_aes_utility=>decrypt_xstring(
      EXPORTING
        i_key                   = iv_key
        i_data                  = iv_data
        i_initialization_vector = iv_ivector
        i_encryption_mode       = zcl_aes_utility=>mc_encryption_mode_cfb
      IMPORTING
        e_data                  = rv_plain ).

  ENDMETHOD.


  METHOD aes256_encrypt.
* CFB mode, https://tools.ietf.org/html/rfc4880#section-13.9

    zcl_aes_utility=>encrypt_xstring(
      EXPORTING
        i_key                   = iv_key
        i_data                  = iv_plain
        i_initialization_vector = iv_ivector
        i_encryption_mode       = zcl_aes_utility=>mc_encryption_mode_cfb
      IMPORTING
        e_data                  = rv_data ).

  ENDMETHOD.
ENDCLASS.