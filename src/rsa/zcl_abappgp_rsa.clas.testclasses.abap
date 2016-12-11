
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

    DATA: lo_n TYPE REF TO zcl_abappgp_integer,
          lo_e TYPE REF TO zcl_abappgp_integer,
          lo_d TYPE REF TO zcl_abappgp_integer.


    zcl_abappgp_rsa=>generate_keys(
      EXPORTING
        io_prime1 = zcl_abappgp_integer=>from_string( iv_p )
        io_prime2 = zcl_abappgp_integer=>from_string( iv_q )
      IMPORTING
        eo_n      = lo_n
        eo_e      = lo_e
        eo_d      = lo_d ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_n->to_string( )
      exp = iv_n ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_e->to_string( )
      exp = iv_e ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_d->to_string( )
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
      '14171711713797974299334871062829803541' INTO lv_p.

    CONCATENATE
      '120275242554787488859562207937345121287'
      '333878036820754336538999839551798509887'
      '978998691469008091316111533468170508320'
      '96022160146366346391812470987105415233' INTO lv_q.

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