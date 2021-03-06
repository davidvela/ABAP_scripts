*&---------------------------------------------------------------------*
*& Report  YAC_DVT_SHAREPOINT_TEST
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT yac_dvt_sharepoint_test.

PARAMETERS: p_folder TYPE string DEFAULT 'Shared%20Documents/DAVIDTEST' LOWER CASE,
            p_fol_sh TYPE string DEFAULT 'del' LOWER CASE,
            p_file   TYPE string DEFAULT 'ar.jpg' LOWER CASE,
            p_cnt    TYPE string DEFAULT 'file content 1234' LOWER CASE,
            p_locald TYPE string DEFAULT 'C:/temp/ar.txt' LOWER CASE.

PARAMETERS: p_def    TYPE c RADIOBUTTON GROUP p2,
            p_fo_ch  TYPE c RADIOBUTTON GROUP p2, " Folder check
            p_fo_sh  TYPE c RADIOBUTTON GROUP p2 DEFAULT 'X', " Folder search
            p_fo_cr  TYPE c RADIOBUTTON GROUP p2, " Folder creation
            p_fo_dl  TYPE c RADIOBUTTON GROUP p2, " Folder delete
            p_fi_ch  TYPE c RADIOBUTTON GROUP p2, " File   check
            p_fi_rd  TYPE c RADIOBUTTON GROUP p2, " File   read
            p_fi_cr  TYPE c RADIOBUTTON GROUP p2, " File   creation
            p_fi_dl  TYPE c RADIOBUTTON GROUP p2, " File   delete
            p_fi_cp  TYPE c RADIOBUTTON GROUP p2, " File   copy.
            p_fi_cpi TYPE c RADIOBUTTON GROUP p2 . " File Copy Image
PARAMETERS: p_debug AS CHECKBOX.

AT SELECTION-SCREEN OUTPUT.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dir.
*  PERFORM select_dir_from_pc.

START-OF-SELECTION.


START-OF-SELECTION.
  DATA: " call PI --
    l_prefix    TYPE string VALUE '/sites/<site_name>/',
    l_length    TYPE i,
    l_ctype     TYPE string,
    l_code      TYPE i,
    l_codestr   TYPE string,
    l_codes     TYPE char1,
    l_path      TYPE string,
    g_body      TYPE string,
    gx_body     TYPE xstring,
    x_method    TYPE string,
    m_method    TYPE string,
    r_error     TYPE abap_bool,
    pi_client   TYPE REF TO if_http_client,
    gs_response TYPE string.

  IF p_def  = abap_true .
    WRITE 'Default test'.      NEW-LINE.
    RETURN.
  ENDIF.


  PERFORM create_client.
  CASE abap_true.
      " Documentation: https://docs.microsoft.com/en-us/sharepoint/dev/sp-add-ins/working-with-folders-and-files-with-rest
      " https://www.w3schools.com/tags/ref_urlencode.ASP

    WHEN p_fo_ch.
      WRITE 'Folder check'.      NEW-LINE.
