CLASS zcl_abappgp_integer DEFINITION
  PUBLIC
  CREATE PUBLIC

  GLOBAL FRIENDS zcl_abappgp_binary_integer .

  PUBLIC SECTION.

    METHODS add
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS and
      IMPORTING
        !io_binary       TYPE REF TO zcl_abappgp_binary_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS constructor
      IMPORTING
        !iv_integer TYPE string DEFAULT '1' .
    METHODS copy
      IMPORTING
        !io_integer       TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS divide
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS divide_by_2
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS is_eq
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_even
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_ge
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_gt
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_le
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_lt
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_negative
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_odd
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_one
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_positive
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_two
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_zero
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS mod
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS modular_pow
      IMPORTING
        !io_exponent     TYPE REF TO zcl_abappgp_integer
        !io_modulus      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS modular_pow_montgomery
      IMPORTING
        !io_exponent     TYPE REF TO zcl_abappgp_integer
        !io_modulus      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS mod_2
      RETURNING
        VALUE(rv_result) TYPE i .
    METHODS mod_inverse
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS multiply
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS power
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS shift_right
      IMPORTING
        !iv_times        TYPE i
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS subtract
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
    METHODS to_string
      RETURNING
        VALUE(rv_integer) TYPE string .
protected section.

  types TY_SPLIT type INT4 .
  types:
    ty_split_tt TYPE STANDARD TABLE OF ty_split WITH DEFAULT KEY .

  data MV_NEGATIVE type ABAP_BOOL .
  constants C_MAX type TY_SPLIT value 10000 ##NO_TEXT.
  data MT_SPLIT type TY_SPLIT_TT .
  constants C_LENGTH type I value 4 ##NO_TEXT.

  methods APPEND_ZEROS
    importing
      !IV_INT type I
      !IV_ZEROS type I
    returning
      value(RV_STR) type STRING .
  methods REMOVE_LEADING_ZEROS .
  methods SPLIT
    importing
      !IV_INTEGER type STRING .
  methods TOGGLE_NEGATIVE
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_INTEGER .
  PRIVATE SECTION.
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
      CREATE OBJECT lo_tmp.
      lo_tmp->copy( io_integer ).
      toggle_negative( ).
      copy( lo_tmp->subtract( me ) ).
      RETURN.
    ELSEIF mv_negative = abap_false AND io_integer->mv_negative = abap_true.
      CREATE OBJECT lo_tmp.
      lo_tmp->copy( io_integer )->toggle_negative( ).
      subtract( lo_tmp ).
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

  ENDMETHOD.


  METHOD and.

    DATA: lo_binary TYPE REF TO zcl_abappgp_binary_integer.


    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = me.

    lo_binary->and( io_binary ).

    copy( lo_binary->to_integer( ) ).

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

    ASSERT iv_integer CO '-1234567890'.

    IF iv_integer = '1'.
      APPEND 1 TO mt_split.
    ELSE.
      split( iv_integer ).
    ENDIF.

  ENDMETHOD.


  METHOD copy.

    mt_split = io_integer->mt_split.
    mv_negative = io_integer->mv_negative.

    ro_integer = me.

  ENDMETHOD.


  METHOD divide.

    DATA: lv_iterations TYPE i,
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

    CREATE OBJECT lo_tmp
      EXPORTING
        iv_integer = '0'.

    CREATE OBJECT lo_guess
      EXPORTING
        iv_integer = '0'.

    CREATE OBJECT lo_middle.
    CREATE OBJECT lo_low_guess.
    CREATE OBJECT lo_high_guess.
    lo_high_guess->copy( me ).

    DO.
      lv_iterations = lv_iterations + 1.

      lo_middle->copy( lo_high_guess )->subtract( lo_low_guess )->divide_by_2( ).
*      WRITE: / 'middle', lo_middle->get( ).

      IF lo_middle->is_zero( ) = abap_true.
        lo_tmp->copy( lo_high_guess )->multiply( io_integer ).
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
      lo_guess->copy( lo_high_guess )->subtract( lo_middle ).
      lo_tmp->copy( lo_guess )->multiply( io_integer ).
      IF lo_tmp->is_ge( me ) = abap_true.
*        WRITE: / 'move high to', lo_guess->get( ).
        lo_high_guess->copy( lo_guess ).
        CONTINUE.
      ENDIF.

* try moving low up
      lo_guess->copy( lo_low_guess )->add( lo_middle ).
      lo_tmp->copy( lo_guess )->multiply( io_integer ).
      IF lo_tmp->is_le( me ) = abap_true.
