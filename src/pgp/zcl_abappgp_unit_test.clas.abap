class ZCL_ABAPPGP_UNIT_TEST definition
  public
  create public
  for testing .

public section.

  class-methods SUBPACKET_IDENTITY
    importing
      !IV_DATA type XSTRING
      !IV_TYPE type ZIF_ABAPPGP_CONSTANTS=>TY_SUB_TYPE
    returning
      value(RI_SUB) type ref to ZIF_ABAPPGP_SUBPACKET .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_UNIT_TEST IMPLEMENTATION.


  METHOD subpacket_identity.

    DATA: lv_result TYPE xstring.


    ri_sub = zcl_abappgp_subpacket_factory=>create(
      iv_data = iv_data
      iv_type = iv_type ).

    lv_result = ri_sub->to_stream( )->get_data( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = iv_data ).

  ENDMETHOD.
ENDCLASS.