* retrieve folder: GET https://{site_url}/_api/web/GetFolderByServerRelativeUrl('/Shared%20Documents')/Folders
*  HTTP header:    Authorization: "Bearer " + accessToken // Accept: "application/json;odata=verbose"
      "or -> retrieve folder: GET https://{site_url}/_api/web/GetFolderByServerRelativeUrl('/Shared%20Documents/FolderName')
      " and if there is error => does not exist!

      l_path = 'GetFolderByServerRelativeUrl(%27' && l_prefix &&  p_folder && '%27)'.
      m_method = 'GET'.
      pi_client->request->set_method( if_http_request=>co_request_method_get ).
      x_method = ''.
      " loop for the name of the folder

    WHEN p_fo_sh.
      "/_api/web/GetFolderByServerRelativeUrl( '/sites/folder' )/Folders
      "?$filter=substringof('del', ServerRelativeUrl) eq true&$select=ServerRelativeUrl

      WRITE 'Folder Search'.      NEW-LINE.
      l_path = 'GetFolderByServerRelativeUrl(%27' && l_prefix &&  p_folder && '%27)'.
      "l_path = l_path  && '/Folders?$filter=substringof(%27del%27,ServerRelativeUrl)%20eq%20true&$select=ServerRelativeUrl'.
      l_path = l_path  && '/Folders?$select=ServerRelativeUrl&$filter=substringof(''' && p_fol_sh &&''',ServerRelativeUrl) eq true'.
      "l_path = l_path  && '/Folders?$select=ServerRelativeUrl'.
      "l_path = l_path  && '/Folders?$select=ServerRelativeUrl&$filter=ServerRelativeUrl%20eq%20%27/sites/<site_name>/Shared%20Documents/DAVIDTEST/test%27'.
      m_method = 'GET'.
      pi_client->request->set_method( if_http_request=>co_request_method_get ).
      x_method = ''.


    WHEN p_fo_cr.
      WRITE 'Folder Creation'.   NEW-LINE.
* create folder:  POST https://{site_url}/_api/web/folders
* HTTP headers:   Authorization: "Bearer " + accessToken // Accept: "application/json;odata=verbose"
*                 Content-Type: "application/json" // Content-Length: {length of request body as integer}
*                 X-RequestDigest: "{form_digest_value}" ??
*BODY =  { "__metadata":{"type": "SP.Folder" },
*          "ServerRelativeUrl": "/Shared%20Documents/DAVIDTEST"   }
*      l_path = 'folders'.
*      g_body = '{ "__metadata":{"type": "SP.Folder" },"ServerRelativeUrl": "' && l_prefix && p_folder && '"   }'.
*     POST https://{site_url}/_api/Web/Folders/add('Shared Documents/folderpath')
      l_path = 'Folders/add(%27' && l_prefix &&  p_folder && '%27)'.
      m_method = 'POST'.
      pi_client->request->set_method( if_http_request=>co_request_method_post ).
      x_method = ''.

    WHEN p_fo_dl.
      WRITE 'Folder Deletion'.   NEW-LINE.
* delete folder:  POST https://{site_url}/_api/web/GetFolderByServerRelativeUrl('/Folder Name')
* HTTP headers:   Authorization: "Bearer " + accessToken // If-Match: "{etag or *}" // X-HTTP-Method: "DELETE"
*                 X-RequestDigest: "{form_digest_value}"
      l_path = 'GetFolderByServerRelativeUrl(%27' && l_prefix &&  p_folder && '%27)'.
      m_method = 'POST'.
      pi_client->request->set_method( if_http_request=>co_request_method_post ).
      x_method = 'DELETE'.
      pi_client->request->set_header_field(  name  = 'x_method' value = x_method ).

    WHEN p_fi_ch.
      WRITE 'File check'.        NEW-LINE.
* get all files in folder: GET https://{site_url}/_api/web/GetFolderByServerRelativeUrl('/Folder Name')/Files
*                 method: GET // Authorization: "Bearer " + accessToken // Accept: "application/json;odata=verbose"

      l_path = 'GetFileByServerRelativeUrl(%27' && l_prefix &&  p_folder && '/' && p_file && '%27)'.
      m_method = 'GET'.
      pi_client->request->set_method( if_http_request=>co_request_method_get ).
      x_method = ''.


    WHEN p_fi_rd.
      WRITE 'File READ'.        NEW-LINE.
* get specific file: GET https://{site_url}/_api/web/GetFolderByServerRelativeUrl('/Folder Name')/Files('{file_name}')/$value
*                    Authorization: "Bearer " + accessToken

* get file by URL: GET https://{site_url}/_api/web/GetFileByServerRelativeUrl('/Folder Name/{file_name})/$value
*                    Authorization: "Bearer " + accessToken
      l_path = 'GetFileByServerRelativeUrl(%27' && l_prefix &&  p_folder && '/' && p_file && '%27)/$value'.
      m_method = 'GET'.
      pi_client->request->set_method( if_http_request=>co_request_method_get ).
      x_method = ''.


    WHEN p_fi_cr.
      WRITE 'File Creation'.     NEW-LINE.
* create file: POST https://{site_url}/_api/web/GetFolderByServerRelativeUrl('/Folder Name')/Files/add(url='a.txt',overwrite=true)
*        Authorization: "Bearer " + accessToken // Content-Length: {length of request body as integer}// X-RequestDigest: "{form_digest_value}"
* BODY: "Contents of file"
      l_path = 'GetFolderByServerRelativeUrl(%27' && l_prefix &&  p_folder  && '%27)/Files/add(url=%27' && p_file && '%27,overwrite=true) '.
      m_method = 'POST'.
      pi_client->request->set_method( if_http_request=>co_request_method_post ).
      x_method = ''.
      g_body = p_cnt.
      pi_client->request->set_cdata( data = g_body ).
      MOVE strlen( g_body ) TO l_length.
      l_ctype = 'text/plain'.

    WHEN p_fi_cpi.

      WRITE 'File Copy Image'.     NEW-LINE.
      l_path = 'GetFolderByServerRelativeUrl(%27' && l_prefix &&  p_folder  && '%27)/Files/add(url=%27' && p_file && '%27,overwrite=true) '.
      m_method = 'POST'.
      pi_client->request->set_method( if_http_request=>co_request_method_post ).
      x_method = ''.
      "g_body.
      PERFORM get_image_body.

      "pi_client->request->set_cdata( data = g_body ).
      pi_client->request->set_data(  data = gx_body ). "offset = 0 length = l_length ).
      l_ctype = 'application/octet-stream'.
      l_ctype = 'image/jpeg'.
      "l_ctype = 'bin'.


    WHEN p_fi_dl.
      WRITE 'File Deletion'.     NEW-LINE.
* delete file: POST https://{site_url}/_api/web/GetFileByServerRelativeUrl('/Folder Name/{file_name}')
*  Authorization: "Bearer " + accessToken// If-Match: "{etag or *}" // X-HTTP-Method: "DELETE" // X-RequestDigest: "{form_digest_value}"
      l_path = 'GetFileByServerRelativeUrl(%27' && l_prefix &&  p_folder && '/' && p_file && '%27)'.
      m_method = 'POST'.
      pi_client->request->set_method( if_http_request=>co_request_method_post ).
      x_method = 'DELETE'.
      pi_client->request->set_header_field(  name  = 'x_method' value = x_method ).

*    WHEN p_fi_cp.  WRITE 'File Copy'.         NEW-LINE.>
* ??? I guess it will be get file content first and then create a new one ...

    WHEN OTHERS.
      WRITE 'Operation currently not supported'.
  ENDCASE.

  WRITE l_path.
  NEW-LINE.
  "RETURN.
  cl_http_utility=>set_request_uri( request = pi_client->request uri = '/msspusps' ).
  pi_client->request->set_header_field(  name  = 'path' value = l_path ).
  pi_client->request->set_header_field(  name  = '~request_method'   value = m_method ).
  pi_client->request->set_header_field(  name  = 'operation'         value = m_method ).
  pi_client->request->set_header_field(  name  = 'x_method'          value = x_method ).
  pi_client->request->set_header_field(  name  = 'content_len'       value = CONV string( l_length ) ).
  pi_client->request->set_header_field(  name  = 'content_type'      value = l_ctype ).
  PERFORM send_req.

  IF r_error = abap_true.
    WRITE 'error occured'.
  ENDIF.



  PERFORM close_client.

  "process response ...
  CASE abap_true.
    WHEN p_fo_ch." if error => folder does not exist
    WHEN p_fo_sh.
      DATA: BEGIN OF ls_ressh,
              serverrelativeurl TYPE string,
            END OF ls_ressh.

      DATA: BEGIN OF lsd,
              BEGIN OF d,
                results LIKE TABLE OF ls_ressh,
              END OF d,
            END OF lsd.
      /ui2/cl_json=>deserialize( EXPORTING json = gs_response  pretty_name = /ui2/cl_json=>pretty_mode-none CHANGING data = lsd ).
      WRITE 'SH Folders:'. NEW-LINE.
      LOOP AT lsd-d-results INTO ls_ressh.
        WRITE  ls_ressh-serverrelativeurl. NEW-LINE.
      ENDLOOP..


    WHEN p_fo_cr.
    WHEN p_fo_dl.
    WHEN p_fi_ch." if error => file does not exist
    WHEN p_fi_rd.
    WHEN p_fi_cr.
    WHEN p_fi_dl.
  ENDCASE..



  "***************************************************************
  "***************************************************************
  " FORMS
  "**************************************************************
  "**************************************************************

FORM send_req.
  "***************************************************************
  " SEND REQUEST
  "**************************************************************

  TRY.
*     pi_client->request->set_method( if_http_request=>co_request_method_post ).
*     pi_client->request->set_header_field(  name  = 'path' value = path ).
*     pi_client->request->set_header_field( name  = 'filename' value = fname ).
*     MOVE strlen( g_body ) TO l_length.
*     pi_client->request->set_cdata( data = g_body ).

      pi_client->propertytype_accept_cookie = 1.
      pi_client->send( EXCEPTIONS
                                http_communication_failure = 1
                                http_invalid_state = 2
                                http_processing_failed = 3
                                http_invalid_timeout  = 4
                                OTHERS = 5 ).
      IF sy-subrc IS NOT INITIAL.
        r_error = abap_true.
      ENDIF.

      pi_client->receive(  EXCEPTIONS
                                http_communication_failure = 1
                                http_invalid_state = 2
                                http_processing_failed = 3
                                OTHERS = 4 ).
      IF sy-subrc IS NOT INITIAL.
        r_error = abap_true.
      ENDIF.

      pi_client->response->get_status( IMPORTING code = l_code ). "DF EIT - Outcome
      " log -- error handling
      r_error   = abap_false.
      l_codestr = l_code.
      l_codes   = l_codestr(1).
      CASE l_codes.
        WHEN '2' .    " successful
        WHEN OTHERS . " errors
          r_error = abap_true.
      ENDCASE.

      DATA(response) = pi_client->response->get_cdata( ).
      DATA(xres)     = pi_client->response->get_data( ).
      gs_response = response.
      WRITE response.
      NEW-LINE.
      WRITE 'HTTP Code = ' && l_code.
      NEW-LINE.

      DATA:  mime_length TYPE i,
             mime_soli   TYPE soli_tab,
             xsres       TYPE string.
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = xres
        IMPORTING
          output_length = mime_length
        TABLES
          binary_tab    = mime_soli.
      CALL FUNCTION 'SCMS_BINARY_TO_STRING'
        EXPORTING
          input_length = mime_length
          first_line   = 0
        IMPORTING
          text_buffer  = xsres
        TABLES
          binary_tab   = mime_soli
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.
      WRITE xsres.


      IF p_debug = abap_true.
        BREAK-POINT.
      ENDIF.
    CATCH cx_root.
      r_error = abap_true.
  ENDTRY.
ENDFORM.


FORM create_client.
  "***************************************************************
  " CREATE CLIENT
  "**************************************************************
  DATA: l_rfc_dest TYPE string.

  CASE sy-sysid(1).
    WHEN 'D'.
      l_rfc_dest = 'DI1_REST_ADAPTER'.
    WHEN 'Q'.
      l_rfc_dest = 'QIX_REST_ADAPTER'.
    WHEN 'P'.
      l_rfc_dest = 'PIX_REST_ADAPTER'.
  ENDCASE.

  TRY.
      cl_http_client=>create_by_destination(
        EXPORTING
          destination        = 'DI1_REST_ADAPTER'
        IMPORTING
          client             = pi_client
        EXCEPTIONS
          argument_not_found = 1
          internal_error     = 2
          plugin_not_active  = 3
          OTHERS             = 4 ).



      IF sy-subrc IS NOT INITIAL.
        WRITE 'Error - creating destination__subrc__' && sy-subrc.
      ENDIF.
    CATCH cx_root.
*        r_error = abap_true.
  ENDTRY.
ENDFORM.

FORM close_client.
  "***************************************************************
  " CLOSE CLIENT
  "**************************************************************
  pi_client->close( ). "DF EIT

ENDFORM..


FORM get_image_body.
  "***************************************************************
  " GET IMAGE BODY
  "**************************************************************
  gx_body = ''.
  DATA: lv_str_filename TYPE string,
        lt_tab          TYPE TABLE OF string.

  "lv_str_filename = 'C:/temp/apple.txt'.
  cl_gui_frontend_services=>gui_upload(
    EXPORTING
      filename                = p_locald   " Name of file
*    filetype                = 'ASC'    " File Type (ASCII, Binary)
*    has_field_separator     = SPACE    " Columns Separated by Tabs in Case of ASCII Upload
*    header_length           = 0    " Length of Header for Binary Data
*    read_by_line            = 'X'    " File Written Line-By-Line to the Internal Table
*    dat_mode                = SPACE    " Numeric and date fields are in DAT format in WS_DOWNLOAD
*    codepage                =     " Character Representation for Output
*    ignore_cerr             = ABAP_TRUE    " Ignore character set conversion errors?
*    replacement             = '#'    " Replacement Character for Non-Convertible Characters
*    virus_scan_profile      =     " Virus Scan Profile
    IMPORTING
      filelength              =  l_length   " File Length
    CHANGING
      data_tab                =  lt_tab   ).
  IF sy-subrc <> 0.
* MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "g_body  = lt_tab[ 1 ]. " base64 image
  g_body  = ''.
  LOOP AT lt_tab INTO DATA(l_str).
    g_body = g_body && l_str.
  ENDLOOP.



  gx_body = cl_http_utility=>if_http_utility~decode_x_base64( encoded = g_body ).
  l_length = xstrlen( gx_body ).
  "RETURN.

  " binary?
  DATA lbt_data TYPE solix_tab .
  lbt_data =  cl_bcs_convert=>xstring_to_solix( iv_xstring = gx_body ).



  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      bin_filesize         = l_length
      filename             = 'C:/temp/sapdw.jpg'
      filetype             = 'BIN'
      show_transfer_status = ' '
    CHANGING
      data_tab             = lbt_data.
ENDFORM..

FORM select_dir_from_pc.
  DATA: lv_dir TYPE string.
  CALL METHOD cl_gui_frontend_services=>directory_browse
    CHANGING
      selected_folder      = lv_dir
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc = 0.
    " p_dir = lv_dir.
  ENDIF.
ENDFORM.

FORM get_image_bin..
*name = 'content-type'value = 'bin'.
*  OPEN DATASET '/file.bin' FOR INPUT IN BINARY MODE.
*  READ DATASET '/file.bin' INTO DATA(l_data).
*  len = xstrlen( l_data ).
*  CALL METHOD part->set_data
*    EXPORTING
*      data   = data
*      offset = 0
*      length = len.
ENDFORM.