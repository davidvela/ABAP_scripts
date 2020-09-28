* online -- yac_cl_json_document

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