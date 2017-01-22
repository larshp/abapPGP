CLASS zcl_abappgp_integer2 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPE-POOLS abap .
    METHODS is_gt
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer2
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    CLASS-METHODS class_constructor .
    CLASS-METHODS from_integer
      IMPORTING
        !io_integer       TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer2 .
    CLASS-METHODS from_string
      IMPORTING
        !iv_integer       TYPE string
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer2 .
    METHODS add
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer2
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer2 .
    METHODS and
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer2
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer2 .
    METHODS clone
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer2 .
    METHODS constructor
      IMPORTING
        !iv_integer TYPE i DEFAULT 1 .
    METHODS divide_by_2
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer2 .
    METHODS get_binary_length
      RETURNING
        VALUE(rv_length) TYPE i .
    METHODS is_eq
      IMPORTING
        !io_integer    TYPE REF TO zcl_abappgp_integer2
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_one
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS is_zero
      RETURNING
        VALUE(rv_bool) TYPE abap_bool .
    METHODS multiply
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer2
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer2 .
    METHODS shift_left
      IMPORTING
        !iv_times        TYPE i
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer2 .
    METHODS shift_right
      IMPORTING
        !iv_times        TYPE i
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer2 .
    METHODS subtract
      IMPORTING
        !io_integer      TYPE REF TO zcl_abappgp_integer2
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_integer2 .
    METHODS to_integer
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
    METHODS to_string
      RETURNING
        VALUE(rv_integer) TYPE string .
    METHODS multiply_karatsuba
      IMPORTING
        !io_integer       TYPE REF TO zcl_abappgp_integer2
        !iv_fallback      TYPE i DEFAULT 20
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer2 .
  PROTECTED SECTION.

    TYPES ty_split TYPE i .
    TYPES:
      ty_split_tt TYPE STANDARD TABLE OF ty_split WITH DEFAULT KEY .

    DATA mt_split TYPE ty_split_tt .
    CLASS-DATA gv_max TYPE i VALUE 8192.        "#EC NOTEXT .  .  . " .
    CLASS-DATA gv_bits TYPE i VALUE 13.         "#EC NOTEXT .  .  . " .
    CLASS-DATA go_max TYPE REF TO zcl_abappgp_integer .
    CLASS-DATA:
      gt_powers TYPE STANDARD TABLE OF REF TO zcl_abappgp_integer WITH DEFAULT KEY .
    CLASS-DATA go_two TYPE REF TO zcl_abappgp_integer2 .

    METHODS remove_leading_zeros .
    CLASS-METHODS split_at
      IMPORTING
        !io_integer TYPE REF TO zcl_abappgp_integer2
        !iv_at      TYPE i
      EXPORTING
        !eo_low     TYPE REF TO zcl_abappgp_integer2
        !eo_high    TYPE REF TO zcl_abappgp_integer2 .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_INTEGER2 IMPLEMENTATION.


  METHOD add.

    DATA: lv_max   TYPE i,
          lv_carry TYPE ty_split,
          lv_op1   TYPE ty_split,
          lv_op2   TYPE ty_split,
          lv_index TYPE i.


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


    lv_lines = nmin( val1 = lines( io_integer->mt_split )
                     val2 = lines( mt_split ) ).

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


    CREATE OBJECT go_two
      EXPORTING
        iv_integer = 2.

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

    IF iv_integer = '0'.
      CREATE OBJECT ro_integer
        EXPORTING
          iv_integer = 0.
    ELSE.
      ro_integer = from_integer( zcl_abappgp_integer=>from_string( iv_integer ) ).
    ENDIF.

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


  METHOD is_eq.

    FIELD-SYMBOLS: <lv_op1> LIKE LINE OF mt_split,
                   <lv_op2> LIKE LINE OF mt_split.


    IF lines( mt_split ) <> lines( io_integer->mt_split ).
      rv_bool = abap_false.
      RETURN.
    ENDIF.

    DO lines( mt_split ) TIMES.
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


  METHOD is_gt.

    DATA: lv_index   TYPE i,
          lv_op1     TYPE ty_split,
          lv_op2     TYPE ty_split,
          lv_length1 TYPE i,
          lv_length2 TYPE i.


    lv_length1 = lines( mt_split ).
    lv_length2 = lines( io_integer->mt_split ).

    IF lv_length1 > lv_length2.
      rv_bool = abap_true.
      RETURN.
    ELSEIF lv_length1 < lv_length2.
      rv_bool = abap_false.
      RETURN.
    ENDIF.

    rv_bool = abap_false.

    DO lv_length1 TIMES.
      lv_index = lv_length1 - sy-index + 1.

      READ TABLE mt_split INDEX lv_index INTO lv_op1.
      READ TABLE io_integer->mt_split INDEX lv_index INTO lv_op2.

      IF lv_op1 > lv_op2.
        rv_bool = abap_true.
        EXIT.
      ELSEIF lv_op1 < lv_op2.
        rv_bool = abap_false.
        EXIT.
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

    mt_split = lt_result.

  ENDMETHOD.


  METHOD multiply_karatsuba.

