REPORT zabappgp_test3.

START-OF-SELECTION.
  PERFORM run1.
*  WRITE: /.
*  PERFORM run2.
*  WRITE: /.
*  PERFORM run3.
*  WRITE: /.
*  PERFORM run4.

FORM run1.

  DATA(lo_u) = zcl_abappgp_integer=>from_string( '5060488832657916' ).
  DATA(lo_v) = zcl_abappgp_integer=>from_string( '3804878826' ).

  lo_u = lo_u->divide_knuth( lo_v ).
  WRITE: / 'result:', lo_u->to_string( ).

ENDFORM.

FORM run2.

  DATA(lo_u) = zcl_abappgp_integer=>from_string( '333344445555' ).
  DATA(lo_v) = zcl_abappgp_integer=>from_string( '11117777' ).

  lo_u = lo_u->divide_knuth( lo_v ).
  WRITE: / 'result:', lo_u->to_string( ).

ENDFORM.

FORM run3.

  DATA(lo_u) = zcl_abappgp_integer=>from_string( '111111111111' ).
  DATA(lo_v) = zcl_abappgp_integer=>from_string( '99999999' ).

  lo_u = lo_u->divide_knuth( lo_v ).
  WRITE: / 'result:', lo_u->to_string( ).

ENDFORM.

FORM run4.

  DATA(lo_u) = zcl_abappgp_integer=>from_string( '977887108912' ).
  DATA(lo_v) = zcl_abappgp_integer=>from_string( '977814152357' ).

  lo_u = lo_u->divide_knuth( lo_v ).
  WRITE: / 'result:', lo_u->to_string( ).

ENDFORM.