class ZCL_ABAPPGP_MESSAGE_FACTORY definition
  public
  create public .

public section.

  class-methods CREATE
    importing
      !IV_ARMOR type STRING
    returning
      value(RI_MESSAGE) type ref to ZIF_ABAPPGP_MESSAGE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_MESSAGE_FACTORY IMPLEMENTATION.


  METHOD create.

    DATA: lv_header TYPE string,
          lo_armor  TYPE REF TO zcl_abappgp_armor.


    lo_armor = zcl_abappgp_armor=>from_string( iv_armor ).

    lv_header = lo_armor->get_armor_header( ).

    IF lv_header = zcl_abappgp_armor=>c_header-message.
      ri_message = zcl_abappgp_message_01=>from_armor( lo_armor ).
    ELSEIF lv_header = zcl_abappgp_armor=>c_header-public.
      ri_message = zcl_abappgp_message_02=>from_armor( lo_armor ).
    ELSEIF lv_header = zcl_abappgp_armor=>c_header-private.
      ri_message = zcl_abappgp_message_03=>from_armor( lo_armor ).
    ELSEIF lv_header CP zcl_abappgp_armor=>c_header-messagexx.
* todo, 04
      ASSERT 0 = 1.
    ELSEIF lv_header CP zcl_abappgp_armor=>c_header-messagex.
* todo, 05
      ASSERT 0 = 1.
    ELSEIF lv_header = zcl_abappgp_armor=>c_header-signature.
      ri_message = zcl_abappgp_message_06=>from_armor( lo_armor ).
    ELSEIF lv_header = zcl_abappgp_armor=>c_header-signed.
* todo, 07
      ASSERT 0 = 1.
    ELSE.
* unknown message type
      ASSERT 0 = 1.
    ENDIF.

  ENDMETHOD.
ENDCLASS.