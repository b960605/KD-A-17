*&---------------------------------------------------------------------*
*& Include ZRSAMEN10_17TOP                          - Report ZRSAMEN10_17
*&---------------------------------------------------------------------*
REPORT zrsamen10_17.

DATA ok_code LIKE sy-ucomm.

TABLES: zvrmat17, zverst17.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS pa_cus TYPE zvrmat17-cusid VALUE CHECK.
SELECTION-SCREEN END OF BLOCK b1.

DATA: BEGIN OF gs_vrmat.
        INCLUDE STRUCTURE zvrmat17.
DATA:   maktx TYPE makt-maktx,
      END OF gs_vrmat,

      gt_vrmat  LIKE TABLE OF gs_vrmat,

      gt_vrmat2 LIKE gt_vrmat,

      gs_vrmat2 LIKE LINE OF gt_vrmat.

DATA: gt_verst TYPE TABLE OF zverst17,
      gs_verst TYPE zverst17,

      gt_vers  TYPE TABLE OF zvers17,
      gs_vers  TYPE zvers17,

      gt_makt  TYPE TABLE OF makt,
      gs_makt  TYPE makt.


" Screen Elements
DATA: gv_vernm TYPE zverst17-vernm,
      gv_name1 TYPE kna1-name1,

      gt_kna1  TYPE TABLE OF kna1,
      gs_kna1  TYPE kna1.

" Drop Down List
DATA: gt_values TYPE vrm_values,
      gs_values TYPE LINE OF vrm_values.

" ALV instances
DATA: go_alv       TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container.

" ALV Setting
DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat,

      gs_layo TYPE lvc_s_layo.
