class ZCL_ABAPPGP_MONTGOMERY_INTEGER definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER2 .
  methods GET_INTEGER
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER2 .
protected section.

  data MO_INTEGER type ref to ZCL_ABAPPGP_INTEGER2 .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_MONTGOMERY_INTEGER IMPLEMENTATION.


  METHOD constructor.

    mo_integer = io_integer.

  ENDMETHOD.


  METHOD get_integer.

    ro_integer = mo_integer.

  ENDMETHOD.
ENDCLASS.