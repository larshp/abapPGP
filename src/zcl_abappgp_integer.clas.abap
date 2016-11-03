class ZCL_ABAPPGP_INTEGER definition
  public
  create public

  global friends ZCL_ABAPPGP_BINARY_INTEGER .

public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods FROM_HIGH_LENGTH
    importing
      !IV_COUNT type I
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  class-methods FROM_LOW_LENGTH
    importing
      !IV_COUNT type I
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  class-methods FROM_STRING
    importing
      !IV_INTEGER type STRING
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods ADD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods CLONE
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods CONSTRUCTOR
    importing
      !IV_INTEGER type I default 1 .
  methods DIVIDE
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods DIVIDE_BY_10
    importing
      !IV_TIMES type I
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods DIVIDE_BY_2
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods DIVIDE_BY_INT
    importing
      !IV_INTEGER type I
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods DIVIDE_KNUTH
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods GET_STRING_LENGTH
    returning
      value(RV_LENGTH) type I .
  methods IS_EQ
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_EVEN
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_GE
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_GT
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_LE
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_LT
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_NEGATIVE
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_ODD
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_ONE
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_POSITIVE
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_TWO
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods IS_ZERO
    returning
      value(RV_BOOL) type ABAP_BOOL .
  methods MOD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods MODULAR_POW
    importing
      !IO_EXPONENT type ref to ZCL_ABAPPGP_INTEGER
      !IO_MODULUS type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods MODULAR_POW_MONTGOMERY
    importing
      !IO_EXPONENT type ref to ZCL_ABAPPGP_INTEGER
      !IO_MODULUS type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods MOD_2
    returning
      value(RV_RESULT) type I .
  methods MOD_INVERSE
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods MULTIPLY
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods MULTIPLY_10
    importing
      !IV_TIMES type I
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods MULTIPLY_INT
    importing
      !IV_INTEGER type I
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods MULTIPLY_KARATSUBA
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
  methods POWER
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods SUBTRACT
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  methods TO_STRING
    returning
      value(RV_INTEGER) type STRING .
protected section.

  types TY_SPLIT type I .
  types:
    ty_split_tt TYPE STANDARD TABLE OF ty_split WITH DEFAULT KEY .

  data MV_NEGATIVE type ABAP_BOOL .
  class-data GV_MAX type TY_SPLIT .
  data MT_SPLIT type TY_SPLIT_TT .
  class-data GV_LENGTH type I .

  class-methods SPLIT_AT
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
      !IV_AT type I
    exporting
      !EO_LOW type ref to ZCL_ABAPPGP_INTEGER
      !EO_HIGH type ref to ZCL_ABAPPGP_INTEGER .
  methods REMOVE_LEADING_ZEROS .
  methods SPLIT
    importing
      !IV_INTEGER type STRING .
  methods TOGGLE_NEGATIVE
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_INTEGER IMPLEMENTATION.


  METHOD add.

    DATA: lv_max   TYPE i,
          lv_carry TYPE ty_split,
          lv_op1   TYPE ty_split,
          lv_op2   TYPE ty_split,
          lv_index TYPE i,
          lo_tmp   TYPE REF TO zcl_abappgp_integer.


    ro_result = me.

    IF mv_negative = abap_true AND io_integer->mv_negative = abap_false.
      lo_tmp = io_integer->clone( ).
      toggle_negative( ).
      ro_result = lo_tmp->subtract( me ).
      RETURN.
    ELSEIF mv_negative = abap_false AND io_integer->mv_negative = abap_true.
      lo_tmp = io_integer->clone( )->toggle_negative( ).
      ro_result = subtract( lo_tmp ).
      RETURN.
    ENDIF.

    ASSERT mv_negative = io_integer->mv_negative.

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


  METHOD class_constructor.

* TY_SPLIT = i
    gv_max = 10000.
    gv_length = 4.

* TY_SPLIT = p LENGTH 16 DECIMALS 0
*    gv_max = 1000000000000000.
*    gv_length = 15.

  ENDMETHOD.


  METHOD clone.

    CREATE OBJECT ro_integer.
    ro_integer->mt_split = mt_split.
    ro_integer->mv_negative = mv_negative.

  ENDMETHOD.


  METHOD constructor.

    ASSERT iv_integer >= 0.
    ASSERT iv_integer < gv_max.

    APPEND iv_integer TO mt_split.

  ENDMETHOD.


  METHOD divide.

    DATA: lv_m TYPE i,
          lv_n TYPE i,
          lv_iterations TYPE i,
          lo_tmp        TYPE REF TO zcl_abappgp_integer,
          lo_middle     TYPE REF TO zcl_abappgp_integer,
          lo_guess      TYPE REF TO zcl_abappgp_integer,
          lo_low_guess  TYPE REF TO zcl_abappgp_integer,
          lo_high_guess TYPE REF TO zcl_abappgp_integer.


    ASSERT io_integer->mv_negative = abap_false.
    ASSERT io_integer->is_zero( ) = abap_false.

    ro_result = me.

    IF io_integer->is_one( ) = abap_true.
      RETURN.
    ELSEIF io_integer->is_gt( me ) = abap_true.
      split( '0' ).
      RETURN.
    ELSEIF io_integer->is_eq( me ) = abap_true.
      split( '1' ).
      RETURN.
    ENDIF.

    IF lines( io_integer->mt_split ) = 1.
      ro_result = divide_by_int( io_integer->mt_split[ 1 ] ).
      RETURN.
    ENDIF.

