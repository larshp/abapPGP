REPORT zabappgp_test5 LINE-SIZE 250.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lv_sent   TYPE abap_bool,
        lv_tested TYPE i,
        lo_one    TYPE REF TO zcl_abappgp_integer,
        lo_two    TYPE REF TO zcl_abappgp_integer,
        lo_low    TYPE REF TO zcl_abappgp_integer,
        lo_high   TYPE REF TO zcl_abappgp_integer.


  zcl_abappgp_random=>bits_to_low_high(
    EXPORTING
      iv_bits = '512'
    IMPORTING
      eo_low  = lo_low
      eo_high = lo_high ).

  CREATE OBJECT lo_one
    EXPORTING
      iv_integer = 1.

  CREATE OBJECT lo_two
    EXPORTING
      iv_integer = 2.

  DATA(lo_random) = NEW zcl_abappgp_random( io_low  = lo_low
                                            io_high = lo_high ).
  DATA(lo_value) = lo_random->random( ).
  IF lo_value->is_even( ) = abap_true.
    lo_value = lo_value->add( lo_one ).
  ENDIF.

  DO. " 5 TIMES.
    lv_tested = sy-index.
*    cl_progress_indicator=>progress_indicate(
*      EXPORTING
*        i_text          = |New Random { lv_tested }|
*        i_processed     = 50
*        i_total         = 100
*        i_output_immediately = abap_true
*      IMPORTING
*        e_progress_sent = lv_sent
*        ).
*    IF lv_sent = abap_true.
*      COMMIT WORK.
*    ENDIF.

    DATA(lv_prime) = zcl_abappgp_prime=>check(
      iv_iterations    = 60
      io_integer       = lo_value
      iv_show_progress = abap_true ).
    IF lv_prime = abap_true.
      PERFORM output_integer USING lo_value.
      EXIT. " current loop
    ENDIF.

    lo_value->add( lo_two ).
  ENDDO.

  WRITE: / 'Done, tested', lv_tested, 'numbers'.

ENDFORM.

FORM output_integer USING io_value TYPE REF TO zcl_abappgp_integer.

  CONSTANTS: lc_output TYPE i VALUE 200.

  DATA: lv_str TYPE string.


  lv_str = io_value->to_string( ).
  WHILE strlen( lv_str ) > lc_output.
    WRITE: / lv_str(lc_output).
    lv_str = lv_str+lc_output.
  ENDWHILE.
  WRITE: / lv_str.

ENDFORM.