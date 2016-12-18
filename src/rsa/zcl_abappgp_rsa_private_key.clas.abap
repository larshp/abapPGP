CLASS zcl_abappgp_rsa_private_key DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !io_d TYPE REF TO zcl_abappgp_integer
        !io_p TYPE REF TO zcl_abappgp_integer
        !io_q TYPE REF TO zcl_abappgp_integer
        !io_u TYPE REF TO zcl_abappgp_integer .
    METHODS get_d
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS get_p
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS get_q
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS get_u
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS get_n
      RETURNING
        VALUE(ro_n) TYPE REF TO zcl_abappgp_integer .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_d TYPE REF TO zcl_abappgp_integer .
    DATA mo_p TYPE REF TO zcl_abappgp_integer .
    DATA mo_q TYPE REF TO zcl_abappgp_integer .
    DATA mo_u TYPE REF TO zcl_abappgp_integer .
ENDCLASS.



CLASS ZCL_ABAPPGP_RSA_PRIVATE_KEY IMPLEMENTATION.


  METHOD constructor.

    mo_d = io_d.
    mo_p = io_p.
    mo_q = io_q.
    mo_u = io_u.

  ENDMETHOD.


  METHOD get_d.

    ro_integer = mo_d.

  ENDMETHOD.


  METHOD get_n.

    ro_n = get_p( )->clone( )->multiply( get_q( ) ).

  ENDMETHOD.


  METHOD get_p.

    ro_integer = mo_p.

  ENDMETHOD.


  METHOD get_q.

    ro_integer = mo_q.

  ENDMETHOD.


  METHOD get_u.

    ro_integer = mo_u.

  ENDMETHOD.
ENDCLASS.