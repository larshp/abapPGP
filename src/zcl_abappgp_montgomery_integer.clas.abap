class ZCL_ABAPPGP_MONTGOMERY_INTEGER definition
  public
  create protected

  global friends ZCL_ABAPPGP_MONTGOMERY .

public section.
protected section.

  data MO_INTEGER type ref to ZCL_ABAPPGP_INTEGER .

  methods CONSTRUCTOR
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER .
  methods GET
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_MONTGOMERY_INTEGER IMPLEMENTATION.


  METHOD constructor.

    mo_integer = io_integer.

  ENDMETHOD.


  method GET.
  endmethod.
ENDCLASS.