class ZCL_ABAPPGP_HASH definition
  public
  create public .

public section.

  class-methods CRC24
    importing
      !IV_DATA type XSTRING
    returning
      value(RV_HASH) type XSTRING .
  class-methods SHA256
    importing
      !IV_INPUT type XSTRING
    returning
      value(RV_HASH) type XSTRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_HASH IMPLEMENTATION.


  METHOD crc24.
* https://tools.ietf.org/html/rfc4880#section-6.1

    CONSTANTS: lc_gen  TYPE xstring VALUE '864CFB',
               lc_init TYPE xstring VALUE 'B704CE'.

* todo

  ENDMETHOD.


  METHOD sha256.

    cl_abap_message_digest=>calculate_hash_for_raw(
      EXPORTING
        if_algorithm   = 'SHA256'
        if_data        = iv_input
      IMPORTING
        ef_hashxstring = rv_hash ).

  ENDMETHOD.
ENDCLASS.