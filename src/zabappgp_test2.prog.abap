REPORT zabappgp_test2.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA(lo_a) = zcl_abappgp_integer=>from_string( '1234084860766158722' ).
  DATA(lo_d) = zcl_abappgp_integer=>from_string( '48112959837082048696' ).
  DATA(lo_n) = zcl_abappgp_integer=>from_string( '48112959837082048697' ).

  DATA(lo_x) = lo_a->modular_pow_montgomery( io_exponent = lo_d
                                             io_modulus  = lo_n ).

  WRITE: / 'Done'.

ENDFORM.