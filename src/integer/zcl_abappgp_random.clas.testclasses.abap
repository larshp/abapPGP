CLASS ltcl_random DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS
      random FOR TESTING.

ENDCLASS.

CLASS ltcl_random IMPLEMENTATION.

  METHOD random.

    CONSTANTS: lc_low  TYPE i VALUE 1111,
               lc_high TYPE i VALUE 9999.

    DATA: lo_low    TYPE REF TO zcl_abappgp_integer,
          lo_high   TYPE REF TO zcl_abappgp_integer,
          lo_random TYPE REF TO zcl_abappgp_random,
          lo_result TYPE REF TO zcl_abappgp_integer,
          lv_int    TYPE i.


    CREATE OBJECT lo_low
      EXPORTING
        iv_integer = lc_low.

    CREATE OBJECT lo_high
      EXPORTING
        iv_integer = lc_high.

    CREATE OBJECT lo_random
      EXPORTING
        io_low  = lo_low
        io_high = lo_high.

    DO 2000 TIMES.
      lo_result = lo_random->random( ).
      cl_abap_unit_assert=>assert_bound( lo_result ).

      lv_int = lo_result->to_string( ).
      cl_abap_unit_assert=>assert_number_between(
        lower  = lc_low
        upper  = lc_high
        number = lv_int ).
    ENDDO.

  ENDMETHOD.

ENDCLASS.
