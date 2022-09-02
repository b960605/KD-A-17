*&---------------------------------------------------------------------*
*& Include ZBC405_A17_EXAM01TOP                     - Report ZBC405_A17_EXAM01
*&---------------------------------------------------------------------*
REPORT zbc405_a17_exam01.

TABLES ztspfli_a17.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: so_car FOR ztspfli_a17-carrid MEMORY ID car,
                  so_con FOR ztspfli_a17-connid MEMORY ID con.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 3(15) TEXT-t02 FOR FIELD pa_layo.
    PARAMETERS: pa_layo TYPE disvariant-variant.
    SELECTION-SCREEN COMMENT pos_high(9) TEXT-t03 FOR FIELD pa_edit.
    PARAMETERS pa_edit AS CHECKBOX DEFAULT 'X'.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.
PARAMETERS pa_sel AS CHECKBOX.

TYPES : BEGIN OF ts_spfli.
          INCLUDE TYPE ztspfli_a17.
TYPES:    iord     TYPE c LENGTH 1,
          fticon   TYPE icon-id,
          frtzone  TYPE sairport-time_zone,
          totzone  TYPE sairport-time_zone,
          gt_col   TYPE lvc_t_scol,
          light    TYPE c LENGTH 1,
          modified TYPE c LENGTH 1,
        END OF ts_spfli.

*SUBMIT
DATA: mem_it_spfli TYPE TABLE OF spfli,
      mem_is_spfli TYPE spfli.

DATA: gt_spfli TYPE TABLE OF ts_spfli,
      gs_spfli TYPE ts_spfli.
" Ok_code
DATA: ok_code LIKE sy-ucomm.
" alv objects
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.

DATA: gs_layout TYPE lvc_s_layo,
      gt_fcat   TYPE lvc_t_fcat,
      gs_fcat   TYPE lvc_s_fcat,
      gt_excl   TYPE ui_functions,
      gs_vari   TYPE disvariant.

DATA: gs_col   TYPE lvc_s_scol.

" sairport
DATA: gt_sairp TYPE TABLE OF sairport,
      gs_sairp TYPE sairport.

" scarr
DATA: gt_scarr TYPE TABLE OF scarr,
      gs_scarr TYPE scarr.

" Screen Element 의 Select-option화
TYPES: BEGIN OF ts_so_car,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE ztspfli_a17-carrid,
         high   TYPE ztspfli_a17-carrid,
       END OF ts_so_car.

DATA: gs_so_car TYPE ts_so_car,
      gt_so_car TYPE TABLE OF ts_so_car.

TYPES: BEGIN OF ts_so_con,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE ztspfli_a17-connid,
         high   TYPE ztspfli_a17-connid,
       END OF ts_so_con.

DATA: gs_so_con TYPE ts_so_con,
      gt_so_con TYPE TABLE OF ts_so_con.
