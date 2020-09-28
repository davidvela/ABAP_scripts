*&---------------------------------------------------------------------*
*& Report  YAE_TEST_JSON
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT yae_test_json_class.

*&* Shows you how to use the JSON parser/mapper located at
*   https://gist.github.com/mydoghasworms/4888a832e28491c3fe47
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Include           ZTEMPJSON_INCL
*&---------------------------------------------------------------------*
* A clean, reliable and compliant JSON parser and mapper to ABAP data;
* the kind your mother would have encouraged you to hang out with.
*----------------------------------------------------------------------*
*       CLASS json_error DEFINITION
*----------------------------------------------------------------------*
CLASS json_error DEFINITION INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    DATA: offset TYPE i READ-ONLY.
    METHODS: constructor IMPORTING offset TYPE i.
ENDCLASS.                    "lcx_json_error DEFINITION
*----------------------------------------------------------------------*
*       CLASS json_error IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS json_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->offset = offset.
  ENDMETHOD.                    "constructor
ENDCLASS.                    "lcx_json_error IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS json_error_unexpected_char DEFINITION
*----------------------------------------------------------------------*
CLASS json_error_unexpected_char DEFINITION INHERITING FROM json_error.
ENDCLASS.                    "json_error_unexpected_char DEFINITION
*----------------------------------------------------------------------*
*       CLASS json_error_unexpected_end DEFINITION
*----------------------------------------------------------------------*
CLASS json_error_unexpected_end DEFINITION INHERITING FROM json_error.
ENDCLASS.                    "json_error_unexpected_end DEFINITION
*----------------------------------------------------------------------*
*       CLASS json_error_expecting_delimiter DEFINITION
*----------------------------------------------------------------------*
CLASS json_error_expecting_delimiter DEFINITION INHERITING FROM json_error.
ENDCLASS.                    "json_error_expecting_delimiter DEFINITION
*----------------------------------------------------------------------*
*       CLASS json_error_expecting_endinput DEFINITION
*----------------------------------------------------------------------*
CLASS json_error_expecting_endinput DEFINITION INHERITING FROM json_error.
ENDCLASS.                    "json_error_expecting_endinput DEFINITION

*--------------------------------------------------------------------*
* JSON DATATYPES

*----------------------------------------------------------------------*
*       CLASS json_value DEFINITION
*----------------------------------------------------------------------*
CLASS json_value DEFINITION.
  PUBLIC SECTION.
    TYPES: json_array TYPE TABLE OF REF TO json_value.
    TYPES: BEGIN OF json_keyval,
             key   TYPE string,
             value TYPE REF TO json_value,
           END OF json_keyval.
    TYPES: json_object TYPE HASHED TABLE OF json_keyval
           WITH UNIQUE KEY key.

* 'Type' can have the following values:
* 'A' - array
* 'O' - object
* 'S' - string
* 'N' - number
* 'B' - boolean
* '0' - null
    DATA: type TYPE char1.

    METHODS:
      get IMPORTING key          TYPE any
          RETURNING VALUE(value) TYPE REF TO json_value.

ENDCLASS.                    "json_value DEFINITION
*----------------------------------------------------------------------*
*       CLASS json_array DEFINITION
*----------------------------------------------------------------------*
CLASS json_array DEFINITION INHERITING FROM json_value.
  PUBLIC SECTION.
    DATA: value TYPE json_value=>json_array.
    METHODS: get REDEFINITION.
ENDCLASS.                    "json_array DEFINITION

*----------------------------------------------------------------------*
*       CLASS json_object DEFINITION
*----------------------------------------------------------------------*
CLASS json_object DEFINITION INHERITING FROM json_value.
  PUBLIC SECTION.
    DATA: value TYPE json_value=>json_object.

    METHODS:
      get REDEFINITION.
ENDCLASS.                    "json_object DEFINITION
*----------------------------------------------------------------------*
*       CLASS json_number DEFINITION
*----------------------------------------------------------------------*
CLASS json_number DEFINITION INHERITING FROM json_value.
  PUBLIC SECTION.
    DATA: value TYPE decfloat34. "numeric.
