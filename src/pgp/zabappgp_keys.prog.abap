REPORT zabappgp_keys.

TABLES: zabappgp_keys_key,
        zabappgp_keys_data.

CONSTANTS: BEGIN OF c_mode,
             create  TYPE i VALUE 1,
             change  TYPE i VALUE 2,
             display TYPE i VALUE 3,
           END OF c_mode.

DATA: gv_ok_code LIKE sy-ucomm.


START-OF-SELECTION.
  PERFORM run.

CLASS lcl_key DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
      call
        IMPORTING
          iv_mode TYPE i
          is_key  TYPE zabappgp_keys OPTIONAL,
      init,
      user_command,
      status.

  PRIVATE SECTION.
    CLASS-METHODS:
      save.

    CLASS-DATA:
      gv_mode     TYPE i,
      gs_key      TYPE zabappgp_keys,
      go_cprivate TYPE REF TO cl_gui_custom_container,
      go_cpublic  TYPE REF TO cl_gui_custom_container,
      go_private  TYPE REF TO cl_gui_textedit,
      go_public   TYPE REF TO cl_gui_textedit.

ENDCLASS.

CLASS lcl_overview DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
      show,
      user_command,
      init RAISING cx_salv_msg cx_salv_not_found,
      status.

  PRIVATE SECTION.
    CLASS-DATA:
      go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_salv_table,
      gt_keys      TYPE STANDARD TABLE OF zabappgp_keys.

    CLASS-METHODS:
      call_display,
      call_change,
      delete,
      get_selected RETURNING VALUE(rs_key) TYPE zabappgp_keys,
      call_key_screen IMPORTING iv_mode TYPE i,
      refresh.

ENDCLASS.

CLASS lcl_overview IMPLEMENTATION.

  METHOD refresh.

    CLEAR gt_keys.
    SELECT * FROM zabappgp_keys INTO TABLE gt_keys.

    IF go_alv IS BOUND.
      go_alv->refresh( ).
    ENDIF.

  ENDMETHOD.

  METHOD call_change.

    call_key_screen( c_mode-change ).

  ENDMETHOD.

  METHOD call_display.

    call_key_screen( c_mode-display ).

  ENDMETHOD.

  METHOD delete.

    DATA: ls_key  LIKE LINE OF gt_keys.


    ls_key = get_selected( ).
    IF ls_key IS INITIAL.
      RETURN.
    ENDIF.

    DELETE FROM zabappgp_keys WHERE key_id = ls_key-key_id.
    ASSERT sy-subrc = 0.

    refresh( ).

  ENDMETHOD.

  METHOD get_selected.

    DATA: lt_rows TYPE salv_t_row,
          lv_row  LIKE LINE OF lt_rows.


    go_alv->get_metadata( ).
    lt_rows = go_alv->get_selections( )->get_selected_rows( ).
    IF lines( lt_rows ) = 0.
      RETURN.
    ENDIF.

    READ TABLE lt_rows INDEX 1 INTO lv_row.
    ASSERT sy-subrc = 0.
    READ TABLE gt_keys INDEX lv_row INTO rs_key.
    ASSERT sy-subrc = 0.

  ENDMETHOD.

  METHOD call_key_screen.

    DATA: ls_key  LIKE LINE OF gt_keys.


    ls_key = get_selected( ).
    IF ls_key IS INITIAL.
      RETURN.
    ENDIF.

    lcl_key=>call( iv_mode = iv_mode
                   is_key  = ls_key ).

    refresh( ).

  ENDMETHOD.

  METHOD show.
    CALL SCREEN 2000.
  ENDMETHOD.

  METHOD status.
    SET PF-STATUS 'STATUS_2000'.
    SET TITLEBAR 'TITLE_2000'.
  ENDMETHOD.

  METHOD user_command.
    CASE gv_ok_code.
      WHEN 'CREATE'.
        CLEAR gv_ok_code.
        lcl_key=>call( c_mode-create ).
        refresh( ).
      WHEN 'GENERATE'.
        CLEAR gv_ok_code.
