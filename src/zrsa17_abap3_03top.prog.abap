*&---------------------------------------------------------------------*
*& Include ZRSA17_ABAP3_03TOP                       - Report ZRSA17_ABAP3_03
*&---------------------------------------------------------------------*
REPORT zrsa17_abap3_03.

TABLES sbuspart.

DATA: gt_sbus TYPE TABLE OF sbuspart,
      gs_sbus TYPE sbuspart.

SELECTION-SCREEN BEGIN OF BLOCK b_condi WITH FRAME TITLE TEXT-t01.

  PARAMETERS     pa_flnum TYPE sbuspart-buspartnum OBLIGATORY.

  SELECT-OPTIONS so_cont FOR sbuspart-contact NO INTERVALS.

  SELECTION-SCREEN ULINE.


  PARAMETERS: pa_rta RADIOBUTTON GROUP r1 DEFAULT 'X',
              pa_rfc RADIOBUTTON GROUP r1.

SELECTION-SCREEN END OF BLOCK b_condi.
