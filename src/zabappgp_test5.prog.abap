REPORT zabappgp_test5 LINE-SIZE 250.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  CONSTANTS: lc_output TYPE i VALUE 200.

  DATA: lv_str    TYPE string,
        lv_sent   TYPE abap_bool,
        lv_tested TYPE i,
        lo_low    TYPE REF TO zcl_abappgp_integer,
        lo_high   TYPE REF TO zcl_abappgp_integer.


  zcl_abappgp_random=>bits_to_low_high(
    EXPORTING
      iv_bits = '1024'
    IMPORTING
      eo_low  = lo_low
      eo_high = lo_high ).

  DATA(lo_random) = NEW zcl_abappgp_random( io_low  = lo_low
                                            io_high = lo_high ).

  DO.
    lv_tested = sy-index.
    cl_progress_indicator=>progress_indicate(
      EXPORTING
        i_text          = |New Random { lv_tested }|
        i_processed     = 50
        i_total         = 100
      IMPORTING
        e_progress_sent = lv_sent ).
    IF lv_sent = abap_true.
      COMMIT WORK.
    ENDIF.

    DATA(lo_value) = lo_random->random( ).
    DATA(lv_prime) = zcl_abappgp_prime=>check(
      iv_iterations    = 60
      io_integer       = lo_value
      iv_show_progress = abap_true ).
    IF lv_prime = abap_true.
      lv_str = lo_value->to_string( ).
      WHILE strlen( lv_str ) > lc_output.
        WRITE: / lv_str(lc_output).
        lv_str = lv_str+lc_output.
      ENDWHILE.
      WRITE: / lv_str.
      EXIT. " current loop
    ENDIF.
  ENDDO.

  WRITE: / 'Done, tested', lv_tested, 'numbers'.

ENDFORM.