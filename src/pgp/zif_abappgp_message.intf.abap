INTERFACE zif_abappgp_message PUBLIC.


  CLASS-METHODS from_armor
    IMPORTING
      !io_armor         TYPE REF TO zcl_abappgp_armor
    RETURNING
      VALUE(ri_message) TYPE REF TO zif_abappgp_message .
  METHODS dump
    RETURNING
      VALUE(rv_dump) TYPE string .
  METHODS to_armor
    RETURNING
      VALUE(ro_armor) TYPE REF TO zcl_abappgp_armor .
ENDINTERFACE.
