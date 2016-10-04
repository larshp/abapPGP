CLASS zcl_abappgp_integer DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS add
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
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
    METHODS eq
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS ge
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS get
      RETURNING
        VALUE(rv_integer) TYPE string .
    METHODS gt
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_one
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_zero
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS le
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS lt
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer
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
    METHODS subtract
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer .
  PROTECTED SECTION.

    TYPES:
      ty_split_tt TYPE STANDARD TABLE OF int4 WITH DEFAULT KEY .

    CONSTANTS c_max TYPE i VALUE 10000 ##NO_TEXT.
    DATA mt_split TYPE ty_split_tt .
    CONSTANTS c_length TYPE i VALUE 4 ##NO_TEXT.

    METHODS append_zeros
      IMPORTING
        !iv_int       TYPE i
        !iv_zeros     TYPE i
      RETURNING
        VALUE(rv_str) TYPE string .
    METHODS remove_leading_zeros .
    METHODS split
      IMPORTING
        !iv_integer     TYPE string
      RETURNING
        VALUE(rt_split) TYPE ty_split_tt .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_INTEGER IMPLEMENTATION.


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


  METHOD copy.

    mt_split = io_integer->mt_split.

*    CREATE OBJECT ro_integer
*      EXPORTING
*        iv_integer = get( ).

    ro_integer = me.

  ENDMETHOD.


  METHOD divide.

    DATA: lo_tmp        TYPE REF TO zcl_abappgp_integer,
          lo_middle     TYPE REF TO zcl_abappgp_integer,
          lo_guess      TYPE REF TO zcl_abappgp_integer,
          lo_low_guess  TYPE REF TO zcl_abappgp_integer,
          lo_high_guess TYPE REF TO zcl_abappgp_integer.


    ASSERT NOT io_integer->is_zero( ).

    ro_result = me.

    IF io_integer->is_one( ) = abap_true.
      RETURN.
    ELSEIF io_integer->gt( me ).
      mt_split = split( '0' ).
      RETURN.
    ELSEIF io_integer->eq( me ).
      mt_split = split( '1' ).
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
      lo_middle->copy( lo_high_guess )->subtract( lo_low_guess )->divide_by_2( ).
*      WRITE: / 'middle', lo_middle->get( ).

      IF lo_middle->is_zero( ).
        lo_tmp->copy( lo_high_guess )->multiply( io_integer ).
        IF lo_tmp->eq( me ) = abap_true.
          mt_split = lo_high_guess->mt_split.
        ELSE.
          mt_split = lo_low_guess->mt_split.
        ENDIF.
        RETURN.
      ENDIF.

* try moving high down
      lo_guess->copy( lo_high_guess )->subtract( lo_middle ).
      lo_tmp->copy( lo_guess )->multiply( io_integer ).
      IF lo_tmp->ge( me ) = abap_true.
*        WRITE: / 'move high to', lo_guess->get( ).
        lo_high_guess->copy( lo_guess ).
        CONTINUE.
      ENDIF.

* try moving low up
      lo_guess->copy( lo_low_guess )->add( lo_middle ).
      lo_tmp->copy( lo_guess )->multiply( io_integer ).
      IF lo_tmp->le( me ) = abap_true.
*        WRITE: / 'move low to', lo_guess->get( ).
        lo_low_guess->copy( lo_guess ).
      ENDIF.

    ENDDO.

  ENDMETHOD.


  METHOD divide_by_2.

    DATA: lv_index TYPE i,
          lv_carry TYPE i.

    FIELD-SYMBOLS: <lv_value> LIKE LINE OF mt_split.


    DO lines( mt_split ) TIMES.
      lv_index = lines( mt_split ) - sy-index + 1.

      READ TABLE mt_split INDEX lv_index ASSIGNING <lv_value>.
      ASSERT sy-subrc = 0.

      <lv_value> = <lv_value> + lv_carry * c_max.
      lv_carry   = <lv_value> MOD 2.
      <lv_value> = <lv_value> DIV 2.

    ENDDO.

    remove_leading_zeros( ).

    ro_result = me.

  ENDMETHOD.


  METHOD eq.

