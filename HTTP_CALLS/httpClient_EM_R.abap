* Enterprise Messaging: 
REPORT zem_api_test.

PARAMETERS: p_target TYPE string DEFAULT 'd-sap-sandbox' LOWER CASE,
            p_payl   TYPE string DEFAULT '{"test":"hello" }' LOWER CASE,
            p_ctype  TYPE string DEFAULT 'application/json' LOWER CASE.

START-OF-SELECTION.
  DATA: lo_api TYPE REF TO zem_api,
        l_res  TYPE zem_api=>ts_http_res.

  lo_api = NEW #(  ).
  CASE p_ctype.
    WHEN 'application/json'.
      l_res = lo_api->send_string( VALUE #( payload = p_payl target = p_target ctype = p_ctype )  ).


*    WHEN 'application/text'.
*    WHEN 'image'.
*    WHEN 'pdf'.
*    new method to be developed
    WHEN OTHERS.
      l_res-code = '500'. l_res-resp = 'Content-type=' && p_ctype && ';not supported yet'.

  ENDCASE.

  WRITE l_res-code && '-' && l_res-resp.