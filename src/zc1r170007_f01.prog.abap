*&---------------------------------------------------------------------*
*& Include          ZC1R170007_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form init_param
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_param .

  pa_bukrs = '1010'.
  pa_gjahr = sy-datum(4).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  _clear gs_data gt_data.

  SELECT a~belnr a~buzei a~shkzg a~dmbtr a~hkont
         b~blart b~budat b~waers
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM       bseg AS a
    INNER JOIN bkpf AS b
    ON    a~bukrs  = b~bukrs
    AND   a~belnr  = b~belnr
    AND   a~gjahr  = b~gjahr
    WHERE b~bukrs  = pa_bukrs
    AND   b~gjahr  = pa_gjahr
    AND   b~belnr IN so_belnr
    AND   b~blart IN so_blart.

  IF sy-subrc <> 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layo-zebra      = 'X'.
  gs_layo-cwidth_opt = 'X'.
  gs_layo-sel_mode   = 'D'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING:
     'X'  'BELNR'   ' '   'BSEG'   'BELNR',
     'X'  'BUZEI'   ' '   'BSEG'   'BUZEI',
     ' '  'BLART'   ' '   'BKPF'   'BLART',
     ' '  'BUDAT'   ' '   'BKPF'   'BUDAT',
     ' '  'SHKZG'   ' '   'BSEG'   'SHKZG',
     ' '  'DMBTR'   ' '   'BSEG'   'DMBTR',
     ' '  'WAERS'   ' '   'BKPF'   'WAERS',
     ' '  'HKONT'   ' '   'BSEG'   'HKONT'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #( key = pv_key
                     fieldname = pv_field
                     coltext = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'DMBTR'.
      gs_fcat-cfieldname = 'WAERS'.

    WHEN 'BELNR'.
      gs_fcat-hotspot = 'X'.

  ENDCASE.

  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

  IF gcl_container IS NOT BOUND.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    SET HANDLER lcl_event_handler=>handle_hotspot FOR gcl_grid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layo
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_COLUMN_ID
*&      --> E_ROW_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING    ps_column TYPE lvc_s_col
                              ps_row    TYPE lvc_s_row .

  CLEAR gs_data.

  READ TABLE gt_data INTO gs_data INDEX ps_row-index.

  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  CASE ps_column-fieldname.
    WHEN 'BELNR'.

      IF gs_data-belnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID : 'BLN' FIELD gs_data-belnr,
                         'BUK' FIELD pa_bukrs,
                         'GJR' FIELD pa_gjahr.

      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

  ENDCASE.

ENDFORM.
