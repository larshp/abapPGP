
CLASS ltcl_pkcs1_emse DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS pkcs1_emse FOR TESTING.

ENDCLASS.       "ltcl_Pkcs1_Emse

CLASS ltcl_pkcs1_emse IMPLEMENTATION.

  METHOD pkcs1_emse.

    DATA: lv_em TYPE xstring,
          lv_m  TYPE xstring VALUE '001122334455667788'.


    lv_em = zcl_abappgp_encode=>pkcs1_emse( lv_m ).

    cl_abap_unit_assert=>assert_not_initial( lv_em ).


  ENDMETHOD.

ENDCLASS.
