CLASS zcl_abappgp_unit_test DEFINITION
  PUBLIC
  CREATE PUBLIC
  FOR TESTING .

  PUBLIC SECTION.

    CLASS-METHODS packet_identity
      IMPORTING
        !io_data      TYPE REF TO zcl_abappgp_stream
        !iv_tag       TYPE zif_abappgp_constants=>ty_tag
      RETURNING
        VALUE(ri_pkt) TYPE REF TO zif_abappgp_packet .
    CLASS-METHODS subpacket_identity
      IMPORTING
        !iv_data      TYPE xstring
        !iv_type      TYPE zif_abappgp_constants=>ty_sub_type
      RETURNING
        VALUE(ri_sub) TYPE REF TO zif_abappgp_subpacket .
    CLASS-METHODS get_message
      RETURNING
        VALUE(rv_message) TYPE string .
    CLASS-METHODS get_private_key
      RETURNING
        VALUE(rv_key) TYPE string .
    CLASS-METHODS get_public_key
      RETURNING
        VALUE(rv_key) TYPE string .
    CLASS-METHODS get_signature
      RETURNING
        VALUE(rv_signature) TYPE string .
    CLASS-METHODS message_identity
      IMPORTING
        !iv_armor         TYPE string
      RETURNING
        VALUE(ri_message) TYPE REF TO zif_abappgp_message .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_UNIT_TEST IMPLEMENTATION.


  METHOD get_message.

    CONCATENATE
      '-----BEGIN PGP MESSAGE-----'
      'Version: OpenPGP.js v2.3.5'
      'Comment: http://openpgpjs.org'
      ''
      'wYwDrPvTeiy+4BgBBACKAU4oGeQ6MUS9Cw9F1+TNeiS4XAY/X0KBUwCArdaS'
      's+JcEg9pecvhYI4PW+AwYyLurdJBK5xf/ayWc3rU4JmWFq2rflBZSDARLmOJ'
      'Mo+lV/OT3lmfjLPVP83wEUE1AvCavKXl2bYnjBnRnNdYetRCxxgbHOc9Gcq8'
      'JNfAVu6kGNLAMgG011ntqdqF7lguIuxvanoxhgrLmFRz+TP6TCN4Ak8Tj48I'
      '5hUuDgzk9bE3jNGWIT6CobclPP7P7S1/wVrCgfZhnoLah0LbwjN0HVMan08I'
      'W8KLjKu6uMLAf9QgyW3vKPJPqsERNqZNgPzCyofmubHcd9yIcD20dmY1uAml'
      '2g6Jx3ZeI55a5DGO7xwuvxLcXHjflWSMCu7qlY+PxSyirzHU4BaeEZCoozsi'
      'wDtBuGbJb3BtOrpLpAnlSDTA4WU/z50risxqSb9XtbbQTgAhdyMXR0il+K3a'
      'fnzuF2o/A4Z+JfYgWMt4UQGDOCrRhqBVsMTd'
      '=gGCj'
      '-----END PGP MESSAGE-----'
      INTO rv_message
      SEPARATED BY cl_abap_char_utilities=>newline.

  ENDMETHOD.


  METHOD get_private_key.

* password: testtest

    CONCATENATE
      '-----BEGIN PGP PRIVATE KEY BLOCK-----'
      'Version: OpenPGP.js v2.0.0'
      'Comment: http://openpgpjs.org'
      ''
      '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'
      'yd50AMsn0I5wjg=='
      '=USF2'
      '-----END PGP PRIVATE KEY BLOCK-----'
      INTO rv_key
      SEPARATED BY cl_abap_char_utilities=>newline.

  ENDMETHOD.


  METHOD get_public_key.

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
      INTO rv_key
      SEPARATED BY cl_abap_char_utilities=>newline.

  ENDMETHOD.


  METHOD get_signature.

    CONCATENATE
      '-----BEGIN PGP SIGNATURE-----'
      'Version: OpenPGP.js v2.3.5'
      'Comment: http://openpgpjs.org'
      ''
      'wpwEAQEIABAFAlhNZj4JEGXaArXjyh3hAADI7QP/Zbp4FlyJ4+pYJhfb8Btr'
      'TyDw+9JKTpQm+OTEQIchxx8Cz194CZotxSrnv+UgewYG37NokrXAGw/92CXA'
      'nY8CLxS5nkVj7uqm0280riY3z6c9tB48mQE51SgpJXOdZ6Xwhyg3Y67qQ2kI'
      'qT7LM/NqmLzmCoSN4IL3R98sPgEK+fQ='
      '=0qk7'
      '-----END PGP SIGNATURE-----'
      INTO rv_signature
      SEPARATED BY cl_abap_char_utilities=>newline.

  ENDMETHOD.


  METHOD message_identity.

    DATA: lv_result TYPE xstring.


    ri_message = zcl_abappgp_message_factory=>create( iv_armor ).

    lv_result = ri_message->to_armor( )->to_string( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = iv_armor ).

  ENDMETHOD.


  METHOD packet_identity.

    DATA: lv_result TYPE xstring,
          lv_data   TYPE xstring.


    lv_data = io_data->get_data( ).

    ri_pkt = zcl_abappgp_packet_factory=>create(
      io_data = io_data
      iv_tag  = iv_tag ).

    lv_result = ri_pkt->to_stream( )->get_data( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = lv_data ).

  ENDMETHOD.


  METHOD subpacket_identity.

    DATA: lv_result TYPE xstring.


    ri_sub = zcl_abappgp_subpacket_factory=>create(
      iv_data = iv_data
      iv_type = iv_type ).

    lv_result = ri_sub->to_stream( )->get_data( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = iv_data ).

  ENDMETHOD.
ENDCLASS.