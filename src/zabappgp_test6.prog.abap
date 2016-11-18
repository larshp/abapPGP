REPORT zabappgp_test6.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lv_t1      TYPE timestamp,
        lv_t2      TYPE timestamp,
        lv_str     TYPE string,
        lv_secs    TYPE i.


  DATA(lo_a) = zcl_abappgp_integer=>from_string( '1174801109299785226408033388385051205871790285928261294516537363690668415901748547320302279220517139756261535213096924348436863500920698920913060497218282' ).
  DATA(lo_d) = zcl_abappgp_integer=>from_string( '12766277192211545813816225926672334295588392179928434976744204620619146243902014255105757670219190617200918022358944112465418900783010731372942957201817996' ).
  DATA(lo_n) = zcl_abappgp_integer=>from_string( '12766277192211545813816225926672334295588392179928434976744204620619146243902014255105757670219190617200918022358944112465418900783010731372942957201817997' ).

  GET TIME STAMP FIELD lv_t1.
  DATA(lo_result) = lo_a->modular_pow_montgomery( io_exponent = lo_d
                                                  io_modulus  = lo_n ).
  GET TIME STAMP FIELD lv_t2.
  lv_secs = cl_abap_tstmp=>subtract( tstmp1 = lv_t2
                                     tstmp2 = lv_t1 ).
  WRITE: / 'Runtime: ', lv_secs, 'seconds'.

  lv_str = lo_result->to_string( ).
  WRITE: / lv_str.
  IF lv_str <> '1843962033955800958855656763034804429341007982033282692487385882399465538684990312937645417336623684640837508723415756053912762601046348829296952705618604'.
    WRITE: / 'ERROR!'.
  ENDIF.

ENDFORM.