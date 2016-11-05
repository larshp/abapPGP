REPORT zabappgp_test7.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lo_one   TYPE REF TO zcl_abappgp_integer,
        lo_two   TYPE REF TO zcl_abappgp_integer,
        lo_low   TYPE REF TO zcl_abappgp_integer,
        lo_high  TYPE REF TO zcl_abappgp_integer,
        lv_t1    TYPE timestamp,
        lv_t2    TYPE timestamp,
        lv_str   TYPE string,
        lv_times TYPE i VALUE 5000,
        lv_secs  TYPE i.


  zcl_abappgp_random=>bits_to_low_high(
    EXPORTING
      iv_bits = '1024'
    IMPORTING
      eo_low  = lo_low
      eo_high = lo_high ).

  CREATE OBJECT lo_one
    EXPORTING
      iv_integer = 1.

  CREATE OBJECT lo_two
    EXPORTING
      iv_integer = 1.

  DATA(lo_random) = NEW zcl_abappgp_random( io_low  = lo_low
                                            io_high = lo_high ).

  GET TIME STAMP FIELD lv_t1.
  DO lv_times TIMES.
    DATA(lo_value) = lo_random->random( ).
    IF lo_value->is_even( ) = abap_true.
      lo_value = lo_value->add( lo_one ).
    ENDIF.
  ENDDO.
  GET TIME STAMP FIELD lv_t2.
  lv_secs = cl_abap_tstmp=>subtract( tstmp1 = lv_t2
                                     tstmp2 = lv_t1 ).
  WRITE: / 'Runtime: ', lv_secs, 'seconds'.

  GET TIME STAMP FIELD lv_t1.
  DO lv_times TIMES.
    lo_value->add( lo_two ).
  ENDDO.
  GET TIME STAMP FIELD lv_t2.
  lv_secs = cl_abap_tstmp=>subtract( tstmp1 = lv_t2
                                     tstmp2 = lv_t1 ).
  WRITE: / 'Runtime: ', lv_secs, 'seconds'.

ENDFORM.