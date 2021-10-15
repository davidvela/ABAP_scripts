* Methods:
" /iwbep/if_v4_dp_basic~read_entity_list
" /iwbep/if_v4_dp_basic~read_entity
" /iwbep/if_v4_dp_basic~read_ref_target_key_data_list

* Redefined: 
" read_entity_salesorder
" read_entity_salesorderitem
" read_list_salesorder
" read_list_salesorderitem
" read_ref_key_list_salesorder

method /iwbep/if_v4_dp_basic~read_entity_list..
*************************************************** 
* READ ENTITY LIST
*************************************************** 

    io_request->get_todos( importing es_todo_list = ls_todo_list ).
     " $skip / $top handling
     if ls_todo_list-process-skip = abap_true.
        ls_done_list-skip = abap_true.
        io_request->get_skip( importing ev_skip = lv_skip ).
      endif.
      if ls_todo_list-process-top = abap_true.
        ls_done_list-top = abap_true.
        io_request->get_top( importing ev_top = lv_top ).
      endif.

      io_request->get_entity_set( importing ev_entity_set_name = lv_entityset_name ).

      case lv_entityset_name.
  
        when gcs_entity_set_names-internal-salesorder.
  
          read_list_salesorder(
            exporting
              io_request        = io_request
              io_response       = io_response
              iv_orderby_string = lv_orderby_string
              iv_select_string  = lv_select_string
              iv_where_clause   = lv_where_clause
              iv_skip           = lv_skip
              iv_top            = lv_top
              is_done_list      = ls_done_list ).

endmethod. 

method read_list_salesorder. 
*************************************************** 
* READ LIST SO
***************************************************
    lt_key_range_salesorder type zif_e2e001_odata_v4_so_types=>gt_key_range-salesorder,
    ls_key_range_salesorder type line of zif_e2e001_odata_v4_so_types=>gt_key_range-salesorder,
    lt_salesorder type standard table of gty_cds_views-salesorder,
    lt_key_salesorder  type standard table of gty_cds_views-salesorder.

    "generic data types
    data: ls_todo_list type /iwbep/if_v4_requ_basic_list=>ty_s_todo_list,
        ls_done_list type /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list,
        lv_count     type i,
        lv_max_index type i.

        if  ls_todo_list-process-filter = abap_false
        and ls_todo_list-process-key_data = abap_false
        and iv_top = 0.
            raise exception type zcx_e2e001_odata_v4_so
            exporting
                textid              = zcx_e2e001_odata_v4_so=>use_filter_top_or_nav
                http_status_code    = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-bad_request
                edm_entity_set_name = gcs_entity_set_names-edm-salesorder.
        endif.      

        "OFFSET is only supported as of NW751
        select (iv_select_string) from ze2e001_c_salesorder
            where (iv_where_clause)
            and   salesorder in @lt_key_range_salesorder
            order by (iv_orderby_string)
            into corresponding fields of table @lt_salesorder
            up to @iv_top rows
            offset @iv_skip.

        io_response->set_busi_data( it_busi_data = lt_salesorder ).

endmethod

method /iwbep/if_v4_dp_basic~read_entity.
*************************************************** 
* READ ENTITY 
***************************************************
    io_request->get_entity_set( importing ev_entity_set_name = lv_entityset_name ).

    case lv_entityset_name.

    when gcs_entity_set_names-internal-salesorder.
        read_entity_salesorder(
        exporting
            io_request  = io_request
            io_response = io_response ).
endmethod. 

method read_entity_salesorder.
*************************************************** 
* READ  SO
***************************************************
    "entity type specific data types
    data: ls_salesorder         type gty_cds_views-salesorder,
          ls_key_salesorder     type gty_cds_views-salesorder,
          lv_salesorder_key_edm type string,
          lv_helper_int         type i.
    "generic data types
    data: ls_todo_list type /iwbep/if_v4_requ_basic_read=>ty_s_todo_list,
          ls_done_list type /iwbep/if_v4_requ_basic_read=>ty_s_todo_process_list.

    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    " read the key data
    io_request->get_key_data( importing es_key_data = ls_key_salesorder ).
    ls_done_list-key_data = abap_true.

    select single * from ze2e001_c_salesorder
    into corresponding fields of @ls_salesorder
    where salesorder = @ls_key_salesorder-salesorder.

    if ls_salesorder is not initial.
      io_response->set_busi_data( is_busi_data = ls_salesorder ).
    else.
      "Move data first to an integer to remove leading zeros from the response
      lv_salesorder_key_edm = lv_helper_int = ls_key_salesorder-salesorder.

      raise exception type zcx_e2e001_odata_v4_so
        exporting
          textid              = zcx_e2e001_odata_v4_so=>entity_not_found
          http_status_code    = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-not_found
          edm_entity_set_name = gcs_entity_set_names-edm-salesorder
          entity_key          = lv_salesorder_key_edm.

    endif.

    " Report list of request options handled by application
    io_response->set_is_done( ls_done_list ).
endmethod

method /iwbep/if_v4_dp_basic~read_ref_target_key_data_list.
*************************************************** 
* READ KEY DATA 
***************************************************
    data: lv_source_entity_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.
    io_request->get_source_entity_type( importing ev_source_entity_type_name = lv_source_entity_name ).
    case lv_source_entity_name.

      when gcs_entity_type_names-internal-salesorder.
        read_ref_key_list_salesorder(
           exporting
            io_request  = io_request
            io_response = io_response ).

      when others.
        super->/iwbep/if_v4_dp_basic~read_ref_target_key_data_list(
          exporting
            io_request  = io_request
            io_response = io_response ).

    endcase.

endmethod.

method read_ref_key_list_salesorder.
*************************************************** 
* READ KEY LIST SO 
***************************************************
    "entity type specific data types
    data: ls_salesorder_key_data     type  gty_cds_views-salesorder,
          lt_salesorderitem_key_data type standard table of gty_cds_views-salesorderitem,
          ls_todo_list               type /iwbep/if_v4_requ_basic_ref_l=>ty_s_todo_list.
    "generic data types
    data: ls_done_list         type /iwbep/if_v4_requ_basic_ref_l=>ty_s_todo_process_list,
          lv_nav_property_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.

    " Get the request options the application should/must handle
    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    if ls_todo_list-process-source_key_data = abap_true.
      io_request->get_source_key_data( importing es_source_key_data =  ls_salesorder_key_data ).
      ls_done_list-source_key_data = abap_true.
    endif.

    io_request->get_navigation_prop( importing ev_navigation_prop_name = lv_nav_property_name ).

    case lv_nav_property_name.
      when gcs_nav_prop_names-internal-salesorder_to_items.

        select salesorder , salesorderitem from ze2e001_c_salesorderitem
        into corresponding fields of table @lt_salesorderitem_key_data
        where salesorder = @ls_salesorder_key_data-salesorder.

        io_response->set_target_key_data( lt_salesorderitem_key_data ).

      when others.

        raise exception type zcx_e2e001_odata_v4_so
          exporting
            http_status_code = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-sv_not_implemented.

    endcase.

    " Report list of request options handled by application
    io_response->set_is_done( ls_done_list ).
endmethod.