class ZCL_ABAPPGP_BIG_INTEGER definition
  public
  create public .

public section.

  methods ADD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods CONSTRUCTOR
    importing
      !IV_INTEGER type STRING .
  methods DIVIDE
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods MOD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods MULTIPLY
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods POWER
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods SUBTRACT
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods GET
    returning
      value(RV_INTEGER) type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_BIG_INTEGER IMPLEMENTATION.


  method ADD.
  endmethod.


  method CONSTRUCTOR.
  endmethod.


  method DIVIDE.
  endmethod.


  method GET.
  endmethod.


  method MOD.
  endmethod.


  method MULTIPLY.
  endmethod.


  method POWER.
  endmethod.


  method SUBTRACT.
  endmethod.
ENDCLASS.