* compare strings
    rv_bool = boolc( get( ) = io_integer->get( ) ).

  ENDMETHOD.


  METHOD ge.

    rv_bool = boolc( gt( io_integer ) = abap_true OR eq( io_integer ) = abap_true ).

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


  METHOD gt.

    DATA: lv_index TYPE i,
          lv_op1   TYPE i,
          lv_op2   TYPE i.


    IF lines( mt_split ) > lines( io_integer->mt_split ).
      rv_bool = abap_true.
      RETURN.
    ELSEIF lines( mt_split ) < lines( io_integer->mt_split ).
      rv_bool = abap_false.
      RETURN.
    ENDIF.

    DO lines( mt_split ) TIMES.
      lv_index = lines( mt_split ) - sy-index + 1.

      READ TABLE mt_split INDEX lv_index INTO lv_op1.
      ASSERT sy-subrc = 0.
      READ TABLE io_integer->mt_split INDEX lv_index INTO lv_op2.
      ASSERT sy-subrc = 0.

      IF lv_op1 > lv_op2.
        rv_bool = abap_true.
        RETURN.
      ELSEIF lv_op1 < lv_op2.
        rv_bool = abap_false.
        RETURN.
      ENDIF.
    ENDDO.

    rv_bool = abap_false. " equal

  ENDMETHOD.


  METHOD is_one.

    FIELD-SYMBOLS: <lv_value> LIKE LINE OF mt_split.


    IF lines( mt_split ) <> 1.
      RETURN.
    ENDIF.

    READ TABLE mt_split INDEX 1 ASSIGNING <lv_value>.

    rv_bool = boolc( <lv_value> = 1 ).

  ENDMETHOD.


  METHOD is_zero.

    FIELD-SYMBOLS: <lv_value> LIKE LINE OF mt_split.


    IF lines( mt_split ) <> 1.
      RETURN.
    ENDIF.

    READ TABLE mt_split INDEX 1 ASSIGNING <lv_value>.
    ASSERT sy-subrc = 0.

    rv_bool = boolc( <lv_value> = 0 ).

  ENDMETHOD.


  METHOD le.

    rv_bool = boolc( lt( io_integer ) = abap_true OR eq( io_integer ) = abap_true ).

  ENDMETHOD.


  METHOD lt.

    rv_bool = boolc( gt( io_integer ) = abap_false ).

  ENDMETHOD.


  METHOD mod.

    DATA: lo_div  TYPE REF TO zcl_abappgp_integer,
          lo_mult TYPE REF TO zcl_abappgp_integer.


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
          lo_original TYPE REF TO zcl_abappgp_integer.


    IF io_modulus->is_one( ) = abap_true.
      mt_split = split( '0' ).
      RETURN.
    ENDIF.

    CREATE OBJECT lo_original.

    lo_original->copy( me ).
    mt_split = split( '1' ).

    IF io_exponent->is_zero( ).
      RETURN.
    ENDIF.

    CREATE OBJECT lo_one.
    CREATE OBJECT lo_count.

    lo_count->copy( io_exponent ).

    WHILE NOT lo_count->is_zero( ).
      multiply( lo_original ).
      mod( io_modulus ).
      lo_count->subtract( lo_one ).
    ENDWHILE.

    ro_result = me.

  ENDMETHOD.


  METHOD multiply.

    DATA: lv_index  TYPE i,
          lv_index1 TYPE i,
          lv_op     TYPE i,
          lv_add    TYPE i,
          lv_carry  TYPE i,
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

    mt_split = lt_result.

  ENDMETHOD.


  METHOD power.

    DATA: lo_count    TYPE REF TO zcl_abappgp_integer,
          lo_one      TYPE REF TO zcl_abappgp_integer,
          lo_original TYPE REF TO zcl_abappgp_integer.


    IF io_integer->is_zero( ).
      mt_split = split( '1' ).
      RETURN.
    ENDIF.

    CREATE OBJECT lo_one.
    CREATE OBJECT lo_original.
    CREATE OBJECT lo_count.

    lo_original->copy( me ).
    lo_count->copy( io_integer ).
    lo_count->subtract( lo_one ).

    WHILE NOT lo_count->is_zero( ).
      multiply( lo_original ).

      lo_count->subtract( lo_one ).
    ENDWHILE.

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
      IF sy-subrc <> 0.
        BREAK-POINT.
      ENDIF.
      ASSERT sy-subrc = 0.
    ENDDO.

    ASSERT lv_carry = 0.

    remove_leading_zeros( ).

    ro_result = me.

  ENDMETHOD.
ENDCLASS.