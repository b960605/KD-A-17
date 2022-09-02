*&---------------------------------------------------------------------*
*& Include ZBC405_ALV_A17_02TOP                     - Report ZBC405_ALV_A17_02
*&---------------------------------------------------------------------*
REPORT zbc405_alv_a17_02.
" Sbook
TABLES ztsbook_a17.
" Selection screen --------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: so_car FOR ztsbook_a17-carrid OBLIGATORY MEMORY ID car,
                  so_con FOR ztsbook_a17-connid OBLIGATORY MEMORY ID con,
                  so_fld FOR ztsbook_a17-fldate,
                  so_cus FOR ztsbook_a17-customid.
  SELECTION-SCREEN SKIP 1.
  PARAMETERS pa_edit AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN SKIP 1.
PARAMETERS: pa_layo TYPE disvariant-variant.
*--------------------------------------------------------------------------
DATA : gt_custom TYPE TABLE OF ztscustom_a17,
       gs_custom TYPE ztscustom_a17.
TYPES: BEGIN OF ts_sbook.
         INCLUDE TYPE ztsbook_a17.
TYPES:   light     TYPE c LENGTH 1,
         row_color TYPE c LENGTH 4,
         gt_col    TYPE lvc_t_scol,
         telephone TYPE ztscustom_a17-telephone,
         email     TYPE ztscustom_a17-email,
         bt        TYPE lvc_t_styl,
         modified  TYPE c LENGTH 1, " 변경되면 X가 들어오는.
       END OF ts_sbook.

DATA: gs_col TYPE lvc_s_scol. " 찾기 힘듬 외워서 써야함

DATA: gt_sbook TYPE TABLE OF ts_sbook,
      gs_sbook TYPE ts_sbook.
DATA: gtt_sbook TYPE TABLE OF ts_sbook.
" for Deleting rows
DATA: dl_sbook  TYPE TABLE OF ztsbook_a17,
      dls_sbook TYPE ztsbook_a17.

DATA: ok_code TYPE sy-ucomm.

" ALV DATA
DATA: go_container_100 TYPE REF TO cl_gui_custom_container,
      go_alv_100       TYPE REF TO cl_gui_alv_grid.

" ALV layout
DATA: gs_layo TYPE lvc_s_layo.

" ALV Variant
DATA: gs_vari TYPE disvariant.
" ALV Sort
DATA: gt_sort TYPE lvc_t_sort,
      gs_sort TYPE lvc_s_sort.
" ALV Exclude
DATA: gt_excl TYPE ui_functions.
" ALV Field Catalog
DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat.

" Refresh
DATA: gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.
