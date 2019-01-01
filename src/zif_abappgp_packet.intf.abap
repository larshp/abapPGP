INTERFACE zif_abappgp_packet PUBLIC.

  CLASS-METHODS from_stream
    IMPORTING
      !io_stream       TYPE REF TO zcl_abappgp_stream
    RETURNING
      VALUE(ri_packet) TYPE REF TO zif_abappgp_packet.
  METHODS dump
    RETURNING
      VALUE(rv_dump) TYPE string.
  METHODS get_name
    RETURNING
      VALUE(rv_name) TYPE string.
  METHODS get_tag
    RETURNING
      VALUE(rv_tag) TYPE zif_abappgp_constants=>ty_tag.
  METHODS to_stream
    RETURNING
      VALUE(ro_stream) TYPE REF TO zcl_abappgp_stream.

ENDINTERFACE.
