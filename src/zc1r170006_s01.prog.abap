*&---------------------------------------------------------------------*
*& Include          ZC1R170006_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS : so_carr FOR scarr-carrid,
                   so_conn FOR sflight-connid,
                   so_ptyp FOR sflight-planetype NO INTERVALS NO-EXTENSION.

SELECTION-SCREEN END OF BLOCK b1.
