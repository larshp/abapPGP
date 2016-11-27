
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
      'Version: OpenPGP.js v2.0.0'
      'Comment: http://openpgpjs.org'
      ''
      'xo0EWC2+6gEEAN05FaocuNPecRuGy61ugl50W9jvla1+LabAdQ3LWwiJ2jMX'
      '2C6SGHXaQ7YmuSUtrl7dVeyNA0Zs60e9JsLnU6DnvsQNuMaJHACww4eknNMi'
      'VQi9U0RAJssYeGu0VqPfPdtnwCcntcV+uDkWIqam6l7uiSDGOEKiqWMNacA3'
      'kp7zABEBAAHNEUZvbyA8Zm9vQGJhci5jb20+wrUEEAEIACkFAlgtvuoGCwkI'
      'BwMCCRBl2gK148od4QQVCAIKAxYCAQIZAQIbAwIeAQAA7agD/3g4zaTXpfnz'
      'ugNaadGYu/SdrUt0AyFOoTYzMMOo1JXXMy8j4FOPA8FHZ290RhYtZVxjDyLL'
      '/rlb+sgn22BubaVqtcF84ga4RLdRGK9p/mlSb91YO/0DWTqSUZh16sXIhiGu'
      'S0IcYnLwOfok2AT6ka9GWwXbxtreNN90if7MiCJzzo0EWC2+6gEEALkkmnMH'
      'Ak/INHIDbuQOC35pZr/gxsHSCaxRtstI4O84mUbm6RqPJmCG8sWTapEgyoV5'
      'yZaN655XANiaEqIfUnDKvrWbIEkNGDu9XYqFnjUBZo3VZ72rFbwVxzeohJUY'
      'qAnDvHUZtcJyIg+s+SPnzAEToKYiH8ScvY9L4LjgpkmLABEBAAHCnwQYAQgA'
      'EwUCWC2+6gkQZdoCtePKHeECGwwAAMJoA/98i5ZOibcAihHKFgJ5F2Lc4gEH'
      'DRvFyxas6eu6P/zAqsazBeBk1IY9Ae0LjpkehrlhfJe1+qjX4EVC4Cz9sfbe'
      'gI6bCt1Jdt3xJBKF0vzjC5ux/SCqTAqVSjZ8QyuJnaU2azAcW8vmFwnlox+j'
      '1ozJvbr1ndbEyd50AMsn0I5wjg=='
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