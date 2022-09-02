*&---------------------------------------------------------------------*
*& Report ZRSA17_ABAP3_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_abap3_03top                      .    " Global Data

INCLUDE zrsa17_abap3_03o01                      .  " PBO-Modules
INCLUDE zrsa17_abap3_03i01                      .  " PAI-Modules
INCLUDE zrsa17_abap3_03f01                      .  " FORM-Routines

AT SELECTION-SCREEN OUTPUT.

*  LOOP AT SCREEN.
*
*    CASE screen-name.
*      WHEN 'SO_CONT-HIGH'.
*        screen-active = '0'.
*        MODIFY SCREEN.
*    ENDCASE.
*
*  ENDLOOP.  -> SELECT-OPTIONS의 No intervals 옵션으로 제거.

START-OF-SELECTION.

  DATA lv_flinum TYPE sbuspart-buspatyp.

  CASE 'X'.
    WHEN pa_rta.
      lv_flinum = 'TA'.
    WHEN pa_rfc.
      lv_flinum = 'FC'.
  ENDCASE.

*  IF pa_rta     = 'X'.
*    lv_flinum   = 'TA'.
*  ELSEIF pa_rfc = 'X'.
*    lv_flinum   = 'FC'.
*  ENDIF.

  SELECT mandant buspartnum contact contphono buspatyp
  FROM sbuspart
  INTO CORRESPONDING FIELDS OF TABLE gt_sbus
  WHERE buspatyp   = lv_flinum
    AND buspartnum = pa_flnum
    AND contact   IN so_cont.

  IF sy-subrc <> 0.
    MESSAGE i000(zmcsa17) WITH 'No Data Found.'.
  ELSE.
    cl_demo_output=>display_data( gt_sbus ).
  ENDIF.
