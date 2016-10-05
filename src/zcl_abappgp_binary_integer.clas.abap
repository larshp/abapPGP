CLASS zcl_abappgp_binary_integer DEFINITION
    PUBLIC
    CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !io_integer TYPE REF TO zcl_abappgp_integer.
    METHODS get
      RETURNING
        VALUE(rv_binary) TYPE string.
    METHODS is_zero
      RETURNING
        VALUE(rv_bool) TYPE abap_bool.
    METHODS mod_2
      RETURNING
        VALUE(rv_result) TYPE i.
    METHODS shift.
    METHODS to_integer
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer.
  PROTECTED SECTION.

    DATA mv_data TYPE string.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_BINARY_INTEGER IMPLEMENTATION.


  METHOD constructor.

    DATA: lo_int TYPE REF TO zcl_abappgp_integer,
          lo_mod TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_mod.
    CREATE OBJECT lo_int.
    lo_int->copy( io_integer ).

    WHILE lo_int->is_zero( ) = abap_false.
      lo_mod->copy( lo_int )->mod_2( ).
      IF lo_mod->is_zero( ) = abap_true.
        CONCATENATE '0' mv_data INTO mv_data.
      ELSE.
        CONCATENATE '1' mv_data INTO mv_data.
      ENDIF.
      lo_int->divide_by_2( ).
    ENDWHILE.

  ENDMETHOD.


  METHOD get.

    rv_binary = mv_data.

  ENDMETHOD.


  METHOD is_zero.

    rv_bool = boolc( mv_data CO '0' ).

  ENDMETHOD.


  METHOD mod_2.

    DATA: lv_length TYPE i.

    lv_length = strlen( mv_data ) - 1.

    rv_result = mv_data+lv_length(1).

  ENDMETHOD.


  METHOD shift.

    DATA: lv_length TYPE i.


    lv_length = strlen( mv_data ) - 1.
    ASSERT lv_length >= 0.

    mv_data = mv_data(lv_length).

  ENDMETHOD.


  METHOD to_integer.

    DATA: lv_offset TYPE i,
          lv_bit    TYPE c LENGTH 1,
          lo_int    TYPE REF TO zcl_abappgp_integer,
          lo_two    TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT ro_integer
      EXPORTING
        iv_integer = '0'.
    CREATE OBJECT lo_two
      EXPORTING
        iv_integer = '2'.
    CREATE OBJECT lo_int.

    lv_offset = strlen( mv_data ) - 1.

    WHILE lv_offset >= 0.
      lv_bit = mv_data+lv_offset(1).
      IF lv_bit = '1'.
        ro_integer->add( lo_int ).
      ENDIF.
      lo_int->multiply( lo_two ).
      lv_offset = lv_offset - 1.
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.