* guesstimate result size
    lv_m = get_string_length( ).
    lv_n = io_integer->get_string_length( ).
    IF lv_m = lv_n.
      CREATE OBJECT lo_low_guess
        EXPORTING
          iv_integer = 1.
      lo_high_guess = clone( ).
    ELSE.
      lv_m = lv_m - lv_n.
      lo_low_guess = from_low_length( lv_m ).
      lo_high_guess = from_high_length( lv_m + 1 ).
      IF lo_high_guess->is_ge( me ) = abap_true.
        lo_high_guess = clone( ).
      ENDIF.
    ENDIF.

    DO.
*      WRITE: / .
      lv_iterations = lv_iterations + 1.

      lo_middle = lo_high_guess->clone( )->subtract( lo_low_guess )->divide_by_2( ).
*      WRITE: / 'middle', lo_middle->to_string( ).

      IF lo_middle->is_zero( ) = abap_true.
        lo_tmp = lo_high_guess->clone( )->multiply( io_integer ).
        IF lo_tmp->is_eq( me ) = abap_true.
          mt_split = lo_high_guess->mt_split.
        ELSE.
          mt_split = lo_low_guess->mt_split.
        ENDIF.
        RETURN.
      ENDIF.

      IF lv_iterations >= 9999.
        BREAK-POINT.
      ENDIF.

* try moving high down
      lo_guess = lo_high_guess->clone( )->subtract( lo_middle ).
      lo_tmp = lo_guess->clone( )->multiply( io_integer ).
      IF lo_tmp->is_ge( me ) = abap_true.
*        WRITE: / 'tmp', lo_tmp->to_string( ), 'guess', lo_guess->to_string( ).
*        WRITE: / 'move high to', lo_guess->to_string( ).
        lo_high_guess = lo_guess.
        CONTINUE.
      ENDIF.

* try moving low up
      lo_guess = lo_low_guess->clone( )->add( lo_middle ).
      lo_tmp = lo_guess->clone( )->multiply( io_integer ).
      IF lo_tmp->is_le( me ) = abap_true.
*        WRITE: / 'move low to', lo_guess->to_string( ).
        lo_low_guess = lo_guess.
      ENDIF.

    ENDDO.

  ENDMETHOD.


  METHOD divide_by_10.

    DATA: lv_insert TYPE i,
          lv_int    TYPE i.


    DO iv_times DIV gv_length TIMES.
      DELETE mt_split INDEX 1.
    ENDDO.

    ASSERT lines( mt_split ) > 0.

    CASE iv_times MOD gv_length.
      WHEN 3.
        lv_int = 1000.
      WHEN 2.
        lv_int = 100.
      WHEN 1.
        lv_int = 10.
    ENDCASE.

    IF lv_int > 0.
      divide_by_int( lv_int ).
    ENDIF.

    ro_result = me.

  ENDMETHOD.


  METHOD divide_by_2.

    DATA: lv_index TYPE i,
          lv_value TYPE ty_split,
          lv_carry TYPE ty_split.


    lv_index = lines( mt_split ) + 1.

    DO lines( mt_split ) TIMES.
      lv_index = lv_index - 1.

      READ TABLE mt_split INDEX lv_index INTO lv_value.

      lv_value = lv_value + lv_carry * gv_max.
      lv_carry = lv_value MOD 2.
      lv_value = lv_value DIV 2.

      MODIFY mt_split INDEX lv_index FROM lv_value.
    ENDDO.

