*&---------------------------------------------------------------------*
*& Include SAPMZSA1702_TOP                          - Module Pool      SAPMZSA1702
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1702.

DATA ok_code LIKE sy-ucomm.

*DATA: BEGIN OF gs_cond,
*        carrid TYPE sflight-carrid,
*        connid TYPE sflight-connid,
*      END OF gs_cond.

"Condition
" 1. Used in Screen
TABLES zssa1760.
" 2. Used in ABAP
DATA gs_cond TYPE zssa1760.
