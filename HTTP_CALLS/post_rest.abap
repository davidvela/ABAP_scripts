" DE1 class YAE0G_CL_LPD_DATAEXTRACT
METHODS post_rest_call
IMPORTING
  !i_url     TYPE string
  !i_payload TYPE string
EXPORTING
  !e_code    TYPE i .
  
METHOD post_rest_call.
    **********************************************************************
    *   REST CALL
    **********************************************************************
    
        DATA: lo_http_client TYPE REF TO if_http_client,
              lo_rest_client TYPE REF TO cl_rest_http_client,
              ls_url         TYPE string,
              l_passpi       TYPE string,
              l_userpi       TYPE string,
              r_string       TYPE string,
              l_dest         TYPE c LENGTH 20,
              l_system       LIKE sy-sysid,
              mime_length    TYPE i,
              mime_soli      TYPE soli_tab,
              lo_request     TYPE REF TO if_rest_entity,
              rlength        TYPE i,
              txlen          TYPE string,
              l_payload      TYPE string.
    
        l_payload = i_payload.
        l_system = sy-sysid.
        l_userpi = 'I_INT_DIGLOG'.
        l_passpi = ''.
    
        CASE l_system.
          WHEN 'DE1'.  "Development
            ls_url   = 'https://dev_server.com/' && 'RESTAdapter/msdynamics/' && i_url.
            l_dest   = 'DI1_REST_ADAPTER'. "LPD DATA EXTRACT
          WHEN 'QE1'.  "Quality
            ls_url   = 'https://qual_server.com/'  && 'RESTAdapter/msdynamics/' && i_url. .   "load balancer
            l_dest   = 'QIX_REST_ADAPTER'.
          WHEN 'PE1'.  "Production
            ls_url   = 'https://prod_server.com/'  && 'RESTAdapter/msdynamics/' && i_url.  "load balancer
            l_dest   = 'PIX_REST_ADAPTER'.
        ENDCASE.
    
        TRY.
    
            IF 1 = 2.
              cl_http_client=>create_by_url(  EXPORTING  url           = ls_url    IMPORTING client         = lo_http_client ).
              lo_http_client->authenticate(   EXPORTING username       = l_userpi   password = l_passpi ).
    
            ELSE.   " RFC Destination
              CALL METHOD cl_http_client=>create_by_destination
                EXPORTING
                  destination              = l_dest
                IMPORTING
                  client                   = lo_http_client
                EXCEPTIONS
                  argument_not_found       = 1
                  destination_not_found    = 2
                  destination_no_authority = 3
                  plugin_not_active        = 4
                  internal_error           = 5.
              cl_http_utility=>set_request_uri( request = lo_http_client->request   uri = '/msdynamics/' && i_url ).
            ENDIF.
            lo_rest_client =  NEW #( lo_http_client ).
    
    *          lo_request = lo_rest_client->if_rest_client~create_request_entity( ).
    *          lo_request->set_content_type( iv_media_type = if_rest_media_type=>gc_appl_json ).
    *          lo_request->set_string_data( l_payload ).
    *          lo_rest_client->if_rest_resource~post( lo_request ).
    *          data(lo_response) = lo_rest_client->if_rest_client~get_response_entity( ).
    *          r_string = lo_response->get_string_data( ).
    
            lo_http_client->request->set_method( if_http_request=>co_request_method_post ).
            lo_http_client->request->set_header_field(  EXPORTING name  = '~request_method'     value = 'POST' ).
            lo_http_client->request->set_header_field(  EXPORTING name  = '~server_protocol'    value = 'HTTP/1.1' ).
            lo_http_client->request->set_header_field(  EXPORTING name  = 'Content-Type'        value = 'application/json' ).
            rlength = strlen( l_payload ) .
            MOVE: rlength TO txlen .
            lo_http_client->request->append_cdata2(  EXPORTING data     = l_payload   offset   = 0  length   = rlength
                                                           encoding = if_http_request=>co_encoding_raw ).
    
    
            lo_http_client->send( EXCEPTIONS http_communication_failure   = 1 http_invalid_state           = 2
                                             http_processing_failed       = 3 http_invalid_timeout         = 4         ).
            IF sy-subrc IS INITIAL.
              lo_http_client->receive( EXCEPTIONS  http_communication_failure  = 1
                                                   http_invalid_state          = 2   http_processing_failed      = 3  ).
            ENDIF.
            IF sy-subrc IS NOT INITIAL.
              lo_http_client->close( ).
              e_code = 500.
              "CONTINUE.
              RETURN.
            ENDIF.
    
            DATA(lx_string) =  lo_http_client->response->get_data( ).
    
    
            lo_http_client->response->get_status( IMPORTING code = DATA(l_code)   reason = DATA(l_reason) ).
            IF l_code <> 200.
              "l_ecount = l_ecount + 1.
            ENDIF.
            e_code = l_code.
    
            CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
              EXPORTING
                buffer        = lx_string
              IMPORTING
                output_length = mime_length
              TABLES
                binary_tab    = mime_soli.
            CALL FUNCTION 'SCMS_BINARY_TO_STRING'
              EXPORTING
                input_length = mime_length
                first_line   = 0
              IMPORTING
                text_buffer  = r_string
              TABLES
                binary_tab   = mime_soli
              EXCEPTIONS
                failed       = 1
                OTHERS       = 2.
    
            lo_http_client->close( ).
    
          CATCH cx_root INTO DATA(lo_error3).
            e_code = 500.
        ENDTRY.
    
      ENDMETHOD.
    