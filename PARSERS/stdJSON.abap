
lv_string = '{"id":"file","value":"File","popup":{"menuitem":[{"value":"New","onclick":"CreateNewDoc()"},{"value":"Open","onclick":"OpenDoc()"},{"value":"Close","onclick":"CloseDoc()"}]}}'.

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


* Deserialization of JSON to get the session id
/ui2/cl_json=>deserialize( EXPORTING json = lv_string  pretty_name = /ui2/cl_json=>pretty_mode-none CHANGING data = menu ).
