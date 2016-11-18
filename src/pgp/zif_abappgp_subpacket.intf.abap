interface ZIF_ABAPPGP_SUBPACKET
  public .


  class-methods FROM_STREAM
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RI_PACKET) type ref to ZIF_ABAPPGP_SUBPACKET .
  methods TO_STREAM
    returning
      value(RO_STREAM) type ref to ZCL_ABAPPGP_STREAM .
  methods GET_TYPE
    returning
      value(RV_TAG) type ZIF_ABAPPGP_CONSTANTS=>TY_TAG .
endinterface.