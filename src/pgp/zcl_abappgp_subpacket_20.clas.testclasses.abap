CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    zcl_abappgp_unit_test=>subpacket_identity(
      iv_data = 'A'
      iv_type = zif_abappgp_constants=>c_sub_type-notation_data ).

  ENDMETHOD.

ENDCLASS.