* https://en.wikipedia.org/wiki/Karatsuba_algorithm
* http://www.geeksforgeeks.org/divide-and-conquer-set-2-karatsuba-algorithm-for-fast-multiplication/

    DATA: lv_m     TYPE i,
          lo_low1  TYPE REF TO zcl_abappgp_integer2,
          lo_low2  TYPE REF TO zcl_abappgp_integer2,
          lo_high1 TYPE REF TO zcl_abappgp_integer2,
          lo_high2 TYPE REF TO zcl_abappgp_integer2,
          lo_z0    TYPE REF TO zcl_abappgp_integer2,
          lo_z1    TYPE REF TO zcl_abappgp_integer2,
          lo_z2    TYPE REF TO zcl_abappgp_integer2.


    IF lines( mt_split ) < iv_fallback
        OR lines( io_integer->mt_split ) < iv_fallback.
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
    lo_z1 = lo_low1->add( lo_high1 )->multiply_karatsuba(
      lo_low2->add( lo_high2 ) ).
* z2 = karatsuba(high1,high2)
    lo_z2 = lo_high1->multiply_karatsuba( lo_high2 ).

* return (z2*10^(2*m2))+((z1-z2-z0)*10^(m2))+(z0)
    mt_split = lo_z2->mt_split.
    shift_left( 2 * lv_m * gv_bits ).
    add( lo_z0 ).
    add( lo_z1->shift_left( lv_m * gv_bits ) ).
    subtract( lo_z2->add( lo_z0 )->shift_left( lv_m * gv_bits ) ).
    ro_integer = me.

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


  METHOD shift_left.

    DATA: lv_append   TYPE i,
          lv_multiply TYPE i.


    lv_append   = iv_times DIV gv_bits.
    lv_multiply = iv_times MOD gv_bits.

    DO lv_multiply TIMES.
      ro_result = multiply( go_two ).
    ENDDO.

    DO lv_append TIMES.
      INSERT 0 INTO mt_split INDEX 1.
    ENDDO.

    ro_result = me.

  ENDMETHOD.


  METHOD shift_right.

    DATA: lv_delete TYPE i,
          lv_divide TYPE i.


    lv_delete = iv_times DIV gv_bits.
    lv_divide = iv_times MOD gv_bits.

    DO lv_delete TIMES.
      DELETE mt_split INDEX 1.
    ENDDO.

    IF lines( mt_split ) = 0.
      APPEND 0 TO mt_split.
    ENDIF.

    DO lv_divide TIMES.
      ro_result = divide_by_2( ).
    ENDDO.

    ro_result = me.

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
          lv_index TYPE i.


    ro_result = me.

    ASSERT is_gt( io_integer ) = abap_true
      OR is_eq( io_integer ) = abap_true.

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
