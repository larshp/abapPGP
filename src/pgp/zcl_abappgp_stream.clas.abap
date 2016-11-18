class ZCL_ABAPPGP_STREAM definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_DATA type XSTRING .
  methods EAT_OCTET
    returning
      value(RV_OCTET) type XSTRING .
  methods EAT_OCTETS
    importing
      !IV_COUNT type I
    returning
      value(RV_OCTETS) type XSTRING .
  methods EAT_STREAM
    importing
      !IV_OCTETS type I
    returning
      value(RO_STREAM) type ref to ZCL_ABAPPGP_STREAM .
  methods GET_DATA
    returning
      value(RV_DATA) type XSTRING .
  methods GET_LENGTH
    returning
      value(RV_LENGTH) type I .
protected section.

  data MV_DATA type XSTRING .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_STREAM IMPLEMENTATION.


  METHOD constructor.

    mv_data = iv_data.

  ENDMETHOD.


  METHOD eat_octet.
    rv_octet = eat_octets( 1 ).
  ENDMETHOD.


  METHOD eat_octets.

    ASSERT iv_count > 0.

    rv_octets = mv_data(iv_count).

    mv_data = mv_data+iv_count.

  ENDMETHOD.


  METHOD eat_stream.

    DATA: lv_data TYPE xstring.


    lv_data = eat_octets( iv_octets ).

    CREATE OBJECT ro_stream
      EXPORTING
        iv_data = lv_data.

  ENDMETHOD.


  METHOD get_data.

    rv_data = mv_data.

  ENDMETHOD.


  METHOD get_length.

    rv_length = xstrlen( mv_data ).

  ENDMETHOD.
ENDCLASS.