* remove leading zero, note: there can only be one when dividing with 2
    READ TABLE mt_split INTO lv_value INDEX lines( mt_split ).
    IF lv_value = 0 AND lines( mt_split ) > 1.
      DELETE mt_split INDEX lines( mt_split ).
    ENDIF.

    ro_result = me.

  ENDMETHOD.


  METHOD divide_by_int.

    DATA: lv_index TYPE i,
          lv_value TYPE ty_split,
          lv_carry TYPE ty_split.


    ASSERT iv_integer > 0.
    ASSERT iv_integer < gv_max.

    ro_result = me.

    IF iv_integer = 1.
      RETURN.
    ENDIF.

    lv_index = lines( mt_split ) + 1.

    DO lines( mt_split ) TIMES.
      lv_index = lv_index - 1.

      READ TABLE mt_split INDEX lv_index INTO lv_value.

      lv_value = lv_value + lv_carry * gv_max.
      lv_carry = lv_value MOD iv_integer.
      lv_value = lv_value DIV iv_integer.

      MODIFY mt_split INDEX lv_index FROM lv_value.
    ENDDO.

    remove_leading_zeros( ).

    ro_result = me.

  ENDMETHOD.


  METHOD divide_knuth.

    DATA: lv_v1    TYPE ty_split,
          lv_j     TYPE i,
          lv_b     TYPE i,
          lv_shift TYPE i,
          lv_u_j   TYPE ty_split,
          lv_v_1   TYPE ty_split,
          lv_v_2   TYPE ty_split,
          lv_q_hat TYPE ty_split,
          lv_u_j_1 TYPE ty_split,
          lv_u_j_2 TYPE ty_split,
          lo_tmp   TYPE REF TO zcl_abappgp_integer,
          lo_v     TYPE REF TO zcl_abappgp_integer,
          lo_u     TYPE REF TO zcl_abappgp_integer,
          lo_d     TYPE REF TO zcl_abappgp_integer,
          lo_q     TYPE REF TO zcl_abappgp_integer.


    ASSERT is_negative( ) = abap_false.
    ASSERT io_integer->is_negative( ) = abap_false.
    ASSERT io_integer->is_zero( ) = abap_false.

    ro_result = me.

    IF io_integer->is_one( ) = abap_true.
      RETURN.
    ELSEIF io_integer->is_gt( me ) = abap_true.
      split( '0' ).
      RETURN.
    ELSEIF io_integer->is_eq( me ) = abap_true.
      split( '1' ).
      RETURN.
    ENDIF.

    IF lines( io_integer->mt_split ) = 1.
      ro_result = divide_by_int( io_integer->mt_split[ 1 ] ).
      RETURN.
    ENDIF.

    CREATE OBJECT lo_q
      EXPORTING
        iv_integer = 0.

    lv_b = gv_max.

*    WRITE: / 'Original':.
*    WRITE: / to_string( ), 'DIV', io_integer->to_string( ).

    lv_shift = lines( mt_split ) - lines( io_integer->mt_split ) - 1.

* D1 - Normalize
    READ TABLE io_integer->mt_split INDEX lines( io_integer->mt_split ) INTO lv_v1.
    CREATE OBJECT lo_d
      EXPORTING
        iv_integer = lv_b DIV ( lv_v1 + 1 ).
*    WRITE: / 'd:', lo_d->to_string( ).

    IF lo_d->is_one( ) = abap_false.
      lv_shift = lv_shift + 1.
    ENDIF.

    lo_u = multiply( lo_d ).
    lo_v = io_integer->clone( )->multiply( lo_d ).
*    WRITE: / 'After normalization:'.
*    WRITE: / to_string( ), 'DIV', lo_v->to_string( ).

* D2 - Initialize j
    lv_j = lines( lo_u->mt_split ).

    WHILE lv_j > 2.

* D3 - Calculate q_hat
      READ TABLE lo_u->mt_split INDEX lv_j INTO lv_u_j.
      ASSERT sy-subrc = 0.
      READ TABLE lo_u->mt_split INDEX lv_j - 1 INTO lv_u_j_1.
      ASSERT sy-subrc = 0.
      READ TABLE lo_u->mt_split INDEX lv_j - 2 INTO lv_u_j_2.
      ASSERT sy-subrc = 0.
      READ TABLE lo_v->mt_split INDEX lines( lo_v->mt_split ) INTO lv_v_1.
      ASSERT sy-subrc = 0.
      READ TABLE lo_v->mt_split INDEX lines( lo_v->mt_split ) - 1 INTO lv_v_2.
      ASSERT sy-subrc = 0.

*      WRITE: / 'lv_u_j', lv_u_j.
*      WRITE: / 'lv_u_j_1', lv_u_j_1.
*      WRITE: / 'lv_v_1', lv_v_1.

      IF lv_u_j = lv_v_1.
        lv_q_hat = lv_b - 1.
      ELSE.
        lv_q_hat = ( lv_u_j * lv_b + lv_u_j_1 ) DIV lv_v_1.

        WHILE lv_v_2 * lv_q_hat > ( lv_u_j * lv_b + lv_u_j_1 - lv_q_hat * lv_v_1 ) * lv_b + lv_u_j_2.
