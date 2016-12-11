class ZCL_ABAPPGP_RSA_PUBLIC_KEY definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_N type ref to ZCL_ABAPPGP_INTEGER
      !IO_E type ref to ZCL_ABAPPGP_INTEGER .
  methods GET_N
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods GET_E
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
protected section.
private section.

  data MO_N type ref to ZCL_ABAPPGP_INTEGER .
  data MO_E type ref to ZCL_ABAPPGP_INTEGER .
ENDCLASS.



CLASS ZCL_ABAPPGP_RSA_PUBLIC_KEY IMPLEMENTATION.


  METHOD constructor.

    mo_n = io_n.
    mo_e = io_e.

  ENDMETHOD.


  METHOD get_e.

    ro_integer = mo_e.

  ENDMETHOD.


  METHOD get_n.

    ro_integer = mo_n.

  ENDMETHOD.
ENDCLASS.