CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lv_public  TYPE string,
          li_message TYPE REF TO zif_abappgp_message.


    lv_public = zcl_abappgp_unit_test=>get_public_key( ).

    zcl_abappgp_unit_test=>message_identity( lv_public ).

  ENDMETHOD.

ENDCLASS.
