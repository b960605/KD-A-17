*&---------------------------------------------------------------------*
*& Include          ZC1R170006_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_flight_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_flight_info .

  SELECT a~carrid    a~carrname b~connid   b~fldate
         b~planetype b~price    b~currency a~url
    FROM       scarr   AS a
    INNER JOIN sflight AS b
     ON a~carrid = b~carrid
    INTO CORRESPONDING FIELDS OF TABLE gt_list
    WHERE a~carrid    IN so_carr
    AND   b~connid    IN so_conn
    AND   b~planetype IN so_ptyp.

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

  gs_layo-zebra      = 'X'.
  gs_layo-cwidth_opt = 'X'.
  gs_layo-sel_mode   = 'D'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING:
          'X' 'CARRID'    ' ' 'SCARR'   'CARRID',
          ' ' 'CARRNAME'  ' ' 'SCARR'   'CARRNAME',
          ' ' 'CONNID'    ' ' 'SFLIGHT' 'CONNID',
          ' ' 'FLDATE'    ' ' 'SFLIGHT' 'FLDATE',
          ' ' 'PLANETYPE' ' ' 'SFLIGHT' 'PLANETYPE',
          ' ' 'PRICE'     ' ' 'SFLIGHT' 'PRICE',
          ' ' 'CURRENCY'  ' ' 'SFLIGHT' 'CURRENCY',
          ' ' 'URL'       ' ' 'SCARR'   'URL'.
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

  gs_fcat = VALUE #( key = pv_key
                     fieldname = pv_field
                     coltext = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'PRICE'.
      gs_fcat = VALUE #( BASE gs_fcat
                         cfieldname = 'CURRENCY' ).
    WHEN 'PLANETYPE'.
      gs_fcat = VALUE #( BASE gs_fcat
                hotspot = 'X' ).
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

    SET HANDLER : lcl_event_handler=>handle_hotspot FOR gcl_grid,
                  lcl_event_handler=>handle_double_click FOR gcl_grid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layo
      CHANGING
        it_outtab       = gt_list
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING ps_row TYPE lvc_s_roid
                           ps_col TYPE lvc_s_col.
  CLEAR gs_list.
  _clear gt_plane.

  CASE ps_col-fieldname.
    WHEN 'PLANETYPE'.
      READ TABLE gt_list INTO gs_list INDEX ps_row-row_id.

      SELECT planetype seatsmax tankcap
             cap_unit  weight   wei_unit producer
        FROM saplane
        INTO CORRESPONDING FIELDS OF TABLE gt_plane
        WHERE planetype = gs_list-planetype.

      IF sy-subrc <> 0.
        MESSAGE s001.
        EXIT.
      ENDIF.

      CALL SCREEN '0101' STARTING AT 20 3.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layo_p_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layo_pop USING ps_layo TYPE lvc_s_layo.

  ps_layo-zebra      = 'X'.
  ps_layo-cwidth_opt = 'X'.
  ps_layo-sel_mode   = 'D'.
  ps_layo-no_toolbar = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_p_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat_p_pop  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat_p_pop = VALUE #( key       = pv_key
                           fieldname = pv_field
                           coltext   = pv_text
                           ref_table = pv_ref_table
                           ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'TANKCAP'.
      gs_fcat_p_pop = VALUE #( BASE gs_fcat
                               qfieldname = 'CAP_UNIT' ).
    WHEN 'WEIGHT'.
      gs_fcat_p_pop = VALUE #( BASE gs_fcat
                               qfieldname = 'WEI_UNIT' ).
  ENDCASE.

  APPEND gs_fcat_p_pop TO gt_fcat_p_pop.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen_p_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen_p_pop.
  IF gcl_container_p_pop IS INITIAL.
    CREATE OBJECT gcl_container_p_pop
      EXPORTING
        container_name = 'GCL_CONTAINER_P_POP'.

    CREATE OBJECT gcl_grid_p_pop
      EXPORTING
        i_parent = gcl_container_p_pop.

    CALL METHOD gcl_grid_p_pop->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layo_p_pop
      CHANGING
        it_outtab       = gt_plane
        it_fieldcatalog = gt_fcat_p_pop.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_COLUMN
*&      --> E_ROW
*&---------------------------------------------------------------------*
FORM handle_double_click  USING ps_column TYPE lvc_s_col
                                ps_row   TYPE lvc_s_row.

  IF ps_column-fieldname NE 'PLANETYPE'.

    CLEAR gs_list.

    READ TABLE gt_list INTO gs_list INDEX ps_row-index.

    IF sy-subrc <> 0.
      MESSAGE s001.
      EXIT.
    ENDIF.

    SELECT carrid connid fldate bookid
           customid custtype smoker
      FROM sbook
      INTO CORRESPONDING FIELDS OF TABLE gt_sbook
      WHERE carrid = gs_list-carrid
      AND   connid = gs_list-connid
      AND   fldate = gs_list-fldate.

    IF sy-subrc <> 0.
      MESSAGE s001.
      EXIT.
    ENDIF.

    CALL SCREEN '0102' STARTING AT 20 3.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_b_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_b_pop USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat_b_pop = VALUE #( key       = pv_key
                           fieldname = pv_field
                           coltext   = pv_text
                           ref_table = pv_ref_table
                           ref_field = pv_ref_field ).

  APPEND gs_fcat_b_pop TO gt_fcat_b_pop.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen_b_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen_b_pop .

  IF gcl_container_b_pop IS INITIAL.
    CREATE OBJECT gcl_container_b_pop
      EXPORTING
        container_name = 'GCL_CONTAINER_B_POP'.

    CREATE OBJECT gcl_grid_b_pop
      EXPORTING
        i_parent = gcl_container_b_pop.

    CALL METHOD gcl_grid_b_pop->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layo_b_pop
      CHANGING
        it_outtab       = gt_sbook
        it_fieldcatalog = gt_fcat_b_pop.
  ENDIF.

ENDFORM.
