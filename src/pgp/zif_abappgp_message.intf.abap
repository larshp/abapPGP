interface ZIF_ABAPPGP_MESSAGE
  public .


  class-methods FROM_ARMOR
    importing
      !IO_ARMOR type ref to ZCL_ABAPPGP_ARMOR
    returning
      value(RI_MESSAGE) type ref to ZIF_ABAPPGP_MESSAGE .
  methods DUMP
    returning
      value(RV_DUMP) type STRING .
  methods GET_TYPE
    returning
      value(RV_TYPE) type ZIF_ABAPPGP_CONSTANTS=>TY_MESSAGE_TYPE .
  methods TO_ARMOR
    returning
      value(RO_ARMOR) type ref to ZCL_ABAPPGP_ARMOR .
endinterface.