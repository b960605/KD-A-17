*&---------------------------------------------------------------------*
*& Include ZRSA17_50_TOP                            - Report ZRSA17_50
*&---------------------------------------------------------------------*
REPORT zrsa17_50.

PARAMETERS pa_emp TYPE ztsa1701-pernr.

DATA: gs_list TYPE zssa17list,
      gt_list LIKE TABLE OF gs_list.

TYPES: BEGIN OF ts_dep,
         depnr TYPE ztsa1702-depnr,
         dname TYPE ztsa1702_t-dname,
       END OF ts_dep.
DATA gt_dep TYPE TABLE OF ts_dep.

DATA go_salv TYPE REF TO cl_salv_table.
