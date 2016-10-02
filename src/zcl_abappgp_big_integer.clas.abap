class ZCL_ABAPPGP_BIG_INTEGER definition
  public
  create public .

public section.

  methods IS_ZERO
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods ADD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods CONSTRUCTOR
    importing
      !IV_INTEGER type STRING .
  methods DIVIDE
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods GET
    returning
      value(RV_INTEGER) type STRING .
  methods MOD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods MULTIPLY
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods POWER
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
  methods SUBTRACT
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_BIG_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_BIG_INTEGER .
protected section.

  types:
    ty_split_tt TYPE STANDARD TABLE OF int4 WITH DEFAULT KEY .

  constants C_MAX type I value 10000 ##NO_TEXT.
  data MT_SPLIT type TY_SPLIT_TT .
  constants C_LENGTH type I value 4 ##NO_TEXT.

  methods APPEND_ZEROS
    importing
      !IV_INT type I
      !IV_ZEROS type I
    returning
      value(RV_STR) type STRING .
  methods REMOVE_LEADING_ZEROS .
  class-methods SPLIT
    importing
      !IV_INTEGER type STRING
    returning
      value(RT_SPLIT) type TY_SPLIT_TT .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_BIG_INTEGER IMPLEMENTATION.


  METHOD add.

    DATA: lv_max   TYPE i,
          lv_carry TYPE i,
          lv_op1   TYPE i,
          lv_op2   TYPE i,
          lv_index TYPE i.


    lv_max = nmax( val1 = lines( io_integer->mt_split )
                   val2 = lines( mt_split ) ).

    DO lv_max TIMES.
      lv_index = sy-index.

      CLEAR: lv_op1,
             lv_op2.

      READ TABLE mt_split INDEX lv_index INTO lv_op1.     "#EC CI_SUBRC
      READ TABLE io_integer->mt_split INDEX lv_index INTO lv_op2. "#EC CI_SUBRC

      lv_op1 = lv_op1 + lv_op2 + lv_carry.

      lv_carry = lv_op1 DIV c_max.
      lv_op1 = lv_op1 - lv_carry * c_max.

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

    ro_result = me.

  ENDMETHOD.


  METHOD append_zeros.

    rv_str = iv_int.

    rv_str = condense( rv_str ).

    IF rv_str = '0'.
      RETURN.
    ENDIF.

    DO iv_zeros TIMES.
      CONCATENATE rv_str '0' INTO rv_str.
    ENDDO.

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

    rv_integer = condense( rv_integer ).

  ENDMETHOD.


  METHOD is_zero.

    DATA: lv_str TYPE string.


    lv_str = get( ).

    rv_bool = boolc( lv_str = '0' ).

  ENDMETHOD.


  METHOD mod.

* todo

    ro_result = me.

  ENDMETHOD.


  METHOD multiply.

    DATA: lv_index1 TYPE i,
          lv_index2 TYPE i,
          lv_op1    TYPE i,
          lv_op2    TYPE i,
          lv_str    TYPE string,
          lo_res    TYPE REF TO zcl_abappgp_big_integer,
          lo_tmp    TYPE REF TO zcl_abappgp_big_integer.


    CREATE OBJECT lo_res
      EXPORTING
        iv_integer = '0'.

    LOOP AT mt_split INTO lv_op1.
      lv_index1 = sy-tabix.
      LOOP AT io_integer->mt_split INTO lv_op2.
        lv_index2 = sy-tabix.

        lv_op1 = lv_op1 * lv_op2.

        lv_str = append_zeros(
          iv_int   = lv_op1
          iv_zeros = ( lv_index1 + lv_index2 - 2 ) * c_length ).

        CREATE OBJECT lo_tmp
          EXPORTING
            iv_integer = lv_str.

        lo_res->add( lo_tmp ).
      ENDLOOP.
    ENDLOOP.

    mt_split = lo_res->mt_split.

    ro_result = me.

  ENDMETHOD.


  METHOD power.

* todo

    ro_result = me.

  ENDMETHOD.


  METHOD remove_leading_zeros.

    DATA: lv_value TYPE i,
          lv_lines TYPE i.


    DO.
      lv_lines = lines( mt_split ).

      READ TABLE mt_split INTO lv_value INDEX lv_lines.
      ASSERT sy-subrc = 0.

      IF lv_value = 0 AND lv_lines <> 1.
        DELETE mt_split INDEX lv_lines.
        ASSERT sy-subrc = 0.
      ELSE.
        EXIT.
      ENDIF.

    ENDDO.

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

    DATA: lv_max   TYPE i,
          lv_carry TYPE i,
          lv_op1   TYPE i,
          lv_op2   TYPE i,
          lv_index TYPE i.


    lv_max = nmax( val1 = lines( io_integer->mt_split )
                   val2 = lines( mt_split ) ).

    DO lv_max TIMES.
      lv_index = sy-index.

      CLEAR: lv_op1,
             lv_op2.

      READ TABLE mt_split INDEX lv_index INTO lv_op1.     "#EC CI_SUBRC
      READ TABLE io_integer->mt_split INDEX lv_index INTO lv_op2. "#EC CI_SUBRC

      lv_op1 = lv_op1 - lv_op2 - lv_carry.
      lv_carry = 0.

      IF lv_op1 < 0.
        lv_op1 = lv_op1 + c_max.
        lv_carry = 1.
      ENDIF.

      MODIFY mt_split INDEX lv_index FROM lv_op1.
      ASSERT sy-subrc = 0.
    ENDDO.

    ASSERT lv_carry = 0.

    remove_leading_zeros( ).

    ro_result = me.

  ENDMETHOD.
ENDCLASS.