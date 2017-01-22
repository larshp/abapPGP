CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test01 FOR TESTING,
      test02 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD test01.
    zcl_abappgp_unit_test=>subpacket_identity(
      iv_data = '03'
      iv_type = zif_abappgp_constants=>c_sub_type-key_flags ).
  ENDMETHOD.

  METHOD test02.
    zcl_abappgp_unit_test=>subpacket_identity(
      iv_data = '0C'
      iv_type = zif_abappgp_constants=>c_sub_type-key_flags ).
  ENDMETHOD.

ENDCLASS.
