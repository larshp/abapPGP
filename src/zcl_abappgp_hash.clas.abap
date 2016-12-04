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

    CONSTANTS: lc_00     TYPE x LENGTH 1 VALUE '00',
               lc_ff     TYPE x LENGTH 1 VALUE 'FF',
               lc_init   TYPE xstring VALUE 'B704CE',
               lc_ffffff TYPE xstring VALUE 'FFFFFF'.

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

      lv_tmp = rv_hash(1). " shift 16 bits right, remove 2 rightmost bytes
      lv_tmp = ( lv_tmp BIT-XOR lv_byte ) BIT-AND lc_ff.
      lv_index = lv_tmp + 1.

      READ TABLE lt_table INDEX lv_index INTO lv_tmp.
      ASSERT sy-subrc = 0.

      CONCATENATE rv_hash+1 lc_00 INTO lv_tmp2 IN BYTE MODE. " shift 8 bits left

      rv_hash = ( lv_tmp2 BIT-XOR lv_tmp ) BIT-AND lc_ffffff.
      rv_hash = rv_hash(3).
    ENDDO.

  ENDMETHOD.


  METHOD crc24_init.

    DEFINE _add.
      append &1 to rt_table.
*      append &2 to rt_table.
*      append &3 to rt_table.
*      append &4 to rt_table.
    END-OF-DEFINITION.

    _add '000000'.
    _add '864CFB'.
    _add '8AD50D'.
    _add '0C99F6'.
    _add '93E6E1'.
    _add '15AA1A'.
    _add '1933EC'.
    _add '9F7F17'.
    _add 'A18139'.
    _add '27CDC2'.
    _add '2B5434'.
    _add 'AD18CF'.
    _add '3267D8'.
    _add 'B42B23'.
    _add 'B8B2D5'.
    _add '3EFE2E'.
    _add 'C54E89'.
    _add '430272'.
    _add '4F9B84'.
    _add 'C9D77F'.
    _add '56A868'.
    _add 'D0E493'.
    _add 'DC7D65'.
    _add '5A319E'.
    _add '64CFB0'.
    _add 'E2834B'.
    _add 'EE1ABD'.
    _add '685646'.
    _add 'F72951'.
    _add '7165AA'.
    _add '7DFC5C'.
    _add 'FBB0A7'.
    _add '0CD1E9'.
    _add '8A9D12'.
    _add '8604E4'.
    _add '00481F'.
    _add '9F3708'.
    _add '197BF3'.
    _add '15E205'.
    _add '93AEFE'.
    _add 'AD50D0'.
    _add '2B1C2B'.
    _add '2785DD'.
    _add 'A1C926'.
    _add '3EB631'.
    _add 'B8FACA'.
    _add 'B4633C'.
    _add '322FC7'.
    _add 'C99F60'.
    _add '4FD39B'.
    _add '434A6D'.
    _add 'C50696'.
    _add '5A7981'.
    _add 'DC357A'.
    _add 'D0AC8C'.
    _add '56E077'.
    _add '681E59'.
    _add 'EE52A2'.
    _add 'E2CB54'.
    _add '6487AF'.
    _add 'FBF8B8'.
    _add '7DB443'.
    _add '712DB5'.
    _add 'F7614E'.
    _add '19A3D2'.
    _add '9FEF29'.
    _add '9376DF'.
    _add '153A24'.
    _add '8A4533'.
    _add '0C09C8'.
    _add '00903E'.
    _add '86DCC5'.
    _add 'B822EB'.
    _add '3E6E10'.
    _add '32F7E6'.
    _add 'B4BB1D'.
    _add '2BC40A'.
    _add 'AD88F1'.
    _add 'A11107'.
    _add '275DFC'.
    _add 'DCED5B'.
    _add '5AA1A0'.
    _add '563856'.
    _add 'D074AD'.
    _add '4F0BBA'.
    _add 'C94741'.
    _add 'C5DEB7'.
    _add '43924C'.
    _add '7D6C62'.
    _add 'FB2099'.
    _add 'F7B96F'.
    _add '71F594'.
    _add 'EE8A83'.
    _add '68C678'.
    _add '645F8E'.
    _add 'E21375'.
    _add '15723B'.
    _add '933EC0'.
    _add '9FA736'.
    _add '19EBCD'.
    _add '8694DA'.
    _add '00D821'.
    _add '0C41D7'.
    _add '8A0D2C'.
    _add 'B4F302'.
    _add '32BFF9'.
    _add '3E260F'.
    _add 'B86AF4'.
    _add '2715E3'.
    _add 'A15918'.
    _add 'ADC0EE'.
    _add '2B8C15'.
    _add 'D03CB2'.
    _add '567049'.
    _add '5AE9BF'.
    _add 'DCA544'.
    _add '43DA53'.
    _add 'C596A8'.
    _add 'C90F5E'.
    _add '4F43A5'.
    _add '71BD8B'.
    _add 'F7F170'.
    _add 'FB6886'.
    _add '7D247D'.
    _add 'E25B6A'.
    _add '641791'.
    _add '688E67'.
    _add 'EEC29C'.
    _add '3347A4'.
    _add 'B50B5F'.
    _add 'B992A9'.
    _add '3FDE52'.
    _add 'A0A145'.
    _add '26EDBE'.
    _add '2A7448'.
    _add 'AC38B3'.
    _add '92C69D'.
    _add '148A66'.
    _add '181390'.
    _add '9E5F6B'.
    _add '01207C'.
    _add '876C87'.
    _add '8BF571'.
    _add '0DB98A'.
    _add 'F6092D'.
    _add '7045D6'.
    _add '7CDC20'.
    _add 'FA90DB'.
    _add '65EFCC'.
    _add 'E3A337'.
    _add 'EF3AC1'.
    _add '69763A'.
    _add '578814'.
    _add 'D1C4EF'.
    _add 'DD5D19'.
    _add '5B11E2'.
    _add 'C46EF5'.
    _add '42220E'.
    _add '4EBBF8'.
    _add 'C8F703'.
    _add '3F964D'.
    _add 'B9DAB6'.
    _add 'B54340'.
    _add '330FBB'.
    _add 'AC70AC'.
    _add '2A3C57'.
    _add '26A5A1'.
    _add 'A0E95A'.
    _add '9E1774'.
    _add '185B8F'.
    _add '14C279'.
    _add '928E82'.
    _add '0DF195'.
    _add '8BBD6E'.
    _add '872498'.
    _add '016863'.
    _add 'FAD8C4'.
    _add '7C943F'.
    _add '700DC9'.
    _add 'F64132'.
    _add '693E25'.
    _add 'EF72DE'.
    _add 'E3EB28'.
    _add '65A7D3'.
    _add '5B59FD'.
    _add 'DD1506'.
    _add 'D18CF0'.
    _add '57C00B'.
    _add 'C8BF1C'.
    _add '4EF3E7'.
    _add '426A11'.
    _add 'C426EA'.
    _add '2AE476'.
    _add 'ACA88D'.
    _add 'A0317B'.
    _add '267D80'.
    _add 'B90297'.
    _add '3F4E6C'.
    _add '33D79A'.
    _add 'B59B61'.
    _add '8B654F'.
    _add '0D29B4'.
    _add '01B042'.
    _add '87FCB9'.
    _add '1883AE'.
    _add '9ECF55'.
    _add '9256A3'.
    _add '141A58'.
    _add 'EFAAFF'.
    _add '69E604'.
    _add '657FF2'.
    _add 'E33309'.
    _add '7C4C1E'.
    _add 'FA00E5'.
    _add 'F69913'.
    _add '70D5E8'.
    _add '4E2BC6'.
    _add 'C8673D'.
    _add 'C4FECB'.
    _add '42B230'.
    _add 'DDCD27'.
    _add '5B81DC'.
    _add '57182A'.
    _add 'D154D1'.
    _add '26359F'.
    _add 'A07964'.
    _add 'ACE092'.
    _add '2AAC69'.
    _add 'B5D37E'.
    _add '339F85'.
    _add '3F0673'.
    _add 'B94A88'.
    _add '87B4A6'.
    _add '01F85D'.
    _add '0D61AB'.
    _add '8B2D50'.
    _add '145247'.
    _add '921EBC'.
    _add '9E874A'.
    _add '18CBB1'.
    _add 'E37B16'.
    _add '6537ED'.
    _add '69AE1B'.
    _add 'EFE2E0'.
    _add '709DF7'.
    _add 'F6D10C'.
    _add 'FA48FA'.
    _add '7C0401'.
    _add '42FA2F'.
    _add 'C4B6D4'.
    _add 'C82F22'.
    _add '4E63D9'.
    _add 'D11CCE'.
    _add '575035'.
    _add '5BC9C3'.
    _add 'DD8538'.

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