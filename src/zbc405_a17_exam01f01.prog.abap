*&---------------------------------------------------------------------*
*& Include          ZBC405_A17_EXAM01F01
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
    FROM ztspfli_a17
    INTO CORRESPONDING FIELDS OF TABLE gt_spfli
    WHERE carrid IN so_car
    AND   connid IN so_con.

  LOOP AT gt_spfli INTO gs_spfli.

    " IORD
    IF gs_spfli-countryfr = gs_spfli-countryto.
      gs_spfli-iord = 'D'.
    ELSE.
      gs_spfli-iord = 'I'.
    ENDIF.
    IF gs_spfli-iord = 'D'.
      gs_col-fname = 'IORD'.
      gs_col-color-col = col_total.
      gs_col-color-int = '1'.
      gs_col-color-inv = '1'.
      APPEND gs_col TO gs_spfli-gt_col.
      CLEAR gs_col.
    ELSEIF gs_spfli-iord = 'I'.
      gs_col-fname = 'IORD'.
      gs_col-color-col = col_positive.
      gs_col-color-int = '1'.
      gs_col-color-inv = '1'.
      APPEND gs_col TO gs_spfli-gt_col.
      CLEAR gs_col.
    ENDIF.

    " fltype icon
    IF gs_spfli-fltype = 'X'.
      gs_spfli-fticon = icon_ws_plane.
    ENDIF.

    " Time  zone
    READ TABLE gt_sairp INTO gs_sairp WITH KEY id = gs_spfli-airpfrom.
    gs_spfli-frtzone = gs_sairp-time_zone.
    CLEAR gs_sairp.
    READ TABLE gt_sairp INTO gs_sairp WITH KEY id = gs_spfli-airpto.
    gs_spfli-totzone = gs_sairp-time_zone.
    CLEAR gs_sairp.

    " Excp handling
    IF gs_spfli-period GE 2.
      gs_spfli-light = '1'.
    ELSEIF gs_spfli-period = 1.
      gs_spfli-light = '2'.
    ELSEIF gs_spfli-period = 0.
      gs_spfli-light = '3'.
    ENDIF.
    MODIFY gt_spfli FROM gs_spfli.
    CLEAR gs_spfli.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layo .
  gs_layout-zebra = 'X'.
  gs_layout-grid_title = 'Flight Schedule Report'.
  gs_layout-ctab_fname = 'GT_COL'.
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led = 'X'.
  gs_layout-sel_mode = 'D'.
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
  gs_fcat-fieldname = 'IORD'.
  gs_fcat-coltext = 'I&D'.
  gs_fcat-col_pos = 5.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'FTICON'.
  gs_fcat-coltext = 'Flight'.
  gs_fcat-col_pos = 9.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'FLTYPE'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'FRTZONE'.
  gs_fcat-coltext = 'From TZ'.
  gs_fcat-col_pos = 17.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'TOTZONE'.
  gs_fcat-coltext = 'To TZ'.
  gs_fcat-col_pos = 18.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'ARRTIME'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'PERIOD'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'FLTIME'.
  gs_fcat-edit = pa_edit.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'DEPTIME'.
  gs_fcat-edit = pa_edit.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_excl
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_excl .
  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_info TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO gt_excl.
ENDFORM.
