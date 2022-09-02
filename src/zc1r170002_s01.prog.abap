*&---------------------------------------------------------------------*
*& Include          ZC1R170002_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS       pa_werks TYPE marc-werks OBLIGATORY.
  SELECT-OPTIONS : so_matnr FOR  mara-matnr,
                   so_mtart FOR  mara-mtart,
                   so_ekgrp FOR  marc-ekgrp.

SELECTION-SCREEN END OF BLOCK b1.
