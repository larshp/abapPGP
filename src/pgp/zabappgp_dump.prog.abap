REPORT zabappgp_dump.

DATA: gv_ok_code  LIKE sy-ucomm,
      go_splitter TYPE REF TO cl_gui_easy_splitter_container,
      go_left     TYPE REF TO cl_gui_textedit,
      go_right    TYPE REF TO cl_gui_textedit.

START-OF-SELECTION.
  PERFORM run.

FORM run.
  CALL SCREEN 2000.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_2000 OUTPUT.
  SET PF-STATUS 'STATUS_2000'.
  SET TITLEBAR 'TITLE_2000'.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.
  CASE gv_ok_code.
    WHEN 'BACK'.
      CLEAR gv_ok_code.
      LEAVE TO SCREEN 0.
    WHEN 'DUMP'.
      CLEAR gv_ok_code.
      PERFORM dump.
    WHEN 'SAMPLE'.
      CLEAR gv_ok_code.
      PERFORM sample.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  INIT_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_2000 OUTPUT.
  PERFORM init_2000.
ENDMODULE.

FORM init_2000.

  IF go_splitter IS BOUND.
    RETURN.
  ENDIF.

  CREATE OBJECT go_splitter
    EXPORTING
      parent      = cl_gui_container=>screen0
      orientation = 1.

  CREATE OBJECT go_left
    EXPORTING
      parent = go_splitter->top_left_container.
  go_left->set_toolbar_mode( ).
  go_left->set_font_fixed( ).

  CREATE OBJECT go_right
    EXPORTING
      parent = go_splitter->bottom_right_container.
  go_right->set_toolbar_mode( ).
  go_right->set_readonly_mode( ).
  go_right->set_font_fixed( ).

ENDFORM.

FORM dump.

  DATA: lo_key  TYPE REF TO zcl_abappgp_message_public_key,
        lv_text TYPE string,
        lv_dump TYPE string.


  go_left->get_textstream( IMPORTING text = lv_text ).
  cl_gui_cfw=>flush( ).

  lo_key = zcl_abappgp_message_public_key=>from_string( lv_text ).

  lv_dump = lo_key->dump( ).

  go_right->set_textstream( lv_dump ).

ENDFORM.

FORM sample.

  DEFINE _append.
    concatenate lv_text &1 cl_abap_char_utilities=>newline into lv_text.
  END-OF-DEFINITION.

  DATA: lv_text TYPE string.


  _append '-----BEGIN PGP PUBLIC KEY BLOCK-----'.
  _append 'Version: OpenPGP.js v2.0.0'.
  _append 'Comment: http://openpgpjs.org'.
  _append ''.
  _append 'xo0EWC2+6gEEAN05FaocuNPecRuGy61ugl50W9jvla1+LabAdQ3LWwiJ2jMX'.
  _append '2C6SGHXaQ7YmuSUtrl7dVeyNA0Zs60e9JsLnU6DnvsQNuMaJHACww4eknNMi'.
  _append 'VQi9U0RAJssYeGu0VqPfPdtnwCcntcV+uDkWIqam6l7uiSDGOEKiqWMNacA3'.
  _append 'kp7zABEBAAHNEUZvbyA8Zm9vQGJhci5jb20+wrUEEAEIACkFAlgtvuoGCwkI'.
  _append 'BwMCCRBl2gK148od4QQVCAIKAxYCAQIZAQIbAwIeAQAA7agD/3g4zaTXpfnz'.
  _append 'ugNaadGYu/SdrUt0AyFOoTYzMMOo1JXXMy8j4FOPA8FHZ290RhYtZVxjDyLL'.
  _append '/rlb+sgn22BubaVqtcF84ga4RLdRGK9p/mlSb91YO/0DWTqSUZh16sXIhiGu'.
  _append 'S0IcYnLwOfok2AT6ka9GWwXbxtreNN90if7MiCJzzo0EWC2+6gEEALkkmnMH'.
  _append 'Ak/INHIDbuQOC35pZr/gxsHSCaxRtstI4O84mUbm6RqPJmCG8sWTapEgyoV5'.
  _append 'yZaN655XANiaEqIfUnDKvrWbIEkNGDu9XYqFnjUBZo3VZ72rFbwVxzeohJUY'.
  _append 'qAnDvHUZtcJyIg+s+SPnzAEToKYiH8ScvY9L4LjgpkmLABEBAAHCnwQYAQgA'.
  _append 'EwUCWC2+6gkQZdoCtePKHeECGwwAAMJoA/98i5ZOibcAihHKFgJ5F2Lc4gEH'.
  _append 'DRvFyxas6eu6P/zAqsazBeBk1IY9Ae0LjpkehrlhfJe1+qjX4EVC4Cz9sfbe'.
  _append 'gI6bCt1Jdt3xJBKF0vzjC5ux/SCqTAqVSjZ8QyuJnaU2azAcW8vmFwnlox+j'.
  _append '1ozJvbr1ndbEyd50AMsn0I5wjg=='.
  _append '=80MV'.
  _append '-----END PGP PUBLIC KEY BLOCK-----'.

  go_left->set_textstream( lv_text ).

ENDFORM.