*&---------------------------------------------------------------------*
*& Report ZBC405_A17_ALV_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a17_alv_01.

TYPES: BEGIN OF ts_flt.
         INCLUDE TYPE sflight.
TYPES:   light            TYPE c LENGTH 1,
         row_color        TYPE c LENGTH 4,
         it_color         TYPE lvc_t_scol,
         changes_possible TYPE icon-id,
         btn_text         TYPE c LENGTH 10,
         gt_styl          TYPE lvc_t_styl, " Button Style
         tankcap          TYPE saplane-tankcap,
         cap_unit         TYPE saplane-cap_unit,
         weight           TYPE saplane-weight,
         wei_unit         TYPE saplane-wei_unit,

       END OF ts_flt. " Deep structure
" for output
DATA gt_flt TYPE TABLE OF ts_flt.
DATA gs_flt TYPE ts_flt.
DATA ok_code LIKE sy-ucomm.

" Style structure
DATA gs_styl TYPE lvc_s_styl.

" for it_color Append
DATA gs_color TYPE lvc_s_scol. " Nested Structure

" for refresh
DATA: gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.

" for excluding
DATA gt_exct TYPE ui_functions.

" it_fieldcatalog table
DATA gt_fcat TYPE lvc_t_fcat.
DATA gs_fcat TYPE lvc_s_fcat.

" Varient Setting
DATA gs_variant TYPE disvariant.
DATA gv_save.

" Layout Setting
DATA gs_layout TYPE lvc_s_layo.
" Sort Setting Table
DATA: gt_sort TYPE lvc_t_sort,
      gs_sort TYPE lvc_s_sort.

*-- alv data 선언
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.

* Class 만들기
INCLUDE zbc405_a17_alv_class.

*-- selection-screen
SELECT-OPTIONS: so_car FOR gs_flt-carrid MEMORY ID car,
                so_con FOR gs_flt-connid MEMORY ID con,
                so_dat FOR gs_flt-fldate.

SELECTION-SCREEN SKIP 1.
PARAMETERS pa_date TYPE sy-datum DEFAULT '20211001'.
PARAMETERS pa_lv TYPE disvariant-variant.

INITIALIZATION.
  so_car-low = 'AA'.

  PERFORM make_variant.
  " Layout Setting
  PERFORM make_layout.

  PERFORM make_sort.

  PERFORM make_fieldcatalog.

  APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.
*  APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exct. " 전부 사라짐
  "gt_exct는 필드가 하나인 테이블 형태기 때문에 값이 직접 들어올 수 있음.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.
  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'F' " Possible Entry로 보여줌 ( S / F / L )
    CHANGING
      cs_variant      = gs_variant
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_lv = gs_variant-variant.
  ENDIF.

*  gs_variant-variant = pa_lv.

START-OF-SELECTION. " Main source
  CLEAR: gs_flt, gt_flt.

  " Exception Handling
  PERFORM get_data.



  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

  CASE ok_code.
    WHEN 'EXIT'.
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.

      FREE: go_alv_grid, go_container.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.

      FREE: go_alv_grid, go_container.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.

      FREE: go_alv_grid, go_container.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
  IF go_container IS INITIAL. " Create container only when container does not exist

    CREATE OBJECT go_container " Create Container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv_grid " ALV to stack on the Container
      EXPORTING
        i_parent = go_container " can be checked through constructor parameters of CL_GUI_ALV_GRID
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    " ALV Event Triggers
    SET HANDLER lcl_handler=>on_doubleclick FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_hotspot FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_usercommand FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_button_click FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_print_top FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_context_menu FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_before_user_command FOR go_alv_grid.

    CALL METHOD go_alv_grid->set_table_for_first_display " Assigning a Table to show on ALV
      EXPORTING
*       i_buffer_active      =
*       i_bypassing_buffer   =
*       i_consistency_check  =
        i_structure_name     = 'SFLIGHT' " 해당 structure의 필드들이 기본적으로 출력된다. 나머지는 fieldcatalog로 출력.
        " <Variant 설정>
        is_variant           = gs_variant
        i_save               = gv_save
        i_default            = 'X'
        " <Layout 설정>
        is_layout            = gs_layout
*       is_print             =
*       it_special_groups    =
        it_toolbar_excluding = gt_exct
*       it_hyperlink         =
*       it_alv_graphics      =
*       it_except_qinfo      =
*       ir_salv_adapter      =
      CHANGING
        it_outtab            = gt_flt " Table for output
        it_fieldcatalog      = gt_fcat
        it_sort              = gt_sort
*       it_filter            =
      EXCEPTIONS
*       invalid_parameter_combination = 1
*       program_error        = 2
*       too_many_lines       = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

  ELSE.

    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
    gv_soft_refresh = 'X'.

    CALL METHOD go_alv_grid->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

  ENDIF.
