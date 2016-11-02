REPORT zabappgp_test2.

START-OF-SELECTION.
  PERFORM run3.

FORM run.

  DATA(lo_a) = zcl_abappgp_integer=>from_string( '1234084860766158722' ).
  DATA(lo_d) = zcl_abappgp_integer=>from_string( '48112959837082048696' ).
  DATA(lo_n) = zcl_abappgp_integer=>from_string( '48112959837082048697' ).

  DATA(lo_x) = lo_a->modular_pow_montgomery( io_exponent = lo_d
                                             io_modulus  = lo_n ).

  WRITE: / 'Done'.

ENDFORM.

FORM run2.

  DATA(lo_shifted) = zcl_abappgp_integer=>from_string( '5827800983498960781124740512078744256512' ).
  DATA(lo_mod) = zcl_abappgp_integer=>from_string( '48112959837082048697' ).

  WRITE: / 'result:', lo_shifted->divide( lo_mod )->to_string( ).

ENDFORM.

FORM run3.

  DATA: lv_op1    TYPE i,
        lv_op2    TYPE i,
        lv_tmp    TYPE i,
        lv_result TYPE i.


  DATA(lo_random1) = NEW zcl_abappgp_random(
    io_low = zcl_abappgp_integer=>from_string( '11111111' )
    io_high = zcl_abappgp_integer=>from_string( '99999999' ) ).

  DATA(lo_random2) = NEW zcl_abappgp_random(
    io_low = zcl_abappgp_integer=>from_string( '1111' )
    io_high = zcl_abappgp_integer=>from_string( '9999' ) ).


  DATA: lv_total TYPE i VALUE 1000.
  DO lv_total TIMES.
    cl_progress_indicator=>progress_indicate(
      i_text               = 'Running'
      i_processed          = sy-index
      i_total              = lv_total
      i_output_immediately = abap_true ).

    DATA(lo_op1) = lo_random1->random( ).
    DATA(lo_op2) = lo_random2->random( ).
    lv_op1 = lo_op1->to_string( ).
    lv_op2 = lo_op2->to_string( ).

    DATA(lo_result) = lo_op1->divide( lo_op2 ).
    lv_result = lo_result->to_string( ).

    lv_tmp = lv_op1 DIV lv_op2.
    IF lv_result <> lv_tmp.
      BREAK-POINT.
      WRITE: / 'error'.
    ENDIF.

  ENDDO.

  WRITE: / 'Done'.

ENDFORM.

FORM run4.

  DATA(ro_int) = zcl_abappgp_integer=>from_string( '7382888' ).
  DATA(lo_var2) = zcl_abappgp_integer=>from_string( '9' ).

  ro_int = ro_int->divide( lo_var2 ).

  WRITE: / ro_int->to_string( ).

ENDFORM.