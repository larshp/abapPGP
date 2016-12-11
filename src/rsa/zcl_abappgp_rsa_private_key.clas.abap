class ZCL_ABAPPGP_RSA_PRIVATE_KEY definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_D type ref to ZCL_ABAPPGP_INTEGER
      !IO_P type ref to ZCL_ABAPPGP_INTEGER
      !IO_Q type ref to ZCL_ABAPPGP_INTEGER
      !IO_U type ref to ZCL_ABAPPGP_INTEGER .
  methods GET_D
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods GET_P
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods GET_Q
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods GET_U
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
protected section.
private section.

  data MO_D type ref to ZCL_ABAPPGP_INTEGER .
  data MO_P type ref to ZCL_ABAPPGP_INTEGER .
  data MO_Q type ref to ZCL_ABAPPGP_INTEGER .
  data MO_U type ref to ZCL_ABAPPGP_INTEGER .
ENDCLASS.



CLASS ZCL_ABAPPGP_RSA_PRIVATE_KEY IMPLEMENTATION.


  METHOD constructor.

    mo_d = io_d.
    mo_p = io_p.
    mo_q = io_q.
    mo_u = io_u.

  ENDMETHOD.


  METHOD GET_D.

    ro_integer = mo_d.

  ENDMETHOD.


  METHOD GET_P.

    ro_integer = mo_p.

  ENDMETHOD.


  METHOD GET_Q.

    ro_integer = mo_q.

  ENDMETHOD.


  METHOD GET_U.

    ro_integer = mo_u.

  ENDMETHOD.
ENDCLASS.