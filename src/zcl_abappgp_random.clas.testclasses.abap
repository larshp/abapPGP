CLASS ltcl_random DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      random FOR TESTING.

ENDCLASS.

CLASS ltcl_random IMPLEMENTATION.

  METHOD random.

* just test that it does not dump

    DATA: lo_low    TYPE REF TO zcl_abappgp_integer,
          lo_high   TYPE REF TO zcl_abappgp_integer,
          lo_random TYPE REF TO zcl_abappgp_random,
          lo_result TYPE REF TO zcl_abappgp_integer.

    CREATE OBJECT lo_low
      EXPORTING
        iv_integer = '111'.

    CREATE OBJECT lo_high
      EXPORTING
        iv_integer = '999'.

    CREATE OBJECT lo_random
      EXPORTING
        io_low  = lo_low
        io_high = lo_high.

    lo_result = lo_random->random( ).

    cl_abap_unit_assert=>assert_bound( lo_result ).

  ENDMETHOD.

ENDCLASS.