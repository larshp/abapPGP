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

    IF lv_header = '-----BEGIN PGP MESSAGE-----'.
* todo
      ASSERT 0 = 1.
    ELSEIF lv_header = '-----BEGIN PGP PUBLIC KEY BLOCK-----'.
      ri_message = zcl_abappgp_message_02=>from_armor( lo_armor ).
    ELSEIF lv_header = '-----BEGIN PGP PRIVATE KEY BLOCK-----'.
      ri_message = zcl_abappgp_message_03=>from_armor( lo_armor ).
    ELSEIF lv_header CP '-----BEGIN PGP MESSAGE, PART +*/+*-----'.
* todo
      ASSERT 0 = 1.
    ELSEIF lv_header CP '-----BEGIN PGP MESSAGE, PART +*-----'.
* todo
      ASSERT 0 = 1.
    ELSEIF lv_header = '-----BEGIN PGP SIGNATURE-----'.
* todo
      ASSERT 0 = 1.
    ELSE.
* unknown message type
      ASSERT 0 = 1.
    ENDIF.

  ENDMETHOD.
ENDCLASS.