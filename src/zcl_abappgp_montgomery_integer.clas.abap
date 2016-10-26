CLASS zcl_abappgp_montgomery_integer DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !io_integer TYPE REF TO zcl_abappgp_integer .
    METHODS get_integer
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
  PROTECTED SECTION.

    DATA mo_integer TYPE REF TO zcl_abappgp_integer .
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