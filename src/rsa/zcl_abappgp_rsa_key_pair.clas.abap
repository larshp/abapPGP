CLASS zcl_abappgp_rsa_key_pair DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !io_private TYPE REF TO zcl_abappgp_rsa_private_key
        !io_public  TYPE REF TO zcl_abappgp_rsa_public_key .
    METHODS get_public
      RETURNING
        VALUE(ro_key) TYPE REF TO zcl_abappgp_rsa_public_key .
    METHODS get_private
      RETURNING
        VALUE(ro_key) TYPE REF TO zcl_abappgp_rsa_private_key .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_private TYPE REF TO zcl_abappgp_rsa_private_key .
    DATA mo_public TYPE REF TO zcl_abappgp_rsa_public_key .
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
