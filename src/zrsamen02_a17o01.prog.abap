*&---------------------------------------------------------------------*
*& Include          ZRSAMEN02_A17O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
  IF go_container_1 IS INITIAL.
    CREATE OBJECT go_container_1
      EXPORTING
        container_name = 'CON_FLT'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv_grid_1
      EXPORTING
        i_parent = go_container_1
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    SET HANDLER lcl_handler=>on_dbclick FOR go_alv_grid_1.
    SET HANDLER lcl_handler=>on_ctmenu FOR go_alv_grid_1.
    SET HANDLER lcl_handler=>on_ucomm FOR go_alv_grid_1.
    SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid_1.

    CALL METHOD go_alv_grid_1->set_table_for_first_display
      EXPORTING
*       i_buffer_active  =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name = 'SFLIGHT'
*       is_variant       =
*       i_save           =
*       i_default        = 'X'
        is_layout        = gs_flay
*       is_print         =
*       it_special_groups             =
*       it_toolbar_excluding          =
*       it_hyperlink     =
*       it_alv_graphics  =
*       it_except_qinfo  =
*       ir_salv_adapter  =
      CHANGING
        it_outtab        = gt_finfo
        it_fieldcatalog  = gt_ffcat
*       it_sort          =
*       it_filter        =
      EXCEPTIONS
*       invalid_parameter_combination = 1
*       program_error    = 2
*       too_many_lines   = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CREATE OBJECT go_container_2
      EXPORTING
        container_name = 'CON_FLT_DET'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv_grid_2
      EXPORTING
        i_parent = go_container_2
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL METHOD go_alv_grid_2->set_table_for_first_display
      EXPORTING
*       i_buffer_active      =
*       i_bypassing_buffer   =
*       i_consistency_check  =
        i_structure_name     = 'SFLIGHT'
*       is_variant           =
*       i_save               =
*       i_default            = 'X'
        is_layout            = gs_slay
*       is_print             =
*       it_special_groups    =
        it_toolbar_excluding = gt_sexc
*       it_hyperlink         =
*       it_alv_graphics      =
*       it_except_qinfo      =
*       ir_salv_adapter      =
      CHANGING
        it_outtab            = gt_sinfo
        it_fieldcatalog      = gt_sfcat
*       it_sort              =
*       it_filter            =
      EXCEPTIONS
*       invalid_parameter_combination = 1
*       program_error        = 2
*       too_many_lines       = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDMODULE.
