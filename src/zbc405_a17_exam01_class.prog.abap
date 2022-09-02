*&---------------------------------------------------------------------*
*& Include          ZBC405_A17_EXAM01_CLASS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object,
      on_ucomm FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm,
      on_dbclick FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row e_column,
      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid IMPORTING er_data_changed,
      on_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid IMPORTING e_modified et_good_cells.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD on_data_changed_finished.
    CLEAR gs_spfli.
    CHECK e_modified = 'X'.
    DATA: ls_good_cells TYPE lvc_s_modi.

    LOOP AT et_good_cells INTO ls_good_cells.
      READ TABLE gt_spfli INTO gs_spfli INDEX ls_good_cells-row_id.
      IF sy-subrc = 0.
        gs_spfli-modified = 'X'.
        MODIFY gt_spfli FROM gs_spfli INDEX ls_good_cells-row_id.
      ENDIF.

      CLEAR gs_spfli.
    ENDLOOP.
  ENDMETHOD.
  METHOD on_data_changed.
    DATA: ls_mod_cells TYPE lvc_s_modi,
          lv_period    TYPE n,
          lv_arrtime   TYPE spfli-arrtime,
          lv_fltime    TYPE spfli-fltime,
          lv_deptime   TYPE spfli-deptime.

    LOOP AT er_data_changed->mt_mod_cells INTO ls_mod_cells.
      IF ls_mod_cells-fieldname = 'FLTIME' OR ls_mod_cells-fieldname = 'DEPTIME'.
        CALL METHOD er_data_changed->get_cell_value
          EXPORTING
            i_row_id    = ls_mod_cells-row_id
            i_fieldname = 'FLTIME'
          IMPORTING
            e_value     = lv_fltime.
        CALL METHOD er_data_changed->get_cell_value
          EXPORTING
            i_row_id    = ls_mod_cells-row_id
            i_fieldname = 'DEPTIME'
          IMPORTING
            e_value     = lv_deptime.

        IF lv_fltime IS NOT INITIAL OR lv_deptime IS NOT INITIAL.
          CLEAR gs_spfli.
          READ TABLE gt_spfli INTO gs_spfli INDEX ls_mod_cells-row_id.
          CALL FUNCTION 'ZBC405_CALC_ARRTIME'
            EXPORTING
              iv_fltime       = lv_fltime
              iv_deptime      = lv_deptime
              iv_utc          = gs_spfli-frtzone
              iv_utc1         = gs_spfli-totzone
            IMPORTING
              ev_arrival_time = lv_arrtime
              ev_period       = lv_period.

          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_mod_cells-row_id
              i_fieldname = 'ARRTIME'
              i_value     = lv_arrtime.

          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_mod_cells-row_id
*             i_tabix     =
              i_fieldname = 'PERIOD'
              i_value     = lv_period.

          gs_spfli-period = lv_period.
          gs_spfli-arrtime = lv_arrtime.
          gs_spfli-fltime = lv_fltime.
          gs_spfli-deptime = lv_deptime.
          IF lv_period GE 2.
            gs_spfli-light = '1'.
          ELSEIF lv_period = 1.
            gs_spfli-light = '2'.
          ELSEIF lv_period = 0.
            gs_spfli-light = '3'.
          ENDIF.

          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_mod_cells-row_id
*             i_tabix     =
              i_fieldname = 'LIGHT'
              i_value     = gs_spfli-light.

          MODIFY gt_spfli FROM gs_spfli INDEX ls_mod_cells-row_id.
          CLEAR: gs_spfli, lv_arrtime, lv_period, lv_fltime, lv_deptime.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD on_dbclick.
    IF e_column-fieldname = 'CARRID' OR e_column-fieldname = 'CONNID'.
      READ TABLE gt_spfli INTO gs_spfli INDEX e_row-index.
      IF sy-subrc = 0.
        SUBMIT bc405_event_s4 AND RETURN
        WITH so_car EQ gs_spfli-carrid
        WITH so_con EQ gs_spfli-connid.
      ENDIF.
    ENDIF.

  ENDMETHOD.
  METHOD on_ucomm.
    DATA: lv_carrname TYPE scarr-carrname,
          ls_row      TYPE lvc_s_row,
          ls_col      TYPE lvc_s_col,
          lt_row      TYPE lvc_t_row.

    CASE e_ucomm.
      WHEN 'FLIGHT'.
        CALL METHOD go_alv_grid->get_current_cell
          IMPORTING
