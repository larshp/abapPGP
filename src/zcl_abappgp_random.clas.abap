CLASS zcl_abappgp_random DEFINITION
    PUBLIC
    CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS bits_to_low_high
      IMPORTING
        !iv_bits TYPE string
      EXPORTING
        !eo_low  TYPE REF TO zcl_abappgp_integer
        !eo_high TYPE REF TO zcl_abappgp_integer.
    METHODS constructor
      IMPORTING
        !io_low  TYPE REF TO zcl_abappgp_integer
        !io_high TYPE REF TO zcl_abappgp_integer.
    METHODS random
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer.
  PROTECTED SECTION.

    DATA mv_low TYPE string.
    DATA mv_high TYPE string.

    METHODS random_digits
      IMPORTING
        !iv_digits       TYPE i
      RETURNING
        VALUE(rv_random) TYPE string.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_RANDOM IMPLEMENTATION.


  METHOD bits_to_low_high.

    DATA: lo_one      TYPE REF TO zcl_abappgp_integer,
          lo_exponent TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_one
      EXPORTING
        iv_integer = 1.

    lo_exponent = zcl_abappgp_integer=>from_string( iv_bits ).

    CREATE OBJECT eo_high
      EXPORTING
        iv_integer = 2.
    eo_high->power( lo_exponent ).

    lo_exponent->subtract( lo_one ).
    CREATE OBJECT eo_low
      EXPORTING
        iv_integer = 2.
    eo_low->power( lo_exponent ).

  ENDMETHOD.


  METHOD constructor.

    mv_low = io_low->to_string( ).
    mv_high = io_high->to_string( ).

  ENDMETHOD.


  METHOD random.

    DATA: lv_rlow   TYPE i,
          lv_rhigh  TYPE i,
          lv_str    TYPE string,
          lv_digits TYPE i,
          lv_front  TYPE c LENGTH 1,
          lo_random TYPE REF TO cl_abap_random.


    lo_random = cl_abap_random=>create( cl_abap_random=>seed( ) ).

* this approach makes the random numbers non uniform
* at both ends of the interval, but typically the interval
* is very large, so it should not matter in the big picture?
    lv_digits = lo_random->intinrange( low  = strlen( mv_low )
                                       high = strlen( mv_high ) ).
    lv_str = random_digits( lv_digits ).

    lv_rlow = 1.
    lv_rhigh = 9.
    IF lv_digits = strlen( mv_low ).
      lv_rlow = mv_low(1).
    ENDIF.
    IF lv_digits = strlen( mv_high ).
      lv_rhigh = mv_high(1).
    ENDIF.
    lv_front = lo_random->intinrange( low  = lv_rlow
                                      high = lv_rhigh ).
    CONCATENATE lv_front lv_str+1 INTO lv_str.

    ro_integer = zcl_abappgp_integer=>from_string( lv_str ).

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