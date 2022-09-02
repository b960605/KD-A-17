*&---------------------------------------------------------------------*
*& Include ZRSAMEN02_A17TOP                         - Report ZRSAMEN02_A17
*&---------------------------------------------------------------------*
REPORT zrsamen02_a17.

DATA ok_code TYPE sy-ucomm.

" to get Carrname
DATA: gs_car TYPE scarr,
      gt_car LIKE TABLE OF gs_car.

" Condition Screen
TABLES zssa17men01.

SELECT-OPTIONS: so_car FOR zssa17men01-carrid NO-EXTENSION,
                so_con FOR zssa17men01-connid NO-EXTENSION,
                so_fld FOR zssa17men01-fldate NO-EXTENSION.

" Flight Info
TABLES zssa17men02.
DATA: gs_finfo LIKE zssa17men02,
      gt_finfo TYPE TABLE OF zssa17men02.

" Selected Flight Info
DATA: gs_sinfo LIKE gs_finfo,
      gt_sinfo LIKE TABLE OF gs_sinfo.

" ALV Data
DATA: go_container_1 TYPE REF TO cl_gui_custom_container,
      go_alv_grid_1  TYPE REF TO cl_gui_alv_grid,
      go_container_2 TYPE REF TO cl_gui_custom_container,
      go_alv_grid_2  TYPE REF TO cl_gui_alv_grid.

" Finfo Layout
DATA: gs_flay TYPE lvc_s_layo.

" Finfo Fieldcatalog
DATA: gt_ffcat TYPE lvc_t_fcat,
      gs_ffcat TYPE lvc_s_fcat.

" Sinfo Layout
DATA: gs_slay TYPE lvc_s_layo.

" Sinfo Fieldcatalog
DATA: gt_sfcat TYPE lvc_t_fcat,
      gs_sfcat TYPE lvc_s_fcat.

" Sinfo excluding
DATA: gt_sexc TYPE ui_functions.