ENDCLASS.                    "json_number DEFINITION

*----------------------------------------------------------------------*
*       CLASS json_null DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS json_null DEFINITION INHERITING FROM json_value.
  PUBLIC SECTION.
    DATA: value TYPE string. "numeric.
ENDCLASS.                    "json_number DEFINITION
*----------------------------------------------------------------------*
*       CLASS json_string DEFINITION
*----------------------------------------------------------------------*
CLASS json_string DEFINITION INHERITING FROM json_value.
  PUBLIC SECTION.
    DATA: value TYPE string.
ENDCLASS.                    "json_string DEFINITION
*----------------------------------------------------------------------*
*       CLASS json_boolean DEFINITION
*----------------------------------------------------------------------*
CLASS json_boolean DEFINITION INHERITING FROM json_value.
  PUBLIC SECTION.
    DATA: value TYPE boole_d.
ENDCLASS.                    "json_boolean DEFINITION

*----------------------------------------------------------------------*
*       CLASS json_object IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS json_object IMPLEMENTATION.
  METHOD get.
    DATA: keyval TYPE json_keyval.
    READ TABLE me->value WITH KEY key = key
      INTO keyval.
    IF sy-subrc = 0.
      value = keyval-value.
    ENDIF.
  ENDMETHOD.                    "get

ENDCLASS.                    "json_object IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS json_array IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS json_array IMPLEMENTATION.
  METHOD get.
    READ TABLE me->value INTO value INDEX key.
  ENDMETHOD.                    "get
ENDCLASS.                    "json_array IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS json_document DEFINITION
*----------------------------------------------------------------------*
CLASS json_document DEFINITION CREATE PROTECTED.
  PUBLIC SECTION.

    DATA: json TYPE string READ-ONLY.
    DATA: root TYPE REF TO json_value READ-ONLY.
    DATA: length TYPE i.

    CONSTANTS: num_pattern TYPE string VALUE '[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?'.

    CLASS-METHODS
      parse
        IMPORTING json            TYPE string
        RETURNING VALUE(document) TYPE REF TO json_document
        RAISING   json_error.

    METHODS:

      next_char RAISING json_error_unexpected_end,
      skip_whitespace RAISING json_error_unexpected_end,
      parse_array
        RETURNING VALUE(array) TYPE REF TO json_array
        RAISING   json_error,
      parse_object
        RETURNING VALUE(object) TYPE REF TO json_object
        RAISING   json_error,
      parse_value
        RETURNING VALUE(value) TYPE REF TO json_value
        RAISING   json_error,
      parse_string
        RETURNING VALUE(string) TYPE string
        RAISING   json_error.

    METHODS:
      map_data
        IMPORTING json_value TYPE REF TO json_value
        CHANGING  data       TYPE any,
      map_root
        CHANGING data TYPE any.


  PROTECTED SECTION.
    DATA: index TYPE i.
    DATA: char(1) TYPE c.

    METHODS:
      constructor
        IMPORTING json TYPE string
        RAISING   json_error.

    METHODS:
      map_table
        IMPORTING json_value TYPE REF TO json_value
        CHANGING  data       TYPE ANY TABLE,
      map_structure
        IMPORTING json_value TYPE REF TO json_value
        CHANGING  data       TYPE any,
      map_scalar
        IMPORTING json_value TYPE REF TO json_value
        CHANGING  data       TYPE any.

ENDCLASS.                    "json_document DEFINITION

*----------------------------------------------------------------------*
*       CLASS json_value IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS json_value IMPLEMENTATION.
  METHOD get.
  ENDMETHOD.                    "get
ENDCLASS.                    "json_value IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS json_document IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS json_document IMPLEMENTATION.

  METHOD constructor.
    me->json = json. "Store local copy of JSON string
    length = strlen( json ). "Determine length of JSON string
    index = 0. "Start at index 0
    char = json+index(1). "Kick off things by reading first char
    skip_whitespace( ).
    CASE char.
      WHEN '{'.
        me->root = parse_object( ).
      WHEN '['.
        me->root = parse_array( ).
      WHEN OTHERS.
