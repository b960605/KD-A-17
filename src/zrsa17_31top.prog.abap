*&---------------------------------------------------------------------*
*& Include ZRSA17_31TOP                             - Report ZRSA17_31
*&---------------------------------------------------------------------*
REPORT zrsa17_31.

"Employee list
DATA: gs_emp TYPE zssa1704,
      gt_emp LIKE TABLE OF gs_emp.
"Selection Screen
PARAMETERS: pa_ent_b LIKE gs_emp-entdt,
            pa_ent_e LIKE gs_emp-entdt.
