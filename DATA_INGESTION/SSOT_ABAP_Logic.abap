*BACKGROUN JOB LOGIC:
*ls_count = me->get_read_bw_bkjob_st( ls_count ).
SELECT * INTO TABLE @DATA(lt_jobs) FROM tbtco
WHERE jobname EQ @ls_count-bk_jobname AND lastchdate = @sy-datum AND sdluname = @sy-uname..
SORT lt_jobs  BY  lastchtime DESCENDING .
ls_count-bk_jobstatus = VALUE #( lt_jobs[ jobname = ls_count-bk_jobname ]-status DEFAULT 'Job not found').


IF ls_count-bk_jobstatus = lc_running OR ls_count-bk_jobstatus = lc_active.
  "do nothing
ELSE.
  "create background job
ENDIF. 
* INPUT LOGIC
        "p_in1,p_in2, p_in3, p_in4, p_in5
*        DATA: l_cinp  TYPE i VALUE 0,
*              l_pin   TYPE i VALUE 1,
*              l_inptm TYPE string.
*
*        SPLIT i_count-input  AT ';' INTO TABLE DATA(lt_inp).
*        LOOP AT lt_inp ASSIGNING FIELD-SYMBOL(<f_inp>).
*          IF l_cinp + strlen( <f_inp> ) > 43.
*            lwa_selection-selname = 'P_IN' && l_pin.
*            lwa_selection-low = l_inptm.
*            APPEND lwa_selection TO li_selection.
*            l_inptm = <f_inp> && ';'.
*            l_cinp = strlen( <f_inp> ).
*            l_pin  =  l_pin + 1.
*          ELSE.
*            l_inptm = l_inptm && <f_inp> && ';'.
*            l_cinp = l_cinp + strlen( <f_inp> ).
*          ENDIF.
*        ENDLOOP.
*
*        IF l_cinp <> 0 AND  l_inptm IS NOT INITIAL.
*          lwa_selection-selname = 'P_IN' && l_pin.
*          lwa_selection-low = l_inptm.
*          APPEND lwa_selection TO li_selection.
*        ENDIF.


DATA: w_package_txt TYPE indx_srtfd,
l_bwclusteri  TYPE string,
l_bwex10      TYPE char10.
l_bwex10 = i_count-ds.
w_package_txt = '$BW' && l_bwex10 && sy-datum && sy-uzeit.
l_bwclusteri = i_count-input.
EXPORT l_bwclusteri FROM l_bwclusteri TO DATABASE yab_df_indx(df) ID w_package_txt.

lwa_selection-selname = 'P_INPUT'.
lwa_selection-low = w_package_txt ."i_count-input. "limitation to 45 char!
APPEND lwa_selection TO li_selection.


**** READ 
DATA: w_package_txt TYPE indx_srtfd,
l_bwclusteri  TYPE string..

IF p_input IS NOT INITIAL.
l_inp15 = p_input.
IF l_inp15(3) = '$BW'.
w_package_txt = p_input.
IMPORT l_bwclusteri TO l_bwclusteri FROM DATABASE yab_df_indx(df) ID w_package_txt.
IF sy-subrc = 0 AND l_bwclusteri IS NOT INITIAL.
l_inp15 = l_bwclusteri.
DELETE FROM DATABASE yab_df_indx(df) ID w_package_txt.
ENDIF.
ENDIF.

it_select    = lo_obj->get_read_bw_tselect( l_inp15  ).

ELSEIF p_in1 IS NOT INITIAL.
l_inp15 = p_in1 && p_in2 && p_in3 && p_in4 &&  p_in5.
it_select    = lo_obj->get_read_bw_tselect( l_inp15  ).
ELSE.




* Counter Dynamic Select 
* YAB_INITIAL_LOAD_API->CREATE
  SELECT (gv_colums) FROM (gv_ddic_table) INTO TABLE <key_tab> PACKAGE SIZE package_size.
  ADD 1 TO w_package.
  w_package_txt =  me->get_cluster_id( VALUE ty_id( db = gv_ddic_table delta = '' pkg = w_package ) ) .
  EXPORT <key_tab> FROM <key_tab> TO DATABASE zcluster_db(df) ID w_package_txt.
  ENDSELECT.
