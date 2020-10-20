*&---------------------------------------------------------------------
*& Report   : YREPORT
*& Author   : David Vela  21.11.2019 
*& Category : Read
*& Title    : yreport
*&---------------------------------------------------------------------
*& yreport
*&---------------------------------------------------------------------
*& 20191217 -- Changes 
*&---------------------------------------------------------------------
*& Authority-check: not included (not necessary )
*&---------------------------------------------------------------------*
REPORT yreport.

DATA:
  lr_api         TYPE REF TO  YAC_API,
  ls_objkey      TYPE /iwbep/cl_query_result_log=>ty_s_objkey_int,
  lv_objkey      TYPE /iwbep/qrl_object_key,
  lt_objkey_tab  TYPE /iwbep/cl_query_result_log=>ty_t_objkey_int,
  lo_table_key   TYPE REF TO data,
  lv_update_cntr TYPE i,
  lv_delete_cntr TYPE i,
  lv_insert_cntr TYPE i.
FIELD-SYMBOLS: <key_fields> TYPE any.

*--------------------------------------------------------------------*
* Selection screen
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK s03 WITH FRAME TITLE text-004.
PARAMETERS: p_ch_iu TYPE c RADIOBUTTON GROUP p1 DEFAULT 'X', "check I and U
            p_ch_d  TYPE c RADIOBUTTON GROUP p1, " check D
            p_del   TYPE c RADIOBUTTON GROUP p1,
            p_dela  TYPE c RADIOBUTTON GROUP p1,
            p_test  TYPE c RADIOBUTTON GROUP p1.
SELECTION-SCREEN END OF BLOCK s03.
SELECTION-SCREEN BEGIN OF BLOCK s02 WITH FRAME TITLE text-003.
PARAMETERS: pa_table TYPE dcobjdef-name DEFAULT '',
            pa_paksz TYPE i DEFAULT 10000,
            pa_dats  TYPE dats DEFAULT sy-datum.
SELECTION-SCREEN SKIP.
PARAMETERS: p_stop AS CHECKBOX DEFAULT abap_false,
            p_ini  AS CHECKBOX DEFAULT abap_false.
SELECTION-SCREEN END OF BLOCK s02.


*--------------------------------------------------------------------*
* Event At Selection Screen output
*--------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
*    IF screen-name = 'PA_TABLE'.
*      screen-input = 0.
*    ENDIF.
*    MODIFY SCREEN.
  ENDLOOP.

*--------------------------------------------------------------------*
* Event Start of Selection
*--------------------------------------------------------------------*
START-OF-SELECTION.
  IF pa_paksz IS INITIAL  . pa_paksz = 10000 . ENDIF.
  IF pa_dats IS INITIAL. pa_dats = sy-datum. ENDIF.
  lv_insert_cntr = 0. lv_update_cntr = 0.
  CASE abap_true.
    WHEN p_ch_iu      PERFORM check_changes.
    WHEN p_ch_d.      PERFORM check_deletion.
    WHEN p_del.       PERFORM del_objclass.
    WHEN p_dela.      PERFORM delete_all.
    WHEN p_tesT.     PERFORM test_dev.
  ENDCASE.
END-OF-SELECTION.

*--------------------------------------------------------------------*
* Subroutines
*--------------------------------------------------------------------*
FORM test_dev.


    DATA: t1     TYPE i,
          t2     TYPE i,
          l_time TYPE string.
  
    "get initial timing
    GET RUN TIME FIELD t1.
  
  
    "check time
    GET RUN TIME FIELD t2. " microseconds = 10-6s
    l_time = (  t2 - t1 ) / 1000000.
    NEW-LINE.
    WRITE  l_time && 's'.
    NEW-LINE.
    l_time = l_time / 60.
    WRITE l_time  && 'min'.
  
  ENDFORM.