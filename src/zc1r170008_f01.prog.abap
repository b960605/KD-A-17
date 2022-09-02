*&---------------------------------------------------------------------*
*& Include          ZC1R170008_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_emp_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_emp_data .

  REFRESH gt_emp.

  SELECT pernr ename entdt gender gender_t depnr carrid
    FROM ztsa1701
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE pernr IN so_pernr.

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
  gs_layout-sel_mode   = 'D'.
  gs_layout-stylefname = 'STYLE'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING:
          'X'  'PERNR'     ' '  'ZTSA1701'  'PERNR'    'X'  '10',
          ' '  'ENAME'     ' '  'ZTSA1701'  'ENAME'    'X'  '15',
          ' '  'ENTDT'     ' '  'ZTSA1701'  'ENTDT'    'X'  '10',
          ' '  'GENDER'    ' '  'ZTSA1701'  'GENDER'   'X'  '3',
          ' '  'GENDER_T'  ' '  'ZTSA1701'  'GENDER_T' 'X'  '10',
          ' '  'DEPNR'     ' '  'ZTSA1701'  'DEPNR'    'X'  '6',
          ' '  'CARRID'    ' '  'ZTSA1701'  'CARRID'   'X'  '5',
          ' '  'CARRNAME'  ' '  'SCARR'     'CARRNAME' ' '  '20'.
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
                     pv_edit
                     pv_cleng.

  CLEAR gs_fcat.

  gs_fcat = VALUE #( key = pv_key
                     fieldname = pv_field
                     coltext = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field
                     edit      = pv_edit
                     outputlen = pv_cleng ).

  APPEND gs_fcat TO gt_fcat.

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
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.

    SET HANDLER : lcl_event_handler=>handle_data_changed    FOR gcl_grid,
                  lcl_event_handler=>handle_change_finished FOR gcl_grid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_emp
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .

  CLEAR gs_emp.

  APPEND gs_emp TO gt_emp.

  PERFORM refresh_grid.

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

  gs_stable-col = 'X'.
  gs_stable-row = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_emp .

  DATA: lt_save  TYPE TABLE OF ztsa1701, " DB에 반영시켜주기 위해서 완전히 똑같은 형태의 테이블을 생성해준다.
        lt_del   TYPE TABLE OF ztsa1701,
        lv_error,
        lv_cnt   TYPE i.

  REFRESH lt_save.

  CALL METHOD gcl_grid->check_changed_data. " ALV의 변경을 ITAB에 반영

  CLEAR : lv_cnt, lv_error.

  LOOP AT gt_emp INTO gs_emp.

    IF gs_emp-pernr IS INITIAL.
      MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
      lv_error = 'X'. " Exit 해도 루프문만 빠져 나가기 때문에 pernr이 없다면 에러 발생의 의미로 X.
      EXIT.
    ENDIF.

    CHECK lv_error IS INITIAL.

    lt_save = VALUE #( BASE lt_save
                      (
                        pernr    = gs_emp-pernr
                        ename    = gs_emp-ename
                        entdt    = gs_emp-entdt
                        gender   = gs_emp-gender
                        gender_t = gs_emp-gender_t
                        depnr    = gs_emp-depnr
                        carrid   = gs_emp-carrid
                       )
                      ).
  ENDLOOP.

  IF lv_error IS NOT INITIAL.
    EXIT.
  ENDIF.

  IF gt_emp_del IS NOT INITIAL.

    LOOP AT gt_emp_del INTO DATA(ls_del).

      lt_del = VALUE #( BASE lt_del
                       (
                        pernr = ls_del-pernr
                        )
                       ).
    ENDLOOP.

    DELETE ztsa1701 FROM TABLE lt_del.

    IF sy-dbcnt > 0.
      lv_cnt = lv_cnt + sy-dbcnt.
    ENDIF.

  ENDIF.

  IF lt_save IS NOT INITIAL.

    MODIFY ztsa1701 FROM TABLE lt_save.

    IF sy-dbcnt > 0.
      lv_cnt = lv_cnt + sy-dbcnt.
    ENDIF.

    IF lv_cnt > 0.
      COMMIT WORK AND WAIT.
      MESSAGE s000 WITH TEXT-m01.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_row .

  REFRESH gt_rows.

  CALL METHOD gcl_grid->get_selected_rows
    IMPORTING
      et_index_rows = gt_rows.

  IF gt_rows IS INITIAL.
    MESSAGE s000 WITH TEXT-e02 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

