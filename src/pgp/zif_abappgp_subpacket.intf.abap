interface ZIF_ABAPPGP_SUBPACKET
  public .


  class-methods FROM_STREAM
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RI_PACKET) type ref to ZIF_ABAPPGP_SUBPACKET .
  methods DUMP
    returning
      value(RV_DUMP) type STRING .
  methods GET_NAME
    returning
      value(RV_NAME) type STRING .
  methods GET_TYPE
    returning
      value(RV_TYPE) type ZIF_ABAPPGP_CONSTANTS=>TY_SUB_TYPE .
  methods TO_STREAM
    returning
      value(RO_STREAM) type ref to ZCL_ABAPPGP_STREAM .
endinterface.