*          WRITE: / 'adjust q_hat - 1'.
          lv_q_hat = lv_q_hat - 1.
        ENDWHILE.

      ENDIF.
*      WRITE: / 'q_hat:', lv_q_hat.

* D4 - Multiply and subtract
      lo_u = lo_u->subtract( lo_v->clone( )->multiply_int( lv_q_hat )->multiply_10( lv_shift * 4 ) ).
      IF lo_u->is_negative( ) = abap_true.
*        WRITE: / 'negative! todo'.
        BREAK-POINT.
      ENDIF.
*      WRITE: / 'D4, u:', lo_u->to_string( ).
*      WRITE: /.

* D5 - Test remainder
      CREATE OBJECT lo_tmp
        EXPORTING
          iv_integer = lv_q_hat.
      lo_q = lo_q->add( lo_tmp->multiply_10( lv_shift * 4 ) ).

      lv_shift = lv_shift - 1.

* D6 - Add back
* todo

* D7 - Loop on j
      lv_j = lv_j - 1.
    ENDWHILE.

* D8 - Unnormalize
* todo, also return remainder?

    mt_split = lo_q->mt_split.
    ro_result = me.

  ENDMETHOD.


  METHOD FROM_HIGH_LENGTH.

    DATA: lv_str TYPE string.


    ASSERT iv_count >= 1.

    DO iv_count TIMES.
      CONCATENATE '9' lv_str INTO lv_str.
    ENDDO.

    ro_integer = from_string( lv_str ).

  ENDMETHOD.


  METHOD from_low_length.

    DATA: lv_str TYPE string.


    ASSERT iv_count >= 1.

    lv_str = '1'.

    DO iv_count - 1 TIMES.
      CONCATENATE lv_str '0' INTO lv_str.
    ENDDO.

    ro_integer = from_string( lv_str ).

  ENDMETHOD.


  METHOD from_string.

    ASSERT iv_integer CO '-1234567890'.
    IF strlen( iv_integer ) > 1.
      ASSERT NOT iv_integer(1) = '0'.
    ENDIF.

    CREATE OBJECT ro_integer.
    ro_integer->split( iv_integer ).

  ENDMETHOD.


  METHOD get_string_length.

* todo, this can be optimized
    rv_length = strlen( to_string( ) ).

  ENDMETHOD.


  METHOD is_eq.

    DATA: lv_index TYPE i.

    FIELD-SYMBOLS: <lv_op1> LIKE LINE OF mt_split,
                   <lv_op2> LIKE LINE OF mt_split.


    IF lines( mt_split ) <> lines( io_integer->mt_split )
        OR mv_negative <> io_integer->mv_negative.
      rv_bool = abap_false.
      RETURN.
    ENDIF.

    DO lines( mt_split ) TIMES.
      lv_index = sy-index.

      READ TABLE mt_split INDEX lv_index ASSIGNING <lv_op1>.
      ASSERT sy-subrc = 0.
      READ TABLE io_integer->mt_split INDEX lv_index ASSIGNING <lv_op2>.
      ASSERT sy-subrc = 0.

      IF <lv_op1> <> <lv_op2>.
        rv_bool = abap_false.
        RETURN.
      ENDIF.
    ENDDO.

    rv_bool = abap_true.

  ENDMETHOD.


  METHOD is_even.

    DATA: lv_char   TYPE c LENGTH 1,
          lv_length TYPE i,
          lv_str    TYPE string.


    lv_str = to_string( ).
    lv_length = strlen( lv_str ) - 1.
    lv_char = lv_str+lv_length(1).

    rv_bool = boolc( lv_char CO '02468' ).

  ENDMETHOD.


  METHOD is_ge.

    rv_bool = boolc( is_gt( io_integer ) = abap_true OR is_eq( io_integer ) = abap_true ).

  ENDMETHOD.


  METHOD is_gt.

    DATA: lv_index TYPE i,
          lv_lines TYPE i,
          lv_op1   TYPE ty_split,
          lv_op2   TYPE ty_split.


    lv_lines = lines( mt_split ).

    IF lv_lines > lines( io_integer->mt_split )
        OR mv_negative = abap_false
        AND io_integer->mv_negative = abap_true.
      rv_bool = abap_true.
      RETURN.
    ELSEIF lv_lines < lines( io_integer->mt_split )
        OR mv_negative = abap_true
        AND io_integer->mv_negative = abap_false.
      rv_bool = abap_false.
      RETURN.
    ENDIF.

    rv_bool = abap_false.

    DO lv_lines TIMES.
      lv_index = lv_lines - sy-index + 1.

      READ TABLE mt_split INDEX lv_index INTO lv_op1.
*      ASSERT sy-subrc = 0.
      READ TABLE io_integer->mt_split INDEX lv_index INTO lv_op2.
