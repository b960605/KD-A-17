*&---------------------------------------------------------------------*
*& Include          ZBC405_A20_R04_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
    FROM ztsbook_a20
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
    WHERE carrid IN so_car
    AND connid IN so_con
    AND fldate IN so_fld
    AND customid IN so_cus.

  "Exception
  CLEAR gs_sbook.
  LOOP AT gt_sbook INTO gs_sbook.
    IF gs_sbook-luggweight > 25.
      gs_sbook-light = 1.
    ELSEIF gs_sbook-luggweight > 20.
      gs_sbook-light = 2.
    ELSE.
      gs_sbook-light = 3.
    ENDIF.

    CASE gs_sbook-class.
      WHEN 'F'.
        CLEAR gs_sbook-rowcol.
        gs_sbook-rowcol = 'C510'.
    ENDCASE.

    "Cell color
    CASE gs_sbook-smoker.
      WHEN 'X'.
        CLEAR gs_cellcol.
        gs_cellcol-fname = 'SMOKER'.
        gs_cellcol-color-col = col_negative.
        gs_cellcol-color-int = 1.
        gs_cellcol-color-inv = 0.
        APPEND gs_cellcol TO gs_sbook-cellcol.
    ENDCASE.

    "Row Color
    CASE gs_sbook-class.
      WHEN 'F'.
        gs_sbook-rowcol = 'C310'.
    ENDCASE.


    MODIFY gt_sbook FROM gs_sbook.
    CLEAR gs_sbook.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .

  gs_layout-cwidth_opt = 'X'.
  "Exception
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led = 'X'.

  gs_layout-grid_title = 'BOOKING INFO'.

  gs_layout-zebra = 'X'.

  gs_layout-sel_mode = 'D'.

  gs_layout-ctab_fname = 'CELLCOL'.
  gs_layout-info_fname = 'ROWCOL'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_catalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_catalog .



ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .

  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 1.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 2.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.
  gs_sort-spos = 3.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.

ENDFORM.
