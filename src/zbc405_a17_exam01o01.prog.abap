*&---------------------------------------------------------------------*
*& Include          ZBC405_A17_EXAM01O01
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

  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    IF sy-subrc = 0.
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container
        EXCEPTIONS
          OTHERS   = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
    IF sy-subrc = 0.

      PERFORM set_layo.
      PERFORM set_fcat.
      PERFORM set_excl.


      SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid.
      SET HANDLER lcl_handler=>on_ucomm FOR go_alv_grid.
      SET HANDLER lcl_handler=>on_dbclick FOR go_alv_grid.
      SET HANDLER lcl_handler=>on_data_changed FOR go_alv_grid.
      SET HANDLER lcl_handler=>on_data_changed_finished FOR go_alv_grid.

      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
*         i_buffer_active      =
*         i_bypassing_buffer   =
*         i_consistency_check  =
          i_structure_name     = 'ZTSPFLI_A17'
          is_variant           = gs_vari
          i_save               = 'A'
          i_default            = 'X'
          is_layout            = gs_layout
*         is_print             =
*         it_special_groups    =
          it_toolbar_excluding = gt_excl
*         it_hyperlink         =
*         it_alv_graphics      =
*         it_except_qinfo      =
*         ir_salv_adapter      =
        CHANGING
          it_outtab            = gt_spfli
          it_fieldcatalog      = gt_fcat
*         it_sort              =
*         it_filter            =
*    EXCEPTIONS
*         invalid_parameter_combination = 1
*         program_error        = 2
*         too_many_lines       = 3
*         others               = 4
        .
      IF sy-subrc <> 0.
*   Implement suitable error handling here
      ENDIF.
*
      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified. " mc_evt_enter (alv_grid의 attribute)
      IF sy-subrc <> 0.
*         Implement suitable error handling here
      ENDIF.
    ENDIF.
  ELSE.
    CALL METHOD go_alv_grid->refresh_table_display.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'S200'.
  SET TITLEBAR 'T200' WITH sy-datum sy-uname.
ENDMODULE.
