class ZCL_ABAPPGP_INTEGER2 definition
  public
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods FROM_INTEGER
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER2 .
  class-methods FROM_STRING
    importing
      !IV_INTEGER type STRING
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER2 .
  methods ADD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER2
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER2 .
  methods AND
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER2
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER2 .
  methods CLONE
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER2 .
  methods CONSTRUCTOR
    importing
      !IV_INTEGER type I default 1 .
  methods GET_BINARY_LENGTH
    returning
      value(RV_LENGTH) type I .
  type-pools ABAP .
  methods IS_ONE
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_ZERO
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods MULTIPLY .
  methods SHIFT_RIGHT .
  methods SUBTRACT .
  methods TO_BINARY_STRING
    returning
      value(RV_BINARY) type STRING .
  methods TO_INTEGER
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods TO_STRING
    returning
      value(RV_INTEGER) type STRING .
PROTECTED SECTION.

  TYPES ty_split TYPE i.
  TYPES:
    ty_split_tt TYPE STANDARD TABLE OF ty_split WITH DEFAULT KEY.

  DATA mt_split TYPE ty_split_tt.
  CLASS-DATA gv_max TYPE i VALUE 8192.
  CLASS-DATA gv_bits TYPE i VALUE 13.

  CLASS-DATA: go_max    TYPE REF TO zcl_abappgp_integer,
              gt_powers TYPE STANDARD TABLE OF REF TO zcl_abappgp_integer WITH DEFAULT KEY.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_INTEGER2 IMPLEMENTATION.


  METHOD add.

    DATA: lv_max   TYPE i,
          lv_carry TYPE ty_split,
          lv_op1   TYPE ty_split,
          lv_op2   TYPE ty_split,
          lv_index TYPE i,
          lo_tmp   TYPE REF TO zcl_abappgp_integer.


    ro_result = me.

    lv_max = nmax( val1 = lines( io_integer->mt_split )
                   val2 = lines( mt_split ) ).

    DO lv_max TIMES.
      lv_index = sy-index.

      CLEAR: lv_op1,
             lv_op2.

      READ TABLE mt_split INDEX lv_index INTO lv_op1.     "#EC CI_SUBRC
      READ TABLE io_integer->mt_split INDEX lv_index INTO lv_op2. "#EC CI_SUBRC

      lv_op1 = lv_op1 + lv_op2 + lv_carry.

      lv_carry = lv_op1 DIV gv_max.
      lv_op1 = lv_op1 - lv_carry * gv_max.

      MODIFY mt_split INDEX lv_index FROM lv_op1.
      IF sy-subrc <> 0.
        APPEND lv_op1 TO mt_split.
      ENDIF.
    ENDDO.

    IF lv_carry <> 0.
      lv_index = lv_max + 1.
      MODIFY mt_split INDEX lv_index FROM lv_carry.
      IF sy-subrc <> 0.
        APPEND lv_carry TO mt_split.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD and.

    DATA: lv_hres   TYPE x LENGTH 2,
          lv_hex1   TYPE x LENGTH 2,
          lv_hex2   TYPE x LENGTH 2,
          lv_lines  TYPE i,
          lt_result LIKE mt_split,
          lv_split  LIKE LINE OF mt_split.


