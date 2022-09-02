*&---------------------------------------------------------------------*
*& Report ZBC405_A17_OM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a17_om.
TABLES spfli.

DATA: gt_spfli TYPE TABLE OF spfli,
      gs_spfli TYPE spfli.

SELECT-OPTIONS: so_car FOR spfli-carrid MEMORY ID car,
                so_con FOR spfli-connid MEMORY ID con.
" main salv
DATA: go_alv TYPE REF TO cl_salv_table.
" get_functions
DATA: go_func TYPE REF TO cl_salv_functions_list.
" get_display_settings
DATA: go_disp TYPE REF TO cl_salv_display_settings.
" get columns
DATA: go_cols   TYPE REF TO cl_salv_columns_table,
      go_column TYPE REF TO cl_salv_column_table,
      go_col    TYPE REF TO cl_salv_column. " get column
" get layout
DATA: go_layo TYPE REF TO cl_salv_layout,
      gs_layo TYPE salv_s_layout_key.
gs_layo-report = sy-cprog.
" get selections
DATA: go_sel TYPE REF TO cl_salv_selections.
"  color structure
DATA: gs_color TYPE lvc_s_colo.


START-OF-SELECTION.
  SELECT *
    FROM spfli
    INTO TABLE gt_spfli
    WHERE carrid IN so_car
    AND   connid IN so_con.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = ' ' " 'X' -> 화면을 리스트로 보고 싶을때      "IF_SALV_C_BOOL_SAP=>FALSE
*         r_container  =
*         container_name =
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_spfli.
    CATCH cx_salv_msg.
  ENDTRY.



  CALL METHOD go_alv->get_functions
    RECEIVING
      value = go_func.

*  CALL METHOD go_func->set_filter
*  CALL METHOD go_func->set_sort_asc
*  CALL METHOD go_func->set_sort_desc

  " Application Toolbar Buttons
  CALL METHOD go_func->set_all.

  " Display Settings
  CALL METHOD go_alv->get_display_settings
    RECEIVING
      value = go_disp.


  CALL METHOD go_disp->set_list_header
    EXPORTING
      value = 'Flight Info'.

  CALL METHOD go_disp->set_striped_pattern
    EXPORTING
      value = 'X'.

  " Columns Setting
  CALL METHOD go_alv->get_columns
    RECEIVING
      value = go_cols.

  CALL METHOD go_cols->set_optimize.

  TRY.
      CALL METHOD go_cols->get_column
        EXPORTING
          columnname = 'MANDT'
        RECEIVING
          value      = go_col.

*    CALL METHOD go_col->set_visible
*       EXPORTING
*         value = ''.
      CALL METHOD go_col->set_technical. " Tech field 는 숨겨진 필드.


    CATCH cx_salv_not_found.
  ENDTRY.

**TRY.
*CALL METHOD go_cols->set_color_column
*  EXPORTING
*    value = 'FLTIME'.
**  CATCH cx_salv_data_error.
**ENDTRY.

*TRY.
  CALL METHOD go_cols->get_column
    EXPORTING
      columnname = 'FLTIME'
    RECEIVING
      value      = go_col.
*  CATCH cx_salv_not_found.
*ENDTRY.

  go_column ?= go_col.

  gs_color-col = '5'.
  gs_color-int = '1'.
  gs_color-inv = '0'.

  CALL METHOD go_column->set_color
    EXPORTING
      value = gs_color.

  CALL METHOD go_alv->get_layout " layout
    RECEIVING
      value = go_layo.

  CALL METHOD go_layo->set_key " layout 대상 program
    EXPORTING
      value = gs_layo.

  CALL METHOD go_layo->set_save_restriction " layout save 가능하게 함.
    EXPORTING
      value = if_salv_c_layout=>restrict_none. " NONE은 i_save의 A

  CALL METHOD go_layo->set_default " SAVE Default 사용
    EXPORTING
      value = 'X'.

  CALL METHOD go_alv->get_selections
    RECEIVING
      value = go_sel.

  CALL METHOD go_sel->set_selection_mode
    EXPORTING
      value = if_salv_c_selection_mode=>cell.

  CALL METHOD go_alv->display.
