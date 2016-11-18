interface ZIF_ABAPPGP_PACKET
  public .


  class-methods FROM_STREAM
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RI_PACKET) type ref to ZIF_ABAPPGP_PACKET .
  methods TO_STREAM
    returning
      value(RO_STREAM) type ref to ZCL_ABAPPGP_STREAM .
endinterface.