*      ASSERT sy-subrc = 0.

      IF lv_op1 > lv_op2.
        rv_bool = abap_true.
        EXIT.
      ELSEIF lv_op1 < lv_op2.
        rv_bool = abap_false.
        EXIT.
      ENDIF.
    ENDDO.

    IF mv_negative = abap_true AND io_integer->mv_negative = abap_true.
* inverse result if both numbers are negative
      IF rv_bool = abap_true.
        rv_bool = abap_false.
      ELSE.
        rv_bool = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD is_le.

    rv_bool = boolc( is_lt( io_integer ) = abap_true OR is_eq( io_integer ) = abap_true ).

  ENDMETHOD.


  METHOD is_lt.

    rv_bool = boolc( is_ge( io_integer ) = abap_false ).

  ENDMETHOD.


  METHOD is_negative.

    rv_bool = boolc( mv_negative = abap_true ).

  ENDMETHOD.


  METHOD is_odd.

    rv_bool = boolc( is_even( ) = abap_false ).

  ENDMETHOD.


  METHOD is_one.

    FIELD-SYMBOLS: <lv_value> LIKE LINE OF mt_split.


    IF lines( mt_split ) <> 1 OR mv_negative = abap_true.
      RETURN.
    ENDIF.

    READ TABLE mt_split INDEX 1 ASSIGNING <lv_value>.

    rv_bool = boolc( <lv_value> = 1 ).

  ENDMETHOD.


  METHOD is_positive.

* including zero

    rv_bool = boolc( mv_negative = abap_false ).

  ENDMETHOD.


  METHOD is_two.

    FIELD-SYMBOLS: <lv_value> LIKE LINE OF mt_split.


    IF lines( mt_split ) <> 1 OR mv_negative = abap_true.
      RETURN.
    ENDIF.

    READ TABLE mt_split INDEX 1 ASSIGNING <lv_value>.

    rv_bool = boolc( <lv_value> = 2 ).

  ENDMETHOD.


  METHOD is_zero.

    DATA: lv_value TYPE ty_split.


    IF lines( mt_split ) <> 1.
      RETURN.
    ENDIF.

    READ TABLE mt_split INDEX 1 INTO lv_value.

    rv_bool = boolc( lv_value = 0 ).

  ENDMETHOD.


  METHOD mod.

    DATA: lo_div  TYPE REF TO zcl_abappgp_integer,
          lo_mult TYPE REF TO zcl_abappgp_integer.


    ASSERT NOT io_integer->mv_negative = abap_true.

    lo_div = clone( )->divide( io_integer ).

    lo_mult = lo_div->clone( )->multiply( io_integer ).

    ro_result = subtract( lo_mult ).

  ENDMETHOD.


  METHOD modular_pow.

* Modular exponentiation
* https://en.wikipedia.org/wiki/Modular_exponentiation

    DATA: lo_base     TYPE REF TO zcl_abappgp_integer,
          lo_exponent TYPE REF TO zcl_abappgp_binary_integer.


    ASSERT NOT io_modulus->mv_negative = abap_true.

    IF io_modulus->is_one( ) = abap_true.
      split( '0' ).
      RETURN.
    ENDIF.

    lo_base = clone( ).

    split( '1' ).

    IF io_exponent->is_zero( ) = abap_true.
      RETURN.
    ENDIF.

    CREATE OBJECT lo_exponent
      EXPORTING
        io_integer = io_exponent.

    lo_base->mod( io_modulus ).

    WHILE lo_exponent->is_zero( ) = abap_false.
      IF lo_exponent->mod_2( ) = 1.
        multiply( lo_base )->mod( io_modulus ).
      ENDIF.
      lo_exponent->shift_right( ).

      lo_base->multiply( lo_base )->mod( io_modulus ).
    ENDWHILE.

    ro_result = me.

  ENDMETHOD.


  METHOD modular_pow_montgomery.

