
CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA: mv_data TYPE xstring.

    METHODS:
      add IMPORTING iv_string TYPE string,
      test FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD add.

    DATA: lv_xstring TYPE xstring.

    lv_xstring = iv_string.

    CONCATENATE mv_data lv_xstring INTO mv_data IN BYTE MODE.

  ENDMETHOD.

  METHOD test.

    DATA: lo_packet TYPE REF TO zcl_abappgp_packet_06,
          lo_stream TYPE REF TO zcl_abappgp_stream.


    add( '04582DBEEA010400DD3915AA1CB8D3DE711B86CB' ).
    add( 'AD6E825E745BD8EF95AD7E2DA6C0750DCB5B0889' ).
    add( 'DA3317D82E921875DA43B626B9252DAE5EDD55EC' ).
    add( '8D03466CEB47BD26C2E753A0E7BEC40DB8C6891C' ).
    add( '00B0C387A49CD3225508BD53444026CB18786BB4' ).
    add( '56A3DF3DDB67C02727B5C57EB8391622A6A6EA5E' ).
    add( 'EE8920C63842A2A9630D69C037929EF30011010001' ).

    CREATE OBJECT lo_stream
      EXPORTING
        iv_data = mv_data.

    lo_packet ?= zcl_abappgp_packet_06=>from_stream( lo_stream ).

  ENDMETHOD.

ENDCLASS.