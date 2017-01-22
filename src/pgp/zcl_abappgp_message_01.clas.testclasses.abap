CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lv_message TYPE string.


    lv_message = zcl_abappgp_unit_test=>get_message( ).

    zcl_abappgp_unit_test=>message_identity( lv_message ).

  ENDMETHOD.

ENDCLASS.
