*&---------------------------------------------------------------------*
*& Report ZRSA17_36
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_36.
TYPES: BEGIN OF ts_dep,
         budget TYPE ztsa1702-budget,
         waers  TYPE ztsa1702-waers,
       END OF ts_dep. " Local 에서 선언하면 Reference를 가져오지 못하기 때문에 alv에서 Ref를 못불러옴.

DATA: gs_dep TYPE zssa1720, "ts_dep,                                   "ztsa1702,
      gt_dep LIKE TABLE OF gs_dep.

DATA go_salv TYPE REF TO cl_salv_table.

*PARAMETERS pa_dep LIKE gs_dep-depnr.

START-OF-SELECTION.
  SELECT *
    FROM ztsa1702
    INTO CORRESPONDING FIELDS OF TABLE gt_dep.

*  WRITE: gs_dep-budget CURRENCY gs_dep-waers,
*         gs_dep-waers.

  cl_salv_table=>factory(
    IMPORTING r_salv_table = go_salv
    CHANGING t_table = gt_dep

  ).
  go_salv->display( ).

*  cl_demo_output=>display_data( gt_dep ).
