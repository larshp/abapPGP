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

  CREATE OBJECT go_right
    EXPORTING
      parent = go_splitter->bottom_right_container.
  go_right->set_toolbar_mode( ).
  go_right->set_readonly_mode( ).

ENDFORM.

FORM dump.
  BREAK-POINT.
ENDFORM.