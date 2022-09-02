*&---------------------------------------------------------------------*
*& Include ZC1R170002_TOP                           - Report ZC1R170002
*&---------------------------------------------------------------------*
REPORT zc1r170002 MESSAGE-ID zmcsa17.

TABLES: mara, marc.

DATA: BEGIN OF gs_mar,
        matnr TYPE mara-matnr,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
        meins TYPE mara-meins,
        tragr TYPE mara-tragr,
        pstat TYPE marc-pstat,
        dismm TYPE marc-dismm,
        ekgrp TYPE marc-ekgrp,
      END OF gs_mar,

      gt_mar    LIKE TABLE OF gs_mar,

      gv_okcode TYPE sy-ucomm.

" ALV Variables

DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_alv       TYPE REF TO cl_gui_alv_grid,

      gt_fcat       TYPE lvc_t_fcat,
      gs_fcat       TYPE lvc_s_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant.
