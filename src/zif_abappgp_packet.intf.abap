interface ZIF_ABAPPGP_PACKET
  public .


  class-methods FROM_STREAM
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RI_PACKET) type ref to ZIF_ABAPPGP_PACKET .
  methods DUMP
    returning
      value(RV_DUMP) type STRING .
  methods GET_NAME
    returning
      value(RV_NAME) type STRING .
  methods GET_TAG
    returning
      value(RV_TAG) type ZIF_ABAPPGP_CONSTANTS=>TY_TAG .
  methods TO_STREAM
    returning
      value(RO_STREAM) type ref to ZCL_ABAPPGP_STREAM .
endinterface.