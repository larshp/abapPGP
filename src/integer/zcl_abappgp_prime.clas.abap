CLASS zcl_abappgp_prime DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS check
      IMPORTING
        !io_integer       TYPE REF TO zcl_abappgp_integer
        !iv_iterations    TYPE i DEFAULT 60
        !iv_show_progress TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(rv_bool)    TYPE abap_bool .
  PROTECTED SECTION.

    TYPES:
      ty_integer_tt TYPE STANDARD TABLE OF REF TO zcl_abappgp_integer WITH DEFAULT KEY .

    CLASS-DATA gt_low TYPE ty_integer_tt.

    CLASS-METHODS low_primes
      RETURNING
        VALUE(rt_low) TYPE ty_integer_tt .
    CLASS-METHODS rabin_miller
      IMPORTING
        !io_n             TYPE REF TO zcl_abappgp_integer
        !iv_iterations    TYPE i
        !iv_show_progress TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(rv_bool)    TYPE abap_bool .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abappgp_prime IMPLEMENTATION.


  METHOD check.

    DATA: lo_integer TYPE REF TO zcl_abappgp_integer,
          lo_copy    TYPE REF TO zcl_abappgp_integer.


    IF io_integer->is_zero( ) = abap_true OR io_integer->is_one( ) = abap_true.
      rv_bool = abap_false.
      RETURN.
    ENDIF.

    IF lines( gt_low ) = 0.
      gt_low = low_primes( ).
    ENDIF.

    LOOP AT gt_low INTO lo_integer.
      IF lo_integer->is_eq( io_integer ) = abap_true.
        rv_bool = abap_true.
        RETURN.
      ENDIF.
      lo_copy = io_integer->clone( ).
      lo_copy->mod( lo_integer ).
      IF lo_copy->is_zero( ) = abap_true.
        rv_bool = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    rv_bool = rabin_miller(
      io_n             = io_integer
      iv_iterations    = iv_iterations
      iv_show_progress = iv_show_progress ).

  ENDMETHOD.


  METHOD low_primes.

    DATA lo_integer TYPE REF TO zcl_abappgp_integer.
    DATA lt_integers TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA lv_integer LIKE LINE OF lt_integers.


    APPEND 2 TO lt_integers.
    APPEND 3 TO lt_integers.
    APPEND 5 TO lt_integers.
    APPEND 7 TO lt_integers.
    APPEND 11 TO lt_integers.
    APPEND 13 TO lt_integers.
    APPEND 17 TO lt_integers.
    APPEND 19 TO lt_integers.
    APPEND 23 TO lt_integers.
    APPEND 29 TO lt_integers.
    APPEND 31 TO lt_integers.
    APPEND 37 TO lt_integers.
    APPEND 41 TO lt_integers.
    APPEND 43 TO lt_integers.
    APPEND 47 TO lt_integers.
    APPEND 53 TO lt_integers.
    APPEND 59 TO lt_integers.
    APPEND 61 TO lt_integers.
    APPEND 67 TO lt_integers.
    APPEND 71 TO lt_integers.
    APPEND 73 TO lt_integers.
    APPEND 79 TO lt_integers.
    APPEND 83 TO lt_integers.
    APPEND 89 TO lt_integers.
    APPEND 97 TO lt_integers.
    APPEND 101 TO lt_integers.
    APPEND 103 TO lt_integers.
    APPEND 107 TO lt_integers.
    APPEND 109 TO lt_integers.
    APPEND 113 TO lt_integers.
    APPEND 127 TO lt_integers.
    APPEND 131 TO lt_integers.
    APPEND 137 TO lt_integers.
    APPEND 139 TO lt_integers.
    APPEND 149 TO lt_integers.
    APPEND 151 TO lt_integers.
    APPEND 157 TO lt_integers.
    APPEND 163 TO lt_integers.
    APPEND 167 TO lt_integers.
    APPEND 173 TO lt_integers.
    APPEND 179 TO lt_integers.
    APPEND 181 TO lt_integers.
    APPEND 191 TO lt_integers.
    APPEND 193 TO lt_integers.
    APPEND 197 TO lt_integers.
    APPEND 199 TO lt_integers.
    APPEND 211 TO lt_integers.
    APPEND 223 TO lt_integers.
    APPEND 227 TO lt_integers.
    APPEND 229 TO lt_integers.
    APPEND 233 TO lt_integers.
    APPEND 239 TO lt_integers.
    APPEND 241 TO lt_integers.
    APPEND 251 TO lt_integers.
    APPEND 257 TO lt_integers.
    APPEND 263 TO lt_integers.
    APPEND 269 TO lt_integers.
    APPEND 271 TO lt_integers.
    APPEND 277 TO lt_integers.
    APPEND 281 TO lt_integers.
    APPEND 283 TO lt_integers.
    APPEND 293 TO lt_integers.
    APPEND 307 TO lt_integers.
    APPEND 311 TO lt_integers.
    APPEND 313 TO lt_integers.
    APPEND 317 TO lt_integers.
    APPEND 331 TO lt_integers.
    APPEND 337 TO lt_integers.
    APPEND 347 TO lt_integers.
    APPEND 349 TO lt_integers.
    APPEND 353 TO lt_integers.
    APPEND 359 TO lt_integers.
    APPEND 367 TO lt_integers.
    APPEND 373 TO lt_integers.
    APPEND 379 TO lt_integers.
    APPEND 383 TO lt_integers.
    APPEND 389 TO lt_integers.
    APPEND 397 TO lt_integers.
    APPEND 401 TO lt_integers.
    APPEND 409 TO lt_integers.
    APPEND 419 TO lt_integers.
    APPEND 421 TO lt_integers.
    APPEND 431 TO lt_integers.
    APPEND 433 TO lt_integers.
    APPEND 439 TO lt_integers.
    APPEND 443 TO lt_integers.
    APPEND 449 TO lt_integers.
    APPEND 457 TO lt_integers.
    APPEND 461 TO lt_integers.
    APPEND 463 TO lt_integers.
    APPEND 467 TO lt_integers.
    APPEND 479 TO lt_integers.
    APPEND 487 TO lt_integers.
    APPEND 491 TO lt_integers.
    APPEND 499 TO lt_integers.
    APPEND 503 TO lt_integers.
    APPEND 509 TO lt_integers.
    APPEND 521 TO lt_integers.
    APPEND 523 TO lt_integers.
    APPEND 541 TO lt_integers.
    APPEND 547 TO lt_integers.
    APPEND 557 TO lt_integers.
    APPEND 563 TO lt_integers.
    APPEND 569 TO lt_integers.
    APPEND 571 TO lt_integers.
    APPEND 577 TO lt_integers.
    APPEND 587 TO lt_integers.
    APPEND 593 TO lt_integers.
    APPEND 599 TO lt_integers.
    APPEND 601 TO lt_integers.
    APPEND 607 TO lt_integers.
    APPEND 613 TO lt_integers.
    APPEND 617 TO lt_integers.
    APPEND 619 TO lt_integers.
    APPEND 631 TO lt_integers.
    APPEND 641 TO lt_integers.
    APPEND 643 TO lt_integers.
    APPEND 647 TO lt_integers.
    APPEND 653 TO lt_integers.
    APPEND 659 TO lt_integers.
    APPEND 661 TO lt_integers.
    APPEND 673 TO lt_integers.
    APPEND 677 TO lt_integers.
    APPEND 683 TO lt_integers.
    APPEND 691 TO lt_integers.
    APPEND 701 TO lt_integers.
    APPEND 709 TO lt_integers.
    APPEND 719 TO lt_integers.
    APPEND 727 TO lt_integers.
    APPEND 733 TO lt_integers.
    APPEND 739 TO lt_integers.
    APPEND 743 TO lt_integers.
    APPEND 751 TO lt_integers.
    APPEND 757 TO lt_integers.
    APPEND 761 TO lt_integers.
    APPEND 769 TO lt_integers.
    APPEND 773 TO lt_integers.
    APPEND 787 TO lt_integers.
    APPEND 797 TO lt_integers.
    APPEND 809 TO lt_integers.
    APPEND 811 TO lt_integers.
    APPEND 821 TO lt_integers.
    APPEND 823 TO lt_integers.
    APPEND 827 TO lt_integers.
    APPEND 829 TO lt_integers.
    APPEND 839 TO lt_integers.
    APPEND 853 TO lt_integers.
    APPEND 857 TO lt_integers.
    APPEND 859 TO lt_integers.
    APPEND 863 TO lt_integers.
    APPEND 877 TO lt_integers.
    APPEND 881 TO lt_integers.
    APPEND 883 TO lt_integers.
    APPEND 887 TO lt_integers.
    APPEND 907 TO lt_integers.
    APPEND 911 TO lt_integers.
    APPEND 919 TO lt_integers.
    APPEND 929 TO lt_integers.
    APPEND 937 TO lt_integers.
    APPEND 941 TO lt_integers.
    APPEND 947 TO lt_integers.
    APPEND 953 TO lt_integers.
    APPEND 967 TO lt_integers.
    APPEND 971 TO lt_integers.
    APPEND 977 TO lt_integers.
    APPEND 983 TO lt_integers.
    APPEND 991 TO lt_integers.
    APPEND 997 TO lt_integers.

    LOOP AT lt_integers INTO lv_integer.
      CREATE OBJECT lo_integer
        EXPORTING
          iv_integer = lv_integer.
      APPEND lo_integer TO rt_low.
    ENDLOOP.

  ENDMETHOD.


  METHOD rabin_miller.

    DATA: lo_one      TYPE REF TO zcl_abappgp_integer,
          lo_two      TYPE REF TO zcl_abappgp_integer,
          lo_tmp      TYPE REF TO zcl_abappgp_integer,
          lv_s        TYPE i, " todo, perhaps it is wrong to define lv_s as i?
          lo_d        TYPE REF TO zcl_abappgp_integer,
          lo_a        TYPE REF TO zcl_abappgp_integer,
          lo_x        TYPE REF TO zcl_abappgp_integer,
          lv_continue TYPE abap_bool,
          lv_index    TYPE i,
          lo_random   TYPE REF TO zcl_abappgp_random.


    CREATE OBJECT lo_one.

    CREATE OBJECT lo_two
      EXPORTING
        iv_integer = 2.

    lo_d = io_n->clone( )->subtract( lo_one ).

    DO.
      IF lo_d->mod_2( ) = 0.
        EXIT.
      ENDIF.
      lo_d->divide_by_2( ).
      lv_s = lv_s + 1.
    ENDDO.

    lo_tmp = io_n->clone( )->subtract( lo_one ).
    CREATE OBJECT lo_random
      EXPORTING
        io_low  = lo_two
        io_high = lo_tmp.

    DO iv_iterations TIMES.
      lv_index = sy-index.

      IF lv_index <> 1 AND iv_show_progress = abap_true.
        cl_progress_indicator=>progress_indicate(
          i_text               = |Running { lv_index }/{ iv_iterations }|
          i_processed          = lv_index
          i_total              = iv_iterations
          i_output_immediately = abap_true ).
        COMMIT WORK.
      ENDIF.

      lo_a = lo_random->random( ).
      ASSERT lo_a->is_one( ) = abap_false.

*      DATA(lv_a) = lo_a->to_string( ).
*      DATA(lv_d) = lo_d->to_string( ).
*      DATA(lv_n) = io_n->to_string( ).

      lo_x = lo_a->modular_pow_montgomery( io_exponent = lo_d
                                           io_modulus  = io_n ).

      IF lo_x->is_one( ) = abap_true OR lo_x->is_eq( lo_tmp ) = abap_true.
        CONTINUE.
      ENDIF.

      lv_continue = abap_false.
      DO lv_s - 1 TIMES.
        lo_x->multiply( lo_x->clone( ) )->mod( io_n ).

        IF lo_x->is_one( ) = abap_true.
          rv_bool = abap_false.
          RETURN.
        ENDIF.

        IF lo_x->is_eq( lo_tmp ) = abap_true.
          lv_continue = abap_true.
          EXIT. " current loop
        ENDIF.
      ENDDO.

      IF lv_continue = abap_false.
        rv_bool = abap_false.
        RETURN.
      ENDIF.
    ENDDO.

    rv_bool = abap_true.

  ENDMETHOD.
ENDCLASS.
