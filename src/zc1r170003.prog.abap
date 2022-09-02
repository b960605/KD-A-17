*&---------------------------------------------------------------------*
*& Report ZC1R170003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r170003.

TABLES: mara, marc.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS : pa_werks TYPE mkal-werks DEFAULT '1010',
               pa_berid TYPE pbid-berid DEFAULT '1010',
               pa_pbdnr TYPE pbid-pbdnr,
               pa_versb TYPE pbid-versb DEFAULT '00'.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t02.

  PARAMETERS : pa_crt  RADIOBUTTON GROUP rg1 DEFAULT 'X' USER-COMMAND mod,
               pa_disp RADIOBUTTON GROUP rg1.

SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-t03.

  SELECT-OPTIONS : so_matnr FOR  mara-matnr MODIF ID mar,
                   so_mtart FOR  mara-mtart MODIF ID mar,
                   so_matkl FOR  mara-matkl MODIF ID mar.

  SELECT-OPTIONS : so_ekgrp FOR  marc-ekgrp MODIF ID mac.
  PARAMETERS     : pa_dispo TYPE marc-dispo MODIF ID mac,
                   pa_dismm TYPE marc-dismm MODIF ID mac.

SELECTION-SCREEN END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT.

  PERFORM set_cond.

  PERFORM set_r_cond.

*&---------------------------------------------------------------------*
*& Form set_cond
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_cond .

  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'PA_PBDNR' OR 'PA_VERSB'.
        screen-input = '0'.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_r_cond
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_r_cond .

  CASE 'X'.
    WHEN pa_crt.
      LOOP AT SCREEN.
        CASE screen-group1.
          WHEN 'MAC'.
            screen-active = '0'. " Invisible은 값을 감추는 것.
            MODIFY SCREEN.
        ENDCASE.
      ENDLOOP.

    WHEN pa_disp.
      LOOP AT SCREEN.
        CASE screen-group1.
          WHEN 'MAR'.
            screen-active = '0'.
            MODIFY SCREEN.
        ENDCASE.
      ENDLOOP.
  ENDCASE.

ENDFORM.
