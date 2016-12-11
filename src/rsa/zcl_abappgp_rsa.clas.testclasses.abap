
CLASS ltcl_find_coprime DEFINITION DEFERRED.
CLASS zcl_abappgp_rsa DEFINITION LOCAL FRIENDS ltcl_find_coprime.

CLASS ltcl_find_coprime DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.

    METHODS: test01 FOR TESTING.
ENDCLASS.       "ltcl_Generate_Keys


CLASS ltcl_find_coprime IMPLEMENTATION.

  METHOD test01.

    DATA: lo_result TYPE REF TO zcl_abappgp_integer,
          lv_str    TYPE string.


    CONCATENATE
      '145906768007583323230186939349070635292401872375357164'
      '399581871019873438799005358938369571402670149802121818'
      '086292467422828157022922076746906543401224889648313811'
      '232279966317301397777852365301547848273478871297222058'
      '587457152891606459269718119268971163555070802643999529'
      '549644116811947516513938184296683521280' INTO lv_str.

    lo_result = zcl_abappgp_rsa=>find_coprime( zcl_abappgp_integer=>from_string( lv_str ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_result->to_string( )
      exp = '65537' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_generate_keys DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.

    METHODS:
      run
        IMPORTING iv_p TYPE string
                  iv_q TYPE string
                  iv_n TYPE string
                  iv_e TYPE string
                  iv_d TYPE string.

    METHODS:
      test01 FOR TESTING,
      test02 FOR TESTING.

ENDCLASS.       "ltcl_Generate_Keys

CLASS ltcl_generate_keys IMPLEMENTATION.

  METHOD run.

    DATA: lo_pair TYPE REF TO zcl_abappgp_rsa_key_pair.


    lo_pair = zcl_abappgp_rsa=>generate_key_pair(
      io_p = zcl_abappgp_integer=>from_string( iv_p )
      io_q = zcl_abappgp_integer=>from_string( iv_q ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_pair->get_public( )->get_n( )->to_string( )
      exp = iv_n ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_pair->get_public( )->get_e( )->to_string( )
      exp = iv_e ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_pair->get_private( )->get_d( )->to_string( )
      exp = iv_d ).

  ENDMETHOD.

  METHOD test01.

    run( iv_p = '7'
         iv_q = '19'
         iv_n = '133'
         iv_e = '5'
         iv_d = '65' ).

  ENDMETHOD.

  METHOD test02.
* http://doctrina.org/How-RSA-Works-With-Examples.html

    DATA: lv_p TYPE string,
          lv_n TYPE string,
          lv_d TYPE string,
          lv_q TYPE string.


    CONCATENATE
      '121310724392112718973236715316124404284'
      '724276337014109256345493123019643730420'
      '856193241973653224168665410170573613652'
      '14171711713797974299334871062829803541' INTO lv_q.

    CONCATENATE
      '120275242554787488859562207937345121287'
      '333878036820754336538999839551798509887'
      '978998691469008091316111533468170508320'
      '96022160146366346391812470987105415233' INTO lv_p.

    CONCATENATE
      '145906768007583323230186939349070635292'
      '401872375357164399581871019873438799005'
      '358938369571402670149802121818086292467'
      '422828157022922076746906543401224889672'
      '472407926969987100581290103199317858753'
      '663710862357656510507883714297115637342'
      '788911463535102712032765166518411726859'
      '837988672111837205085526346618740053' INTO lv_n.

    CONCATENATE
      '894894250092744443682285459217730939196'
      '695860658842574454978544564876748396298'
      '183909349419732628796167979706089172836'
      '798754993315741611138540888132754881105'
      '882471930775825272784379065040156806234'
      '235500672400424666656542323835029222154'
      '936232894721388664458187891279461234078'
      '07725702626644091036502372545139713' INTO lv_d.

    run( iv_p = lv_p
         iv_q = lv_q
         iv_n = lv_n
         iv_e = '65537'
         iv_d = lv_d ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_sign DEFINITION FOR TESTING
    DURATION MEDIUM
    RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test01 FOR TESTING.

ENDCLASS.

CLASS ltcl_sign IMPLEMENTATION.

  METHOD test01.

    DATA: lo_public  TYPE REF TO zcl_abappgp_rsa_public_key,
          lo_private TYPE REF TO zcl_abappgp_rsa_private_key,
          lo_m       TYPE REF TO zcl_abappgp_integer,
          lo_s       TYPE REF TO zcl_abappgp_integer,
          lv_valid   TYPE abap_bool.


    lo_m = zcl_abappgp_integer=>from_string( '35' ).

    CREATE OBJECT lo_private
      EXPORTING
        io_d = zcl_abappgp_integer=>from_string( '29' )
        io_p = zcl_abappgp_integer=>from_string( '7' )
        io_q = zcl_abappgp_integer=>from_string( '13' )
        io_u = zcl_abappgp_integer=>from_string( '0' ).

    CREATE OBJECT lo_public
      EXPORTING
        io_n = zcl_abappgp_integer=>from_string( '91' )
        io_e = zcl_abappgp_integer=>from_string( '5' ).

    lo_s = zcl_abappgp_rsa=>sign(
      io_m       = lo_m
      io_private = lo_private ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_s->to_string( )
      exp = '42' ).

    lv_valid = zcl_abappgp_rsa=>verify(
      io_m      = lo_m
      io_s      = lo_s
      io_public = lo_public ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_valid
      exp = abap_true ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_encrypt DEFINITION FOR TESTING
    DURATION MEDIUM
    RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      test01 FOR TESTING.

ENDCLASS.

CLASS ltcl_encrypt IMPLEMENTATION.

  METHOD test01.
* http://doctrina.org/How-RSA-Works-With-Examples.html

    DATA: lv_q         TYPE string,
          lv_p         TYPE string,
          lo_keys      TYPE REF TO zcl_abappgp_rsa_key_pair,
          lo_encrypted TYPE REF TO zcl_abappgp_integer,
          lv_result    TYPE string,
          lv_plain     TYPE string.


    CONCATENATE
      '121310724392112718973236715316124404284'
      '724276337014109256345493123019643730420'
      '856193241973653224168665410170573613652'
      '14171711713797974299334871062829803541' INTO lv_q.

    CONCATENATE
      '120275242554787488859562207937345121287'
      '333878036820754336538999839551798509887'
      '978998691469008091316111533468170508320'
      '96022160146366346391812470987105415233' INTO lv_p.

    lv_plain = '1976620216402300889624482718775150'.


    lo_keys = zcl_abappgp_rsa=>generate_key_pair(
      io_p = zcl_abappgp_integer=>from_string( lv_p )
      io_q = zcl_abappgp_integer=>from_string( lv_q ) ).

    lo_encrypted = zcl_abappgp_rsa=>encrypt(
      io_plain  = zcl_abappgp_integer=>from_string( lv_plain )
      io_public = lo_keys->get_public( ) ).

    lv_result = zcl_abappgp_rsa=>decrypt(
      io_encrypted = lo_encrypted
      io_private   = lo_keys->get_private( ) )->to_string( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = lv_plain ).

  ENDMETHOD.

ENDCLASS.