* TODO: raise exception; expecting array or object
    ENDCASE.
    IF index < length.
      RAISE EXCEPTION TYPE json_error_expecting_endinput
        EXPORTING
          offset = index.
    ENDIF.
  ENDMETHOD.                    "constructor

**********************************************************************
* MAPPER METHODS
**********************************************************************

  METHOD map_root.
* Convenience method to map the root json entity of the document
    CALL METHOD map_data
      EXPORTING
        json_value = root
      CHANGING
        data       = data.
  ENDMETHOD.                    "map_root

  METHOD map_data.
* Entry point for mapping JSON to ABAP data
    DATA: descr TYPE REF TO cl_abap_typedescr.
    descr = cl_abap_datadescr=>describe_by_data( data ).
    IF descr->kind = cl_abap_datadescr=>kind_struct.
      IF json_value->type NE 'O'. "No mapping if no type match
        RETURN.
      ENDIF.
      CALL METHOD map_structure
        EXPORTING
          json_value = json_value
        CHANGING
          data       = data.
    ELSEIF descr->kind = cl_abap_datadescr=>kind_table.
      CALL METHOD map_table
        EXPORTING
          json_value = json_value
        CHANGING
          data       = data.
    ELSE.
      CALL METHOD map_scalar
        EXPORTING
          json_value = json_value
        CHANGING
          data       = data.
    ENDIF.
  ENDMETHOD.                    "map_data

  METHOD map_scalar.
    DATA: descr TYPE REF TO cl_abap_typedescr.
    FIELD-SYMBOLS: <value> TYPE any.
    descr = cl_abap_typedescr=>describe_by_data( data ).

    IF descr->type_kind = cl_abap_datadescr=>typekind_oref.
      TRY.
          data ?= json_value.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
    ELSE.
      ASSIGN json_value->('VALUE') TO <value>.
      data = <value>.
    ENDIF.

  ENDMETHOD.                    "map_scalar

  METHOD map_structure.

    IF json_value->type NE 'O'. "No mapping if no type match
      RETURN.
    ENDIF.

    DATA: json_object TYPE REF TO json_object.
    json_object ?= json_value.

    FIELD-SYMBOLS: <field> TYPE any.
    DATA: descr TYPE REF TO cl_abap_typedescr.
    DATA: json_comp TYPE REF TO json_value.
    descr = cl_abap_datadescr=>describe_by_data( data ).

    DATA: keyval TYPE json_value=>json_keyval.

    LOOP AT json_object->value INTO keyval.
      TRANSLATE keyval-key TO UPPER CASE.
