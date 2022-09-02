*&---------------------------------------------------------------------*
*& Include MZSA1708_TOP                             - Module Pool      SAPMZSA1708
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1708.

" Employee Info
TABLES zssa1735.
DATA gs_emp TYPE zssa1735.

" RadioButton for gender
DATA: gv_r1, gv_r2, gv_r3.

" Dep Info
TABLES zssa1736.
DATA gs_dep TYPE zssa1736.
