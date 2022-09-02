*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_A17_02F01
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

  DATA :lt_sbook  TYPE TABLE OF ts_sbook.

  SELECT *
    FROM ztsbook_a17
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_fld
    AND   customid IN so_cus.

  IF sy-subrc = 0. " for all entries 쓸 때는 꼭 체크
    lt_sbook = gt_sbook.
    DELETE lt_sbook WHERE customid = space. " 비어있는 값도 필요없기 때문에 삭제
    SORT lt_sbook BY customid.
    DELETE ADJACENT DUPLICATES FROM lt_sbook COMPARING customid. " 중복된 값 삭제. 어차피 customid가 있는 것들은 하나씩만 들어갈 것.

    SELECT *
      FROM ztscustom_a17
      INTO CORRESPONDING FIELDS OF TABLE gt_custom
      FOR ALL ENTRIES IN gt_sbook
      WHERE id = gt_sbook-customid.
  ENDIF.

  LOOP AT gt_sbook INTO gs_sbook.
    READ TABLE gt_custom WITH KEY id = gs_sbook-customid INTO gs_custom.
    gs_sbook-telephone = gs_custom-telephone.
    gs_sbook-email = gs_custom-email.

    IF gs_sbook-luggweight > 25.
      gs_sbook-light = 1. " Red Light
    ELSEIF gs_sbook-luggweight > 15.
      gs_sbook-light = 2. " Orange Light
    ELSE.
      gs_sbook-light = 3. " Green Light
    ENDIF.

    IF gs_sbook-class = 'F'.
      gs_sbook-row_color = 'C711'.
    ENDIF.

    IF gs_sbook-smoker = 'X'.
      gs_col-fname = 'SMOKER'.
      gs_col-color-col = col_negative.
      gs_col-color-int = '1'.
      gs_col-color-inv = '0'.
      APPEND gs_col TO gs_sbook-gt_col.
      CLEAR gs_col.
    ENDIF.
    MODIFY gt_sbook FROM gs_sbook.
    CLEAR gs_sbook.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layo-sel_mode = 'D'.
  gs_layo-excp_fname = 'LIGHT'.
  gs_layo-excp_led = 'X'.
  gs_layo-zebra = 'X'.
  gs_layo-cwidth_opt = 'X'.
  gs_layo-info_fname = 'ROW_COLOR'.
  gs_layo-ctab_fname = 'GT_COL'.
  gs_layo-stylefname = 'BT'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  gs_sort-spos = '1'.
  APPEND gs_sort TO gt_sort.
  CLEAR gs_sort.

  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = '2'.
  APPEND gs_sort TO gt_sort.
  CLEAR gs_sort.

  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.
  gs_sort-spos = '3'.
  APPEND gs_sort TO gt_sort.
  CLEAR gs_sort.
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
  APPEND cl_gui_alv_grid=>mc_fc_info TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_excl.
  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_excl.
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
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'SMOKER'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'CANCELLED'.
  gs_fcat-checkbox = 'X'.
  gs_fcat-edit = pa_edit.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'INVOICE'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'TELEPHONE'.
  gs_fcat-ref_field = 'TELEPHONE'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A17'.
  gs_fcat-col_pos = 23.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'EMAIL'.
  gs_fcat-ref_field = 'EMAIL'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A17'.
  gs_fcat-col_pos = 24.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'CUSTOMID'.
*  gs_fcat-emphasize = 'C311'.
  gs_fcat-edit = pa_edit.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form customer_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELL
*&---------------------------------------------------------------------*
FORM customer_change_part  USING    p_changed TYPE REF TO cl_alv_changed_data_protocol
                                    p_cell TYPE lvc_s_modi.

  DATA: lv_val   TYPE ztsbook_a17-customid,
        lv_tel   TYPE ztscustom_a17-telephone,
        lv_email TYPE ztscustom_a17-email,
        lv_cname TYPE ztscustom_a17-name.

  CALL METHOD p_changed->get_cell_value
    EXPORTING
     i_row_id    = p_cell-row_id
*      i_tabix     =
      i_fieldname = 'CUSTOMID'
    IMPORTING
      e_value     = lv_val.

  IF lv_val IS INITIAL.
    CLEAR: lv_email, lv_tel, lv_cname.
  ELSE.
    CLEAR gs_custom.
    READ TABLE gt_custom INTO gs_custom WITH KEY id = lv_val.
    IF sy-subrc = 0.
      lv_tel = gs_custom-telephone.
      lv_email = gs_custom-email.
      lv_cname = gs_custom-name.
      CLEAR gs_custom.
    ELSE.
      SELECT SINGLE telephone email name
        FROM ztscustom_a17
        INTO (lv_tel, lv_email, lv_cname)
        WHERE id = lv_val.
    ENDIF.
  ENDIF.

  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cell-row_id