*     dvt --> fix - replace points for _
      REPLACE ALL OCCURRENCES OF '.' IN keyval-key WITH '_'.

      ASSIGN COMPONENT keyval-key OF STRUCTURE data TO <field>.
      IF sy-subrc NE 0. "No corresponding ABAP component, no match
        CONTINUE.
      ENDIF.
      descr = cl_abap_datadescr=>describe_by_data( <field> ).

      IF descr->kind = cl_abap_datadescr=>kind_struct.
        IF keyval-value->type NE 'O'. "No mapping if no type match
          CONTINUE. "Next component of object
        ENDIF.
        CALL METHOD map_structure
          EXPORTING
            json_value = keyval-value
          CHANGING
            data       = <field>.

      ELSEIF descr->kind = cl_abap_datadescr=>kind_table.
        IF keyval-value->type NE 'A'. "No mapping if no type match
          RETURN. "Next component of object
        ENDIF.
        CALL METHOD map_table
          EXPORTING
            json_value = keyval-value
          CHANGING
            data       = <field>.

      ELSE.
        CALL METHOD map_scalar
          EXPORTING
            json_value = keyval-value
          CHANGING
            data       = <field>.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.                    "map_structure

  METHOD map_table.

    IF json_value->type NE 'A'.
      RETURN.
    ENDIF.
    DATA: json_array TYPE REF TO json_array.
    json_array ?= json_value.

    DATA: json_row TYPE REF TO json_value.
    FIELD-SYMBOLS: <row> TYPE any.
    FIELD-SYMBOLS: <stab> TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <ktab> TYPE SORTED TABLE.
    DATA: row_data TYPE REF TO data.
    DATA: descr TYPE REF TO cl_abap_typedescr.
    DATA: rowdesc TYPE REF TO cl_abap_typedescr.
    DATA: tabdesc TYPE REF TO cl_abap_tabledescr.

    CLEAR data.
    CREATE DATA row_data LIKE LINE OF data.
    ASSIGN row_data->* TO <row>.

    tabdesc ?= cl_abap_typedescr=>describe_by_data( data ).
    rowdesc = cl_abap_typedescr=>describe_by_data( <row> ).

    IF tabdesc->table_kind = cl_abap_tabledescr=>tablekind_hashed OR
       tabdesc->table_kind = cl_abap_tabledescr=>tablekind_sorted.
      ASSIGN data TO <ktab>.
    ELSE.
      ASSIGN data TO <stab>.
    ENDIF.

    LOOP AT json_array->value INTO json_row.

      IF rowdesc->kind = cl_abap_typedescr=>kind_struct.
        CALL METHOD map_structure
          EXPORTING
            json_value = json_row
          CHANGING
            data       = <row>.
      ELSEIF rowdesc->kind = cl_abap_typedescr=>kind_table.
        CALL METHOD map_table
          EXPORTING
            json_value = json_row
          CHANGING
            data       = <row>.
      ELSE.
        CALL METHOD map_scalar
          EXPORTING
            json_value = json_row
          CHANGING
            data       = <row>.
      ENDIF.

      IF tabdesc->table_kind = cl_abap_tabledescr=>tablekind_hashed OR
         tabdesc->table_kind = cl_abap_tabledescr=>tablekind_sorted.
        INSERT <row> INTO TABLE <ktab>.
      ELSE.
        APPEND <row> TO <stab>.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.                    "map_table

**********************************************************************
* PARSE METHODS
**********************************************************************

  METHOD next_char.
    index = index + 1.
    IF index < length.
      char = json+index(1).
    ELSEIF index = length.
      char = space.
    ELSEIF index > length.
* Unexpected end reached; exception
      RAISE EXCEPTION TYPE json_error_unexpected_end
        EXPORTING
          offset = index.
    ENDIF.
  ENDMETHOD.                    "next_char

  METHOD skip_whitespace.
    WHILE char = ' ' OR char = cl_abap_char_utilities=>newline OR char = cl_abap_char_utilities=>cr_lf(1).
      next_char( ).
    ENDWHILE.
  ENDMETHOD.                    "skip_whitespace

  METHOD parse_array.
    CREATE OBJECT array.
    array->type = 'A'.

    next_char( ). "Skip past opening bracket
    WHILE index < length.
      skip_whitespace( ).
      APPEND parse_value( ) TO array->value.
      IF char = ','.
        next_char( ). "Skip comma, on to next value
        " Continue to next value
      ELSEIF char = ']'.
        next_char( ). "Skip past closing bracket
        "Return completed array object
        RETURN.
      ELSE.
        RAISE EXCEPTION TYPE json_error_unexpected_char
          EXPORTING
            offset = index.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.                    "parse_array

  METHOD parse_object.

    DATA: entry TYPE json_value=>json_keyval.
    CREATE OBJECT object.
    object->type = 'O'.

    next_char( ). "Skip past opening brace

    WHILE index < length.

      skip_whitespace( ).
      IF char = '"'.
        entry-key = parse_string( ).
      ELSE.
* TODO: exception: expecting key
      ENDIF.

      skip_whitespace( ).
      IF char = ':'.
        next_char( ).
        entry-value = parse_value( ).
        INSERT entry INTO TABLE object->value.
      ELSE.
