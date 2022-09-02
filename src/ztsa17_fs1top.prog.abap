*&---------------------------------------------------------------------*
*& Include ZTSA17_FS1TOP                            - Report ZRSA17_FS1
*&---------------------------------------------------------------------*
REPORT zrsa17_fs1.

TABLES ztspfli_t03.

TYPES: BEGIN OF ts_spfli.
         INCLUDE TYPE ztspfli_t03.
TYPES:   sum TYPE ztspfli_t03-wtg001,
       END OF ts_spfli.

DATA: gt_fcat TYPE TABLE OF lvc_s_fcat,
      gs_fcat TYPE lvc_s_fcat.

DATA : gt_nametab TYPE TABLE OF dntab,
       gs_nametab TYPE dntab.

DATA: gt_spfli TYPE TABLE OF ts_spfli,
      gs_spfli TYPE ts_spfli.

DATA: fname(30),
      nn TYPE n LENGTH 3.

FIELD-SYMBOLS <fs> TYPE any.
FIELD-SYMBOLS : <lf> TYPE lvc_s_fcat.

SELECT-OPTIONS: so_car FOR ztspfli_t03-carrid,
                so_con FOR ztspfli_t03-connid.

DATA: go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container.