*      i_tabix     =
      i_fieldname = 'TELEPHONE'
      i_value     = lv_tel.


  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cell-row_id
*      i_tabix     =
      i_fieldname = 'EMAIL'
      i_value     = lv_email.

  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cell-row_id
*      i_tabix     =
      i_fieldname = 'PASSNAME'
      i_value     = lv_cname.



  gs_sbook-telephone = lv_tel.
  gs_sbook-email = lv_email.
  gs_sbook-passname = lv_cname.

  MODIFY gt_sbook FROM gs_sbook INDEX p_cell-row_id.

  CLEAR gs_sbook.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form insert_parts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_INS_ROWS
*&---------------------------------------------------------------------*
FORM insert_parts  USING    p_data_changed TYPE REF TO cl_alv_changed_data_protocol
                            p_rows TYPE lvc_s_moce.
  gs_sbook-carrid = so_car-low.
  gs_sbook-connid = so_con-low.
  gs_sbook-fldate = so_fld-low.

  CALL METHOD p_data_changed->modify_cell
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'CARRID'
      i_value     = gs_sbook-carrid.

  CALL METHOD p_data_changed->modify_cell
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'CONNID'
      i_value     = gs_sbook-connid.

  CALL METHOD p_data_changed->modify_cell
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'FLDATE'
      i_value     = gs_sbook-fldate.

  CALL METHOD p_data_changed->modify_cell
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'ORDER_DATE'
      i_value     = sy-datum.

  CALL METHOD p_data_changed->modify_cell
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'CUSTTYPE'
      i_value     = 'P'.

  CALL METHOD p_data_changed->modify_cell
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'CLASS'
      i_value     = 'C'.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'FLDATE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'CUSTTYPE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'CLASS'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'DISCOUNT'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'SMOKER'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'LUGGWEIGHT'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'WUNIT'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'INVOICE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'FORCURAM'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'FORCURKEY'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'LOCCURAM'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'LOCCURKEY'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'ORDER_DATE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD p_data_changed->modify_style
    EXPORTING
      i_row_id    = p_rows-row_id
      i_fieldname = 'AGENCYNUM'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  APPEND gs_sbook TO gt_sbook.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .
  DATA: lt_ins_sbook TYPE TABLE OF ztsbook_a17,
        ls_ins_sbook TYPE ztsbook_a17,
        next_number  TYPE s_book_id,
        ret_code     TYPE inri-returncode,
        lv_tabix     LIKE sy-tabix.

*  CLEAR : lt_ins_sbook. REFRESH : lt_ins_sbook.

  " -- update
  LOOP AT gt_sbook INTO gs_sbook WHERE modified = 'X'. " update 대상
    UPDATE ztsbook_a17
       SET customid = gs_sbook-customid " 이 record를 뒤의 record로 바꾼다
           cancelled = gs_sbook-cancelled
           passname = gs_sbook-passname
    WHERE  carrid = gs_sbook-carrid " ztsbook_a17 의 여기에 해당하는 row를.
    AND    connid = gs_sbook-connid
    AND    fldate = gs_sbook-fldate
    AND    bookid = gs_sbook-bookid.
    CLEAR gs_sbook.
  ENDLOOP.

  " -- insert -> bookid가 키값임에도 불구하고 없는 record들이 새롭게 생긴 row로 볼 수 있기 때문에 그것으로 판단
  LOOP AT gt_sbook INTO gs_sbook WHERE bookid IS INITIAL.

    lv_tabix = sy-tabix. " Internal table의 시스템 tabix를 오염시키지 않기 위해서 값을 옮겨놓는다.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZBOOKIDA17'
*       QUANTITY                = '1'
        subobject               = gs_sbook-carrid
*       TOYEAR                  = '0000'
*       IGNORE_BUFFER           = ' '
      IMPORTING
        number                  = next_number
*       QUANTITY                =
        returncode              = ret_code
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF next_number IS NOT INITIAL. " 해당 번호가 있으면 assign
      gs_sbook-bookid = next_number.
      MOVE-CORRESPONDING gs_sbook TO ls_ins_sbook. " 형태가 다름
      APPEND ls_ins_sbook TO lt_ins_sbook.

      MODIFY gt_sbook FROM gs_sbook INDEX lv_tabix TRANSPORTING bookid. " transporting 뒤에 나온 것만 modify
    ENDIF.
  ENDLOOP.
  IF lt_ins_sbook IS NOT INITIAL.
    INSERT ztsbook_a17 FROM TABLE lt_ins_sbook.
  ENDIF.

*-- delete
  IF dl_sbook IS NOT INITIAL.
    DELETE ztsbook_a17 FROM TABLE dl_sbook.

    CLEAR: dl_sbook.
    REFRESH dl_sbook." header-line 테이블을 클리어

  ENDIF.
ENDFORM.