* todo
        BREAK-POINT.
      WHEN 'DISPLAY'.
        CLEAR gv_ok_code.
        call_display( ).
      WHEN 'CHANGE'.
        CLEAR gv_ok_code.
        call_change( ).
      WHEN 'DELETE'.
        CLEAR gv_ok_code.
        delete( ).
      WHEN 'REFRESH'.
        CLEAR gv_ok_code.
        refresh( ).
      WHEN 'BACK'.
        CLEAR gv_ok_code.
        LEAVE TO SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD init.

    IF go_container IS BOUND.
      RETURN.
    ENDIF.

    refresh( ).

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'CUSTOM_2000'.

    cl_salv_table=>factory(
      EXPORTING
        r_container  = go_container
      IMPORTING
        r_salv_table = go_alv
      CHANGING
        t_table      = gt_keys ).

    go_alv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
    go_alv->get_columns( )->get_column( 'MANDT' )->set_technical( ).
    go_alv->get_columns( )->get_column( 'PRIVATE_KEY' )->set_technical( ).
    go_alv->get_columns( )->get_column( 'PUBLIC_KEY' )->set_technical( ).
    go_alv->display( ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_key IMPLEMENTATION.

  METHOD user_command.
    CASE gv_ok_code.
      WHEN 'BACK'.
        CLEAR gv_ok_code.
        LEAVE TO SCREEN 0.
      WHEN 'SAVE'.
        CLEAR gv_ok_code.
        save( ).
        LEAVE TO SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD save.

    DATA: ls_key TYPE zabappgp_keys.


    MOVE-CORRESPONDING zabappgp_keys_key TO ls_key.
    MOVE-CORRESPONDING zabappgp_keys_data TO ls_key.

    go_public->get_textstream( IMPORTING text = ls_key-public_key ).
    go_private->get_textstream( IMPORTING text = ls_key-private_key ).
    cl_gui_cfw=>flush( ).

    CASE gv_mode.
      WHEN c_mode-create.
        INSERT zabappgp_keys FROM ls_key.
        ASSERT sy-subrc = 0.
      WHEN c_mode-change.
        MODIFY zabappgp_keys FROM ls_key.
        ASSERT sy-subrc = 0.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.
  ENDMETHOD.

  METHOD call.
    gv_mode = iv_mode.
    gs_key = is_key.

    MOVE-CORRESPONDING is_key TO zabappgp_keys_key.
    MOVE-CORRESPONDING is_key TO zabappgp_keys_data.

    CALL SCREEN 3000.
  ENDMETHOD.

  METHOD init.

    IF NOT go_cprivate IS BOUND.
      CREATE OBJECT go_cprivate
        EXPORTING
          container_name = 'CUSTOM_PRIVATE'.
      CREATE OBJECT go_private
        EXPORTING
          parent = go_cprivate.
      go_private->set_toolbar_mode( ).
      go_private->set_font_fixed( ).

      CREATE OBJECT go_cpublic
        EXPORTING
          container_name = 'CUSTOM_PUBLIC'.
      CREATE OBJECT go_public
        EXPORTING
          parent = go_cpublic.
      go_public->set_toolbar_mode( ).
      go_public->set_font_fixed( ).
    ENDIF.

    LOOP AT SCREEN.
      IF gv_mode = c_mode-display.
        screen-input = 0.
      ELSE.
        screen-input = 1.
      ENDIF.
      IF gv_mode = c_mode-change
          AND screen-name = 'ZABAPPGP_KEYS_KEY-KEY_ID'.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

    IF gv_mode = c_mode-display.
      go_public->set_readonly_mode( cl_gui_textedit=>true ).
      go_private->set_readonly_mode( cl_gui_textedit=>true ).
    ELSE.
      go_public->set_readonly_mode( cl_gui_textedit=>false ).
      go_private->set_readonly_mode( cl_gui_textedit=>false ).
    ENDIF.

    go_public->set_textstream( gs_key-public_key ).
    go_private->set_textstream( gs_key-private_key ).

    go_public->set_statusbar_mode( cl_gui_textedit=>false ).
    go_private->set_statusbar_mode( cl_gui_textedit=>false ).

  ENDMETHOD.

  METHOD status.

    DATA: lt_excluding TYPE TABLE OF sy-ucomm.


    IF gv_mode = c_mode-display.
      APPEND 'SAVE' TO lt_excluding.
    ENDIF.

    SET PF-STATUS 'STATUS_3000' EXCLUDING lt_excluding.
    SET TITLEBAR 'TITLE_3000'.

  ENDMETHOD.

ENDCLASS.

FORM run.
  lcl_overview=>show( ).
ENDFORM.

MODULE status_2000 OUTPUT.
  lcl_overview=>status( ).
ENDMODULE.

MODULE user_command_2000 INPUT.
  lcl_overview=>user_command( ).
ENDMODULE.

MODULE init_2000 OUTPUT.
  lcl_overview=>init( ).
ENDMODULE.

MODULE init_3000 OUTPUT.
  lcl_key=>init( ).
ENDMODULE.

MODULE status_3000 OUTPUT.
  lcl_key=>status( ).
ENDMODULE.

MODULE user_command_3000 INPUT.
  lcl_key=>user_command( ).
ENDMODULE.