* Modular exponentiation
* https://en.wikipedia.org/wiki/Modular_exponentiation

    DATA: lo_base     TYPE REF TO zcl_abappgp_integer,
          lo_tmp      TYPE REF TO zcl_abappgp_integer,
          lo_one      TYPE REF TO zcl_abappgp_integer,
          lo_exponent TYPE REF TO zcl_abappgp_binary_integer,
          lo_mont     TYPE REF TO zcl_abappgp_montgomery,
          lo_me       TYPE REF TO zcl_abappgp_montgomery_integer,
          lo_basem    TYPE REF TO zcl_abappgp_montgomery_integer.


    ASSERT NOT io_modulus->mv_negative = abap_true.

    IF io_modulus->is_one( ) = abap_true.
      split( '0' ).
      ro_result = me.
      RETURN.
    ENDIF.

    CREATE OBJECT lo_tmp.

    lo_base = clone( ).

    CREATE OBJECT lo_one.

    IF io_exponent->is_zero( ) = abap_true.
      RETURN.
    ENDIF.

    CREATE OBJECT lo_exponent
      EXPORTING
        io_integer = io_exponent.

    lo_base = lo_base->mod( io_modulus ).

    CREATE OBJECT lo_mont
      EXPORTING
        io_modulus = io_modulus.
    lo_me = lo_mont->build( lo_one ).
    lo_basem = lo_mont->build( lo_base ).

    WHILE lo_exponent->is_zero( ) = abap_false.
      IF lo_exponent->mod_2( ) = 1.
        lo_me = lo_mont->multiply( io_x = lo_me
                                   io_y = lo_basem ).
      ENDIF.
      lo_exponent->shift_right( ).

      lo_basem = lo_mont->multiply( io_x = lo_basem
                                    io_y = lo_basem ).
    ENDWHILE.

    ro_result = lo_mont->unbuild( lo_me ).

  ENDMETHOD.


  METHOD mod_2.

    DATA: lv_value TYPE ty_split.

* only the first digit is relevant for calculating MOD2
    READ TABLE mt_split INDEX 1 INTO lv_value.

    rv_result = lv_value MOD 2.

  ENDMETHOD.


  METHOD mod_inverse.

* https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
* https://rosettacode.org/wiki/Modular_inverse

    DATA: lo_a   TYPE REF TO zcl_abappgp_integer,
          lo_b   TYPE REF TO zcl_abappgp_integer,
          lo_t   TYPE REF TO zcl_abappgp_integer,
          lo_nt  TYPE REF TO zcl_abappgp_integer,
          lo_r   TYPE REF TO zcl_abappgp_integer,
          lo_nr  TYPE REF TO zcl_abappgp_integer,
          lo_q   TYPE REF TO zcl_abappgp_integer,
          lo_tmp TYPE REF TO zcl_abappgp_integer,
          lo_foo TYPE REF TO zcl_abappgp_integer,
          lo_one TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_one.

    lo_a = clone( ).
    lo_b = io_integer->clone( ).

    CREATE OBJECT lo_t
      EXPORTING
        iv_integer = 0.

    CREATE OBJECT lo_nt.

    lo_r = lo_b->clone( ).
    lo_nr = lo_a->clone( )->mod( lo_b ).

    CREATE OBJECT lo_q.
    CREATE OBJECT lo_tmp.
    CREATE OBJECT lo_foo.

    IF lo_b->is_negative( ) = abap_true.
      lo_b->toggle_negative( ).
    ENDIF.

    IF lo_a->is_negative( ) = abap_true.
      lo_tmp = lo_a->clone( )->toggle_negative( )->mod( lo_b ).
      lo_a = lo_b->clone( )->subtract( lo_tmp ).
    ENDIF.

    WHILE lo_nr->is_zero( ) = abap_false.
      lo_q = lo_r->clone( )->divide( lo_nr ).
      lo_tmp = lo_nt->clone( ).
      lo_foo = lo_q->clone( )->multiply( lo_nt ).
      lo_nt = lo_t->clone( )->subtract( lo_foo ).
      lo_t = lo_tmp->clone( ).
      lo_tmp = lo_nr->clone( ).
      lo_foo = lo_q->clone( )->multiply( lo_nr ).
      lo_nr = lo_r->clone( )->subtract( lo_foo ).
      lo_r = lo_tmp->clone( ).
    ENDWHILE.

    IF lo_r->is_gt( lo_one ) = abap_true.
* No inverse
      BREAK-POINT.
    ENDIF.

    IF lo_t->is_negative( ) = abap_true.
      lo_t = lo_t->add( lo_b ).
    ENDIF.

    ro_result = lo_t.

  ENDMETHOD.


  METHOD multiply.

    DATA: lv_index  TYPE i,
          lv_index1 TYPE i,
          lv_op     TYPE ty_split,
          lv_add    TYPE ty_split,
          lv_carry  TYPE ty_split,
          lt_result LIKE mt_split.

    FIELD-SYMBOLS: <lv_result> TYPE ty_split,
                   <lv_op1>    TYPE ty_split,
                   <lv_op2>    TYPE ty_split.


    ro_result = me.

    IF is_zero( ) = abap_true OR io_integer->is_zero( ) = abap_true.
      CLEAR mt_split.
      APPEND 0 TO mt_split.
      RETURN.
    ENDIF.

    LOOP AT mt_split ASSIGNING <lv_op1>.
      lv_index1 = sy-tabix.
      LOOP AT io_integer->mt_split ASSIGNING <lv_op2>.
        lv_index = lv_index1 + sy-tabix - 1.

        READ TABLE lt_result INDEX lv_index ASSIGNING <lv_result>.
        IF sy-subrc <> 0.
          APPEND INITIAL LINE TO lt_result ASSIGNING <lv_result>.
        ENDIF.

        lv_op = <lv_op1> * <lv_op2>.
        lv_add = lv_op MOD gv_max.
        <lv_result> = <lv_result> + lv_add.

        lv_carry = <lv_result> DIV gv_max + lv_op DIV gv_max.
        <lv_result> = <lv_result> MOD gv_max.

        WHILE lv_carry <> 0.
          lv_index = lv_index + 1.
          READ TABLE lt_result INDEX lv_index ASSIGNING <lv_result>.
          IF sy-subrc <> 0.
            APPEND INITIAL LINE TO lt_result ASSIGNING <lv_result>.
          ENDIF.
