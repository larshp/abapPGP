class ZCL_ABAPPGP_BINARY_INTEGER definition
  public
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  methods AND
    importing
      !IO_BINARY type ref to ZCL_ABAPPGP_BINARY_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BINARY_INTEGER .
  methods CONSTRUCTOR
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER .
  methods IS_ZERO
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods MOD_2
    returning
      value(RV_RESULT) type I .
  methods SHIFT_LEFT
    importing
      !IV_TIMES type I default 1
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BINARY_INTEGER .
  methods SHIFT_RIGHT
    importing
      !IV_TIMES type I default 1
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BINARY_INTEGER .
  methods TO_BINARY_STRING
    returning
      value(RV_BINARY) type STRING .
  methods TO_INTEGER
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods GET_BINARY_LENGTH
    returning
      value(RV_LENGTH) type I .
  PROTECTED SECTION.
    DATA mv_data TYPE string.
    CLASS-DATA: go_two    TYPE REF TO zcl_abappgp_integer,
                gt_powers TYPE STANDARD TABLE OF REF TO zcl_abappgp_integer WITH DEFAULT KEY.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_BINARY_INTEGER IMPLEMENTATION.


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


  METHOD class_constructor.

    CREATE OBJECT go_two
      EXPORTING
        iv_integer = 1.

    APPEND go_two TO gt_powers.

    CREATE OBJECT go_two
      EXPORTING
        iv_integer = 2.

    APPEND go_two TO gt_powers.

  ENDMETHOD.


  METHOD constructor.

    DATA: lo_int TYPE REF TO zcl_abappgp_integer.


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


  METHOD get_binary_length.

    rv_length = strlen( to_binary_string( ) ).

  ENDMETHOD.


  METHOD is_zero.

    rv_bool = boolc( mv_data CO '0' ).

  ENDMETHOD.


  METHOD mod_2.

    DATA: lv_length TYPE i.

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

    DATA: lv_length TYPE i.

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
ENDCLASS.