*        WRITE: / 'move low to', lo_guess->get( ).
        lo_low_guess->copy( lo_guess ).
      ENDIF.

    ENDDO.

  ENDMETHOD.


  METHOD divide_by_2.

    DATA: lv_index TYPE i,
          lv_value TYPE ty_split,
          lv_carry TYPE ty_split.

    FIELD-SYMBOLS: <lv_value> LIKE LINE OF mt_split.


    lv_index = lines( mt_split ) + 1.

    DO lines( mt_split ) TIMES.
      lv_index = lv_index - 1.

      READ TABLE mt_split INDEX lv_index INTO lv_value.

      lv_value = lv_value + lv_carry * c_max.
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

      READ TABLE mt_split INDEX 1 ASSIGNING <lv_op1>.
      ASSERT sy-subrc = 0.
      READ TABLE io_integer->mt_split INDEX 1 ASSIGNING <lv_op2>.
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
          lv_op1   TYPE ty_split,
          lv_op2   TYPE ty_split.


    IF lines( mt_split ) > lines( io_integer->mt_split )
        OR mv_negative = abap_false AND io_integer->mv_negative = abap_true.
      rv_bool = abap_true.
      RETURN.
    ELSEIF lines( mt_split ) < lines( io_integer->mt_split )
        OR mv_negative = abap_true AND io_integer->mv_negative = abap_false.
      rv_bool = abap_false.
      RETURN.
    ENDIF.

    rv_bool = abap_false.

    DO lines( mt_split ) TIMES.
      lv_index = lines( mt_split ) - sy-index + 1.

      READ TABLE mt_split INDEX lv_index INTO lv_op1.
      ASSERT sy-subrc = 0.
      READ TABLE io_integer->mt_split INDEX lv_index INTO lv_op2.
      ASSERT sy-subrc = 0.

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
    ASSERT sy-subrc = 0.

    rv_bool = boolc( lv_value = 0 ).

  ENDMETHOD.


  METHOD mod.

    DATA: lo_div  TYPE REF TO zcl_abappgp_integer,
          lo_mult TYPE REF TO zcl_abappgp_integer.


    ASSERT NOT io_integer->mv_negative = abap_true.

    CREATE OBJECT lo_div.
    CREATE OBJECT lo_mult.

    lo_div->copy( me )->divide( io_integer ).

    lo_mult->copy( lo_div )->multiply( io_integer ).

    subtract( lo_mult ).

    ro_result = me.

  ENDMETHOD.


  METHOD modular_pow.

* Modular exponentiation
* https://en.wikipedia.org/wiki/Modular_exponentiation

    DATA: lo_count    TYPE REF TO zcl_abappgp_integer,
          lo_one      TYPE REF TO zcl_abappgp_integer,
          lo_base     TYPE REF TO zcl_abappgp_integer,
          lo_tmp      TYPE REF TO zcl_abappgp_integer,
          lo_exponent TYPE REF TO zcl_abappgp_binary_integer.


    ASSERT NOT io_modulus->mv_negative = abap_true.

    IF io_modulus->is_one( ) = abap_true.
      split( '0' ).
      RETURN.
    ENDIF.

    CREATE OBJECT lo_tmp.
    CREATE OBJECT lo_base.
    lo_base->copy( me ).

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

      lo_tmp->copy( lo_base ).
      lo_base->multiply( lo_tmp )->mod( io_modulus ).
    ENDWHILE.

    ro_result = me.

  ENDMETHOD.


  METHOD modular_pow_montgomery.

* Modular exponentiation
* https://en.wikipedia.org/wiki/Modular_exponentiation

*    DATA: lv_mult TYPE i.

    DATA: lo_count    TYPE REF TO zcl_abappgp_integer,
          lo_one      TYPE REF TO zcl_abappgp_integer,
          lo_base     TYPE REF TO zcl_abappgp_integer,
          lo_tmp      TYPE REF TO zcl_abappgp_integer,
          lo_exponent TYPE REF TO zcl_abappgp_binary_integer,
          lo_mont     TYPE REF TO zcl_abappgp_montgomery,
          lo_me       TYPE REF TO zcl_abappgp_montgomery_integer,
          lo_basem    TYPE REF TO zcl_abappgp_montgomery_integer.


    ASSERT NOT io_modulus->mv_negative = abap_true.

    IF io_modulus->is_one( ) = abap_true.
      split( '0' ).
      RETURN.
    ENDIF.

    CREATE OBJECT lo_tmp.
    CREATE OBJECT lo_base.
    lo_base->copy( me ).

    split( '1' ).

    IF io_exponent->is_zero( ) = abap_true.
      RETURN.
    ENDIF.

    CREATE OBJECT lo_exponent
      EXPORTING
        io_integer = io_exponent.

    lo_base->mod( io_modulus ).

    CREATE OBJECT lo_mont
      EXPORTING
        io_modulus = io_modulus.
    lo_me = lo_mont->build( me ).
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

    copy( lo_mont->unbuild( lo_me ) ).

    ro_result = me.

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

    CREATE OBJECT lo_a.
    lo_a->copy( me ).

    CREATE OBJECT lo_b.
    lo_b->copy( io_integer ).

    CREATE OBJECT lo_t
      EXPORTING
        iv_integer = '0'.

    CREATE OBJECT lo_nt
      EXPORTING
        iv_integer = '1'.

    CREATE OBJECT lo_r.
    lo_r->copy( lo_b ).

    CREATE OBJECT lo_nr.
    lo_nr->copy( lo_a )->mod( lo_b ).

    CREATE OBJECT lo_q.
    CREATE OBJECT lo_tmp.
    CREATE OBJECT lo_foo.

    IF lo_b->is_negative( ) = abap_true.
      lo_b->toggle_negative( ).
    ENDIF.

    IF lo_a->is_negative( ) = abap_true.
      lo_tmp->copy( lo_a )->toggle_negative( )->mod( lo_b ).
      lo_a->copy( lo_b )->subtract( lo_tmp ).
    ENDIF.

    WHILE lo_nr->is_zero( ) = abap_false.
      lo_q->copy( lo_r )->divide( lo_nr ).
      lo_tmp->copy( lo_nt ).
      lo_foo->copy( lo_q )->multiply( lo_nt ).
      lo_nt->copy( lo_t )->subtract( lo_foo ).
      lo_t->copy( lo_tmp ).
      lo_tmp->copy( lo_nr ).
      lo_foo->copy( lo_q )->multiply( lo_nr ).
      lo_nr->copy( lo_r )->subtract( lo_foo ).
      lo_r->copy( lo_tmp ).
    ENDWHILE.

    IF lo_r->is_gt( lo_one ) = abap_true.
