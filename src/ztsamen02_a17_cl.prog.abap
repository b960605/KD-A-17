*&---------------------------------------------------------------------*
*& Include          ZTSAMEN02_A17_CL
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_dbclick FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row e_column es_row_no,
      on_ctmenu FOR EVENT context_menu_request OF cl_gui_alv_grid IMPORTING e_object,
      on_ucomm FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm,
      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD on_dbclick.
    CLEAR gs_finfo.
    READ TABLE gt_finfo INTO gs_finfo INDEX e_row-index.

    IF gt_sinfo IS NOT INITIAL.
      LOOP AT gt_sinfo INTO gs_sinfo.
        IF gs_sinfo-carrid = gs_finfo-carrid
          AND gs_sinfo-connid = gs_finfo-connid
          AND gs_sinfo-fldate = gs_finfo-fldate.

          MESSAGE i000(zmcsa17) WITH '이미 존재하는 데이터입니다.'.
          CLEAR: gs_sinfo, gs_finfo.
          RETURN.
        ENDIF.
      ENDLOOP.
      APPEND gs_finfo TO gt_sinfo.
      CLEAR gs_finfo.
    ELSE.
      APPEND gs_finfo TO gt_sinfo.
      CLEAR gs_finfo.
    ENDIF.
    CALL METHOD go_alv_grid_2->refresh_table_display.
  ENDMETHOD.

  METHOD on_ctmenu.

    CALL METHOD e_object->add_separator.

    CALL METHOD e_object->add_function
      EXPORTING
        fcode = 'MOVETOLOW'
        text  = 'Move To Lower Table'.

  ENDMETHOD.

  METHOD on_ucomm.
    DATA: ls_rows   TYPE lvc_s_row,
          lt_rows   TYPE lvc_t_row,
          ls_sinfo  LIKE gs_sinfo,
          lv_count  TYPE i,
          lv_count2 TYPE i.
    CASE e_ucomm.
      WHEN 'MOVETOLOW'.
        CALL METHOD go_alv_grid_1->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.

        IF gt_sinfo IS INITIAL.
          LOOP AT lt_rows INTO ls_rows.
            READ TABLE gt_finfo INTO gs_finfo INDEX ls_rows-index.
            APPEND gs_finfo TO gt_sinfo.
*            APPEND gs_finfo TO lt_sinfo.
            CLEAR gs_finfo.
          ENDLOOP.
        ELSE.
          LOOP AT lt_rows INTO ls_rows.
            READ TABLE gt_finfo INTO gs_finfo INDEX ls_rows-index.
            APPEND gs_finfo TO gt_sinfo.
            CLEAR gs_finfo.
          ENDLOOP.

          SORT gt_sinfo.
*              cl_demo_output=>display_data( gt_sinfo ).
          DESCRIBE TABLE gt_sinfo.

          DO sy-tfill - 1 TIMES.
            lv_count = lv_count + 1.
            lv_count2 = lv_count + 1.
            READ TABLE gt_sinfo INTO gs_sinfo INDEX lv_count.
            READ TABLE gt_sinfo INTO ls_sinfo INDEX lv_count2.
*            cl_demo_output=>display_data( gt_sinfo ).
            IF gs_sinfo-carrid = ls_sinfo-carrid
              AND gs_sinfo-connid = ls_sinfo-connid
              AND gs_sinfo-fldate = ls_sinfo-fldate.
              MESSAGE i000(zmcsa17) WITH '중복된 값을 제외하고 추가됩니다.'.
              CLEAR: gs_sinfo, ls_sinfo.
              DELETE ADJACENT DUPLICATES FROM gt_sinfo COMPARING carrid connid fldate.
              EXIT.
            ENDIF.
          ENDDO.

          DELETE ADJACENT DUPLICATES FROM gt_sinfo COMPARING carrid connid fldate.
*          cl_demo_output=>display_data( gt_sinfo ).
        ENDIF.

*        cl_demo_output=>display_data( lt_sinfo ).
        CALL METHOD go_alv_grid_2->refresh_table_display.

      WHEN 'SELALL'.
        CLEAR: ls_rows, lt_rows.

        DESCRIBE TABLE gt_finfo.
        DO sy-tfill TIMES.
          ls_rows-index = ls_rows-index + 1.
          APPEND ls_rows TO lt_rows.
        ENDDO.
        CALL METHOD go_alv_grid_1->set_selected_rows
          EXPORTING
            it_index_rows = lt_rows.

      WHEN 'DESELALL'.
        CLEAR: ls_rows, lt_rows.
        CALL METHOD go_alv_grid_1->set_selected_rows
          EXPORTING
            it_index_rows = lt_rows.
    ENDCASE.
  ENDMETHOD.

  METHOD on_toolbar.
    DATA: ls_butn TYPE stb_button.

    ls_butn-function = 'SELALL'.
    ls_butn-butn_type = '0'.
    ls_butn-text = 'SELECT ALL'.
    APPEND ls_butn TO e_object->mt_toolbar.
    CLEAR ls_butn.

    ls_butn-function = 'DESELALL'.
    ls_butn-butn_type = '0'.
    ls_butn-text = 'DESELECT ALL'.
    APPEND ls_butn TO e_object->mt_toolbar.
    CLEAR ls_butn.
  ENDMETHOD.
ENDCLASS.
