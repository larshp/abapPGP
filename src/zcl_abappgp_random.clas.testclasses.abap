CLASS ltcl_random DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      random FOR TESTING.

ENDCLASS.

CLASS ltcl_random IMPLEMENTATION.

  METHOD random.

* just test that it does not dump

    DATA: lo_random TYPE REF TO zcl_abappgp_random,
          lo_result TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_random
      EXPORTING
        iv_bits = '256'.

    lo_result = lo_random->random( ).

    cl_abap_unit_assert=>assert_bound( lo_result ).

  ENDMETHOD.

ENDCLASS.