*           e_row     =
*           e_value   =
*           e_col     =
            es_row_id = ls_row
            es_col_id = ls_col
*           es_row_no =
          .
        IF ls_col-fieldname = 'CARRID'.
          CLEAR gs_spfli.
          READ TABLE gt_spfli INTO gs_spfli INDEX ls_row-index.
          READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = gs_spfli-carrid.
          lv_carrname = gs_scarr-carrname.
          CLEAR: gs_scarr, gs_spfli.
          MESSAGE i000(zmcsa17) WITH lv_carrname.
        ELSE.
          MESSAGE i000(zmcsa17) WITH 'Available only on Airline Field.'.
        ENDIF.
        CLEAR: ls_row, ls_col.

      WHEN 'FLIGHTINFO'.
        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
            et_index_rows = lt_row.
        CLEAR mem_it_spfli.
        LOOP AT lt_row INTO ls_row.
          READ TABLE gt_spfli INTO gs_spfli INDEX ls_row-index.
          MOVE-CORRESPONDING gs_spfli TO mem_is_spfli.
          APPEND mem_is_spfli TO mem_it_spfli.
          CLEAR: mem_is_spfli, gs_spfli.
        ENDLOOP.
        IF mem_it_spfli IS NOT INITIAL.
          EXPORT mem_it_spfli FROM mem_it_spfli TO MEMORY ID 'BC405'.
          SUBMIT bc405_call_flights AND RETURN.
        ELSE.
          MESSAGE i000(zmcsa17) WITH 'No data found. Select at least 1 row.'.
        ENDIF.
      WHEN 'FLIGHTDATA'.
        CALL METHOD go_alv_grid->get_current_cell
          IMPORTING
            es_row_id = ls_row.
        READ TABLE gt_spfli INTO gs_spfli INDEX ls_row-index.
        IF sy-subrc = 0.
          SET PARAMETER ID 'CAR' FIELD gs_spfli-carrid.
          SET PARAMETER ID 'CON' FIELD gs_spfli-connid.
          SET PARAMETER ID 'DAY' FIELD ' '.
          CALL TRANSACTION 'SAPBC410A_INPUT_FIEL'.
        ENDIF.


    ENDCASE.
  ENDMETHOD.

  METHOD on_toolbar.
    DATA: ls_toolbar TYPE stb_button.

    ls_toolbar-butn_type = '3'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
    CLEAR ls_toolbar.

    ls_toolbar-function = 'FLIGHT'.
    ls_toolbar-icon = icon_flight.
    ls_toolbar-quickinfo = 'Airline Info'.
    ls_toolbar-butn_type = '0'.
    ls_toolbar-text = 'Flight'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
    CLEAR ls_toolbar.

    ls_toolbar-function = 'FLIGHTINFO'.
    ls_toolbar-quickinfo = 'Goto Flight list info'.
    ls_toolbar-butn_type = '0'.
    ls_toolbar-text = 'FlightInfo'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
    CLEAR ls_toolbar.

    ls_toolbar-function = 'FLIGHTDATA'.
    ls_toolbar-quickinfo = 'Goto Flight Data'.
    ls_toolbar-butn_type = '0'.
    ls_toolbar-text = 'Flight Data'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
    CLEAR ls_toolbar.
  ENDMETHOD.
ENDCLASS.
