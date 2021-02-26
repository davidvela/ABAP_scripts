*&---------------------------------------------------------------------*
*& Report Z_R_TEST
*&---------------------------------------------------------------------*
*& $RT20200208 -- code review 20200208
*&---------------------------------------------------------------------*
REPORT z_r_test.

DATA cl_aktie     TYPE REF TO zsd_cl_verplak. "Klasse referenzzieren
DATA aktie  TYPE  zsd_tp_verplak_ausk.
DATA punkte TYPE  zsd_tp_verplak_bunt.
DATA return TYPE  zsd_l_rc_verplak.
DATA kunnr  TYPE  kunnr.
DATA x_request_id TYPE  zsd_l_vertr_req_id.
DATA: gt_produkt        TYPE TABLE OF zsd_s_proabf_produkt,
      gt_t03            TYPE STANDARD TABLE OF zsd_t_sernr,
      gt_verfuegbar     TYPE TABLE OF zsd_s_propun_verfuegbar,
      gs_verfuegbar     TYPE zsd_s_propun_verfuegbar,
      gs_produkt        TYPE zsd_s_proabf_produkt,
      gt_punkte         TYPE zsd_tp_verplak_bunt,
      gs_punkte         TYPE zsd_s_verplak_bunt,
      gt_aktie          TYPE zsd_tp_verplak_ausk,
      gv_aktie_besitzer,
      gs_verplak        TYPE zsd_t_verplak,
      gs_vermich        TYPE zsd_s_vermich,
      gs_verplog        TYPE zsd_t_verplog,
      gt_verplak        TYPE TABLE OF zsd_t_verplak,
      gt_verplap        TYPE TABLE OF zsd_t_verplap,
      gs_verplap        TYPE zsd_t_verplap,
      gs_t03            TYPE zsd_t_sernr,
      gs_timeout        TYPE zsd_t_timeout,
      gv_menge          TYPE zsd_l_punkte,
      gt_t04            TYPE TABLE OF zsd_t_charge,
      gs_t04            TYPE zsd_t_charge,
      gs_aktie          TYPE zsd_s_verplak_ausk.

CLEAR: punkte[], aktie[], gt_produkt[], gt_punkte[], gt_verfuegbar[], gt_aktie[].

CHECK return+2(2) = zsd_cl_verplak=>ct_rc_00_erfolgreich.
return = 'PV00'.

cl_aktie->logneu( EXPORTING kunnr = kunnr  fuba = 'Z_R_TEST' x_request_id = x_request_id ).
CALL FUNCTION 'ZSD_F_PRODUKTABFRAGE'
  EXPORTING
    i_kunnr            = kunnr
    i_funktion         = 'IP'
  TABLES
    t_produkt          = gt_produkt
    t_sernr            = gt_t03
  EXCEPTIONS
    kundenr_not_found  = 1
    funktion_not_found = 2
    OTHERS             = 3.

