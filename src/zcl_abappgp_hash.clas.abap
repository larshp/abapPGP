class ZCL_ABAPPGP_HASH definition
  public
  create public .

public section.

  class-methods CRC24
    importing
      !IV_DATA type XSTRING
    returning
      value(RV_HASH) type XSTRING .
  class-methods SHA256
    importing
      !IV_INPUT type XSTRING
    returning
      value(RV_HASH) type XSTRING .
protected section.

  types:
    ty_table_tt TYPE STANDARD TABLE OF xstring WITH DEFAULT KEY .

  class-methods CRC24_INIT
    returning
      value(RT_TABLE) type TY_TABLE_TT .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_HASH IMPLEMENTATION.


  METHOD crc24.
* https://tools.ietf.org/html/rfc4880#section-6.1

    CONSTANTS: lc_gen    TYPE xstring VALUE '864CFB',
               lc_ff     TYPE x LENGTH 1 VALUE 'FF',
               lc_ffffff TYPE xstring VALUE 'FFFFFF',
               lc_init   TYPE xstring VALUE 'B704CE'.

    DATA: lv_index TYPE i,
          lt_table TYPE ty_table_tt,
          lv_tmp   LIKE rv_hash,
          lv_tmp2  LIKE rv_hash,
          lv_byte  TYPE x LENGTH 1.


    ASSERT xstrlen( iv_data ) > 0.

    lt_table = zcl_abappgp_hash=>crc24_init( ).

    rv_hash = lc_init.

    DO xstrlen( iv_data ) TIMES.
      lv_index = sy-index - 1.
      lv_byte = iv_data+lv_index(1).

      lv_tmp = rv_hash.
      SHIFT lv_tmp BY 2 PLACES RIGHT IN BYTE MODE.
      lv_tmp = ( lv_tmp BIT-XOR lv_byte ) BIT-AND lc_ff.
      lv_index = lv_tmp + 1.

      READ TABLE lt_table INDEX lv_index INTO lv_tmp.
      ASSERT sy-subrc = 0.

      lv_tmp2 = rv_hash.
      SHIFT lv_tmp2 BY 1 PLACES LEFT IN BYTE MODE.

      rv_hash = ( lv_tmp2 BIT-XOR lv_tmp ) BIT-AND lc_ffffff.
    ENDDO.

  ENDMETHOD.


  METHOD crc24_init.

    DATA: lt_table TYPE STANDARD TABLE OF xstring.

    DEFINE _add.
      append &1 to rt_table.
    END-OF-DEFINITION.

    _add '00000000'.
    _add '00864CFB'.
    _add '018AD50D'.
    _add '010C99F6'.
    _add '0393E6E1'.
    _add '0315AA1A'.
    _add '021933EC'.
    _add '029F7F17'.
    _add '07A18139'.
    _add '0727CDC2'.
    _add '062B5434'.
    _add '06AD18CF'.
    _add '043267D8'.
    _add '04B42B23'.
    _add '05B8B2D5'.
    _add '053EFE2E'.
    _add '0FC54E89'.
    _add '0F430272'.
    _add '0E4F9B84'.
    _add '0EC9D77F'.
    _add '0C56A868'.
    _add '0CD0E493'.
    _add '0DDC7D65'.
    _add '0D5A319E'.
    _add '0864CFB0'.
    _add '08E2834B'.
    _add '09EE1ABD'.
    _add '09685646'.
    _add '0BF72951'.
    _add '0B7165AA'.
    _add '0A7DFC5C'.
    _add '0AFBB0A7'.
    _add '1F0CD1E9'.
    _add '1F8A9D12'.
    _add '1E8604E4'.
    _add '1E00481F'.
    _add '1C9F3708'.
    _add '1C197BF3'.
    _add '1D15E205'.
    _add '1D93AEFE'.
    _add '18AD50D0'.
    _add '182B1C2B'.
    _add '192785DD'.
    _add '19A1C926'.
    _add '1B3EB631'.
    _add '1BB8FACA'.
    _add '1AB4633C'.
    _add '1A322FC7'.
    _add '10C99F60'.
    _add '104FD39B'.
    _add '11434A6D'.
    _add '11C50696'.
    _add '135A7981'.
    _add '13DC357A'.
    _add '12D0AC8C'.
    _add '1256E077'.
    _add '17681E59'.
    _add '17EE52A2'.
    _add '16E2CB54'.
    _add '166487AF'.
    _add '14FBF8B8'.
    _add '147DB443'.
    _add '15712DB5'.
    _add '15F7614E'.
    _add '3E19A3D2'.
    _add '3E9FEF29'.
    _add '3F9376DF'.
    _add '3F153A24'.
    _add '3D8A4533'.
    _add '3D0C09C8'.
    _add '3C00903E'.
    _add '3C86DCC5'.
    _add '39B822EB'.
    _add '393E6E10'.
    _add '3832F7E6'.
    _add '38B4BB1D'.
    _add '3A2BC40A'.
    _add '3AAD88F1'.
    _add '3BA11107'.
    _add '3B275DFC'.
    _add '31DCED5B'.
    _add '315AA1A0'.
    _add '30563856'.
    _add '30D074AD'.
    _add '324F0BBA'.
    _add '32C94741'.
    _add '33C5DEB7'.
    _add '3343924C'.
    _add '367D6C62'.
    _add '36FB2099'.
    _add '37F7B96F'.
    _add '3771F594'.
    _add '35EE8A83'.
    _add '3568C678'.
    _add '34645F8E'.
    _add '34E21375'.
    _add '2115723B'.
    _add '21933EC0'.
    _add '209FA736'.
    _add '2019EBCD'.
    _add '228694DA'.
    _add '2200D821'.
    _add '230C41D7'.
    _add '238A0D2C'.
    _add '26B4F302'.
    _add '2632BFF9'.
    _add '273E260F'.
    _add '27B86AF4'.
    _add '252715E3'.
    _add '25A15918'.
    _add '24ADC0EE'.
    _add '242B8C15'.
    _add '2ED03CB2'.
    _add '2E567049'.
    _add '2F5AE9BF'.
    _add '2FDCA544'.
    _add '2D43DA53'.
    _add '2DC596A8'.
    _add '2CC90F5E'.
    _add '2C4F43A5'.
    _add '2971BD8B'.
    _add '29F7F170'.
    _add '28FB6886'.
    _add '287D247D'.
    _add '2AE25B6A'.
    _add '2A641791'.
    _add '2B688E67'.
    _add '2BEEC29C'.
    _add '7C3347A4'.
    _add '7CB50B5F'.
    _add '7DB992A9'.
    _add '7D3FDE52'.
    _add '7FA0A145'.
    _add '7F26EDBE'.
    _add '7E2A7448'.
    _add '7EAC38B3'.
    _add '7B92C69D'.
    _add '7B148A66'.
    _add '7A181390'.
    _add '7A9E5F6B'.
    _add '7801207C'.
    _add '78876C87'.
    _add '798BF571'.
    _add '790DB98A'.
    _add '73F6092D'.
    _add '737045D6'.
    _add '727CDC20'.
    _add '72FA90DB'.
    _add '7065EFCC'.
    _add '70E3A337'.
    _add '71EF3AC1'.
    _add '7169763A'.
    _add '74578814'.
    _add '74D1C4EF'.
    _add '75DD5D19'.
    _add '755B11E2'.
    _add '77C46EF5'.
    _add '7742220E'.
    _add '764EBBF8'.
    _add '76C8F703'.
    _add '633F964D'.
    _add '63B9DAB6'.
    _add '62B54340'.
    _add '62330FBB'.
    _add '60AC70AC'.
    _add '602A3C57'.
    _add '6126A5A1'.
    _add '61A0E95A'.
    _add '649E1774'.
    _add '64185B8F'.
    _add '6514C279'.
    _add '65928E82'.
    _add '670DF195'.
    _add '678BBD6E'.
    _add '66872498'.
    _add '66016863'.
    _add '6CFAD8C4'.
    _add '6C7C943F'.
    _add '6D700DC9'.
    _add '6DF64132'.
    _add '6F693E25'.
    _add '6FEF72DE'.
    _add '6EE3EB28'.
    _add '6E65A7D3'.
    _add '6B5B59FD'.
    _add '6BDD1506'.
    _add '6AD18CF0'.
    _add '6A57C00B'.
    _add '68C8BF1C'.
    _add '684EF3E7'.
    _add '69426A11'.
    _add '69C426EA'.
    _add '422AE476'.
    _add '42ACA88D'.
    _add '43A0317B'.
    _add '43267D80'.
    _add '41B90297'.
    _add '413F4E6C'.
    _add '4033D79A'.
    _add '40B59B61'.
    _add '458B654F'.
    _add '450D29B4'.
    _add '4401B042'.
    _add '4487FCB9'.
    _add '461883AE'.
    _add '469ECF55'.
    _add '479256A3'.
    _add '47141A58'.
    _add '4DEFAAFF'.
    _add '4D69E604'.
    _add '4C657FF2'.
    _add '4CE33309'.
    _add '4E7C4C1E'.
    _add '4EFA00E5'.
    _add '4FF69913'.
    _add '4F70D5E8'.
    _add '4A4E2BC6'.
    _add '4AC8673D'.
    _add '4BC4FECB'.
    _add '4B42B230'.
    _add '49DDCD27'.
    _add '495B81DC'.
    _add '4857182A'.
    _add '48D154D1'.
    _add '5D26359F'.
    _add '5DA07964'.
    _add '5CACE092'.
    _add '5C2AAC69'.
    _add '5EB5D37E'.
    _add '5E339F85'.
    _add '5F3F0673'.
    _add '5FB94A88'.
    _add '5A87B4A6'.
    _add '5A01F85D'.
    _add '5B0D61AB'.
    _add '5B8B2D50'.
    _add '59145247'.
    _add '59921EBC'.
    _add '589E874A'.
    _add '5818CBB1'.
    _add '52E37B16'.
    _add '526537ED'.
    _add '5369AE1B'.
    _add '53EFE2E0'.
    _add '51709DF7'.
    _add '51F6D10C'.
    _add '50FA48FA'.
    _add '507C0401'.
    _add '5542FA2F'.
    _add '55C4B6D4'.
    _add '54C82F22'.
    _add '544E63D9'.
    _add '56D11CCE'.
    _add '56575035'.
    _add '575BC9C3'.
    _add '57DD8538'.

  ENDMETHOD.


  METHOD sha256.

    TRY.
        cl_abap_message_digest=>calculate_hash_for_raw(
          EXPORTING
            if_algorithm   = 'SHA256'
            if_data        = iv_input
          IMPORTING
            ef_hashxstring = rv_hash ).
      CATCH cx_abap_message_digest.
        ASSERT 0 = 1.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.