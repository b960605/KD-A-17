*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_A17_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_dbclick FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row e_column,
      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object,
      on_ucomm FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm,
      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid IMPORTING er_data_changed,
      on_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid IMPORTING e_modified et_good_cells.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD on_data_changed_finished. " 변경된 값인지 아닌지를 알려주는 필드를 생성
    DATA: ls_good_cells TYPE lvc_s_modi.

    CHECK e_modified = 'X'.
    LOOP AT et_good_cells INTO ls_good_cells.
*      CLEAR gs_sbook.
      READ TABLE gt_sbook INTO gs_sbook INDEX ls_good_cells-row_id.
      IF sy-subrc = 0.
        gs_sbook-modified = 'X'.
        MODIFY gt_sbook FROM gs_sbook INDEX ls_good_cells-row_id.
*        CLEAR gs_sbook.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD on_data_changed.
    DATA: ls_mod_cell TYPE lvc_s_modi,
          lt_ins_rows TYPE lvc_t_moce,
          ls_ins_rows TYPE lvc_s_moce,
          ls_del_rows TYPE lvc_s_moce.

*    FIELD-SYMBOLS <fs> LIKE gt_sbook.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cell.
      CASE ls_mod_cell-fieldname.
        WHEN 'CUSTOMID'.
          PERFORM customer_change_part USING er_data_changed
                                             ls_mod_cell.
      ENDCASE.
    ENDLOOP.

    IF er_data_changed->mt_inserted_rows IS NOT INITIAL. " 로우 추가를 했을 경우에.
      LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_rows.
        PERFORM insert_parts USING er_data_changed
                                   ls_ins_rows.
      ENDLOOP.
*  cl_demo_output=>display_data( gt_sbook ).
*      ASSIGN er_data_changed->mp_mod_rows->* TO <fs>.
*      IF sy-subrc = 0.
*        APPEND LINES OF <fs> TO gt_sbook.
*        LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_rows.
*          READ TABLE gt_sbook INTO gs_sbook INDEX ls_ins_rows-row_id.
*          IF sy-subrc = 0.
*            PERFORM insert_parts USING er_data_changed
*                                       ls_ins_rows.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
    ENDIF.

    IF er_data_changed->mt_deleted_rows IS NOT INITIAL. " 지워진 게 있으면
      LOOP AT er_data_changed->mt_deleted_rows INTO ls_del_rows.
        READ TABLE gt_sbook INTO gs_sbook INDEX ls_del_rows-row_id.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING gs_sbook TO dls_sbook.
          APPEND dls_sbook TO dl_sbook. " dl_sbook은 휴지통
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD on_ucomm.
    DATA: ls_row TYPE lvc_s_row,
          ls_col TYPE lvc_s_col.
    CALL METHOD go_alv_100->get_current_cell
      IMPORTING
        es_row_id = ls_row
        es_col_id = ls_col.

    CASE e_ucomm.
      WHEN 'GOTOFL'.
        READ TABLE gt_sbook INTO gs_sbook INDEX ls_row-index.
        IF sy-subrc = 0.
          SET PARAMETER ID 'CAR' FIELD gs_sbook-carrid. " SAP memory
          SET PARAMETER ID 'CON' FIELD gs_sbook-connid.

          CALL TRANSACTION 'SAPBC405CAL'.
        ENDIF.
*        set PARAMETER ID 'CAR' field
    ENDCASE.
  ENDMETHOD.

  METHOD on_dbclick.
    DATA: lv_carrname TYPE scarr-carrname.
    CLEAR gs_sbook.
    IF e_column-fieldname = 'CARRID'.
      READ TABLE gt_sbook INTO gs_sbook INDEX e_row-index.
      IF sy-subrc = 0.
        SELECT SINGLE carrname
          FROM scarr
          INTO lv_carrname
          WHERE carrid = gs_sbook-carrid.
        IF sy-subrc = 0.
          MESSAGE i000(zmcsa17) WITH lv_carrname.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD on_toolbar.
    DATA ls_butn TYPE stb_button.

    ls_butn-butn_type = '3'.
    APPEND ls_butn TO e_object->mt_toolbar.
    CLEAR ls_butn.

    ls_butn-butn_type = '0'.
    ls_butn-function = 'GOTOFL'. " Flight Connection으로 이동
    ls_butn-icon = icon_flight.
    ls_butn-quickinfo = 'Flight Connection'.
    ls_butn-text = 'Flight'.
    APPEND ls_butn TO e_object->mt_toolbar.
    CLEAR ls_butn.
  ENDMETHOD.
ENDCLASS.