* carry might trigger the next carry
          <lv_result> = <lv_result> + lv_carry.
          lv_carry    = <lv_result> DIV gv_max.
          <lv_result> = <lv_result> MOD gv_max.
        ENDWHILE.

      ENDLOOP.
    ENDLOOP.

    IF mv_negative = io_integer->mv_negative.
      mv_negative = abap_false.
    ELSE.
      mv_negative = abap_true.
    ENDIF.

    mt_split = lt_result.

  ENDMETHOD.


  METHOD multiply_10.

    DATA: lv_insert TYPE i,
          lv_int    TYPE i.


    CASE iv_times MOD gv_length.
      WHEN 3.
        lv_int = 1000.
      WHEN 2.
        lv_int = 100.
      WHEN 1.
        lv_int = 10.
    ENDCASE.

    IF lv_int > 0.
      multiply_int( lv_int ).
    ENDIF.

    DO iv_times DIV gv_length TIMES.
      INSERT 0 INTO mt_split INDEX 1.
    ENDDO.

    ro_result = me.

  ENDMETHOD.


  METHOD multiply_int.

    DATA: lo_integer TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_integer
      EXPORTING
        iv_integer = iv_integer.

    ro_result = multiply( lo_integer ).

  ENDMETHOD.


  METHOD multiply_karatsuba.

* https://en.wikipedia.org/wiki/Karatsuba_algorithm

    DATA: lv_m     TYPE i,
          lo_low1  TYPE REF TO zcl_abappgp_integer,
          lo_low2  TYPE REF TO zcl_abappgp_integer,
          lo_high1 TYPE REF TO zcl_abappgp_integer,
          lo_high2 TYPE REF TO zcl_abappgp_integer,
          lo_z0    TYPE REF TO zcl_abappgp_integer,
          lo_z1    TYPE REF TO zcl_abappgp_integer,
          lo_z2    TYPE REF TO zcl_abappgp_integer.


    ASSERT io_integer->is_positive( ) = abap_true.
    ASSERT is_positive( ) = abap_true.

    IF lines( mt_split ) < 2 OR lines( io_integer->mt_split ) < 2.
      ro_integer = multiply( io_integer ).
      RETURN.
    ENDIF.

    lv_m = nmax( val1 = lines( mt_split )
                 val2 = lines( io_integer->mt_split ) ).

    lv_m = lv_m DIV 2.

    split_at( EXPORTING io_integer = me
                        iv_at      = lv_m
              IMPORTING eo_low     = lo_low1
                        eo_high    = lo_high1 ).

    split_at( EXPORTING io_integer = io_integer
                        iv_at      = lv_m
              IMPORTING eo_low     = lo_low2
                        eo_high    = lo_high2 ).

* z0 = karatsuba(low1,low2)
    lo_z0 = lo_low1->clone( )->multiply_karatsuba( lo_low2 ).
* z1 = karatsuba((low1+high1),(low2+high2))
    lo_z1 = lo_low1->add( lo_high1 )->multiply_karatsuba( lo_low2->clone( )->add( lo_high2 ) ).
* z2 = karatsuba(high1,high2)
    lo_z2 = lo_high1->multiply_karatsuba( lo_high2 ).

