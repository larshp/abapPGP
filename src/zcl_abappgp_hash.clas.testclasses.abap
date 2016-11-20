CLASS ltcl_sha256 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: test
      IMPORTING iv_input    TYPE string
                iv_expected TYPE xstring.

    METHODS: test01 FOR TESTING.

ENDCLASS.       "ltcl_Sha256

CLASS ltcl_sha256 IMPLEMENTATION.

  METHOD test.

    DATA: lv_hash TYPE xstring.


    lv_hash = zcl_abappgp_hash=>sha256( zcl_abappgp_convert=>string_to_utf8( iv_input ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = iv_expected ).

  ENDMETHOD.

  METHOD test01.

    test( iv_input    = 'abc'
          iv_expected = 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_crc24 DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: test
      IMPORTING iv_input    TYPE string
                iv_expected TYPE xstring.

    METHODS:
      test01 FOR TESTING,
      test02 FOR TESTING.

ENDCLASS.       "ltcl_Crc24

CLASS ltcl_crc24 IMPLEMENTATION.

  METHOD test.

    DATA: lv_hash TYPE xstring.


    lv_hash = zcl_abappgp_hash=>crc24( zcl_abappgp_convert=>string_to_utf8( iv_input ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hash
      exp = iv_expected ).

  ENDMETHOD.

  METHOD test02.

    test( iv_input    = '010203040506'
          iv_expected = 'BC7E06' ).

  ENDMETHOD.

  METHOD test01.

    test( iv_input    = '00000000'
          iv_expected = '000000' ).

  ENDMETHOD.

ENDCLASS.