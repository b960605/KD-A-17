*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_A17_02O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF pa_edit = 'X'.
    SET PF-STATUS 'S100'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
  ENDIF.
  SET TITLEBAR 'T100' WITH sy-datum sy-uzeit sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT_100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object_100 OUTPUT.
  IF go_container_100 IS INITIAL.
    " container
    CREATE OBJECT go_container_100
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    IF sy-subrc = 0.
      " ALV
      CREATE OBJECT go_alv_100
        EXPORTING
          i_parent = go_container_100
        EXCEPTIONS
          OTHERS   = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      IF sy-subrc = 0.
        " Layouts
        PERFORM set_layout.
        " Sort
        PERFORM set_sort.
        " Exclude toolbar
        PERFORM set_excl.
        " Field Catalog
        PERFORM set_fcat.

        gs_vari-variant = pa_layo.

        SET HANDLER lcl_handler=>on_dbclick FOR go_alv_100.
        SET HANDLER lcl_handler=>on_toolbar FOR go_alv_100.
        SET HANDLER lcl_handler=>on_ucomm FOR go_alv_100.
        SET HANDLER lcl_handler=>on_data_changed FOR go_alv_100.
        SET HANDLER lcl_handler=>on_data_changed_finished FOR go_alv_100.

        CALL METHOD go_alv_100->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSBOOK_A17'
            is_variant           = gs_vari
            i_save               = 'A'
            i_default            = 'X'
            is_layout            = gs_layo
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_excl
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_sbook
            it_fieldcatalog      = gt_fcat
            it_sort              = gt_sort
*           it_filter            =
*      EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*     Implement suitable error handling here
        ENDIF.

*       ALV 상의 변경이 발생하면 알려주는 method 필요
        CALL METHOD go_alv_100->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified. " mc_evt_enter (alv_grid의 attribute)
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
*-- refresh alv method
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
    gv_soft_refresh = 'X'.
    CALL METHOD go_alv_100->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        others         = 2
            .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
*
  ENDIF.
ENDMODULE.