ENDMODULE.
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
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flt
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.

  LOOP AT gt_flt INTO gs_flt.
    SELECT SINGLE *
      FROM saplane
      INTO CORRESPONDING FIELDS OF gs_flt
      WHERE planetype = gs_flt-planetype.
    " Exception Field Setting
    IF gs_flt-seatsocc < 5.
      gs_flt-light = '1'.
    ELSEIF gs_flt-seatsocc < 100.
      gs_flt-light = '2'.
    ELSE.
      gs_flt-light = '3'.
    ENDIF.

    " Row color setting
    IF gs_flt-fldate+4(2) = sy-datum+4(2).
      gs_flt-row_color = 'C511'.
    ENDIF.

    " Cell color setting
    IF gs_flt-planetype = '747-400'.
      gs_color-fname = 'PLANETYPE'.
      gs_color-color-col = col_total.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.
    IF gs_flt-seatsocc_b = 0.
      gs_color-fname = 'SEATSOCC_B'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    " Add icon Field
    IF gs_flt-fldate < pa_date.
      gs_flt-changes_possible = icon_space.
    ELSE.
      gs_flt-changes_possible = icon_okay.
    ENDIF.

    " Cell Button
    IF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
      gs_flt-btn_text = 'Full Seats'.

      gs_styl-fieldname = 'BTN_TEXT'.
      gs_styl-style = cl_gui_alv_grid=>mc_style_button.
      APPEND gs_styl TO gs_flt-gt_styl.

*    ELSEIF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
*      gs_flt-btn_text = ''.
    ENDIF.

    MODIFY gt_flt FROM gs_flt.
    CLEAR gs_flt.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .
  gs_variant-report = sy-cprog.
  gv_save = 'A'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
  gs_layout-zebra = 'X'.
*  gs_layout-cwidth_opt = 'X'. " field catalog의 col_opt 기능

  gs_layout-sel_mode = 'D'.
  "P.155"A-> mulitiple row/column selection 가능 / B-> Multiple column만 가능 / C-> Multiple Row/Column이지만 Selection columnd이 없음. / D->
  gs_layout-excp_fname = 'LIGHT'. " Exception Handling Field Name Setting
  gs_layout-excp_led = 'X'.

  gs_layout-info_fname = 'ROW_COLOR'.
  gs_layout-ctab_fname = 'IT_COLOR'.

  gs_layout-stylefname = 'GT_STYL'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form make_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .
  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 1.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'. "Ascending
  gs_sort-spos = 2.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'. "Descending
  gs_sort-spos = 3.
  APPEND gs_sort TO gt_sort.

*  CLEAR gs_sort.
*  gs_sort-fieldname = 'PLANETYPE'.
*  gs_sort-up = 'X'.
*  gs_sort-spos = 4.
*  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.

  gs_fcat-fieldname = 'PRICE'.
  gs_fcat-emphasize = 'C610'. " Column Color
  gs_fcat-col_opt = 'X'.
*  gs_fcat-edit = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'CHANGES_POSSIBLE'. "Add new field
  gs_fcat-coltext = 'Chang.Poss'. " Field output name
  gs_fcat-col_opt = 'X'. " Column size
  gs_fcat-col_pos = 5. " Column 배치
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'PAYMENTSUM'.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'CARRID'.
  gs_fcat-coltext = 'Airline Code'.
  gs_fcat-col_opt = 'X'.
*  gs_fcat-hotspot = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'BTN_TEXT'.
  gs_fcat-coltext = 'Status'.
  gs_fcat-col_pos = 12.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'TANKCAP'.
  gs_fcat-coltext = 'Tank Cap'.
  gs_fcat-col_pos = 17.
  gs_fcat-col_opt = 'X'.
  gs_fcat-decimals_o = 0.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'CAP_UNIT'.
  gs_fcat-coltext = 'Cap unit'.
  gs_fcat-col_pos = 18.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'WEIGHT'.
*  gs_fcat-ref_table = 'SAPLANE'.
*  gs_fcat-ref_field = 'WEIGHT'.
*  gs_fcat-qfieldname = 'WEI_UNIT'. " ref field로 사용하는 경우 단위 필드(qfieldname, cfieldname) 지정해줘야 Decimals 사라짐
  gs_fcat-coltext = 'Weight'.
  gs_fcat-col_pos = 19.
  gs_fcat-col_opt = 'X'.
  gs_fcat-decimals_o = 0.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'WEI_UNIT'.
  gs_fcat-coltext = 'Weight Unit'.
*  gs_fcat-ref_table = 'SAPLANE'.
*  gs_fcat-ref_field = 'WEI_UNIT'.
  gs_fcat-col_pos = 20.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.
*  gs_fcat-fieldname = 'PRICE'.
*  gs_fcat-no_out = 'X'.
*  APPEND gs_fcat TO gt_fcat.

ENDFORM.
