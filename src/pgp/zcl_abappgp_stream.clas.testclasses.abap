
CLASS ltcl_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: mpi FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD mpi.

    DATA: lv_hex     TYPE xstring,
          lo_integer TYPE REF TO zcl_abappgp_integer,
          lo_stream  TYPE REF TO zcl_abappgp_stream.


    lv_hex = '000901FF'.

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = lv_hex.

    lo_integer = lo_stream->eat_mpi( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_integer->to_integer( )
      exp = 511 ).

    lo_stream->write_mpi( lo_integer ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_stream->get_data( )
      exp = lv_hex ).

  ENDMETHOD.

ENDCLASS.