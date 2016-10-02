CLASS zcl_abappgp_random DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_bits TYPE string .
    METHODS random
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer.
protected section.

  data MV_LOW type STRING .
  data MV_HIGH type STRING .

  methods BITS_TO_LOW_HIGH
    importing
      !IV_BITS type STRING
    exporting
      !EV_LOW type STRING
      !EV_HIGH type STRING .
  methods RANDOM_DIGITS
    importing
      !IV_DIGITS type I
    returning
      value(RV_RANDOM) type STRING .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_RANDOM IMPLEMENTATION.


  METHOD bits_to_low_high.

    DATA: lo_one      TYPE REF TO zcl_abappgp_integer,
          lo_low      TYPE REF TO zcl_abappgp_integer,
          lo_high     TYPE REF TO zcl_abappgp_integer,
          lo_exponent TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_one
      EXPORTING
        iv_integer = '1'.

    CREATE OBJECT lo_exponent
      EXPORTING
        iv_integer = iv_bits.

    CREATE OBJECT lo_high
      EXPORTING
        iv_integer = '2'.
    lo_high->power( lo_exponent ).

    lo_exponent->subtract( lo_one ).
    CREATE OBJECT lo_low
      EXPORTING
        iv_integer = '2'.
    lo_low->power( lo_exponent ).

    ev_low = lo_low->get( ).
    ev_high = lo_high->get( ).

  ENDMETHOD.


  METHOD constructor.

    bits_to_low_high(
      EXPORTING
        iv_bits = iv_bits
      IMPORTING
        ev_low  = mv_low
        ev_high = mv_high ).

  ENDMETHOD.


  METHOD random.

    DATA: lv_length TYPE i,
          lv_rlow   TYPE i,
          lv_rhigh  TYPE i,
          lv_part1  TYPE string,
          lv_part2  TYPE string,
          lv_str    TYPE string.


    lv_length = strlen( mv_low ) - 1.
    lv_part2 = random_digits( lv_length ).

    lv_rlow  = mv_low(1).
    lv_length = strlen( mv_high ) - lv_length.
    lv_rhigh = mv_high(lv_length).
    lv_part1 = cl_abap_random=>create(
      cl_abap_random=>seed( ) )->intinrange( low  = lv_rlow
                                             high = lv_rhigh ).
    CONDENSE lv_part1.

    CONCATENATE lv_part1 lv_part2 INTO lv_str.

    CREATE OBJECT ro_integer
      EXPORTING
        iv_integer = lv_str.

  ENDMETHOD.


  METHOD random_digits.

* hmm, is CL_ABAP_RANDOM=>seed crypto secure?

    DATA: lv_str TYPE string,
          lv_tmp TYPE string.


    WHILE strlen( lv_str ) <= iv_digits.
      lv_tmp = cl_abap_random=>seed( ).
      CONDENSE lv_tmp.
      CONCATENATE lv_tmp lv_str INTO lv_str.
    ENDWHILE.

    rv_random = lv_str(iv_digits).

  ENDMETHOD.
ENDCLASS.