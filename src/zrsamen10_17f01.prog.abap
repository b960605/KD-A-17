*&---------------------------------------------------------------------*
*& Include          ZRSAMEN10_17F01
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
  DATA: lv_tabix LIKE sy-tabix,
        lt_vrmat LIKE gt_vrmat,
        ls_vrmat LIKE LINE OF gt_vrmat.

  REFRESH: gt_vrmat2, gt_verst.

  SELECT mandt cusid versn matnr meins
    FROM zvrmat17
    INTO CORRESPONDING FIELDS OF TABLE gt_vrmat2
    WHERE cusid = pa_cus.

  SELECT cusid versn spras vernm
    FROM zverst17
    INTO CORRESPONDING FIELDS OF TABLE gt_verst
    WHERE spras = sy-langu.

  PERFORM set_drop_down.

  " ALV Screen cusid
  zverst17-cusid = pa_cus.

  " ALV Screen name1
  READ TABLE gt_kna1 INTO gs_kna1 WITH KEY kunnr = zverst17-cusid.
  gv_name1 = gs_kna1-name1.
  CLEAR gs_kna1.

  " Setting ALV
  lt_vrmat = gt_vrmat2.

  SORT lt_vrmat BY matnr.
  DELETE ADJACENT DUPLICATES FROM lt_vrmat COMPARING matnr.

  SELECT matnr maktx
    FROM makt
    INTO CORRESPONDING FIELDS OF TABLE gt_makt
    FOR ALL ENTRIES IN lt_vrmat
    WHERE matnr = lt_vrmat-matnr.

  LOOP AT gt_vrmat2 INTO gs_vrmat2.
    lv_tabix = sy-tabix.

    READ TABLE gt_makt INTO gs_makt WITH KEY matnr = gs_vrmat2-matnr.

    IF sy-subrc = 0.
      gs_vrmat2-maktx = gs_makt-maktx.
      MODIFY gt_vrmat2 FROM gs_vrmat2 INDEX lv_tabix TRANSPORTING maktx.
      CLEAR gs_makt.
    ENDIF.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .
  gs_fcat-fieldname = 'VERSN'.
  gs_fcat-no_out    = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'CUSID'.
  gs_fcat-no_out    = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'MATNR'.
  gs_fcat-coltext   = '제품코드'.
  gs_fcat-edit = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'MEINS'.
  gs_fcat-coltext   = '단위'.
  gs_fcat-col_opt   = 'X'.
  gs_fcat-edit = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'MAKTX'.
  gs_fcat-ref_field = 'MAKTX'.
  gs_fcat-ref_table = 'MAKT'.
  gs_fcat-coltext = '제품코드명'.
  gs_fcat-col_pos   = 5.
  gs_fcat-col_opt   = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_drop_down
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_drop_down .
  DATA: lt_vrmat LIKE gt_vrmat2,
        ls_vrmat LIKE LINE OF gt_vrmat2.

  lt_vrmat = gt_vrmat2.
  DELETE lt_vrmat WHERE versn = space.
  SORT lt_vrmat BY versn.
  DELETE ADJACENT DUPLICATES FROM lt_vrmat COMPARING versn.


  LOOP AT lt_vrmat INTO ls_vrmat.

    READ TABLE gt_verst INTO gs_verst WITH KEY versn = ls_vrmat-versn .

    IF sy-subrc = 0.

      gs_values-key  = ls_vrmat-versn.
      gs_values-text = gs_verst-vernm.
      APPEND gs_values TO gt_values.
      CLEAR gs_values.

    ENDIF.
  ENDLOOP.

ENDFORM.
