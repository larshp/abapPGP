CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lv_signature TYPE string.


    lv_signature = zcl_abappgp_unit_test=>get_signature( ).

    zcl_abappgp_unit_test=>message_identity( lv_signature ).

  ENDMETHOD.

ENDCLASS.