*&---------------------------------------------------------------------
*& Report   : YREPORT2
*& Author   : David Vela  21.11.2019 
*& Category : Read
*& Title    : yreport
*&---------------------------------------------------------------------
*& yreport
*&---------------------------------------------------------------------
*& 20191217 -- Changes 
*&---------------------------------------------------------------------
*& Authority-check: not included (not necessary )
*&---------------------------------------------------------------------*
REPORT yreport2.
DATA:
  lv_string   type string. 
*--------------------------------------------------------------------*
* Selection screen
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK s03 WITH FRAME TITLE text-004.
PARAMETERS: p_input type string.
SELECTION-SCREEN END OF BLOCK s02.

*--------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

*--------------------------------------------------------------------*
START-OF-SELECTION.

*--------------------------------------------------------------------*
* Subroutines
*--------------------------------------------------------------------*