IF sy-subrc = 0.
  CLEAR gv_aktie_besitzer.
  LOOP AT gt_produkt INTO gs_produkt WHERE ( produkt = 'A100' OR produkt = 'A200' ) AND zahl_status = '3' AND kzinumsch NE 'X'.
    gv_aktie_besitzer = 'X'.
    CLEAR gs_aktie.
    IF gs_produkt-kzinumsch = 'O'.
      gs_aktie-in_plattform = 'X'.
    
    "  $RT20200208 -- selects should be outside the loop; 
    "  but since it's select single is ok. so I will leave it. 
    SELECT SINGLE * INTO CORRESPONDING FIELDS OF @gs_verplap
          FROM zsd_t_verplap AS a
          INNER JOIN zsd_t_verplak AS b ON  a~offerte = b~offerte
        WHERE  a~sernr = @gs_produkt-produktnr AND a~typ = 'A' AND b~kunnr = @kunnr
          AND a~seqnr = 0 AND b~seqnr = 0
          AND b~status <> '3' AND b~status <> '2' AND b~status <> '5'.

      IF sy-subrc = 0.
        gs_aktie-offerte = gs_verplap-offerte.
      ENDIF.
    ENDIF.

    "  $RT20200208 DELETE should be outside the loop!  
    "  and gt_produkt is not used anymore in the report. so I will delete this code 
    " and clean up the table after the loop to release memory.
    "{ 
    " IF gs_produkt-produktstatus NE '06'.
    "   DELETE gt_produkt INDEX sy-tabix.
    "   CONTINUE.
    " ENDIF.
    "  $RT20200208 DELETE should be outside the loop!  } 

    gs_aktie-matnr     = gs_produkt-produkt.
    gs_aktie-sernr     = gs_produkt-produktnr.
    gs_aktie-classic   = gs_produkt-classic.
    gs_aktie-lifetime  = gs_produkt-lifetime.
    gs_aktie-f21       = gs_produkt-kzfa21.
    gs_aktie-vertr_unt = gs_produkt-vertr_unt.
    APPEND gs_aktie TO gt_aktie.
  ENDLOOP.
  CLEAR gt_produkt. "not longer needed.  

  ELSE.  " $RT20200208 -- error handling - {
CASE sy-subrc.
    WHEN 1. return = 'Kunden: ' && kunnr && ' not found'. 
    WHEN 2. return = 'Funtion IP '.
    WHEN 3. return = 'other'.
        
    WHEN OTHERS.
ENDCASE.
" $RT20200208 -- error handling - {
ENDIF.
 
IF gv_aktie_besitzer IS INITIAL.
  return = zsd_cl_verplak=>ct_s1_feh_kein_treffer.
  EXIT.
ENDIF.

