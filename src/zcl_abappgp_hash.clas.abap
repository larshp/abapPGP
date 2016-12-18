CLASS zcl_abappgp_hash DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS crc24
      IMPORTING
        !iv_data       TYPE xstring
      RETURNING
        VALUE(rv_hash) TYPE xstring .
    CLASS-METHODS sha256
      IMPORTING
        !iv_input      TYPE xstring
      RETURNING
        VALUE(rv_hash) TYPE xstring .
    CLASS-METHODS sha1
      IMPORTING
        !iv_data       TYPE xstring
      RETURNING
        VALUE(rv_hash) TYPE xstring .
  PROTECTED SECTION.

    TYPES:
      ty_table_tt TYPE STANDARD TABLE OF xstring WITH DEFAULT KEY .

    CLASS-METHODS crc24_init
      RETURNING
        VALUE(rt_table) TYPE ty_table_tt .
  PRIVATE SECTION.
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
      append &2 to rt_table.
      append &3 to rt_table.
      append &4 to rt_table.
    END-OF-DEFINITION.

    _add '000000' '864CFB' '8AD50D' '0C99F6'.
    _add '93E6E1' '15AA1A' '1933EC' '9F7F17'.
    _add 'A18139' '27CDC2' '2B5434' 'AD18CF'.
    _add '3267D8' 'B42B23' 'B8B2D5' '3EFE2E'.
    _add 'C54E89' '430272' '4F9B84' 'C9D77F'.
    _add '56A868' 'D0E493' 'DC7D65' '5A319E'.
    _add '64CFB0' 'E2834B' 'EE1ABD' '685646'.
    _add 'F72951' '7165AA' '7DFC5C' 'FBB0A7'.
    _add '0CD1E9' '8A9D12' '8604E4' '00481F'.
    _add '9F3708' '197BF3' '15E205' '93AEFE'.
    _add 'AD50D0' '2B1C2B' '2785DD' 'A1C926'.
    _add '3EB631' 'B8FACA' 'B4633C' '322FC7'.
    _add 'C99F60' '4FD39B' '434A6D' 'C50696'.
    _add '5A7981' 'DC357A' 'D0AC8C' '56E077'.
    _add '681E59' 'EE52A2' 'E2CB54' '6487AF'.
    _add 'FBF8B8' '7DB443' '712DB5' 'F7614E'.
    _add '19A3D2' '9FEF29' '9376DF' '153A24'.
    _add '8A4533' '0C09C8' '00903E' '86DCC5'.
    _add 'B822EB' '3E6E10' '32F7E6' 'B4BB1D'.
    _add '2BC40A' 'AD88F1' 'A11107' '275DFC'.
    _add 'DCED5B' '5AA1A0' '563856' 'D074AD'.
    _add '4F0BBA' 'C94741' 'C5DEB7' '43924C'.
    _add '7D6C62' 'FB2099' 'F7B96F' '71F594'.
    _add 'EE8A83' '68C678' '645F8E' 'E21375'.
    _add '15723B' '933EC0' '9FA736' '19EBCD'.
    _add '8694DA' '00D821' '0C41D7' '8A0D2C'.
    _add 'B4F302' '32BFF9' '3E260F' 'B86AF4'.
    _add '2715E3' 'A15918' 'ADC0EE' '2B8C15'.
    _add 'D03CB2' '567049' '5AE9BF' 'DCA544'.
    _add '43DA53' 'C596A8' 'C90F5E' '4F43A5'.
    _add '71BD8B' 'F7F170' 'FB6886' '7D247D'.
    _add 'E25B6A' '641791' '688E67' 'EEC29C'.
    _add '3347A4' 'B50B5F' 'B992A9' '3FDE52'.
    _add 'A0A145' '26EDBE' '2A7448' 'AC38B3'.
    _add '92C69D' '148A66' '181390' '9E5F6B'.
    _add '01207C' '876C87' '8BF571' '0DB98A'.
    _add 'F6092D' '7045D6' '7CDC20' 'FA90DB'.
    _add '65EFCC' 'E3A337' 'EF3AC1' '69763A'.
    _add '578814' 'D1C4EF' 'DD5D19' '5B11E2'.
    _add 'C46EF5' '42220E' '4EBBF8' 'C8F703'.
    _add '3F964D' 'B9DAB6' 'B54340' '330FBB'.
    _add 'AC70AC' '2A3C57' '26A5A1' 'A0E95A'.
    _add '9E1774' '185B8F' '14C279' '928E82'.
    _add '0DF195' '8BBD6E' '872498' '016863'.
    _add 'FAD8C4' '7C943F' '700DC9' 'F64132'.
    _add '693E25' 'EF72DE' 'E3EB28' '65A7D3'.
    _add '5B59FD' 'DD1506' 'D18CF0' '57C00B'.
    _add 'C8BF1C' '4EF3E7' '426A11' 'C426EA'.
    _add '2AE476' 'ACA88D' 'A0317B' '267D80'.
    _add 'B90297' '3F4E6C' '33D79A' 'B59B61'.
    _add '8B654F' '0D29B4' '01B042' '87FCB9'.
    _add '1883AE' '9ECF55' '9256A3' '141A58'.
    _add 'EFAAFF' '69E604' '657FF2' 'E33309'.
    _add '7C4C1E' 'FA00E5' 'F69913' '70D5E8'.
    _add '4E2BC6' 'C8673D' 'C4FECB' '42B230'.
    _add 'DDCD27' '5B81DC' '57182A' 'D154D1'.
    _add '26359F' 'A07964' 'ACE092' '2AAC69'.
    _add 'B5D37E' '339F85' '3F0673' 'B94A88'.
    _add '87B4A6' '01F85D' '0D61AB' '8B2D50'.
    _add '145247' '921EBC' '9E874A' '18CBB1'.
    _add 'E37B16' '6537ED' '69AE1B' 'EFE2E0'.
    _add '709DF7' 'F6D10C' 'FA48FA' '7C0401'.
    _add '42FA2F' 'C4B6D4' 'C82F22' '4E63D9'.
    _add 'D11CCE' '575035' '5BC9C3' 'DD8538'.

  ENDMETHOD.


  METHOD sha1.

    DATA: lv_hash TYPE hash160.


    CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
      EXPORTING
        data           = iv_data
      IMPORTING
        hash           = lv_hash
      EXCEPTIONS
        unknown_alg    = 1
        param_error    = 2
        internal_error = 3
        OTHERS         = 4.
    ASSERT sy-subrc = 0.

    rv_hash = lv_hash.

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