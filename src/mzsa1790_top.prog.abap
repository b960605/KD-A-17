*&---------------------------------------------------------------------*
*& Include MZSA1790_TOP                             - Module Pool      SAPMZSA1790
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1790.

" Condition
TABLES zssa1790.

" Tab Strip
CONTROLS ts_info TYPE TABSTRIP.

*CONTROLS tc_info type TABLEVIEW USING SCREEN 100.

" Meal Info
*WRITE xxx CURRENCY xxx TO cxx. " xxx를 cxx에 통화를 적용해서 담아라.
TABLES zssa1791.

" Vendor Info
TABLES zssa1792.
