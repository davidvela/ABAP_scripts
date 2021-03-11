*&---------------------------------------------------------------------*
*& Report yac_dvt_encr_decryp: Encryption & Decryption of data using ABAP
*&---------------------------------------------------------------------*
*& https://blogs.sap.com/2006/11/21/encryption-decryption-of-data-using-abap/
* Adding to this there are methods for BASE64 encoding and decoding of binary data as
*&---------------------------------------------------------------------*
REPORT zdvt_encr_decryp.

DATA: o_encryptor        TYPE REF TO cl_hard_wired_encryptor,
      o_cx_encrypt_error TYPE REF TO cx_encrypt_error.
DATA: v_ac_string  TYPE string VALUE 'Welcome to ABAP',
      v_ac_xstring TYPE xstring,
      v_en_string  TYPE string,
      v_en_xstring TYPE xstring,
      v_de_string  TYPE string,
      v_de_xstring TYPE string,
      v_error_msg  TYPE string.

PARAMETERS p_text TYPE string.

PARAMETERS: p_dnn   TYPE c RADIOBUTTON GROUP p1  DEFAULT 'X',               " Do nothing
            p_all   TYPE c RADIOBUTTON GROUP p1,
            p_e_s2s TYPE c RADIOBUTTON GROUP p1,
            p_d_s2s TYPE c RADIOBUTTON GROUP p1,
            p_e_s2b TYPE c RADIOBUTTON GROUP p1,
            p_d_b2s TYPE c RADIOBUTTON GROUP p1.

***********************************************************************************
START-OF-SELECTION.
***********************************************************************************
* Create object for Encryption
  CREATE OBJECT o_encryptor.

  CASE abap_true.
    WHEN p_all.
      PERFORM enc_str2str.
      PERFORM dec_str2str.
      PERFORM enc_str2byte.
      PERFORM dec_byte2str.
      PERFORM enc_byte2byte.

    WHEN OTHERS.
      PERFORM do_nothing.
  ENDCASE.

***********************************************************************************
***********************************************************************************

FORM do_nothing.
**********************************************************************
* DO NOTHING
**********************************************************************
  WRITE 'YAB_HR CONTR ADD ADMIN'.
ENDFORM .


*&———————————————————————** Encryption – String to String*&———————————————————————*
FORM enc_str2str.
  WRITE / 'Encryption – String to String'.
  TRY.
      v_en_string = o_encryptor->encrypt_string2string( v_ac_string     )  .
      .
    CATCH cx_encrypt_error INTO o_cx_encrypt_error.
      v_error_msg =  o_cx_encrypt_error->if_message~get_text(  ).
      MESSAGE v_error_msg TYPE 'E'.
  ENDTRY.

  WRITE:/ 'Actual String: ', v_ac_string.
  WRITE:/ 'Encrypted String: ', v_en_string.  SKIP.
ENDFORM.

*&———————————————————————** Decryption – String to String*&———————————————————————*
FORM dec_str2str.
  WRITE / 'Decryption – String to String'.
  TRY.
      v_de_string = o_encryptor->decrypt_string2string( v_en_string   ).      .
    CATCH cx_encrypt_error INTO o_cx_encrypt_error.
      v_error_msg = o_cx_encrypt_error->if_message~get_text(  ).
      MESSAGE v_error_msg TYPE 'E'.
  ENDTRY.
  WRITE:/ 'Encrypted String: ', v_en_string.
  WRITE:/ 'Decrypted String: ', v_de_string.  SKIP.
ENDFORM.


*&———————————————————————** Encryption – String to Bytes*&———————————————————————*
FORM enc_str2byte.
  WRITE 'Encryption – String to Bytes'.
  TRY.
      v_en_xstring = o_encryptor->encrypt_string2bytes(  v_ac_string ) ..
    CATCH cx_encrypt_error INTO o_cx_encrypt_error.
      v_error_msg = o_cx_encrypt_error->if_message~get_text(  ).
      MESSAGE v_error_msg TYPE 'E'.
  ENDTRY.
  WRITE:/ 'Actual String: ', v_ac_string.
  WRITE:/ 'Encrypted Bytes: ', v_en_xstring.  SKIP.
ENDFORM.


*&———————————————————————** Decryption – Bytes TO String*&———————————————————————*
FORM dec_byte2str.
  WRITE 'Decryption – Bytes TO String'.
  TRY.
      v_de_string = o_encryptor->decrypt_bytes2string(  v_en_xstring ) ..
    CATCH cx_encrypt_error INTO o_cx_encrypt_error.
      v_error_msg = o_cx_encrypt_error->if_message~get_text(  ).
      MESSAGE v_error_msg TYPE 'E'.
  ENDTRY.
  WRITE:/ 'Encrypted Bytes: ', v_en_xstring.
  WRITE:/ 'Decrypted String: ', v_de_string.
  SKIP.
ENDFORM.

*&———————————————————————** Encryption – Bytes to Bytes*&———————————————————————*
FORM enc_byte2byte.
  WRITE 'Encryption – Bytes TO Bytes'.
  v_ac_xstring = '004E00650074005700650061007600650072'.
  TRY.
      v_en_xstring = o_encryptor->encrypt_bytes2bytes(  v_ac_xstring ) ..
    CATCH cx_encrypt_error INTO o_cx_encrypt_error.
      v_error_msg = o_cx_encrypt_error->if_message~get_text(  ).
      MESSAGE v_error_msg TYPE 'E'.
  ENDTRY.
  WRITE:/ 'Actual Bytes: ', v_ac_xstring.
  WRITE:/ 'Encrypted String: ', v_en_xstring.
  SKIP.
ENDFORM.

*&———————————————————————** Decryption – Bytes to Bytes*&———————————————————————* 
FORM dec_byte2byte.
  WRITE 'Decryption – Bytes TO Bytes'.
  v_ac_xstring = '004E00650074005700650061007600650072'.
  TRY.
      v_de_xstring = o_encryptor->decrypt_bytes2bytes(  v_en_xstring ) ..
    CATCH cx_encrypt_error INTO o_cx_encrypt_error.
      v_error_msg = o_cx_encrypt_error->if_message~get_text(  ).
      MESSAGE v_error_msg TYPE 'E'.
  ENDTRY.
  WRITE:/ 'Encrypted Bytes: ', v_en_xstring.
  WRITE:/ 'Decrypted String: ', v_de_xstring.
  SKIP.
ENDFORM.
