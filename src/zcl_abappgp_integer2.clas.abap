class ZCL_ABAPPGP_INTEGER2 definition
  public
  create public .

public section.

  methods CONSTRUCTOR .
  class-methods FROM_STRING
    importing
      !IV_INTEGER type STRING
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER2 .
  methods ADD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER2
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER2 .
  methods TO_STRING
    returning
      value(RV_INTEGER) type STRING .
  class-methods FROM_INTEGER
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER2 .
protected section.

  types TY_SPLIT type I .
  types:
    ty_split_tt TYPE STANDARD TABLE OF ty_split WITH DEFAULT KEY .

  data MT_SPLIT type TY_SPLIT_TT .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_INTEGER2 IMPLEMENTATION.


  method ADD.
  endmethod.


  method CONSTRUCTOR.
  endmethod.


  method FROM_INTEGER.
  endmethod.


  METHOD from_string.

    BREAK-POINT.

  ENDMETHOD.


  method TO_STRING.
  endmethod.
ENDCLASS.