" $RT20200208 -- SELECTS and DELETES should be outside the loop. (but I will allow select singles assuming the select is fast) 
"LOOP AT gt_aktie INTO gs_aktie.  $RT20200208 -- 
LOOP AT gt_aktie ASSIGNING FIELD-SYMBOL(<gs_aktie>) .   "$RT20200208 ++
  "SERNR Tabelle dazu lesen
  SELECT SINGLE * FROM zsd_t_sernr INTO gs_t03 WHERE kunnr = kunnr AND sernr = <gs_aktie>-sernr AND matnr = <gs_aktie>-matnr AND histo_kz = ' '.
  IF sy-subrc = 0.
    IF gs_t03-kuend IS NOT INITIAL.
      "DELETE gt_aktie INDEX sy-tabix. " $RT20200208 -- (instead of delete here, I will set up matnr = zero and then delete all the MATNR = 0 
      clear <gs_aktie>-matnr. 
      CONTINUE.

    ENDIF.

    "Abfrage generell ungültige Status
    IF '04!10!24!16!26!27!' CS gs_t03-status.
      "DELETE gt_aktie INDEX sy-tabix. " $RT20200208 --
      clear <gs_aktie>-matnr. 
      CONTINUE.
    ENDIF.

    IF gs_t03-kzimtau IS NOT INITIAL.
      "DELETE gt_aktie INDEX sy-tabix." $RT20200208 --
      clear <gs_aktie>-matnr. 
      CONTINUE.
    ENDIF.

    "Abfrage auf Kombination VGART RCHC mit ungütligen VGSTATUS 01 02 oder 03
    IF gs_t03-vgart = 'RCHC' AND gs_t03-vgstatus = '01' OR gs_t03-vgstatus = '02' OR gs_t03-vgstatus = '03'.
      "DELETE gt_aktie INDEX sy-tabix." $RT20200208 --
      clear <gs_aktie>-matnr. 
      CONTINUE.
    ENDIF.

    "SERNR Tabelle updaten
    gs_t03-ref_sernr = 'SERNR verarbeitet'.
    MODIFY zsd_t_sernr FROM gs_t03.

  ENDIF.

  SELECT SINGLE * FROM zsd_t_timeout
    INTO gs_timeout WHERE kunnr = kunnr
     AND sernr = <gs_aktie>-sernr
     AND histo_kz = ' '
     AND vorgang = 'Abschluss'.
  IF sy-subrc = 0.
    IF gs_timeout-ende_still > sy-datum.
      "DELETE gt_aktie INDEX sy-tabix." $RT20200208 --
      clear <gs_aktie>-matnr. 
      CONTINUE.
    ENDIF.
  ENDIF.

  "gegen CHARGEN-Tabelle prüfen
  SELECT * FROM zsd_t_charge INTO gs_t04 WHERE kunnr = kunnr AND sernr = <gs_aktie>-sernr AND matnr_bas = <gs_aktie>-matnr AND kzvor = 'X'.
    ADD gs_t04-menge TO gv_menge.
  ENDSELECT.
  IF gv_menge < 60.
    "DELETE gt_aktie INDEX sy-tabix." $RT20200208 --
    clear <gs_aktie>-matnr. 
    CONTINUE.
  ENDIF.
ENDLOOP.

DELETE gt_aktie where matnr is initial. "$RT20200208 ++ 

aktie = gt_aktie.
" $RT20200208 ++  - now we don't need gt_aktie,.   
"IF gt_aktie[] IS INITIAL. "$RT20200208 --
IF aktie[] IS INITIAL. " "$RT20200208 ++ 
    return = 'no aktie allowed'. " "$RT20200208 ++ 
    EXIT.
ENDIF.

" $RT20200208 ??? -- aktie is not used anymore???  

CALL FUNCTION 'ZSD_F_PUNKTESTANDSABFRAGE'
  EXPORTING
    i_kunnr               = kunnr
    i_www                 = 'L'
  TABLES
    t_propun_verfueg      = gt_verfuegbar
  EXCEPTIONS
    kundenr_not_found     = 1
    resvnr_not_found      = 2
    kundenr_empty         = 3
    order_not_found       = 4
    herkunft_kz_not_found = 5.


LOOP AT gt_verfuegbar INTO gs_verfuegbar WHERE pktetyp = 'HS' .
 "  $RT20200208  we should re-use the code from above instead of doing again a select into zsd_t_verplap { --
"   SELECT SUM( menge )  FROM zsd_t_verplap AS a
"              INNER JOIN zsd_t_verplak AS b
"              ON  a~offerte = b~offerte
"              INTO gs_punkte-in_plattform
"              WHERE  a~typ = 'P' AND b~kunnr = kunnr AND a~vfdat = gs_verfuegbar-vfdat AND a~seqnr = 0 AND b~seqnr = 0 AND ( b~status = '1' OR b~status = '4' ).
  
"   IF gs_punkte-menge = 0 AND gs_punkte-gesperrt = 0 AND gs_punkte-gesperrt = 0 AND gs_punkte-in_plattform = 0.
"     "wenn keine Punkte dann Satz nicht berücksichtigen
"     EXIT.
"   ENDIF.
  "  $RT20200208 } -- 
  
  "  $RT20200208 Suggested change -- needs to be validated.
  "  $RT20200208 { ++ 
  clear  gs_punkte . 
    LOOP AT aktie ASSIGNING FIELD-SYMBOL(<fs-ak>) WHERE  a~typ = 'P' vfdat = gs_verfuegbar-vfdat AND a~seqnr = 0 AND b~seqnr = 0 . 
    gs_punkte-menge = <gs_punkte>-MENGE +  <fs-ak>-menge
    gs_punkte-gesperrt     = <fs-ak>-gesperrt.
    gs_punkte-in_plattform = <fs-ak>-in_plattform.
    ENDLOOP. 
    
    IF gs_punkte-menge = 0 AND gs_punkte-gesperrt = 0 AND gs_punkte-in_plattform = 0. 
        "wenn keine Punkte dann Satz nicht berücksichtigen
        EXIT.
      ENDIF.
    "  $RT20200208 } ++
  
    APPEND gs_punkte TO gt_punkte.

ENDLOOP.

punkte = gt_punkte.
**** weitere Programmcode...