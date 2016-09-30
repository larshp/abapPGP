CLASS zcl_abappgp_big_integer DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS add
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_big_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_big_integer.
    METHODS constructor
      IMPORTING
        !iv_integer TYPE string.
    METHODS divide
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_big_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_big_integer.
    METHODS get
      RETURNING
        VALUE(rv_integer) TYPE string.
    METHODS mod
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_big_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_big_integer.
    METHODS multiply
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_big_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_big_integer.
    METHODS power
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_big_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_big_integer.
    METHODS subtract
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_big_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_big_integer.
  PROTECTED SECTION.

    TYPES:
      ty_split_tt TYPE STANDARD TABLE OF int4 WITH DEFAULT KEY.

    DATA mt_split TYPE ty_split_tt.
    CONSTANTS c_length TYPE i VALUE 4 ##NO_TEXT.

    CLASS-METHODS split
      IMPORTING
        !iv_integer     TYPE string
      RETURNING
        VALUE(rt_split) TYPE ty_split_tt.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_BIG_INTEGER IMPLEMENTATION.


  METHOD add.

* todo

    ro_result = me.

  ENDMETHOD.


  METHOD constructor.

    ASSERT iv_integer CO '1234567890'.

    mt_split = split( iv_integer ).

  ENDMETHOD.


  METHOD divide.

* todo

    ro_result = me.

  ENDMETHOD.


  METHOD get.

    DATA: lv_int TYPE c LENGTH c_length.

    LOOP AT mt_split INTO lv_int.
      IF sy-tabix <> lines( mt_split ).
        SHIFT lv_int RIGHT DELETING TRAILING space.
        OVERLAY lv_int WITH '0000'.
      ENDIF.
      CONCATENATE lv_int rv_integer INTO rv_integer.
    ENDLOOP.

    CONDENSE rv_integer.

  ENDMETHOD.


  METHOD mod.

* todo

    ro_result = me.

  ENDMETHOD.


  METHOD multiply.

* todo

    ro_result = me.

  ENDMETHOD.


  METHOD power.

* todo

    ro_result = me.

  ENDMETHOD.


  METHOD split.

    DATA: lv_length TYPE i,
          lv_offset TYPE i.


    lv_offset = strlen( iv_integer ) - c_length.

    DO.
      IF lv_offset < 0.
        lv_offset = 0.
      ENDIF.

      lv_length = c_length.
      IF lv_length > strlen( iv_integer ).
        lv_length = strlen( iv_integer ).
      ELSEIF lv_offset = 0.
        lv_length = strlen( iv_integer ) - lines( rt_split ) * c_length.
      ENDIF.

      APPEND iv_integer+lv_offset(lv_length) TO rt_split.

      IF lv_offset = 0.
        EXIT. " current loop
      ENDIF.

      lv_offset = lv_offset - c_length.
    ENDDO.

  ENDMETHOD.


  METHOD subtract.

* todo

    ro_result = me.

  ENDMETHOD.
ENDCLASS.