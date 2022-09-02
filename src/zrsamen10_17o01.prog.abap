*&---------------------------------------------------------------------*
*& Include          ZRSAMEN10_17O01
*&---------------------------------------------------------------------*
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
*& Module DROP_DOWN_LIST OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE drop_down_list OUTPUT.
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'ZVERST17-VERSN'
      values = gt_values
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_object OUTPUT.
  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_container.

    PERFORM set_fcat.

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        i_structure_name = 'ZVRMAT17'
*       is_variant       =
*       i_save           =
*       i_default        = 'X'
        is_layout        = gs_layo
      CHANGING
        it_outtab        = gt_vrmat
        it_fieldcatalog  = gt_fcat.
*       it_sort          =
*       it_filter        =

  else.

    CALL METHOD go_alv->refresh_table_display.

  ENDIF.

ENDMODULE.
