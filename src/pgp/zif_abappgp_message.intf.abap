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
  methods TO_ARMOR
    returning
      value(RO_ARMOR) type ref to ZCL_ABAPPGP_ARMOR .
endinterface.
