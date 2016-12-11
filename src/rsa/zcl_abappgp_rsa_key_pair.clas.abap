class ZCL_ABAPPGP_RSA_KEY_PAIR definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_PRIVATE type ref to ZCL_ABAPPGP_RSA_PRIVATE_KEY
      !IO_PUBLIC type ref to ZCL_ABAPPGP_RSA_PUBLIC_KEY .
  methods GET_PUBLIC
    returning
      value(RO_KEY) type ref to ZCL_ABAPPGP_RSA_PUBLIC_KEY .
  methods GET_PRIVATE
    returning
      value(RO_KEY) type ref to ZCL_ABAPPGP_RSA_PRIVATE_KEY .
protected section.
private section.

  data MO_PRIVATE type ref to ZCL_ABAPPGP_RSA_PRIVATE_KEY .
  data MO_PUBLIC type ref to ZCL_ABAPPGP_RSA_PUBLIC_KEY .
ENDCLASS.



CLASS ZCL_ABAPPGP_RSA_KEY_PAIR IMPLEMENTATION.


  METHOD constructor.

    mo_private = io_private.
    mo_public  = io_public.

  ENDMETHOD.


  METHOD get_private.

    ro_key = mo_private.

  ENDMETHOD.


  METHOD get_public.

    ro_key = mo_public.

  ENDMETHOD.
ENDCLASS.