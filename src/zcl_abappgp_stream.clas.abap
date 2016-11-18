class ZCL_ABAPPGP_STREAM definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_DATA type XSTRING .
  methods EAT_OCTETS
    importing
      !IV_COUNT type I
    returning
      value(RV_OCTETS) type XSTRING .
  methods EAT_OCTET
    returning
      value(RV_OCTET) type XSTRING .
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
ENDCLASS.