*-------------------------방법 1
  SORT gt_rows BY index DESCENDING. " 위에부터 지워지면 index가 하나씩 줄어드는 현상이 발생하기 때문에 꼭 아래서부터 지워줘야함.

  LOOP AT gt_rows INTO gs_row.

*ITAB에서 삭제하기전에 DB Table에서도 삭제해야하므로 삭제 대상을 따로 보관
    READ TABLE gt_emp INTO gs_emp INDEX gs_row-index.

    IF sy-subrc = 0.
      APPEND gs_emp TO gt_emp_del.
    ENDIF.

    DELETE gt_emp INDEX gs_row-index. " 사용자가 선택한 행을 직접 삭제

  ENDLOOP.

*--------------------------방법 2

*  LOOP AT gt_rows INTO gs_row.
*
*    READ TABLE gt_emp INTO gs_emp INDEX gs_row-index.
*
*    IF sy-subrc EQ 0.
*      gs_emp-mark = 'X'.
*
*      MODIFY gt_emp FROM gs_emp INDEX gs_row-index
*      TRANSPORTING mark.
*    ENDIF.
*
*  ENDLOOP.
*
*  DELETE gt_emp WHERE mark IS NOT INITIAL.

  PERFORM refresh_grid. " 변경된 ITAB을 ALV에 반영

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_style_table .

*  TABLE로 직접 값을 넣어주는 경우

  DATA: lv_tabix TYPE sy-tabix,
        ls_style TYPE lvc_s_styl,
        lt_style TYPE lvc_t_styl.

  lt_style = VALUE #(
                      (
                       fieldname = 'PERNR'
                       style     = cl_gui_alv_grid=>mc_style_disabled
                      )
                     ).

*  DB에서 가지고온 데이터의 PK는 변경 방지를 위해서 편집 금지모드로.
  LOOP AT gt_emp INTO gs_emp.
    lv_tabix = sy-tabix.

    REFRESH gs_emp-style. " Table type의 필드기 때문에

*    APPEND LINES OF lt_style TO gs_emp-style.
*    gt_emp-style = lt_style.
    MOVE-CORRESPONDING lt_style TO gs_emp-style.

    MODIFY gt_emp FROM gs_emp INDEX lv_tabix
    TRANSPORTING style.

  ENDLOOP.

ENDFORM.

FORM set_style .

  DATA: lv_tabix TYPE sy-tabix,
        ls_style TYPE lvc_s_styl.

  ls_style-fieldname = 'PERNR'.
  ls_style-style     = cl_gui_alv_grid=>mc_style_disabled. " 변경 불가능.

*  DB에서 가지고온 데이터의 PK는 변경 방지를 위해서 편집 금지모드로.
  LOOP AT gt_emp INTO gs_emp.
    lv_tabix = sy-tabix.

    REFRESH gs_emp-style. " Table type의 필드기 때문에

    APPEND ls_style TO gs_emp-style.

    MODIFY gt_emp FROM gs_emp INDEX lv_tabix
    TRANSPORTING style.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_data_changed
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM handle_data_changed  USING pcl_data_changed TYPE REF TO
                                cl_alv_changed_data_protocol.

*  LOOP AT pcl_data_changed->mt_mod_cells INTO DATA(ls_modi).
*
*    READ TABLE gt_emp INTO gs_emp INDEX ls_modi-row_id.
*
*    IF sy-subrc <> 0.
*      CONTINUE.
*    ENDIF.
*
*    SELECT SINGLE carrname
*      INTO gs_emp-carrname
*      FROM scarr
*      WHERE carrid = gs_emp-carrid.
*
*    IF sy-subrc NE 0.
*      CLEAR gs_emp-carrname.
*    ENDIF.
*
*    MODIFY gt_emp FROM gs_emp INDEX ls_modi-row_id
*    TRANSPORTING carrname.
*
*  ENDLOOP.
*
*  PERFORM refresh_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_change_finished
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_MODIFIED
*&      --> ET_GOOD_CELLS
*&---------------------------------------------------------------------*
FORM handle_change_finished  USING pv_modified
                                   pt_good_cells TYPE lvc_t_modi.

  LOOP AT pt_good_cells INTO DATA(ls_modi).

    READ TABLE gt_emp INTO gs_emp INDEX ls_modi-row_id.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    SELECT SINGLE carrname
      INTO gs_emp-carrname
      FROM scarr
      WHERE carrid = gs_emp-carrid.

    IF sy-subrc NE 0.
      CLEAR gs_emp-carrname.
    ENDIF.

    MODIFY gt_emp FROM gs_emp INDEX ls_modi-row_id
    TRANSPORTING carrname.

  ENDLOOP.

  PERFORM refresh_grid.

ENDFORM.
