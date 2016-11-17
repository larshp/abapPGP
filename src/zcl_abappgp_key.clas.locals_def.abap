*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CLASS lcl_stream DEFINITION.

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING iv_data TYPE xstring,
      eat_octet
        RETURNING VALUE(rv_octet) TYPE xstring,
      eat_octets
        IMPORTING iv_count         TYPE i
        RETURNING VALUE(rv_octets) TYPE xstring.

  PRIVATE SECTION.
    DATA: mv_data TYPE xstring.

ENDCLASS.