* return (z2*10^(2*m2))+((z1-z2-z0)*10^(m2))+(z0)
    mt_split = lo_z2->mt_split.
    multiply_10( 2 * lv_m * 4 ).
    add( lo_z1->subtract( lo_z2 )->subtract( lo_z0 )->multiply_10( lv_m * 4 ) ).
    add( lo_z0 ).

    ro_integer = me.

  ENDMETHOD.


  METHOD power.

    DATA: lo_count    TYPE REF TO zcl_abappgp_integer,
          lo_one      TYPE REF TO zcl_abappgp_integer,
          lo_original TYPE REF TO zcl_abappgp_integer.


    ASSERT NOT io_integer->mv_negative = abap_true.

    IF io_integer->is_zero( ) = abap_true.
      split( '1' ).
      RETURN.
    ENDIF.

    CREATE OBJECT lo_one.

    lo_original = clone( ).
    lo_count = io_integer->clone( ).
    lo_count->subtract( lo_one ).

    WHILE lo_count->is_zero( ) = abap_false.
      multiply( lo_original ).

      lo_count->subtract( lo_one ).
    ENDWHILE.

    ro_result = me.

  ENDMETHOD.


  METHOD remove_leading_zeros.

    DATA: lv_lines TYPE i,
          lv_value TYPE ty_split.


    lv_lines = lines( mt_split ) + 1.

    DO.
      lv_lines = lv_lines - 1.

      READ TABLE mt_split INTO lv_value INDEX lv_lines.

      IF lv_value = 0 AND lv_lines <> 1.
        DELETE mt_split INDEX lv_lines.
        ASSERT sy-subrc = 0.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD split.

    DATA: lv_integer LIKE iv_integer,
          lv_length  TYPE i,
          lv_offset  TYPE i.


    ASSERT strlen( iv_integer ) > 0.

    CLEAR mt_split.
    CLEAR mv_negative.

    lv_integer = iv_integer.

    IF lv_integer(1) = '-'.
      mv_negative = abap_true.
      lv_integer = lv_integer+1.
    ENDIF.

    lv_offset = strlen( lv_integer ) - gv_length.

    DO.
      IF lv_offset < 0.
        lv_offset = 0.
      ENDIF.

      lv_length = gv_length.
      IF lv_length > strlen( lv_integer ).
        lv_length = strlen( lv_integer ).
      ELSEIF lv_offset = 0.
        lv_length = strlen( lv_integer ) - lines( mt_split ) * gv_length.
      ENDIF.

      APPEND lv_integer+lv_offset(lv_length) TO mt_split.

      IF lv_offset = 0.
        EXIT. " current loop
      ENDIF.

      lv_offset = lv_offset - gv_length.
    ENDDO.

  ENDMETHOD.


  METHOD split_at.

    DATA: lv_split TYPE ty_split.


    CREATE OBJECT eo_low.
    CLEAR eo_low->mt_split.

    CREATE OBJECT eo_high.
    CLEAR eo_high->mt_split.

    LOOP AT io_integer->mt_split INTO lv_split.
      IF sy-tabix <= iv_at.
        APPEND lv_split TO eo_low->mt_split.
      ELSE.
        APPEND lv_split TO eo_high->mt_split.
      ENDIF.
    ENDLOOP.

    ASSERT lines( eo_low->mt_split ) > 0.

    IF lines( eo_high->mt_split ) = 0.
      APPEND 0 TO eo_high->mt_split.
    ENDIF.

  ENDMETHOD.


  METHOD subtract.

    DATA: lv_max   TYPE i,
          lv_carry TYPE ty_split,
          lv_op1   TYPE ty_split,
          lv_op2   TYPE ty_split,
          lv_index TYPE i,
          lo_tmp   TYPE REF TO zcl_abappgp_integer.


    ro_result = me.

    IF mv_negative <> io_integer->mv_negative.
      toggle_negative( ).
      add( io_integer ).
      toggle_negative( ).
      RETURN.
    ELSEIF ( is_lt( io_integer ) = abap_true AND mv_negative = abap_false )
        OR ( is_gt( io_integer ) = abap_true AND mv_negative = abap_true ).
      lo_tmp = io_integer->clone( )->subtract( me ).
      ro_result = lo_tmp->toggle_negative( ).
      RETURN.
    ENDIF.

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
        lv_op1 = lv_op1 + gv_max.
        lv_carry = 1.
      ENDIF.

      MODIFY mt_split INDEX lv_index FROM lv_op1.
      ASSERT sy-subrc = 0.
    ENDDO.

    ASSERT lv_carry = 0.

    remove_leading_zeros( ).

  ENDMETHOD.


  METHOD toggle_negative.

    IF mv_negative = abap_true.
      mv_negative = abap_false.
    ELSE.
      mv_negative = abap_true.
    ENDIF.

    ro_result = me.

  ENDMETHOD.


  METHOD to_string.

    DATA: lv_int TYPE string.

    LOOP AT mt_split INTO lv_int.
      CONDENSE lv_int.
      IF sy-tabix <> lines( mt_split ).
        WHILE strlen( lv_int ) <> gv_length.
          CONCATENATE '0' lv_int INTO lv_int.
        ENDWHILE.
      ENDIF.
      CONCATENATE lv_int rv_integer INTO rv_integer.
    ENDLOOP.

    rv_integer = condense( rv_integer ).

    IF mv_negative = abap_true.
      CONCATENATE '-' rv_integer INTO rv_integer.
    ENDIF.

  ENDMETHOD.
ENDCLASS.