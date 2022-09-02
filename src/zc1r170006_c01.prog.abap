*&---------------------------------------------------------------------*
*& Include          ZC1R170006_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.

  PUBLIC SECTION.

    CLASS-METHODS:
      handle_hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_column_id
          es_row_no,
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_column
          e_row.
ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_hotspot.

    PERFORM handle_hotspot USING es_row_no e_column_id.

  ENDMETHOD.

  METHOD handle_double_click.

    PERFORM handle_double_click USING e_column e_row.

  ENDMETHOD.

ENDCLASS.
