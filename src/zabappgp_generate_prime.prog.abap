REPORT zabappgp_generate_prime LINE-SIZE 250.

PARAMETERS: p_bits TYPE i DEFAULT 512 OBLIGATORY,
            p_pnum TYPE i DEFAULT 1 OBLIGATORY.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lv_tested TYPE i,
        lo_one    TYPE REF TO zcl_abappgp_integer,
        lo_two    TYPE REF TO zcl_abappgp_integer,
        ls_primes TYPE zabappgp_primes,
        lv_t1     TYPE timestamp,
        lv_t2     TYPE timestamp,
        lv_secs   TYPE i.


  CREATE OBJECT lo_one
    EXPORTING
      iv_integer = 1.

  CREATE OBJECT lo_two
    EXPORTING
      iv_integer = 2.

  DO p_pnum TIMES.
    GET TIME STAMP FIELD lv_t1.

    DATA(lo_random) = zcl_abappgp_random=>from_bits( p_bits ).
    DATA(lo_value) = lo_random->random( ).
    IF lo_value->is_even( ) = abap_true.
      lo_value = lo_value->add( lo_one ).
    ENDIF.

    DO.
      lv_tested = sy-index.
      IF lv_tested MOD 10 = 0.
        cl_progress_indicator=>progress_indicate(
          i_text          = |New Random, { lv_tested } tested|
          i_processed     = 50
          i_total         = 100
          i_output_immediately = abap_true ).
        COMMIT WORK.
      ENDIF.

      DATA(lv_prime) = zcl_abappgp_prime=>check(
        io_integer       = lo_value
        iv_show_progress = abap_true ).
      IF lv_prime = abap_true.
        PERFORM output_integer USING lo_value.
        EXIT. " current loop
      ENDIF.

      lo_value->add( lo_two ).
    ENDDO.

    WRITE: / 'Done, tested', lv_tested, 'numbers'.

    GET TIME STAMP FIELD lv_t2.
    lv_secs = cl_abap_tstmp=>subtract( tstmp1 = lv_t2
                                       tstmp2 = lv_t1 ).
    WRITE: / 'Runtime: ', lv_secs, 'seconds'.

    CLEAR ls_primes.
    ls_primes-pdate   = sy-datum.
    ls_primes-ptime   = sy-uzeit.
    ls_primes-bits    = p_bits.
    ls_primes-runtime = lv_secs.
    ls_primes-tested  = lv_tested.
    MODIFY zabappgp_primes FROM ls_primes.
    COMMIT WORK.
  ENDDO.

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
