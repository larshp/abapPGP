REPORT zabappgp_test4.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lv_str1 TYPE string,
  lv_str2 TYPE string.


  DATA(lo_random) = NEW zcl_abappgp_random(
    io_low = zcl_abappgp_integer=>from_string( '11111' )
    io_high = zcl_abappgp_integer=>from_string( '999999999999' ) ).

  DO 100 TIMES.
    DATA(lo_var1) = lo_random->random( ).
    DATA(lo_var2) = lo_random->random( ).

    lv_str1 = lo_var1->to_string( ).
    lv_str2 = lo_var2->to_string( ).
    WRITE: / lv_str1, '/', lv_str2.

    DATA(lo_knuth) = lo_var1->clone( )->divide_knuth( lo_var2 ).
    DATA(lo_binary) = lo_var1->clone( )->divide( lo_var2 ).

    IF lo_knuth->is_eq( lo_binary ) = abap_false.
      WRITE 'ERROR'.
    ELSE.
      WRITE 'OK'.
    ENDIF.
  ENDDO.

ENDFORM.