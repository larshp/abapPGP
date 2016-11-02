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
protected section.

  data MO_LOW type ref to ZCL_ABAPPGP_INTEGER .
  data MO_HIGH type ref to ZCL_ABAPPGP_INTEGER .

  methods RANDOM_DIGITS
    importing
      !IV_DIGITS type I
    returning
      value(RV_RANDOM) type STRING .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_RANDOM IMPLEMENTATION.


  METHOD bits_to_low_high.

* todo, to be used for random keys
* or not, it can easily be shorter than required number of bits?

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

    mo_low = io_low.
    mo_high = io_high.

  ENDMETHOD.


  METHOD random.

    DATA: lv_str TYPE string.


    DO 100 TIMES.
      CLEAR ro_integer.

      lv_str = random_digits( strlen( mo_high->to_string( ) ) ).

      SHIFT lv_str LEFT DELETING LEADING '0'.
      IF lv_str IS INITIAL.
        lv_str = '0'.
      ENDIF.

      ro_integer = zcl_abappgp_integer=>from_string( lv_str ).

      IF ro_integer->is_le( mo_high ) = abap_true
          AND ro_integer->is_ge( mo_low ) = abap_true.
* todo, or EQ
        EXIT.
      ENDIF.
    ENDDO.

    ASSERT ro_integer IS BOUND.

  ENDMETHOD.


  METHOD random_digits.

* hmm, is CL_ABAP_RANDOM=>seed crypto secure?

    DATA: lv_str TYPE string,
          lv_tmp TYPE n LENGTH 10.


    WHILE strlen( lv_str ) <= iv_digits.
      lv_tmp = cl_abap_random=>seed( ).
* first digit cannot be larger than 2
      CONCATENATE lv_tmp+1 lv_str INTO lv_str.
    ENDWHILE.

    rv_random = lv_str(iv_digits).

  ENDMETHOD.
ENDCLASS.