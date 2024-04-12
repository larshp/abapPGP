CLASS zcl_abappgp_encode DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS pkcs1_emse
      IMPORTING
        !iv_m        TYPE xstring
      RETURNING
        VALUE(rv_em) TYPE xstring .
  PROTECTED SECTION.

    CLASS-METHODS hash_prefix
      RETURNING
        VALUE(rv_prefix) TYPE xstring .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abappgp_encode IMPLEMENTATION.


  METHOD hash_prefix.

    DATA lv_hex TYPE x LENGTH 1.

    DEFINE _add.
      lv_hex = &1.
      concatenate rv_prefix lv_hex into rv_prefix in byte mode.
    END-OF-DEFINITION.

    _add '30'.
    _add '31'.
    _add '30'.
    _add '0D'.
    _add '06'.
    _add '09'.
    _add '60'.
    _add '86'.
    _add '48'.
    _add '01'.
    _add '65'.
    _add '03'.
    _add '04'.
    _add '02'.
    _add '01'.
    _add '05'.
    _add '00'.
    _add '04'.
    _add '20'.

  ENDMETHOD.


  METHOD pkcs1_emse.
* https://tools.ietf.org/html/rfc4880#section-13.1.3

* todo, only implemented for hash algorithm '8' = SHA256

    CONSTANTS: lc_00 TYPE x LENGTH 1 VALUE '00',
               lc_01 TYPE x LENGTH 1 VALUE '01',
               lc_ff TYPE x LENGTH 1 VALUE 'FF'.

    DATA: lv_tlen  TYPE i,
          lv_emlen TYPE i VALUE 128,
          lv_ps    TYPE xstring,
          lv_h     TYPE xstring,
          lv_t     TYPE xstring.

* 1. Apply the hash function to the message M to produce a hash value
*    H:
*
*    H = Hash(M).
*
*    If the hash function outputs "message too long," output "message
*    too long" and stop.
    lv_h = zcl_abappgp_hash=>sha256( iv_m ).

* 2. Using the list in Section 5.2.2, produce an ASN.1 DER value for
*    the hash function used.  Let T be the full hash prefix from
*    Section 5.2.2, and let tLen be the length in octets of T.
    lv_t = hash_prefix( ).
    CONCATENATE lv_t lv_h INTO lv_t IN BYTE MODE.
    lv_tlen = xstrlen( lv_t ).

* 3. If emLen < tLen + 11, output "intended encoded message length
*    too short" and stop.
    IF lv_emlen < lv_tlen + 11.
      ASSERT 1 = 'todo'.
    ENDIF.

* 4. Generate an octet string PS consisting of emLen - tLen - 3
*    octets with hexadecimal value 0xFF.  The length of PS will be at
*    least 8 octets.
    DO lv_emlen - lv_tlen - 3 TIMES.
      CONCATENATE lv_ps lc_ff INTO lv_ps IN BYTE MODE.
    ENDDO.

* 5. Concatenate PS, the hash prefix T, and other padding to form the
*    encoded message EM as
*
*    EM = 0x00 || 0x01 || PS || 0x00 || T.
    CONCATENATE lc_00 lc_01 lv_ps lc_00 lv_t INTO rv_em IN BYTE MODE.

  ENDMETHOD.
ENDCLASS.
