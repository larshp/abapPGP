CLASS ltcl_build_key DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING.

ENDCLASS.       "ltcl_Build_Key

CLASS ltcl_build_key IMPLEMENTATION.

  METHOD test01.

    DATA: lo_s2k TYPE REF TO zcl_abappgp_string_to_key,
          lv_exp TYPE xstring,
          lv_key TYPE xstring.


    CREATE OBJECT lo_s2k
      EXPORTING
        iv_type  = zif_abappgp_constants=>c_s2k_type-iterated_salted
        iv_hash  = zif_abappgp_constants=>c_algorithm_hash-sha256
        iv_salt  = '5B6474F1397A257D'
        iv_count = '96'.

    lv_key = lo_s2k->build_key( 'testtest' ).

    cl_abap_unit_assert=>assert_not_initial( lv_key ).

    lv_exp = '6AAF4172CF8B4CE14E979E642008D71AA14BDF7A9382D37CE4BB7B5F55EB5A9D'.

    cl_abap_unit_assert=>assert_equals(
      act = lv_key
      exp = lv_exp ).

  ENDMETHOD.

ENDCLASS.
