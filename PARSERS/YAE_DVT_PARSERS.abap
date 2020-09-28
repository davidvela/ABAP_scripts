*&---------------------------------------------------------------------*
*& Report  YAE_DVT_PARSERS
*&    * JSON 
*&    * XML
*&---------------------------------------------------------------------*
REPORT yae_test_json.
BREAK-POINT.

DATA : lt_data   TYPE TABLE OF string,
       lv_string TYPE string.


CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename                = 'C:\temp\json.txt'
*   FILETYPE                = 'ASC'
*   HAS_FIELD_SEPARATOR     = ' '
*   HEADER_LENGTH           = 0
*   READ_BY_LINE            = 'X'
*   DAT_MODE                = ' '
*   CODEPAGE                = ' '
*   IGNORE_CERR             = ABAP_TRUE
*   REPLACEMENT             = '#'
*   CHECK_BOM               = ' '
*   VIRUS_SCAN_PROFILE      = VIRUS_SCAN_PROFILE
*   NO_AUTH_CHECK           = ' '
* IMPORTING
*   FILELENGTH              = FILELENGTH
*   HEADER                  = HEADER
  TABLES
    data_tab                = lt_data
* CHANGING
*   ISSCANPERFORMED         = ' '
  EXCEPTIONS
    file_open_error         = 1
    file_read_error         = 2
    no_batch                = 3
    gui_refuse_filetransfer = 4
    invalid_type            = 5
    no_authority            = 6
    unknown_error           = 7
    bad_data_format         = 8
    header_not_allowed      = 9
    separator_not_allowed   = 10
    header_too_long         = 11
    unknown_dp_error        = 12
    access_denied           = 13
    dp_out_of_memory        = 14
    disk_full               = 15
    dp_timeout              = 16.

IF sy-subrc = 0.

*  CALL FUNCTION 'CRM_SVY_DB_CONVERT_CTAB2STRING'
*    IMPORTING
*      s     = lv_string
*    TABLES
*      c_tab = lt_data.
*
**DATA IT_TLINES    TYPE /SAPSLL/TLINES_T.
**DATA EV_TXTSTRING TYPE STRING.
*
*CALL FUNCTION '/SAPSLL/TEXT_TABLE_TO_STRING'
*  EXPORTING
*    it_tlines          = it_tlines
** IMPORTING
**   EV_TXTSTRING       = EV_TXTSTRING.

  READ TABLE lt_data INTO lv_string INDEX 1.
  IF sy-subrc = 0.
    "CONTINUE.
  ELSE.
    lv_string = '{"id":"file","value":"File","popup":{"menuitem":[{"value":"New","onclick":"CreateNewDoc()"},{"value":"Open","onclick":"OpenDoc()"},{"value":"Close","onclick":"CloseDoc()"}]}}'.
  ENDIF.

***    CLEAR lt_data.
**** deserialize JSON string json into internal table lt_flight doing camelCase to ABAP like field name mapping
***    /ui2/cl_json=>deserialize( EXPORTING json = lv_string pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_json_itab ).

  "DATA : l_json_parser   TYPE REF TO /ui5/cl_json_parser.
  DATA l_json_parser TYPE REF TO yac_cl_json_document.
  DATA: BEGIN OF menuitem,
          value   TYPE string,
          onclick TYPE string,
        END OF menuitem.


  DATA: BEGIN OF menu,
          id    TYPE string,
          value TYPE string,
          BEGIN OF popup,
            menuitem LIKE TABLE OF menuitem,
          END OF popup,
        END OF menu.



  " json parsing
  CREATE OBJECT l_json_parser EXPORTING json = lv_string.
  "l_json_parser->parse( lv_string ).
  TRY.
      "Parse JSON string into an objectified document in memory
      "DATA(jdoc) = yac_cl_json_document=>parse( lv_string ).
      "Map parsed document to a predefined ABAP structure
      l_json_parser->map_root(  CHANGING   data = menu ).
  ENDTRY.
ENDIF.

BREAK-POINT.

*&---------------------------------------------------------------------*
*& Report  YAE_TEST_XML
*&
*&---------------------------------------------------------------------*
REPORT YAE_TEST_XML.

DATA : lt_data      TYPE TABLE OF string,
       ls_json_data TYPE zmtest_json_0,
       lv_string    TYPE string.


CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename                = 'C:\temp\XML.txt'
*   FILETYPE                = 'ASC'
*   HAS_FIELD_SEPARATOR     = ' '
*   HEADER_LENGTH           = 0
*   READ_BY_LINE            = 'X'
*   DAT_MODE                = ' '
*   CODEPAGE                = ' '
*   IGNORE_CERR             = ABAP_TRUE
*   REPLACEMENT             = '#'
*   CHECK_BOM               = ' '
*   VIRUS_SCAN_PROFILE      = VIRUS_SCAN_PROFILE
*   NO_AUTH_CHECK           = ' '
* IMPORTING
*   FILELENGTH              = FILELENGTH
*   HEADER                  = HEADER
  TABLES
    data_tab                = lt_data
* CHANGING
*   ISSCANPERFORMED         = ' '
  EXCEPTIONS
    file_open_error         = 1
    file_read_error         = 2
    no_batch                = 3
    gui_refuse_filetransfer = 4
    invalid_type            = 5
    no_authority            = 6
    unknown_error           = 7
    bad_data_format         = 8
    header_not_allowed      = 9
    separator_not_allowed   = 10
    header_too_long         = 11
    unknown_dp_error        = 12
    access_denied           = 13
    dp_out_of_memory        = 14
    disk_full               = 15
    dp_timeout              = 16.

IF sy-subrc = 0.
  READ TABLE lt_data INTO lv_string INDEX 1.
  IF sy-subrc = 0.
    DATA : lo_reader TYPE REF TO cl_sxml_string_reader.
    lo_reader ?= cl_sxml_string_reader=>create(
                   cl_abap_codepage=>convert_to( lv_string ) ).

    CALL TRANSFORMATION zmtest_json_transform1
      SOURCE XML lo_reader
      RESULT contacts_json = ls_json_data.

  ENDIF.

ENDIF.

DATA:   lv_response TYPE string value 'xml...<?>???<>/??',
        lt_table_sp TYPE TABLE OF string, 
        lv_value    TYPE string, 
        l_xml_part1 TYPE string, 
        l_xml_part2 TYPE string  .

  SPLIT lv_response AT '<xml_attr>' INTO TABLE lt_table_sp.
  IF sy-subrc IS INITIAL.
    READ TABLE lt_table_sp  INDEX 1  INTO l_xml_part1 .
    READ TABLE lt_table_sp  INDEX 2  INTO lv_string .
    SPLIT lv_string AT '</xml_attr>' INTO TABLE lt_table_sp.
    IF sy-subrc IS INITIAL.
      READ TABLE lt_table_sp  INDEX 1 INTO lv_value .
      READ TABLE lt_table_sp  INDEX 2 INTO l_xml_part2 .
    ENDIF.
  ENDIF.

  l_response = l_xml_part1 && lv_value && l_xml_part2.
