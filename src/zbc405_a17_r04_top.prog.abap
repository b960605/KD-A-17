*&---------------------------------------------------------------------*
*& Include ZBC405_A20_R04_TOP                       - Report ZBC405_A20_R04
*&---------------------------------------------------------------------*
REPORT zbc405_a20_r04.

"COMMON VARIABLE
DATA ok_code TYPE sy-ucomm.

TABLES : ztsbook_a20, sscrfields.

"SELECTION SCREEN.
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_car FOR ztsbook_a20-carrid OBLIGATORY MEMORY ID car,
                   so_con FOR ztsbook_a20-connid MEMORY ID con,
                   so_fld FOR ztsbook_a20-fldate,
                   so_cus FOR ztsbook_a20-customid.
  SELECTION-SCREEN SKIP 2.
  PARAMETERS pa_edit AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN SKIP 2.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02.
  PARAMETERS pa_var TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK bl2.

"TYPE
TYPES BEGIN OF ts_sbook.
INCLUDE TYPE ztsbook_a20.
TYPES : light   TYPE c LENGTH 1,
        cellcol TYPE lvc_t_scol,
        rowcol  TYPE c LENGTH 4,
        END OF ts_sbook.

"FOR ALV
DATA : gs_sbook TYPE ts_sbook,
       gt_sbook LIKE TABLE OF gs_sbook.


DATA : go_con TYPE REF TO cl_gui_custom_container,
       go_alv TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gs_cellcol TYPE lvc_s_scol,
       gt_sort    TYPE lvc_t_sort,
       gs_sort    LIKE LINE OF gt_sort,
       gs_fcat    TYPE lvc_s_fcat,
       gt_fcat    LIKE TABLE OF gs_fcat.



gs_layout-ctab_fname = 'GT_CELLCOL'.
gs_layout-info_fname = 'GS_ROWCOL'.
