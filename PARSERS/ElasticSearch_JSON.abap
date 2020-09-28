method SEARCH_CSS_1.
    DATA: BEGIN OF hit,
          _index    TYPE string,
          _type     TYPE string,
          _id       TYPE string,
          _score    TYPE p DECIMALS 2,
          _source   TYPE REF TO yac_cl_json_value, "object,
          highlight TYPE REF TO yac_cl_json_value, "object,
        END OF hit.
  DATA: BEGIN OF search_response,
          took      TYPE i,
          timed_out TYPE string,
          BEGIN OF _shards,
            total      TYPE i,
            successful TYPE i,
            failed     TYPE i,
          END OF _shards,
          BEGIN OF hits,
            total     TYPE i,
            max_score TYPE p DECIMALS 2,
            hits      LIKE TABLE OF hit,
          END OF hits,
        END OF search_response,


        BEGIN OF css_source2,
          data1        TYPE string,      
          data2          TYPE string,      
          data3        TYPE string,     
          pred         TYPE string,      
          surveyresult TYPE string,     
          question     TYPE string,      
          answer       TYPE string,     
        END OF css_source2 ,


*          BEGIN OF css_highlight,
*            oq1result TYPE TABLE OF string, "doc.document
*          END OF css_highlight,

        BEGIN OF css_highlight2,
          answer TYPE TABLE OF string, "doc.document
        END OF css_highlight2.


  DATA: elastic_client  TYPE REF TO if_http_client,
        rest_client     TYPE REF TO cl_rest_http_client,
        request         TYPE REF TO if_rest_entity,
        response_entity TYPE REF TO if_rest_entity,

        url             TYPE string,
        response        TYPE string,
        query           TYPE string,
        search_term     TYPE string,
        lv_string       TYPE string,
        wa_index        TYPE string,
        wa_ind_sy       TYPE string,
        l_json_parser   TYPE REF TO /ui5/cl_json_parser,
        entries         LIKE LINE OF l_json_parser->m_entries.
*          wa_entityset    LIKE LINE OF et_entityset.

  IF NOT search_term IS INITIAL.
    CASE sy-sysid.
      WHEN 'DEV'. wa_ind_sy = 'bwd/'.
      WHEN 'QUAL'. wa_ind_sy = 'bwq/'.
      WHEN 'PROD'. wa_ind_sy = 'bwp/'.
      WHEN OTHERS.
    ENDCASE.

    wa_ind_sy = 'bwq/'.  "Testing purposes

    wa_index = 'css2'.
    url = 'http://elastic_serach_server.com/' && wa_ind_sy  && wa_index && '/_search'.
*      CONCATENATE 'http://elastic_serach_server.com/osc/dsv1/_search?q=*' query '*' INTO url.
*      url = 'http://elastic_serach_server.com/bwd/'  && wa_index && '/_search'.
    cl_http_client=>create_by_url(
      EXPORTING
        url                = url
      IMPORTING
        client             = elastic_client
      EXCEPTIONS
        argument_not_found = 1
        internal_error     = 2
        plugin_not_active  = 3
        OTHERS             = 4 ) .

*    elastic_client->authenticate( username = 'elastic_user' password = 'elastic_password!').
    elastic_client->request->set_method( if_http_request=>co_request_method_get ).
    elastic_client->propertytype_accept_cookie = 1.

    CREATE OBJECT rest_client
      EXPORTING
        io_http_client = elastic_client.

    request = rest_client->if_rest_client~create_request_entity( ).
    request->set_content_type( iv_media_type = if_rest_media_type=>gc_appl_json ).
*      Concatenate '{ "query" : { "match" : { "doc.document":"' query '" }}, "highlight" : {"fields" : {"doc.document" : {}}}}' into query.
*      CONCATENATE '{ "query" : { "match" : { "oq1Result":"' query '" }}, "highlight" : {"fields" : {"oq1Result" : {}}}}' INTO query.
*      CONCATENATE '{ "query" : { "regexp" : { "oq1Result":".*' query '.*" }}, "highlight" : {"fields" : {"oq1Result" : {}}}}' INTO query.
*      query  = '{ "query" : { "regexp" : { "answer":".*' &&  search_term && '.*" }}, "highlight" : {"fields" : {"answer" : {}}}}' .

*      increase the size:
    query  = '{ "from" : 0, "size" : 20, "query" : { "regexp" : { "answer":".*' &&  search_term && '.*" }}, "highlight" : {"fields" : {"answer" : {}}}}' .


    request->set_string_data( query ).
    rest_client->if_rest_client~set_request_header( iv_name = 'Authorization' iv_value = 'Basic abcdf' ).
    rest_client->if_rest_resource~post( request ).
    response_entity = rest_client->if_rest_client~get_response_entity( ).
    response = response_entity->get_string_data( ).


    CREATE OBJECT l_json_parser.
    l_json_parser->parse( response ).

    TRY.
* Parse JSON string into an objectified document in memory
        DATA(jdoc) = yac_cl_json_document=>parse( response ).
* Map parsed document to a predefined ABAP structure
        jdoc->map_root(   CHANGING   data = search_response ).
* Map a substructure contained in the mapped data to some differ
        LOOP AT search_response-hits-hits INTO hit.
          jdoc->map_data(  EXPORTING  json_value = hit-_source
                            CHANGING   data       = css_source2  ).
          jdoc->map_data(  EXPORTING  json_value = hit-highlight
                            CHANGING   data       = css_highlight2 ).
          CLEAR  lv_string.

*        LOOP AT css_highlight-oq1result INTO DATA(lv_str) .
          LOOP AT css_highlight2-answer INTO DATA(lv_str) .
            lv_string = lv_string && lv_str.
          ENDLOOP.


          REPLACE ALL OCCURRENCES OF '<em' IN lv_string WITH '<strong'.
          REPLACE ALL OCCURRENCES OF '</em' IN lv_string WITH '</strong'.

        ENDLOOP.
*        CATCH json_error INTO lx_jerr.
      CATCH cx_root.
    ENDTRY.

  ENDIF.



endmethod.