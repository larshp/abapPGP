class ZCL_ABAPPGP_SUBPACKET_27 definition
  public
  create public .

public section.

  interfaces ZIF_ABAPPGP_SUBPACKET .

  aliases FROM_STREAM
    for ZIF_ABAPPGP_SUBPACKET~FROM_STREAM .
  aliases GET_NAME
    for ZIF_ABAPPGP_SUBPACKET~GET_NAME .
  aliases GET_TYPE
    for ZIF_ABAPPGP_SUBPACKET~GET_TYPE .
  aliases TO_STREAM
    for ZIF_ABAPPGP_SUBPACKET~TO_STREAM .

  methods CONSTRUCTOR
    importing
      !IV_CERTIFY_OTHER type ABAP_BOOL
      !IV_SIGN_DATA type ABAP_BOOL
      !IV_ENCRYPT_COMMUNICATIONS type ABAP_BOOL
      !IV_ENCRYPT_STORAGE type ABAP_BOOL .
protected section.

  data MV_CERTIFY_OTHER type ABAP_BOOL .
  data MV_SIGN_DATA type ABAP_BOOL .
  data MV_ENCRYPT_COMMUNICATIONS type ABAP_BOOL .
  data MV_ENCRYPT_STORAGE type ABAP_BOOL .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_SUBPACKET_27 IMPLEMENTATION.


  METHOD constructor.

    mv_certify_other = iv_certify_other.
    mv_sign_data     = iv_sign_data.
    mv_encrypt_communications = iv_encrypt_communications.
    mv_encrypt_storage = iv_encrypt_storage.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~dump.

    rv_dump = |\tSub - { get_name( ) }(sub { get_type( ) })({
      to_stream( )->get_length( ) } bytes)\n\t\tCertify other\t{
      mv_certify_other }\n\t\tSign data\t{
      mv_sign_data }\n\t\tEnc comm\t{
      mv_encrypt_communications }\n\t\tEnc stor\t{
      mv_encrypt_storage }\n|.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~from_stream.

    DATA: lv_certify_other          TYPE abap_bool,
          lv_sign_data              TYPE abap_bool,
          lv_encrypt_communications TYPE abap_bool,
          lv_encrypt_storage        TYPE abap_bool,
          lv_octet                  TYPE x LENGTH 1.


    lv_octet = io_stream->eat_octet( ).

* todo, cleanup
    CASE lv_octet.
      WHEN '01'.
        lv_certify_other = abap_true.
      WHEN '02'.
        lv_sign_data = abap_true.
      WHEN '03'.
        lv_certify_other = abap_true.
        lv_sign_data = abap_true.
      WHEN '0C'.
        lv_encrypt_communications = abap_true.
        lv_encrypt_storage = abap_true.
      WHEN OTHERS.
* not implmented, todo
        ASSERT 0 = 1.
    ENDCASE.

    CREATE OBJECT ri_packet
      TYPE zcl_abappgp_subpacket_27
      EXPORTING
        iv_certify_other          = lv_certify_other
        iv_sign_data              = lv_sign_data
        iv_encrypt_communications = lv_encrypt_communications
        iv_encrypt_storage        = lv_encrypt_storage.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_name.

    rv_name = 'Key Flags'.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~get_type.

    rv_type = zif_abappgp_constants=>c_sub_type-key_flags.

  ENDMETHOD.


  METHOD zif_abappgp_subpacket~to_stream.

    DATA: lv_octet TYPE x LENGTH 1.


    IF mv_certify_other = abap_true.
      lv_octet = lv_octet + 1.
    ENDIF.

    IF mv_sign_data = abap_true.
      lv_octet = lv_octet + 2.
    ENDIF.

    IF mv_encrypt_communications = abap_true.
      lv_octet = lv_octet + 4.
    ENDIF.

    IF mv_encrypt_storage = abap_true.
      lv_octet = lv_octet + 8.
    ENDIF.

    CREATE OBJECT ro_stream.
    ro_stream->write_octet( lv_octet ).

  ENDMETHOD.
ENDCLASS.