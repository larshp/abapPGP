
CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: test FOR TESTING.

ENDCLASS.       "ltcl_Test


CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lv_armor  TYPE string,
          lv_result TYPE string,
          lo_armor  TYPE REF TO zcl_abappgp_armor.


    CONCATENATE
      '-----BEGIN PGP PUBLIC KEY BLOCK-----'
      'Version: foo'
      ''
      'DATA'
      '=80MV'
      '-----END PGP PUBLIC KEY BLOCK-----'
      INTO lv_armor
      SEPARATED BY cl_abap_char_utilities=>newline.

    lo_armor = zcl_abappgp_armor=>from_string( lv_armor ).

    lv_result = lo_armor->to_string( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = lv_armor ).

  ENDMETHOD.

ENDCLASS.