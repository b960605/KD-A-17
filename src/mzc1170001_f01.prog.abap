*&---------------------------------------------------------------------*
*& Include          SAPMZC1170001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_werks
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_werks .

  SELECT werks, name1, ekorg, land1
    FROM t001w
    INTO TABLE @DATA(lt_werks).

  IF sy-subrc <> 0.
    MESSAGE s001.
    EXIT.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'WERKS'
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'GS_DATA-WERKS'
      window_title = TEXT-t01
      value_org    = 'S'
    TABLES
      value_tab    = lt_werks.


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

  REFRESH gt_data.

  SELECT matnr werks mtart matkl menge meins
         dmbtr waers
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM ztsa17_mar.

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

  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode   = 'D'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING:
          'X'  'MATNR'  ' '  'ZTSA17_MAR'  'MATNR'  ' '     ' ',
          'X'  'WERKS'  ' '  'ZTSA17_MAR'  'WERKS'  ' '     ' ',
          ' '  'MTART'  ' '  'ZTSA17_MAR'  'MTART'  ' '     ' ',
          ' '  'MATKL'  ' '  'ZTSA17_MAR'  'MATKL'  ' '     ' ',
          ' '  'MENGE'  ' '  'ZTSA17_MAR'  'MENGE'  'MEINS' ' ',
          ' '  'MEINS'  ' '  'ZTSA17_MAR'  'MEINS'  ' '     ' ',
          ' '  'DMBTR'  ' '  'ZTSA17_MAR'  'DMBTR'  ' '     'WAERS',
          ' '  'WAERS'  ' '  'ZTSA17_MAR'  'WAERS'  ' '     ' '.

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
FORM set_fcat  USING pv_key
                     pv_field
                     pv_text
                     pv_ref_table
                     pv_ref_field
                     pv_qfield
                     pv_cfield.

  gt_fcat = VALUE #( BASE gt_fcat
                    (
                      key        = pv_key
                      fieldname  = pv_field
                      coltext    = pv_text
                      ref_table  = pv_ref_table
                      ref_field  = pv_ref_field
                      qfieldname = pv_qfield
                      cfieldname = pv_cfield
                     )
                    ).

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
        container_name = 'GCL_CONTAINER'.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.
  ELSE.

    PERFORM refresh_grid.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .

  DATA : ls_save TYPE ztsa17_mar.

  CLEAR ls_save.

  IF gs_data-matnr IS INITIAL OR
    gs_data-werks IS INITIAL.
    MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  ls_save = CORRESPONDING #( gs_data ).

  MODIFY ztsa17_mar FROM ls_save. " DATABASE에 직접 접근.

  IF sy-dbcnt > 0. " dbcnt에는 데이터베이스에서 무언가 발생한 record의 수를 저장하고 있음.
    COMMIT WORK AND WAIT.
    MESSAGE s000 WITH TEXT-m01.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s000 WITH TEXT-m02 DISPLAY LIKE 'W'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .

  DATA: ls_stable TYPE lvc_s_stbl.

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = space. "'X'시에 편집된 레이아웃(서브토탈 등)에서 서브토탈이 안바뀔 수 있음.

ENDFORM.
