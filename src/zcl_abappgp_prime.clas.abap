class ZCL_ABAPPGP_PRIME definition
  public
  create public .

public section.

  class-methods CHECK
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RV_BOOL) type ABAP_BOOL .
protected section.

  class-methods LOW_PRIMES
    returning
      value(RT_LOW) type STRING_TABLE .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_PRIME IMPLEMENTATION.


  METHOD check.



  ENDMETHOD.


  METHOD low_primes.

    DEFINE _add.
      APPEND &1 TO rt_low.
    END-OF-DEFINITION.

    _add '3'.
    _add '5'.
    _add '7'.
    _add '11'.
    _add '13'.
    _add '17'.
    _add '19'.
    _add '23'.
    _add '29'.
    _add '31'.
    _add '37'.
    _add '41'.
    _add '43'.
    _add '47'.
    _add '53'.
    _add '59'.
    _add '61'.
    _add '67'.
    _add '71'.
    _add '73'.
    _add '79'.
    _add '83'.
    _add '89'.
    _add '97'.
    _add '101'.
    _add '103'.
    _add '107'.
    _add '109'.
    _add '113'.
    _add '127'.
    _add '131'.
    _add '137'.
    _add '139'.
    _add '149'.
    _add '151'.
    _add '157'.
    _add '163'.
    _add '167'.
    _add '173'.
    _add '179'.
    _add '181'.
    _add '191'.
    _add '193'.
    _add '197'.
    _add '199'.
    _add '211'.
    _add '223'.
    _add '227'.
    _add '229'.
    _add '233'.
    _add '239'.
    _add '241'.
    _add '251'.
    _add '257'.
    _add '263'.
    _add '269'.
    _add '271'.
    _add '277'.
    _add '281'.
    _add '283'.
    _add '293'.
    _add '307'.
    _add '311'.
    _add '313'.
    _add '317'.
    _add '331'.
    _add '337'.
    _add '347'.
    _add '349'.
    _add '353'.
    _add '359'.
    _add '367'.
    _add '373'.
    _add '379'.
    _add '383'.
    _add '389'.
    _add '397'.
    _add '401'.
    _add '409'.
    _add '419'.
    _add '421'.
    _add '431'.
    _add '433'.
    _add '439'.
    _add '443'.
    _add '449'.
    _add '457'.
    _add '461'.
    _add '463'.
    _add '467'.
    _add '479'.
    _add '487'.
    _add '491'.
    _add '499'.
    _add '503'.
    _add '509'.
    _add '521'.
    _add '523'.
    _add '541'.
    _add '547'.
    _add '557'.
    _add '563'.
    _add '569'.
    _add '571'.
    _add '577'.
    _add '587'.
    _add '593'.
    _add '599'.
    _add '601'.
    _add '607'.
    _add '613'.
    _add '617'.
    _add '619'.
    _add '631'.
    _add '641'.
    _add '643'.
    _add '647'.
    _add '653'.
    _add '659'.
    _add '661'.
    _add '673'.
    _add '677'.
    _add '683'.
    _add '691'.
    _add '701'.
    _add '709'.
    _add '719'.
    _add '727'.
    _add '733'.
    _add '739'.
    _add '743'.
    _add '751'.
    _add '757'.
    _add '761'.
    _add '769'.
    _add '773'.
    _add '787'.
    _add '797'.
    _add '809'.
    _add '811'.
    _add '821'.
    _add '823'.
    _add '827'.
    _add '829'.
    _add '839'.
    _add '853'.
    _add '857'.
    _add '859'.
    _add '863'.
    _add '877'.
    _add '881'.
    _add '883'.
    _add '887'.
    _add '907'.
    _add '911'.
    _add '919'.
    _add '929'.
    _add '937'.
    _add '941'.
    _add '947'.
    _add '953'.
    _add '967'.
    _add '971'.
    _add '977'.
    _add '983'.
    _add '991'.
    _add '997'.

  ENDMETHOD.
ENDCLASS.