* TODO: Expecting colon
      ENDIF.

      skip_whitespace( ).
      IF char = '}'. "End of object reached
        " Exit
        next_char( ). "Skip past closing brace
        RETURN.
      ELSEIF char = ','.
        next_char( ).
        " Continue to next keyval
      ELSE.
        RAISE EXCEPTION TYPE json_error_unexpected_char
          EXPORTING
            offset = index.
      ENDIF.

    ENDWHILE.
  ENDMETHOD.                    "parse_object

  METHOD parse_value.
    skip_whitespace( ).

    CASE char.
      WHEN '['.
        DATA: array TYPE REF TO json_array.
        array = parse_array( ).
        value = array.
      WHEN '{'.
        DATA: object TYPE REF TO json_object.
        object = parse_object( ).
        value = object.
      WHEN '"'.
        DATA: string TYPE REF TO json_string.
        CREATE OBJECT string.
        string->type = 'S'.
        string->value = parse_string( ).
        value = string.
      WHEN OTHERS.
        DATA: sval TYPE string.
* Run to delimiter
        WHILE index < length.
          sval = |{ sval }{ char }|.
          next_char( ).
          IF char = ',' OR char = '}' OR char = ']' OR char = ' ' OR char = cl_abap_char_utilities=>newline
            OR char = cl_abap_char_utilities=>cr_lf(1).
            EXIT.
          ENDIF.
        ENDWHILE.
* Determine different scalar types. Must be: true, false, null or number
        CONDENSE sval.
        FIELD-SYMBOLS: <value> TYPE any.
        IF sval = 'true' OR sval = 'false'.
          CREATE OBJECT value TYPE json_boolean.
          ASSIGN value->('VALUE') TO <value>.
          value->type = 'B'.
          IF sval = 'true'.
            <value> = abap_true.
          ELSE.
            <value> = abap_false.
          ENDIF.
        ELSEIF sval = 'null'.
          CREATE OBJECT value TYPE json_null.
          value->type = '0'.
        ELSE.
          FIND REGEX num_pattern IN sval.
          IF sy-subrc NE 0.
            RAISE EXCEPTION TYPE json_error_unexpected_char
              EXPORTING
                offset = index.
          ENDIF.
          CREATE OBJECT value TYPE json_number.
          ASSIGN value->('VALUE') TO <value>.
          value->type = 'N'.
          <value> = sval.
        ENDIF.
    ENDCASE.

* After parsing array or object, cursor will be on closing bracket or brace, so we want to skip to next char

    skip_whitespace( ). "Skip to next character, which should be a delimiter of sorts

    IF char NE ',' AND char NE '}' AND char NE ']'.
      RAISE EXCEPTION TYPE json_error_expecting_delimiter
        EXPORTING
          offset = index.
    ENDIF.

  ENDMETHOD.                    "parse_value

  METHOD parse_string.
    DATA: pchar(1) TYPE c. "Previous character
    WHILE index < length.
      next_char( ).
      IF char = '"' AND pchar NE '\'.
        EXIT.
      ENDIF.
      CONCATENATE string char INTO string RESPECTING BLANKS.
      pchar = char.
    ENDWHILE.
    next_char( ). "Skip past closing quote
  ENDMETHOD.                    "parse_string

  METHOD parse.
    CREATE OBJECT document
      EXPORTING
        json = json.
  ENDMETHOD.                    "parse

ENDCLASS.                    "json_document IMPLEMENTATION



START-OF-SELECTION.
  BREAK-POINT.

  DATA : lt_data   TYPE TABLE OF string,
         lv_string TYPE string.


  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = 'C:\temp\json.txt'
*     FILETYPE                = 'ASC'
*     HAS_FIELD_SEPARATOR     = ' '
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      = VIRUS_SCAN_PROFILE
*     NO_AUTH_CHECK           = ' '
* IMPORTING
*     FILELENGTH              = FILELENGTH
*     HEADER                  = HEADER
    TABLES
      data_tab                = lt_data
* CHANGING
*     ISSCANPERFORMED         = ' '
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

    DATA l_json_parser TYPE REF TO json_document. "yac_json_document
    "CREATE OBJECT l_json_parser EXPORTING json = lv_string.
    l_json_parser = json_document=>parse( lv_string ).
    TRY.
        "Parse JSON string into an objectified document in memory
        "DATA(jdoc) = yac_cl_json_document=>parse( lv_string ).
        "Map parsed document to a predefined ABAP structure
        l_json_parser->map_root(  CHANGING   data = menu ).
    ENDTRY.
  ENDIF.

  BREAK-POINT.