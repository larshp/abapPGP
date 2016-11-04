REPORT zabappgp_test4.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lv_times TYPE i VALUE 60000,
        lv_str1  TYPE string,
        lv_str2  TYPE string.


  DATA(lo_random) = NEW zcl_abappgp_random(
    io_low = zcl_abappgp_integer=>from_low_length( 5 )
    io_high = zcl_abappgp_integer=>from_high_length( 16 ) ).

  DO lv_times TIMES.
    IF sy-index MOD 100 = 0.
      cl_progress_indicator=>progress_indicate(
        i_text               = 'Processing'
        i_processed          = sy-index
        i_total              = lv_times
        i_output_immediately = abap_true ).
    ENDIF.

    DATA(lo_var1) = lo_random->random( ).
    DATA(lo_var2) = lo_random->random( ).

    lv_str1 = lo_var1->to_string( ).
    lv_str2 = lo_var2->to_string( ).

    DATA(lo_knuth) = lo_var1->clone( )->divide_knuth( lo_var2 ).
    DATA(lo_binary) = lo_var1->clone( )->divide( lo_var2 ).

    IF lo_knuth->is_eq( lo_binary ) = abap_false.
      WRITE: 'ERROR', lv_str1, '/', lv_str2.
    ENDIF.
  ENDDO.

  WRITE: / 'Done'.

ENDFORM.