* No inverse
      BREAK-POINT.
    ENDIF.

    IF lo_t->is_negative( ) = abap_true.
      lo_t->add( lo_b ).
    ENDIF.

    copy( lo_t ).
    ro_result = me.

  ENDMETHOD.


  METHOD multiply.

    DATA: lv_index  TYPE i,
          lv_index1 TYPE i,
          lv_op     TYPE ty_split,
          lv_add    TYPE ty_split,
          lv_carry  TYPE ty_split,
          lt_result LIKE mt_split.

    FIELD-SYMBOLS: <lv_result> TYPE i,
                   <lv_op1>    TYPE i,
                   <lv_op2>    TYPE i.


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
        lv_add = lv_op MOD c_max.
        <lv_result> = <lv_result> + lv_add.

        lv_carry = <lv_result> DIV c_max + lv_op DIV c_max.
        <lv_result> = <lv_result> MOD c_max.

        WHILE lv_carry <> 0.
          lv_index = lv_index + 1.
          READ TABLE lt_result INDEX lv_index ASSIGNING <lv_result>.
          IF sy-subrc <> 0.
            APPEND INITIAL LINE TO lt_result ASSIGNING <lv_result>.
          ENDIF.
* carry might trigger the next carry
          <lv_result> = <lv_result> + lv_carry.
          lv_carry    = <lv_result> DIV c_max.
          <lv_result> = <lv_result> MOD c_max.
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
    CREATE OBJECT lo_original.
    CREATE OBJECT lo_count.

    lo_original->copy( me ).
    lo_count->copy( io_integer ).
    lo_count->subtract( lo_one ).

    WHILE lo_count->is_zero( ) = abap_false.
      multiply( lo_original ).

      lo_count->subtract( lo_one ).
    ENDWHILE.

    ro_result = me.

  ENDMETHOD.


  METHOD remove_leading_zeros.

    DATA: lv_lines TYPE i,
          lv_value TYPE i.


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


  METHOD shift_right.

    DO iv_times TIMES.
      divide_by_2( ).
    ENDDO.

    ro_result = me.

  ENDMETHOD.


  METHOD split.

    DATA: lv_integer LIKE iv_integer,
          lv_length  TYPE i,
          lv_offset  TYPE i.


    CLEAR mt_split.
    CLEAR mv_negative.

    lv_integer = iv_integer.

    IF lv_integer(1) = '-'.
      mv_negative = abap_true.
      lv_integer = lv_integer+1.
    ENDIF.

    lv_offset = strlen( lv_integer ) - c_length.

    DO.
      IF lv_offset < 0.
        lv_offset = 0.
      ENDIF.

      lv_length = c_length.
      IF lv_length > strlen( lv_integer ).
        lv_length = strlen( lv_integer ).
      ELSEIF lv_offset = 0.
        lv_length = strlen( lv_integer ) - lines( mt_split ) * c_length.
      ENDIF.

      APPEND lv_integer+lv_offset(lv_length) TO mt_split.

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
      CREATE OBJECT lo_tmp.
      lo_tmp->copy( io_integer )->subtract( me ).
      copy( lo_tmp ).
      toggle_negative( ).
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
        lv_op1 = lv_op1 + c_max.
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

    DATA: lv_int TYPE c LENGTH c_length.

    LOOP AT mt_split INTO lv_int.
      IF sy-tabix <> lines( mt_split ).
        SHIFT lv_int RIGHT DELETING TRAILING space.
        OVERLAY lv_int WITH '0000'.
      ENDIF.
      CONCATENATE lv_int rv_integer INTO rv_integer.
    ENDLOOP.

    rv_integer = condense( rv_integer ).

    IF mv_negative = abap_true.
      CONCATENATE '-' rv_integer INTO rv_integer.
    ENDIF.

  ENDMETHOD.
ENDCLASS.