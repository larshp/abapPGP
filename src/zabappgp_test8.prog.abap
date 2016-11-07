REPORT zabappgp_test8 LINE-SIZE 250.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lv_tested TYPE i,
        lo_one    TYPE REF TO zcl_abappgp_integer,
        lo_two    TYPE REF TO zcl_abappgp_integer.


  CREATE OBJECT lo_one
    EXPORTING
      iv_integer = 1.

  CREATE OBJECT lo_two
    EXPORTING
      iv_integer = 2.

  DATA: lv_str TYPE string.

  CONCATENATE '1429301524998502613365623295227994727457854533553256621542280577197871184053906800701471185155993208707813750'
    '2595366559449672544379060010036428639288193692782801618895407859466005802202854041413366300'
    '2207089682713027895510493373181269391902851389622417024000737683322186246230230375305217633474141609891337099' INTO lv_str.

  DATA(lo_value) = zcl_abappgp_integer=>from_string( lv_str ).

  DO 7 TIMES.
    lv_tested = sy-index.

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