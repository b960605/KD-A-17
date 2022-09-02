*&---------------------------------------------------------------------*
*& Include ZRSA17_M03TOP                            - Report ZRSA17_M03
*&---------------------------------------------------------------------*
REPORT zrsa17_m03.

TYPES: BEGIN OF ts_emp,
         pernr    TYPE ztsa2001-pernr,
         ename    TYPE ztsa2001-ename,
         depid    TYPE ztsa2001-depid,
         gender   TYPE ztsa2001-gender,
         gender_t TYPE c LENGTH 10,
         phone    TYPE ztsa2002-phone,
       END OF ts_emp.

DATA: gs_emp TYPE ts_emp,
      gt_emp TYPE TABLE OF ts_emp,
      gs_dep TYPE ztsa2002,
      gt_dep TYPE TABLE OF ztsa2002.