*******************************************************************************
* YAB_INITIAL_LOAD_API->READ_TABLE
  DATA:w_package_txt TYPE indx_srtfd.
  FIELD-SYMBOLS: <data_tab> TYPE STANDARD TABLE,
                <key_tab>  TYPE STANDARD TABLE.
  w_package_txt =  me->get_cluster_id( VALUE ty_id( db = gv_ddic_table delta = '' pkg = i_package ) ) .
  ASSIGN go_table_key->*    TO <key_tab>.
  ASSIGN go_table_fields->* TO <data_tab>.
  IMPORT <key_tab> TO <key_tab> FROM DATABASE zcluster_db(df) ID w_package_txt.
  IF sy-subrc = 0 AND <key_tab> IS NOT INITIAL.
    " select the actual data by the primary key packages
    TRY.
        SELECT * FROM (gv_ddic_table) INTO CORRESPONDING FIELDS OF TABLE <data_tab>
                FOR ALL ENTRIES IN <key_tab> WHERE (gt_where_condition).
        IF sy-subrc = 0.
          DELETE FROM DATABASE zcluster_db(df) ID w_package_txt.
        ENDIF.
      CATCH cx_root.
    ENDTRY.
  ENDIF.
  r_table_data = go_table_fields. "type - ref to data
*******************************************************************************

* YAB_BMC_API_BW->GET_DATA
  DATA: l_stop  TYPE abap_bool,
  l_count TYPE i.
  gi_option     = i_option     .
  IF gno_data = 'X'.
  ext_no_data( ). "ii_srsc
  RETURN.
  ENDIF. .

  ext_get_source(  ).
  CASE gs_osource-exmethod.
  WHEN 'F1' OR 'F2' OR 'FS'. " Specific Function module used
      IF gi_srsc-readonly = abap_false .
          IF gs_osource-basosource IS NOT INITIAL.
              ext_t_gfm( ).
          ELSE.
              ext_t_rsa3_get_data_simple(  ).
          ENDIF.
      ELSE. " read_only
          ext_t_rfh_get_data_simple( ).
      ENDIF.
  WHEN 'V'.
      "ext_t__v( ).
      IF gs_osource-type = 'TEXT' .
          ext_t_rfh_get_data_simple( ).
          "ext_t_fciw_bw_texts( ).
      ELSE.
          ext_t_rsa1_proxy_pk(  ).
      ENDIF.  
  ENDCASE.
  zend_of_process( ). " Creates the EVENT file to trigger ADF `
*******************************************************************************

