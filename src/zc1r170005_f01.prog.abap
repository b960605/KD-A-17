*&---------------------------------------------------------------------*
*& Include          ZC1R170005_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_flight_list
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_flight_list .

  _clear gs_list gt_list.

  SELECT carrid connid fldate price
         currency planetype paymentsum
    INTO CORRESPONDING FIELDS OF TABLE gt_list
    FROM  sflight
    WHERE carrid IN so_carr.

  IF sy-subrc NE 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layo .

  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING:
          'X' 'CARRID'       ' ' 'SFLIGHT' 'CARRID',
          'X' 'CONNID'       ' ' 'SFLIGHT' 'CONNID',
          'X' 'FLDATE'       ' ' 'SFLIGHT' 'FLDATE',
          ' ' 'CARRNAME'     ' ' 'SCARR'   'CARRNAME',
          ' ' 'PRICE'        ' ' 'SFLIGHT' 'PRICE',
          ' ' 'CURRENCY'     ' ' 'SFLIGHT' 'CURRENCY',
          ' ' 'PLANETYPE'    ' ' 'SFLIGHT' 'PLANETYPE',
          ' ' 'PAYMENTSUM'   ' ' 'SFLIGHT' 'PAYMENTSUM'.

    IF gt_sort IS INITIAL.

      PERFORM set_sort.

    ENDIF.

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
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #( key       = pv_key
                     fieldname = pv_field
                     coltext   = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'PRICE'.
      gs_fcat = VALUE #( BASE gs_fcat
                         cfieldname = 'CURRENCY'
                         do_sum     = 'X' ).
    WHEN 'PAYMENTSUM'.
      gs_fcat = VALUE #( BASE gs_fcat
                         cfieldname = 'CURRENCY' ).
  ENDCASE.

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

    SET HANDLER : lcl_event_handler=>handle_double_click FOR gcl_grid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_list
        it_fieldcatalog = gt_fcat
        it_sort         = gt_sort.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM handle_double_click USING ps_row    TYPE lvc_s_row
                               ps_column TYPE lvc_s_col.

  READ TABLE gt_list INTO gs_list INDEX ps_row-index.

  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  CASE ps_column-fieldname.
    WHEN 'CARRID'.
      IF gs_list-carrid IS INITIAL.
        EXIT.
      ENDIF.

      PERFORM get_airline_info USING gs_list-carrid.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_LIST_CARRID
*&---------------------------------------------------------------------*
FORM get_airline_info  USING pv_carrid TYPE scarr-carrid.

  _clear gs_scarr gt_scarr.

  SELECT  carrid carrname currcode url
    FROM  scarr
    INTO CORRESPONDING FIELDS OF TABLE gt_scarr
    WHERE carrid = pv_carrid.

  IF sy-subrc <> 0.
    MESSAGE s000 WITH TEXT-t02.
    EXIT. " STOP 쓰지 말 것.
  ENDIF.

  CALL SCREEN '0101' STARTING AT 20 3. " 팝업이 나오는 좌표를 지정.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layo_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layo_pop .

  gs_layout_pop-zebra      = 'X'.
  gs_layout_pop-cwidth_opt = 'X'.
  gs_layout_pop-sel_mode   = 'D'.
  gs_layout_pop-no_toolbar = 'X'.

  IF gt_fcat_pop IS INITIAL.

    PERFORM set_fcat_pop USING :
          'X'  'CARRID'    ' '    'SCARR'  'CARRID',
          ' '  'CARRNAME'  ' '    'SCARR'  'CARRNAME',
          ' '  'CURRCODE'  ' '    'SCARR'  'CURRCODE',
          ' '  'URL'       ' '    'SCARR'  'URL'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat_pop  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gt_fcat_pop = VALUE #( BASE gt_fcat_pop
                        (
                          key       = pv_key
                          fieldname = pv_field
                          coltext   = pv_text
                          ref_table = pv_ref_table
                          ref_field = pv_ref_field
                         )
                        ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen_pop .

  IF gcl_container_pop IS INITIAL.

    CREATE OBJECT gcl_container_pop
      EXPORTING
        container_name = 'GCL_CONTAINER_POP'.

    CREATE OBJECT gcl_grid_pop
      EXPORTING
        i_parent = gcl_container_pop.

    CALL METHOD gcl_grid_pop->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop
      CHANGING
        it_outtab       = gt_scarr
        it_fieldcatalog = gt_fcat_pop.

  ENDIF.

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

  gt_sort = VALUE #(
                    (
                      spos      = 1   " sort 순서
                      fieldname = 'CARRID' " 이름 알파벳 순서로 넣어줘야함.
                      up        = 'X' " Ascending
                      subtot    = 'X'
                    )
                    (
                      spos      = 2
                      fieldname = 'CONNID'
                      up        = 'X'
                    )
                   ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_carrname
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_carrname .

  DATA: lv_tabix TYPE sy-tabix,
        lt_scarr TYPE zc1tt17001,
        ls_scarr LIKE LINE OF lt_scarr,
        lv_code,
        lv_msg   TYPE char100.

  IF gcl_scarr IS INITIAL.
    CREATE OBJECT gcl_scarr.
  ENDIF.

  LOOP AT gt_list INTO gs_list.
    lv_tabix = sy-tabix.

    CLEAR: lv_code, lv_msg.
    _clear ls_scarr lt_scarr.
*    gcl_scarr->get_airline_info( )
    CALL METHOD gcl_scarr->get_airline_info
      EXPORTING
        pi_carrid  = gs_list-carrid
      IMPORTING
        pe_code    = lv_code
        pe_msg     = lv_msg
      CHANGING
        et_airline = lt_scarr.

    IF lv_code = 'S'.
      READ TABLE lt_scarr INTO ls_scarr WITH KEY carrid = gs_list-carrid.

      IF ls_scarr IS NOT INITIAL.
        gs_list-carrname = ls_scarr-carrname.

        MODIFY gt_list FROM gs_list INDEX lv_tabix
        TRANSPORTING carrname.
      ENDIF.

    ENDIF.

  ENDLOOP.


ENDFORM.
