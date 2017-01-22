REPORT zabappgp_sign.

TABLES: zabappgp_sign.

DATA: gv_ok_code LIKE sy-ucomm.

CLASS lcl_screen_2000 DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
      call,
      status,
      user_command.

  PRIVATE SECTION.
    CLASS-DATA:
      go_container1 TYPE REF TO cl_gui_custom_container,
      go_container2 TYPE REF TO cl_gui_custom_container,
      go_result     TYPE REF TO cl_gui_textedit,
      go_message    TYPE REF TO cl_gui_textedit.

    CLASS-METHODS:
      call_sign
        RAISING
          zcx_abappgp_invalid_key.

ENDCLASS.

CLASS lcl_screen_2000 IMPLEMENTATION.

  METHOD call.
    CALL SCREEN 2000.
  ENDMETHOD.

  METHOD status.
    SET PF-STATUS 'STATUS_2000'.
    SET TITLEBAR 'TITLE_2000'.

    IF NOT go_container1 IS BOUND.
      CREATE OBJECT go_container1
        EXPORTING
          container_name = 'CUSTOM_INPUT'.
      CREATE OBJECT go_message
        EXPORTING
          parent = go_container1.
      go_message->set_toolbar_mode( ).
      go_message->set_font_fixed( ).
      go_message->set_statusbar_mode( cl_gui_textedit=>false ).

      CREATE OBJECT go_container2
        EXPORTING
          container_name = 'CUSTOM_RESULT'.
      CREATE OBJECT go_result
        EXPORTING
          parent = go_container2.
      go_result->set_toolbar_mode( ).
      go_result->set_font_fixed( ).
      go_result->set_readonly_mode( ).
      go_result->set_statusbar_mode( cl_gui_textedit=>false ).
    ENDIF.

    LOOP AT SCREEN.
      IF screen-name = 'ZABAPPGP_SIGN-PASSWORD'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD user_command.

    DATA: lx_error TYPE REF TO zcx_abappgp_invalid_key.

    CASE gv_ok_code.
      WHEN 'BACK'.
        CLEAR gv_ok_code.
        LEAVE TO SCREEN 0.
      WHEN 'SIGN'.
        CLEAR gv_ok_code.
        TRY.
            call_sign( ).
          CATCH zcx_abappgp_invalid_key INTO lx_error.
            MESSAGE lx_error TYPE 'E'.
        ENDTRY.
    ENDCASE.

  ENDMETHOD.

  METHOD call_sign.

    DATA: lv_message   TYPE string,
          lv_result    TYPE string,
          lo_message   TYPE REF TO zcl_abappgp_rsa_private_key,
          lo_private   TYPE REF TO zcl_abappgp_rsa_private_key,
          lo_signature TYPE REF TO zcl_abappgp_message_06.


    go_message->get_textstream( IMPORTING text = lv_message ).
    cl_gui_cfw=>flush( ).

    lo_private = zcl_abappgp_message_03=>from_store( zabappgp_sign-key_id
      )->decrypt( zabappgp_sign-password ).

    lo_signature = zcl_abappgp_message_06=>sign(
      iv_data    = zcl_abappgp_convert=>string_to_utf8( lv_message )
      iv_issuer  = zabappgp_sign-key_id
      io_private = lo_private ).

    lv_result = lo_signature->to_armor( )->to_string( ).

    go_result->set_textstream( lv_result ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  lcl_screen_2000=>call( ).

*&---------------------------------------------------------------------*
*&      Module  STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_2000 OUTPUT.
  lcl_screen_2000=>status( ).
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.
  lcl_screen_2000=>user_command( ).
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000_E  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000_e INPUT.
  lcl_screen_2000=>user_command( ).
ENDMODULE.