*YAB_BMC_API->READ_DB_COUNT
  CASE l_opt .
      WHEN 'IL_'."Initial load
        l_dbj-p_il   = 'X'.
        ls_count-counter       = me->get_counter(  i_count-ds ).
        ls_count-no_pages      = me->calc_no_pages( EXPORTING  i_count = CONV i( ls_count-counter ) i_max   = CONV i( ls_count-block_max_size ) ).
      WHEN 'IC_'."Initial Load conditional
        l_dbj-p_ic   = 'X'.
        l_cond = i_count-input.
        REPLACE ALL OCCURRENCES OF '"'  IN l_cond WITH ''''.
        ls_count-counter       = me->get_counter( EXPORTING i_table =  i_count-ds i_cond = l_cond ).
        ls_count-no_pages      = me->calc_no_pages( EXPORTING  i_count = CONV i( ls_count-counter ) i_max   = CONV i( ls_count-block_max_size ) ).

      WHEN 'DL_'."Initial Load conditional
        l_dbj-p_dl   = 'X'.
        IF l_strlen = 11.
          l_dbj-p_dats = i_count-aedat+3(8).
        ENDIF.
        ls_count-counter      = me->get_change_history_count( EXPORTING im_object =  i_count-ds  im_aedat = i_count-input ).
        IF ls_count-counter   = '0'.
          ls_count-no_pages   = 0.
        ELSE.
          ls_count-no_pages   = me->get_no_pages( i_table =  i_count-ds    i_ddic_lines =   CONV i( ls_count-counter )    ).
        ENDIF.

      WHEN 'ILM'."Initial load Multitable
        l_dbj-p_il   = 'X'.
        l_dbj-p_ml   = 'X'.
        ls_count-counter       = 0.
        ls_count-no_pages      = 0.

      WHEN 'DLM'."Delta load Multitable
        l_dbj-p_dl   = 'X'.
        l_dbj-p_ml   = 'X'.
        IF l_strlen = 11.
          l_dbj-p_dats = i_count-aedat+3(8).
        ENDIF.
        ls_count-counter       = 0.
        ls_count-no_pages      = 0.
      WHEN 'TOP'."Delta load Multitable
        l_dbj-p_topn           = 'X'.
        ls_count-counter       = 0.
        ls_count-no_pages      = 1.
    ENDCASE.
*******************************************************************************

* ext_t_rsa1_proxy_pk 
  DO.
    g_package = sy-index.
    ADD 1 TO g_packno.
    "g_s_info-packetnumber = l_packno.
    REFRESH: <l_t_pack>.
    CALL FUNCTION 'RSA1_PROXY_PACKAGE_GET'
      EXPORTING
        i_oltpsource    = gi_srsc-dsource
        i_packno        = g_packno
        i_requnr        = gi_srsc-requnr
        i_maxsize       = gi_srsc-maxsize  " records/package
        i_updmode       = g_updmode
  *               i_t_langu       = i_t_langu
        i_read_only     = gi_srsc-readonly
        i_debugmode     = ''
        i_quiet         = ''
        i_t_segments    = g_t_segments
        i_rlogsys       = gi_targetsys
        i_t_select      = gi_srsc-t_select
        i_t_field       = g_t_fields
      TABLES
        e_t_data        = <l_t_pack>
      CHANGING
        c_no_more_data  = l_no_more_data
      EXCEPTIONS
        metadata_error  = 1
        extractor_error = 2
        internal_error  = 3
        no_authority    = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
    ... 
  ENDDO. 
*******************************************************************************

* ext_t_rsa3_get_data_simple
  CALL FUNCTION 'RSA3_GET_DATA_SIMPLE'
  EXPORTING
    i_requnr                     = gi_srsc-requnr
    i_chabasnm                   = gs_roosource-basosource
    i_isource                    = gs_roosource-oltpsource
    i_maxsize                    = gi_srsc-maxsize
    i_initflag                   = 'X'
    i_updmode                    = g_updmode
    i_rlogsys                    = gi_targetsys
  TABLES
    i_t_select                   = gi_srsc-t_select " ???? e_srsc-t_select DF 220620
    i_t_fields                   = g_t_fields
  *       e_t_data                     =
  EXCEPTIONS
    no_more_data                 = 1
    error_passed_to_mess_handler = 2
    OTHERS                       = 3.

  FREE <l_t_data>.
  CLEAR g_count.
  IF sy-subrc IS INITIAL.
  TRY.
      DO.
        l_datapakid = g_package = sy-index.
        FREE <l_t_pack>.
        CALL FUNCTION 'RSA3_GET_DATA_SIMPLE'
  ... 
      ENDDO.
  ... 
*******************************************************************************

* ext_t_rfh_get_data_simple
  CALL FUNCTION 'RSFH_GET_DATA_SIMPLE'
  EXPORTING
    i_requnr                     = gi_srsc-requnr
    i_osource                    = gi_srsc-dsource
    i_maxsize                    = gi_srsc-maxsize
    i_maxfetch                   = gi_maxfetch
    i_updmode                    = g_updmode
    i_rlogsys                    = gi_targetsys
    i_read_only                  = gi_srsc-readonly
  TABLES
    i_t_select                   = gi_srsc-t_select
    i_t_field                    = g_t_fields
    e_t_data                     = <l_t_data>
  EXCEPTIONS
    generation_error             = 1
    interface_table_error        = 2
    metadata_error               = 3
    error_passed_to_mess_handler = 4
    no_authority                 = 5
    OTHERS                       = 6.

*******************************************************************************


*SCHEDULE BACKGROUND JOB 
METHOD get_read_bw_bkjob.
      DATA: starttimeimmediate TYPE btch0000-char1 VALUE 'X',
            li_selection       TYPE TABLE OF rsparams,
            lwa_selection      TYPE rsparams,
            jobname            TYPE tbtcjob-jobname, "32 char limit'
            jobcount           TYPE tbtcjob-jobcount.
      DATA(ls_count) = i_count.
      DATA li_srsc TYPE srsc_s_if_simple.
      DATA(lt_select) = get_read_bw_tselect( i_count-input  ).
      DATA(l_desc) = me->get_read_bw_desc( lt_select ).
      jobname               =  'B_' && i_count-ds &&  l_desc .
      ls_count-bk_jobname   = jobname.
      ls_count = me->get_read_bw_bkjob_st( ls_count ).
        IF ls_count-bk_jobstatus = lc_running OR ls_count-bk_jobstatus = lc_active.
          "do nothing
        ELSE.
          REFRESH li_selection.
          CLEAR lwa_selection.
          lwa_selection-kind = 'P'.
          lwa_selection-sign = 'I'.
          lwa_selection-option = 'EQ'.
          lwa_selection-high = space.
          lwa_selection-selname = 'P_REQNR'.
          lwa_selection-low = i_bwjob-reqnr.
          APPEND lwa_selection TO li_selection.
          " ... 
          "p_in1,p_in2, p_in3, p_in4, p_in5
          DATA: l_cinp  TYPE i VALUE 0,
                l_pin   TYPE i VALUE 1,
                l_inptm TYPE string.
  
          SPLIT i_count-input  AT ';' INTO TABLE DATA(lt_inp).
          LOOP AT lt_inp ASSIGNING FIELD-SYMBOL(<f_inp>).
            IF l_cinp + strlen( <f_inp> ) > 43.
              lwa_selection-selname = 'P_IN' && l_pin.
              lwa_selection-low = l_inptm.
              APPEND lwa_selection TO li_selection.
              l_inptm = <f_inp> && ';'.
              l_cinp = strlen( <f_inp> ).
              l_pin  =  l_pin + 1.
            ELSE.
              l_inptm = l_inptm && <f_inp> && ';'.
              l_cinp = l_cinp + strlen( <f_inp> ).
            ENDIF.
          ENDLOOP.
          "...
          CALL FUNCTION 'JOB_OPEN'
            EXPORTING
              delanfrep        = ' '
              jobgroup         = ' '
              jobname          = jobname
              jobclass         = 'C'
              sdlstrtdt        = sy-datum
              sdlstrttm        = sy-uzeit
            IMPORTING
              jobcount         = jobcount
            EXCEPTIONS
              cant_create_job  = 01
              invalid_job_data = 02
              jobname_missing  = 03.
          IF sy-subrc NE 0.
            "error processing
          ENDIF.
  
          SUBMIT yab_ssot_bw_extractor WITH SELECTION-TABLE li_selection AND RETURN
          USER sy-uname
          VIA JOB jobname
          NUMBER jobcount.
          IF sy-subrc > 0.
            "error processing
          ENDIF. 
          CALL FUNCTION 'JOB_CLOSE'
            EXPORTING
              jobcount             = jobcount
              jobname              = jobnamem
              strtimmed            = starttimeimmediate
            EXCEPTIONS
              cant_start_immediate = 01 invalid_startdate    = 02 jobname_missing      = 03
              job_close_failed     = 04 job_nosteps  = 05 job_notex = 06
              lock_failed          = 07 OTHERS = 99.
  
          IF sy-subrc EQ 0.
            "error processing
          ENDIF.
          COMMIT WORK.
          ls_count-bk_jobstatus = 'Scheduled'.
          set_log( EXPORTING is_log = VALUE yab_dext_log( source = 'BC_' && i_count-ds name_ext = sy-uname date_ext =  sy-datum time_ext = sy-uzeit
                  no_rec = 0 parameters = l_desc  job_name = jobname ) ).
        ENDIF.
      r_count = ls_count.
ENDMETHOD.

* BK JOB STATUS 
  SELECT * INTO TABLE @DATA(lt_jobs)
  FROM tbtco
  WHERE jobname EQ @ls_count-bk_jobname AND lastchdate = @sy-datum AND sdluname = @sy-uname..
  SORT lt_jobs  BY  lastchtime DESCENDING .
  ls_count-bk_jobstatus = VALUE #( lt_jobs[ jobname = ls_count-bk_jobname ]-status DEFAULT 'Job not found').

* HTTP_SEND_Data
METHOD send_data_to_azure.
      DATA: " call PI --
        l_length        TYPE i,
        l_code          TYPE i,
        l_codestr       TYPE string,
        l_codes         TYPE char1,
        azure_dl_client TYPE REF TO if_http_client,
        lo_zip          TYPE REF TO cl_abap_zip,
        lv_xstring      TYPE xstring,
        lv_zip_xstring  TYPE xstring.
      TRY.
          cl_http_client=>create_by_destination( EXPORTING destination        = g_dest
            IMPORTING client             = azure_dl_client
            EXCEPTIONS argument_not_found = 1 internal_error     = 2
              plugin_not_active  = 3 OTHERS  = 4 ).
  
          azure_dl_client->request->set_method( if_http_request=>co_request_method_post ).
          azure_dl_client->request->set_header_field(  name  = 'path' value = path ).
          azure_dl_client->request->set_header_field( name  = 'filename' value = fname ).
  
          IF gc_zip IS NOT INITIAL.
            CREATE OBJECT lo_zip.
            CALL FUNCTION 'SCMS_STRING_TO_XSTRING' EXPORTING text   = gi_data
              IMPORTING buffer = lv_xstring
              EXCEPTIONS failed = 1 OTHERS = 2.
            IF sy-subrc IS NOT INITIAL.
              r_error = abap_true. EXIT.
            ENDIF.
            lo_zip->add(  name = fname content = lv_xstring ).
            lv_zip_xstring = lo_zip->save( ).
              MOVE xstrlen( lv_zip_xstring ) TO l_length.
            CALL METHOD azure_dl_client->request->set_data( data = lv_zip_xstring ). 
          ELSE.
            MOVE strlen( gi_data ) TO l_length.
            CALL METHOD azure_dl_client->request->set_cdata( data = gi_data ).
          ENDIF.
  
          cl_http_utility=>set_request_uri( request = azure_dl_client->request uri = '/ssot' ).
          azure_dl_client->propertytype_accept_cookie = 1.
  
          azure_dl_client->send( EXCEPTIONS
                                    http_communication_failure = 1
                                    http_invalid_state = 2
                                    http_processing_failed = 3
                                    http_invalid_timeout  = 4
                                    OTHERS = 5 ).
          IF sy-subrc IS NOT INITIAL.
            r_error = abap_true.
          ENDIF.
  
          azure_dl_client->receive(  EXCEPTIONS
                                    http_communication_failure = 1
                                    http_invalid_state = 2
                                    http_processing_failed = 3
                                    OTHERS = 4 ).
          IF sy-subrc IS NOT INITIAL.
            r_error = abap_true.
          ENDIF.
  
  
          azure_dl_client->response->get_status( IMPORTING code = l_code ). "DF EIT - Outcome
          " log -- error handling
          r_error   = abap_false.
          l_codestr = l_code.
          l_codes   = l_codestr(1).
          CASE l_codes.
            WHEN '2' .    " successful
            WHEN OTHERS . " errors
              r_error = abap_true.
          ENDCASE.
          DATA(response) = azure_dl_client->response->get_cdata( ).
          azure_dl_client->close( ). "DF EIT
        CATCH cx_root.
          r_error = abap_true.
      ENDTRY.
        CLEAR gi_data.
    ENDMETHOD.

* xxx