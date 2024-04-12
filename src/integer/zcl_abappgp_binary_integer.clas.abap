CLASS zcl_abappgp_binary_integer DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS from_string
      IMPORTING
        !iv_string       TYPE string
      RETURNING
        VALUE(ro_binary) TYPE REF TO zcl_abappgp_binary_integer .
    METHODS to_string
      RETURNING
        VALUE(rv_string) TYPE string .
    METHODS and
      IMPORTING
        !io_binary       TYPE REF TO zcl_abappgp_binary_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_binary_integer .
    METHODS constructor
      IMPORTING
        !io_integer TYPE REF TO zcl_abappgp_integer .
    METHODS is_zero
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS mod_2
      RETURNING
        VALUE(rv_result) TYPE i .
    METHODS shift_left
      IMPORTING
        !iv_times        TYPE i DEFAULT 1
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_binary_integer .
    METHODS shift_right
      IMPORTING
        !iv_times        TYPE i DEFAULT 1
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_binary_integer .
    METHODS to_binary_string
      RETURNING
        VALUE(rv_binary) TYPE string .
    METHODS to_integer
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS get_binary_length
      RETURNING
        VALUE(rv_length) TYPE i .
  PROTECTED SECTION.
    DATA mv_data TYPE string.
    CLASS-DATA: go_two    TYPE REF TO zcl_abappgp_integer,
                gt_powers TYPE STANDARD TABLE OF REF TO zcl_abappgp_integer WITH DEFAULT KEY.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abappgp_binary_integer IMPLEMENTATION.


  METHOD and.

    DATA: lv_min    TYPE i,
          lv_offset TYPE i,
          lv_index  TYPE i,
          lv_char1  TYPE c LENGTH 1,
          lv_char2  TYPE c LENGTH 1,
          lv_result TYPE string.


    lv_min = nmin( val1 = strlen( mv_data )
                   val2 = strlen( io_binary->mv_data ) ).

    DO lv_min TIMES.
      lv_index = sy-index.

      lv_offset = strlen( mv_data ) - lv_index.
      lv_char1 = mv_data+lv_offset(1).

      lv_offset = strlen( io_binary->mv_data ) - lv_index.
      lv_char2 = io_binary->mv_data+lv_offset(1).

      IF lv_char1 = '1' AND lv_char2 = '1'.
        CONCATENATE '1' lv_result INTO lv_result.
      ELSE.
        CONCATENATE '0' lv_result INTO lv_result.
      ENDIF.

    ENDDO.

    SHIFT lv_result LEFT DELETING LEADING '0'.

    mv_data = lv_result.

    ro_result = me.

  ENDMETHOD.

  METHOD constructor.

    DATA lo_int TYPE REF TO zcl_abappgp_integer.

    IF go_two IS INITIAL.
      CREATE OBJECT go_two
        EXPORTING
          iv_integer = 1.

      APPEND go_two TO gt_powers.

      CREATE OBJECT go_two
        EXPORTING
          iv_integer = 2.

      APPEND go_two TO gt_powers.
    ENDIF.

    ASSERT io_integer->is_positive( ) = abap_true.

    lo_int = io_integer->clone( ).

    WHILE lo_int->is_zero( ) = abap_false.
      IF lo_int->mod_2( ) = 0.
        CONCATENATE '0' mv_data INTO mv_data.
      ELSE.
        CONCATENATE '1' mv_data INTO mv_data.
      ENDIF.
      lo_int->divide_by_2( ).
    ENDWHILE.

  ENDMETHOD.


  METHOD from_string.

    DATA lo_integer TYPE REF TO zcl_abappgp_integer.


    lo_integer = zcl_abappgp_integer=>from_string( iv_string ).

    CREATE OBJECT ro_binary
      EXPORTING
        io_integer = lo_integer.

  ENDMETHOD.


  METHOD get_binary_length.

    rv_length = strlen( to_binary_string( ) ).

  ENDMETHOD.


  METHOD is_zero.

    rv_bool = boolc( mv_data CO '0' ).

  ENDMETHOD.


  METHOD mod_2.

    DATA lv_length TYPE i.

    lv_length = strlen( mv_data ) - 1.

    rv_result = mv_data+lv_length(1).

  ENDMETHOD.


  METHOD shift_left.

    ASSERT iv_times >= 1.

    IF is_zero( ) = abap_true.
      RETURN.
    ENDIF.

    DO iv_times TIMES.
      CONCATENATE mv_data '0' INTO mv_data.
    ENDDO.

    ro_result = me.

  ENDMETHOD.


  METHOD shift_right.

    DATA lv_length TYPE i.

    ASSERT iv_times >= 1.

    DO iv_times TIMES.
      lv_length = strlen( mv_data ) - 1.
      ASSERT lv_length >= 0.

      mv_data = mv_data(lv_length).
    ENDDO.

    ro_result = me.

  ENDMETHOD.


  METHOD to_binary_string.
* returns string with zeros and ones

    rv_binary = mv_data.

  ENDMETHOD.


  METHOD to_integer.

    DATA: lv_offset TYPE i,
          lv_bit    TYPE c LENGTH 1,
          lo_int    TYPE REF TO zcl_abappgp_integer,
          lo_tmp    TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT ro_integer
      EXPORTING
        iv_integer = 0.

    lv_offset = strlen( mv_data ) - 1.

    WHILE lv_offset >= 0.
      READ TABLE gt_powers INTO lo_int INDEX sy-index.
      IF sy-subrc <> 0.
        ASSERT lo_int IS BOUND.
        lo_tmp = lo_int->clone( )->multiply( go_two ).
        APPEND lo_tmp TO gt_powers.
        lo_int = lo_tmp.
      ENDIF.

      lv_bit = mv_data+lv_offset(1).
      IF lv_bit = '1'.
        ro_integer = ro_integer->add( lo_int ).
      ENDIF.

      lv_offset = lv_offset - 1.
    ENDWHILE.

  ENDMETHOD.


  METHOD to_string.

    rv_string = to_integer( )->to_string( ).

  ENDMETHOD.
ENDCLASS.
