*&---------------------------------------------------------------------*
*& Include          ZBC405_A17_ALV_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION. " 정의 " Local Class
  PUBLIC SECTION.
    CLASS-METHODS: on_doubleclick FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no,
      on_hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,
      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      on_usercommand FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_button_click FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id es_row_no,
      on_print_top FOR EVENT print_top_of_page OF cl_gui_alv_grid,
      on_print_tol FOR EVENT print_top_of_list OF cl_gui_alv_grid,
      on_context_menu FOR EVENT context_menu_request OF cl_gui_alv_grid
        IMPORTING e_object,
      on_before_user_command FOR EVENT before_user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.

ENDCLASS.

CLASS lcl_handler IMPLEMENTATION. " 구현
  METHOD on_print_top.
    WRITE : / sy-datum, sy-uzeit.
  ENDMETHOD.

  METHOD on_print_tol.
*    WRITE : / so_car-low.
  ENDMETHOD.

  METHOD on_doubleclick.
    DATA: lv_total_occ   TYPE i,
          lv_total_occ_c TYPE c LENGTH 10.

    CASE e_column-fieldname.
      WHEN 'CHANGES_POSSIBLE'.
        READ TABLE gt_flt INTO gs_flt INDEX e_row-index.

        IF sy-subrc = 0.
          lv_total_occ = gs_flt-seatsocc + gs_flt-seatsocc_b + gs_flt-seatsocc_f.

          lv_total_occ_c = lv_total_occ.
          CONDENSE lv_total_occ_c. " 숫자의 우측 정렬을 문자의 좌측정렬로 바꿔줌.
          MESSAGE i000(zt03_msg) WITH 'Total number of booking:' lv_total_occ_c.

        ELSE.
          MESSAGE i016(pn) WITH 'Internal Error'.
          EXIT.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD on_hotspot.
    DATA: lv_carr_name TYPE scarr-carrname.

    CASE e_column_id-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_flt INTO gs_flt INDEX e_row_id-index.
        IF sy-subrc = 0.
          SELECT SINGLE carrname
            FROM scarr
            INTO lv_carr_name
            WHERE carrid = gs_flt-carrid.

          IF sy-subrc = 0.
            MESSAGE i000(zt03_msg) WITH lv_carr_name.
          ELSE.
            MESSAGE i000(zt03_msg) WITH 'No found!'.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD on_toolbar.
    DATA: "lt_button TYPE ttb_button,
          ls_button TYPE stb_button.
    ls_button-function = 'PERCENTAGE'. " Percentage
    ls_button-quickinfo = 'Occupied Total Percentage'. " 마우스 대면 나오는 소개
    ls_button-butn_type = '0'. " Normal type
    ls_button-text = 'Percentage'.

    APPEND ls_button TO e_object->mt_toolbar.
    CLEAR ls_button.

    "Separator
    ls_button-butn_type = '3'.
    "APPEND ls_button TO e_object->mt_toolbar.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.
    CLEAR ls_button.

    ls_button-function = 'PERCENTAGE_MARKED'.
    ls_button-quickinfo = 'Occupied Marked Percentage'.
    ls_button-butn_type = '0'.
    ls_button-text = 'Marked Percentage'.
*    ls_button-icon = ?
    APPEND ls_button TO e_object->mt_toolbar.
    CLEAR ls_button.

    ls_button-function = 'CARRNAME'.
    ls_button-quickinfo = 'Airline Info'.
    ls_button-butn_type = '0'.
*    ls_button-text = 'Airline'.
    ls_button-icon = icon_flight.
    APPEND ls_button TO e_object->mt_toolbar.
    CLEAR ls_button.
  ENDMETHOD.

  METHOD on_usercommand.
    DATA: lv_occp     TYPE i,
          lv_capa     TYPE i,
          lv_perct    TYPE p LENGTH 8 DECIMALS 1,
          lv_perct_t  TYPE c LENGTH 20,
          lt_rows     TYPE lvc_t_row,
          ls_rows     TYPE lvc_s_row,
          ls_col      TYPE lvc_s_col,
          lv_carrname TYPE scarr-carrname.

    CASE e_ucomm.
      WHEN 'PERCENTAGE'.
        LOOP AT gt_flt INTO gs_flt.
          lv_occp = lv_occp + gs_flt-seatsocc.
          lv_capa = lv_capa + gs_flt-seatsmax.
          CLEAR gs_flt.
        ENDLOOP.
        lv_perct = lv_occp / lv_capa * 100.
        lv_perct_t = lv_perct.
        CONDENSE lv_perct_t.
        MESSAGE i000(zmcsa17) WITH 'Percentage of Occupied seats :' lv_perct_t.
        CLEAR: lv_occp, lv_capa, lv_perct, lv_perct_t.

      WHEN 'PERCENTAGE_MARKED'.
        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
