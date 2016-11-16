REPORT zabappgp_test1.

PARAMETERS: p_gname TYPE rfcgr MATCHCODE OBJECT serv_group DEFAULT 'parallel_generators'.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: lv_max  TYPE i,
        lv_free TYPE i.

  CALL FUNCTION 'SPBT_INITIALIZE'
    EXPORTING
      group_name                     = p_gname
    IMPORTING
      max_pbt_wps                    = lv_max
      free_pbt_wps                   = lv_free
    EXCEPTIONS
      invalid_group_name             = 1
      internal_error                 = 2
      pbt_env_already_initialized    = 3
      currently_no_resources_avail   = 4
      no_pbt_resources_found         = 5
      cant_init_different_pbt_groups = 6
      OTHERS                         = 7.
  IF sy-subrc <> 0.
    BREAK-POINT.
  ENDIF.

*CALL FUNCTION 'ZFOOBAR' STARTING NEW TASK TASKNAME
* DESTINATION IN GROUP p_gname PERFORMING callback ON END OF TASK

  WRITE: / lv_max, lv_free.

  WRITE: / 'Done'.

ENDFORM.