* todo, nmin() instead?
    IF lines( io_integer->mt_split ) < lines( mt_split ).
      lv_lines = lines( io_integer->mt_split ).
    ELSE.
      lv_lines = lines( mt_split ).
    ENDIF.

    DO lv_lines TIMES.
      READ TABLE io_integer->mt_split INTO lv_hex1 INDEX sy-index.
      READ TABLE mt_split INTO lv_hex2 INDEX sy-index.

      lv_hres = lv_hex1 BIT-AND lv_hex2.
      APPEND lv_hres TO lt_result.
    ENDDO.

    mt_split = lt_result.

    WHILE lines( mt_split ) > 0.
      READ TABLE mt_split INDEX lines( mt_split ) INTO lv_split.
      IF lv_split = 0.
        DELETE mt_split INDEX lines( mt_split ).
      ELSE.
        EXIT. " current loop
      ENDIF.
    ENDWHILE.

    ro_result = me.

  ENDMETHOD.


  METHOD class_constructor.

    CREATE OBJECT go_max
      EXPORTING
        iv_integer = 1.

    APPEND go_max TO gt_powers.

    CREATE OBJECT go_max
      EXPORTING
        iv_integer = gv_max.

    APPEND go_max TO gt_powers.

  ENDMETHOD.


  METHOD clone.

    CREATE OBJECT ro_integer.
    ro_integer->mt_split = mt_split.

  ENDMETHOD.


  METHOD constructor.

    ASSERT iv_integer >= 0.
    ASSERT iv_integer < gv_max.

    APPEND iv_integer TO mt_split.

  ENDMETHOD.


  METHOD from_integer.

    DATA: lv_hex   TYPE x LENGTH 2, " 16 bits
          lv_count TYPE i VALUE 16,
          lv_int   TYPE i,
          lo_int   TYPE REF TO zcl_abappgp_integer.


    ASSERT io_integer->is_positive( ) = abap_true.

    CREATE OBJECT ro_integer.
    CLEAR ro_integer->mt_split.

    lo_int = io_integer->clone( ).

    WHILE lo_int->is_zero( ) = abap_false.
      IF lo_int->mod_2( ) = 1.
        SET BIT lv_count OF lv_hex.
      ENDIF.

      IF lv_count = 4.
        lv_count = 16.

        lv_int = lv_hex.
        APPEND lv_int TO ro_integer->mt_split.
        CLEAR lv_hex.
      ELSE.
        lv_count = lv_count - 1.
      ENDIF.

      lo_int->divide_by_2( ).
    ENDWHILE.

    IF NOT lv_hex IS INITIAL.
      lv_int = lv_hex.
      APPEND lv_int TO ro_integer->mt_split.
    ENDIF.

  ENDMETHOD.


  METHOD from_string.
* input = base 10

    ASSERT iv_integer CO '0123456789'.

    ro_integer = from_integer( zcl_abappgp_integer=>from_string( iv_integer ) ).

  ENDMETHOD.


  METHOD get_binary_length.

    DATA: lv_split LIKE LINE OF mt_split,
          lv_bit   TYPE c LENGTH 1,
          lv_hex   TYPE x LENGTH 2.


    IF is_zero( ) = abap_true.
      rv_length = 1.
    ENDIF.

    IF lines( mt_split ) > 1.
      rv_length = ( lines( mt_split ) - 1 ) * gv_bits.
    ENDIF.

    READ TABLE mt_split INDEX lines( mt_split ) INTO lv_split.
    lv_hex = lv_split.
    DO 16 TIMES.
      GET BIT sy-index OF lv_hex INTO lv_bit.
      IF lv_bit = '1'.
        rv_length = rv_length + 17 - sy-index.
        RETURN.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD is_one.

    DATA: lv_split LIKE LINE OF mt_split.


    rv_bool = abap_false.

    IF lines( mt_split ) = 1.
      READ TABLE mt_split INDEX 1 INTO lv_split.
      rv_bool = boolc( lv_split = 1 ).
    ENDIF.

  ENDMETHOD.


  METHOD is_zero.

    DATA: lv_split LIKE LINE OF mt_split.


    rv_bool = abap_false.

    IF lines( mt_split ) = 1.
      READ TABLE mt_split INDEX 1 INTO lv_split.
      rv_bool = boolc( lv_split = 0 ).
    ENDIF.

  ENDMETHOD.


  METHOD multiply.

    BREAK-POINT.

  ENDMETHOD.


  METHOD shift_right.

    BREAK-POINT.

  ENDMETHOD.


  METHOD subtract.

    BREAK-POINT.

  ENDMETHOD.


  METHOD to_binary_string.

    BREAK-POINT.

  ENDMETHOD.


  METHOD to_integer.

    DATA: lv_split LIKE LINE OF mt_split,
          lo_split TYPE REF TO zcl_abappgp_integer,
          lo_int   TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT ro_integer
      EXPORTING
        iv_integer = 0.

    LOOP AT mt_split INTO lv_split.
      READ TABLE gt_powers INTO lo_int INDEX sy-tabix.
      IF sy-subrc <> 0.
        ASSERT lo_int IS BOUND.
        lo_int = lo_int->clone( )->multiply( go_max ).
        APPEND lo_int TO gt_powers.
      ENDIF.

      CREATE OBJECT lo_split
        EXPORTING
          iv_integer = lv_split.
      ro_integer = ro_integer->add( lo_split->multiply( lo_int ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD to_string.
* output integer base 10

    rv_integer = to_integer( )->to_string( ).

  ENDMETHOD.
ENDCLASS.