*            et_row_no     =
        .

*        go_alv_grid->get_selected_rows(
*        IMPORTING et_index_rows = lt_rows ).
        IF lines( lt_rows ) > 0.
          LOOP AT lt_rows INTO ls_rows.

            READ TABLE gt_flt INDEX ls_rows-index INTO gs_flt.
            lv_occp = lv_occp + gs_flt-seatsocc.
            lv_capa = lv_capa + gs_flt-seatsmax.
            CLEAR gs_flt.

          ENDLOOP.

          lv_perct = lv_occp / lv_capa * 100.
          lv_perct_t = lv_perct.
          CONDENSE lv_perct_t.
          MESSAGE i000(zmcsa17) WITH 'Percentage of Occupied seats(%) :' lv_perct_t.
          CLEAR: lv_occp, lv_capa, lv_perct, lv_perct_t.
        ELSE.
          MESSAGE i000(zmcsa17) WITH 'Please select more than 1 row.'.
        ENDIF.

      WHEN 'CARRNAME'.
        CALL METHOD go_alv_grid->get_current_cell
          IMPORTING
*           e_row     =
*           e_value   =
*           e_col     =
            es_row_id = ls_rows
            es_col_id = ls_col.
*           es_row_no =
        IF ls_col-fieldname = 'CARRID'.
          READ TABLE gt_flt INTO gs_flt INDEX ls_rows-index.

          SELECT SINGLE carrname
            FROM scarr
            INTO lv_carrname
            WHERE carrid = gs_flt-carrid.

          MESSAGE i000(zmcsa17) WITH lv_carrname.
        ELSE.
          MESSAGE i000(zmcsa17) WITH 'Possble only you select Airline Code field'.
        ENDIF.
        CLEAR: lv_carrname, ls_col-fieldname.

      WHEN 'SCHE'. " go to flight schedule report
        CLEAR: gs_flt, ls_rows.

        CALL METHOD go_alv_grid->get_current_cell
          IMPORTING
            es_row_id = ls_rows
            es_col_id = ls_col.

        READ TABLE gt_flt INTO gs_flt INDEX ls_rows-index.
        IF sy-subrc = 0.
          SUBMIT bc405_event_d4 AND RETURN
            WITH so_car EQ gs_flt-carrid
            WITH so_con EQ gs_flt-connid.
          CLEAR gs_flt.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD on_button_click.

    CALL METHOD go_alv_grid->get_current_cell
*      IMPORTING
*        e_row     =
*        e_value   =
*        e_col     =
*        es_row_id =
*        es_col_id =
*        es_row_no =
      .
    READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
    IF ( gs_flt-seatsmax NE gs_flt-seatsocc ) OR
      ( gs_flt-seatsmax_f NE gs_flt-seatsocc_f ).
      MESSAGE i000(zmcsa17) WITH 'It is possible to reserve'.
    ELSE.
      MESSAGE i000(zmcsa17) WITH 'Please reserve other class.'.
    ENDIF.

  ENDMETHOD.

  METHOD on_context_menu.
    DATA: ls_rows TYPE lvc_s_row,
          ls_cols TYPE lvc_s_col,
          lt_fun  TYPE ui_functions,
          ls_fun  TYPE ui_func.

    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = ls_rows
        es_col_id = ls_cols.
*       es_row_no =



    CALL METHOD e_object->add_function
      EXPORTING
        fcode = 'PERCENTAGE'
        text  = 'Percentage'
*       icon  =
*       ftype =
*       disabled          =
*       hidden            =
*       checked           =
*       accelerator       =
*       insert_at_the_top = SPACE
      .
    CALL METHOD e_object->add_separator.


*    IF ls_cols-fieldname = 'CARRID'.
    CALL METHOD cl_ctmenu=>load_gui_status
      EXPORTING
        program    = sy-cprog
        status     = 'CT_MENU'
*       disable    =
        menu       = e_object
      EXCEPTIONS
        read_error = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
*    ENDIF.

    " Hide Functions 활용
    ls_fun = 'CARRNAME'.
    APPEND ls_fun TO lt_fun.
    CLEAR ls_fun.

    IF ls_cols-fieldname NE 'CARRID'.
      CALL METHOD e_object->hide_functions
        EXPORTING
          fcodes = lt_fun.
    ENDIF.

  ENDMETHOD.

  METHOD on_before_user_command.
    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail.
        CALL METHOD go_alv_grid->set_user_command
          EXPORTING
            i_ucomm = 'SCHE'.  " Flight schedule report

    ENDCASE.
  ENDMETHOD.
ENDCLASS.
