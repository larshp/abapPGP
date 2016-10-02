CLASS zcl_abappgp_prime DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS check
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PRIME IMPLEMENTATION.


  method CHECK.
  endmethod.
ENDCLASS.