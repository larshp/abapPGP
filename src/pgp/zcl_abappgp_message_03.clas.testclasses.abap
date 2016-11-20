CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test FOR TESTING.

ENDCLASS.       "ltcl_Test


CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA: lv_text    TYPE string,
          li_message TYPE REF TO zif_abappgp_message.


    CONCATENATE
      '-----BEGIN PGP PRIVATE KEY BLOCK-----'
      'Version: OpenPGP.js v2.0.0'
      'Comment: http://openpgpjs.org'
      ''
      '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'
      'yd50AMsn0I5wjg=='
      '=USF2'
      '-----END PGP PRIVATE KEY BLOCK-----'
      INTO lv_text
      SEPARATED BY cl_abap_char_utilities=>newline.

    li_message = zcl_abappgp_message_03=>from_armor(
      zcl_abappgp_armor=>from_string( lv_text ) ).

    DATA(lv_str) = li_message->dump( ).
* todo

  ENDMETHOD.

ENDCLASS.