*&---------------------------------------------------------------------*
*& Include MZSA1719_TOP                             - Module Pool      SAPMZSA1719
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1719.

" Condition, Emp, Dep
TABLES: zssa1734, zssa1735, zssa1736.

" Radio Button for Gender
DATA: gv_r1, gv_r2, gv_r3.

" Tap Strip for Info
CONTROLS ts_info TYPE TABSTRIP.
