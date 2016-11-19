class ZCL_ABAPPGP_UNIT_TEST definition
  public
  create public
  for testing .

public section.

  class-methods PACKET_IDENTITY
    importing
      !IO_DATA type ref to ZCL_ABAPPGP_STREAM
      !IV_TAG type ZIF_ABAPPGP_CONSTANTS=>TY_TAG
    returning
      value(RI_PKT) type ref to ZIF_ABAPPGP_PACKET .
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


  METHOD packet_identity.

    DATA: lv_result TYPE xstring.


    ri_pkt = zcl_abappgp_packet_factory=>create(
      io_data = io_data
      iv_tag = iv_tag ).

    lv_result = ri_pkt->to_stream( )->get_data( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = io_data->get_data( ) ).

  ENDMETHOD.


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