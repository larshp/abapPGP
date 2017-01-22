
CLASS ltcl_format_unix DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.

    METHODS: format_unix FOR TESTING.

ENDCLASS.       "ltcl_Format_Unix


CLASS ltcl_format_unix IMPLEMENTATION.

  METHOD format_unix.

    DATA: lv_formatted TYPE string.


    lv_formatted = zcl_abappgp_time=>format_unix( 1479483416 ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_formatted
      exp = '20161118 153656' ).

  ENDMETHOD.

ENDCLASS.
