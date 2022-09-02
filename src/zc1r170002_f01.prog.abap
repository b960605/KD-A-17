*&---------------------------------------------------------------------*
*& Include          ZC1R170002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_param
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_param .

  pa_werks = '1010'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT  a~matnr a~mtart a~matkl a~meins
          a~tragr b~pstat b~dismm b~ekgrp
    FROM       mara AS a
    INNER JOIN marc AS b
    ON    a~matnr = b~matnr
    INTO CORRESPONDING FIELDS OF TABLE gt_mar
    WHERE b~werks  = pa_werks
    AND   a~matnr IN so_matnr
    AND   a~mtart IN so_mtart
    AND   b~ekgrp IN so_ekgrp.

  IF sy-subrc <> 0.

    MESSAGE s001.
    LEAVE LIST-PROCESSING.

  ENDIF.

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

    CREATE OBJECT gcl_alv
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_alv->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_mar
        it_fieldcatalog = gt_fcat.

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

  PERFORM set_fcat USING:

        'X' 'MATNR' ' ' 'MARA' 'MATNR',
        ' ' 'MTART' ' ' 'MARA' 'MTART',
        ' ' 'MATKL' ' ' 'MARA' 'MATKL',
        ' ' 'MEINS' ' ' 'MARA' 'MEINS',
        ' ' 'TRAGR' ' ' 'MARA' 'TRAGR',
        ' ' 'PSTAT' ' ' 'MARC' 'PSTAT',
        ' ' 'MATNR' ' ' 'MARC' 'DISMM',
        ' ' 'MATNR' ' ' 'MARC' 'EKGRP'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat USING p_key p_field p_text p_ref_table p_ref_field.

  gs_fcat = VALUE #( key       = p_key
                     fieldname = p_field
                     coltext   = p_text
                     ref_table = p_ref_table
                     ref_field = p_ref_field ).

  APPEND gs_fcat TO gt_fcat.


ENDFORM.
