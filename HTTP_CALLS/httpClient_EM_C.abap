* Enterprise Messaging Class: 
CLASS zem_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ts_str_req,
        target  TYPE string,
        payload TYPE string,
        ctype   TYPE string,
      END OF ts_str_req,

      BEGIN OF ts_http_req,
        target TYPE string,
        method TYPE string,
      END OF ts_http_req,
      BEGIN OF ts_http_res,
        code   TYPE i,
        reason TYPE string,
        resp   TYPE string,
      END OF ts_http_res.

    METHODS: send_string            IMPORTING is_rq TYPE ts_str_req RETURNING VALUE(r_ret) TYPE ts_http_res.

  PROTECTED SECTION.
    DATA: go_http_client TYPE REF TO if_http_client.
    METHODS:
      create_http_req ,
      send_http_req        IMPORTING is_rq TYPE ts_http_req RETURNING VALUE(r_ret) TYPE ts_http_res.

  PRIVATE SECTION.

ENDCLASS.



CLASS zem_api IMPLEMENTATION.

  METHOD send_string.
****************************************************
*Send JSON
****************************************************
    me->create_http_req( ).
    IF go_http_client IS NOT BOUND.
      r_ret-code = '500'.
      r_ret-resp = 'ABAP HTTP client not initialized'.
      RETURN.
    ENDIF.

    DATA:  rlength TYPE i,
           txlen   TYPE string.

    go_http_client->request->set_header_field(  EXPORTING name  = 'Content-Type'        value = is_rq-ctype ).
    IF is_rq-payload IS NOT INITIAL .
      rlength = strlen( is_rq-payload ) .
      MOVE: rlength TO txlen .
      go_http_client->request->append_cdata2(  EXPORTING data  = is_rq-payload   offset   = 0  length   = rlength
                                                         encoding = if_http_request=>co_encoding_raw ).
    ENDIF.

    r_ret = me->send_http_req( VALUE #( method = 'POST' target = is_rq-target ) ).

  ENDMETHOD.



  METHOD send_http_req.
****************************************************
*Send HTTP Request
****************************************************

    TRY.
        go_http_client->request->set_method( if_http_request=>co_request_method_post ).
        go_http_client->request->set_header_field(  EXPORTING name  = 'topic'               value = is_rq-target ).
        go_http_client->request->set_header_field(  EXPORTING name  = '~request_method'     value = is_rq-method ).
        go_http_client->request->set_header_field(  EXPORTING name  = '~server_protocol'    value = 'HTTP/1.1' ).

        go_http_client->send( EXCEPTIONS http_communication_failure   = 1 http_invalid_state           = 2
                                         http_processing_failed       = 3 http_invalid_timeout         = 4         ).
        IF sy-subrc IS INITIAL.
          go_http_client->receive( EXCEPTIONS  http_communication_failure  = 1
                                               http_invalid_state          = 2   http_processing_failed      = 3  ).
        ENDIF.
*      IF sy-subrc IS NOT INITIAL.
*        lo_http_client->close( ).
*        e_code = 500.
*        "CONTINUE.
*        RETURN.
*      ENDIF.
*
*      DATA(lx_string) =  lo_http_client->response->get_data( ).
        DATA(response)  =  go_http_client->response->get_cdata( ).
        r_ret-resp  = response.
        go_http_client->response->get_status( IMPORTING code = DATA(l_code)   reason = r_ret-reason ).
        r_ret-code = l_code.
        IF l_code <> 200.
        ENDIF.
        go_http_client->close( ).
      CATCH cx_root INTO DATA(lo_error3).
        r_ret-code = 500.
    ENDTRY.
  ENDMETHOD.


  METHOD create_http_req.
****************************************************
*Create HTTP Request
****************************************************
    DATA:
      ls_url   TYPE string,
      l_dest   TYPE c LENGTH 20,
      l_system LIKE sy-sysid.

    l_system  = sy-sysid.
    CASE l_system(1).
      WHEN 'D'.  "Development
        ls_url   = 'https://dev_server.com/' && 'RESTAdapter/em/' .
        l_dest   = 'DI1_REST_ADAPTER'. "LPD DATA EXTRACT
      WHEN 'Q'.  "Quality
        ls_url   = 'https://qual_server.com/'  && 'RESTAdapter/em/'. .   "load balancer
        l_dest   = 'QIX_REST_ADAPTER'.
      WHEN 'P'.  "Production
        ls_url   = 'https://prod_server.com/'  && 'RESTAdapter/em/' .  "load balancer
        l_dest   = 'PIX_REST_ADAPTER'.
    ENDCASE.

    TRY.
        " RFC Destination
        CALL METHOD cl_http_client=>create_by_destination
          EXPORTING
            destination              = l_dest
          IMPORTING
            client                   = go_http_client
          EXCEPTIONS
            argument_not_found       = 1
            destination_not_found    = 2
            destination_no_authority = 3
            plugin_not_active        = 4
            internal_error           = 5.
        cl_http_utility=>set_request_uri( request = go_http_client->request   uri = '/em/'  ).
      CATCH cx_root INTO DATA(lo_error3).
        "r_ret-code = 500.
    ENDTRY.
  ENDMETHOD.


ENDCLASS.