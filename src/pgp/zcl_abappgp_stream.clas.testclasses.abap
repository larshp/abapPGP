CLASS ltcl_length DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS
      test
        IMPORTING
          iv_hex TYPE xstring
          iv_exp TYPE i.

    METHODS length01 FOR TESTING RAISING cx_static_check.
    METHODS length02 FOR TESTING RAISING cx_static_check.
    METHODS length03 FOR TESTING RAISING cx_static_check.
    METHODS length04 FOR TESTING RAISING cx_static_check.
    METHODS length05 FOR TESTING RAISING cx_static_check.
    METHODS length06 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_length IMPLEMENTATION.

  METHOD test.

    DATA: lv_length TYPE i,
          lo_stream TYPE REF TO zcl_abappgp_stream.


    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = iv_hex.

    lv_length = lo_stream->eat_length( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_length
      exp = iv_exp ).

    lo_stream->write_length( lv_length ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_stream->get_data( )
      exp = iv_hex ).

  ENDMETHOD.

  METHOD length01.
    test( iv_exp = 100
          iv_hex = '64' ).
  ENDMETHOD.

  METHOD length02.
    test( iv_exp = 1723
          iv_hex = 'C5FB' ).
  ENDMETHOD.

  METHOD length03.
    test( iv_exp = 100000
          iv_hex = 'FF000186A0' ).
  ENDMETHOD.

  METHOD length04.
    test( iv_exp = 191
          iv_hex = 'BF' ).
  ENDMETHOD.

  METHOD length05.
    test( iv_exp = 8383
          iv_hex = 'DFFF' ).
  ENDMETHOD.

  METHOD length06.
    test( iv_exp = 242
          iv_hex = 'C032' ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_mpi DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS mpi01 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_mpi IMPLEMENTATION.

  METHOD mpi01.

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
