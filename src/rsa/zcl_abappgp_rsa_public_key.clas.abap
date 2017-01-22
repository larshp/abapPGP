CLASS zcl_abappgp_rsa_public_key DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !io_n TYPE REF TO zcl_abappgp_integer
        !io_e TYPE REF TO zcl_abappgp_integer .
    METHODS get_n
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS get_e
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_n TYPE REF TO zcl_abappgp_integer .
    DATA mo_e TYPE REF TO zcl_abappgp_integer .
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
