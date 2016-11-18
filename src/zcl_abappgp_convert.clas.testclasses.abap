
CLASS ltcl_read_mpi DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: run
      IMPORTING iv_raw TYPE xstring
                iv_exp TYPE string.

    METHODS:
      test01 FOR TESTING,
      test02 FOR TESTING.
ENDCLASS.       "ltcl_Read_Mpi

CLASS ltcl_read_mpi IMPLEMENTATION.

  METHOD run.

    DATA: lo_stream  TYPE REF TO zcl_abappgp_stream,
          lo_integer TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = iv_raw.

    lo_integer = zcl_abappgp_convert=>read_mpi( lo_stream ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_integer->to_string( )
      exp = iv_exp ).

  ENDMETHOD.

  METHOD test01.
    run( iv_raw = '000101'
         iv_exp = '1' ).
  ENDMETHOD.

  METHOD test02.
    run( iv_raw = '000901FF'
         iv_exp = '511' ).
  ENDMETHOD.

ENDCLASS.