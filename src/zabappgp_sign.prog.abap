REPORT zabappgp_sign.

TABLES: zabappgp_sign.

DATA: gv_ok_code LIKE sy-ucomm.


CLASS lcl_screen_3000 DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
      call
        IMPORTING
          iv_key_id   TYPE zabappgp_key_id
          iv_password TYPE zabappgp_password
          iv_message  TYPE string
        RAISING
          zcx_abappgp_invalid_key,
      status,
      user_command.

  PRIVATE SECTION.
    CLASS-DATA:
      mv_result    TYPE string,
      go_container TYPE REF TO cl_gui_custom_container,
      go_result    TYPE REF TO cl_gui_textedit.

ENDCLASS.

CLASS lcl_screen_3000 IMPLEMENTATION.

  METHOD call.

    DATA: lo_message   TYPE REF TO zcl_abappgp_rsa_private_key,
          lo_private   TYPE REF TO zcl_abappgp_rsa_private_key,
          lo_signature TYPE REF TO zcl_abappgp_message_06.


    lo_private = zcl_abappgp_message_03=>from_store( iv_key_id )->decrypt( iv_password ).

    lo_signature = zcl_abappgp_message_06=>sign(
      iv_data    = zcl_abappgp_convert=>string_to_utf8( iv_message )
      iv_issuer  = iv_key_id
      io_private = lo_private ).

    mv_result = lo_signature->to_armor( )->to_string( ).

    CALL SCREEN 3000.

  ENDMETHOD.

  METHOD status.

    SET PF-STATUS 'SCREEN_3000'.
    SET TITLEBAR 'TITLE_3000'.

    IF NOT go_container IS BOUND.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CUSTOM_3000'.
      CREATE OBJECT go_result
        EXPORTING
          parent = go_container.
      go_result->set_toolbar_mode( ).
      go_result->set_font_fixed( ).
    ENDIF.

    go_result->set_textstream( mv_result ).

  ENDMETHOD.

  METHOD user_command.
    CASE gv_ok_code.
      WHEN 'BACK'.
        CLEAR gv_ok_code.
        LEAVE TO SCREEN 0.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_screen_2000 DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
      call,
      status,
      user_command
        RAISING
          zcx_abappgp_invalid_key.

  PRIVATE SECTION.
    CLASS-DATA:
      go_container TYPE REF TO cl_gui_custom_container,
      go_message   TYPE REF TO cl_gui_textedit.

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

    IF NOT go_container IS BOUND.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CUSTOM_2000'.
      CREATE OBJECT go_message
        EXPORTING
          parent = go_container.
      go_message->set_toolbar_mode( ).
      go_message->set_font_fixed( ).
    ENDIF.
  ENDMETHOD.

  METHOD user_command.
    CASE gv_ok_code.
      WHEN 'BACK'.
        CLEAR gv_ok_code.
        LEAVE TO SCREEN 0.
      WHEN 'SIGN'.
        CLEAR gv_ok_code.
        call_sign( ).
    ENDCASE.
  ENDMETHOD.

  METHOD call_sign.

    DATA: lv_message TYPE string.


    go_message->get_textstream( IMPORTING text = lv_message ).
    cl_gui_cfw=>flush( ).

    lcl_screen_3000=>call(
      iv_key_id   = zabappgp_sign-key_id
      iv_password = zabappgp_sign-password
      iv_message  = lv_message ).

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
*&      Module  STATUS_3000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_3000 OUTPUT.
  lcl_screen_3000=>status( ).
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3000 INPUT.
  lcl_screen_3000=>user_command( ).
ENDMODULE.