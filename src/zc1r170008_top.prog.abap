*&---------------------------------------------------------------------*
*& Include ZC1R170008_TOP                           - Report ZC1R170008
*&---------------------------------------------------------------------*
REPORT zc1r170008 MESSAGE-ID zmcsa17.

TABLES ztsa1701.

DATA: BEGIN OF gs_emp,
        mark,
        pernr    TYPE ztsa1701-pernr,
        ename    TYPE ztsa1701-ename,
        entdt    TYPE ztsa1701-entdt,
        gender   TYPE ztsa1701-gender,
        gender_t TYPE ztsa1701-gender_t,
        depnr    TYPE ztsa1701-depnr,
        style    TYPE lvc_t_styl,
        carrid   TYPE ztsa1701-carrid,
        carrname TYPE scarr-carrname,
      END OF gs_emp,

      gt_emp     LIKE TABLE OF gs_emp,
      gt_emp_del LIKE TABLE OF gs_emp,

      gv_okcode  TYPE sy-ucomm.

*      ALV 관련
DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,

      gt_fcat       TYPE lvc_t_fcat,
      gs_fcat       TYPE lvc_s_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant,
      gs_stable     TYPE lvc_s_stbl.

DATA: gt_rows TYPE lvc_t_row, " 선택한 행들의 정보를 저장할 ITAB for Deleting
      gs_row  TYPE lvc_s_row.
