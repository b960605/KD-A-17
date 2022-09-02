*&---------------------------------------------------------------------*
*& Include          ZRSAMEN02_A17I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEL'.
    DATA: ls_rows  TYPE lvc_s_row,
          lt_rows  TYPE lvc_t_row,
          ls_sinfo LIKE gs_sinfo,
          lv_count TYPE i,
                    lv_count2 TYPE i.

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
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
