*&---------------------------------------------------------------------*
*& Include MZSA1710_TOP                             - Module Pool      SAPMZSA1710
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1710.

" Common Variable
DATA ok_code TYPE sy-ucomm.
DATA gv_subrc TYPE sy-subrc.

"Condition
TABLES zssa1780." Use Screen 스크린 용도
*DATA gs_cond TYPE zssa1780. " Use ABAP 아밥 용도 (변경할 값들)

" Airline Info
TABLES zssa1781.
*DATA gs_airline TYPE zssa1781.

" Connection Info
TABLES zssa1782.
DATA gs_con TYPE zssa1782.
