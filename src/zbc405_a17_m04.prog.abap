*&---------------------------------------------------------------------*
*& Report ZBC405_A17_M04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc405_a17_m04top                       .    " Global Data

INCLUDE zbc405_a17_m04o01                       .  " PBO-Modules
INCLUDE zbc405_a17_m04i01                       .  " PAI-Modules
INCLUDE zbc405_a17_m04f01                       .  " FORM-Routines

INITIALIZATION.
  gv_text = '버튼'.
  gv_chg = '1'.

  tab1 = 'Car Info'.
  tab2 = 'Flight Date'.

  so_fld-low+0(4) = sy-datum+0(4) - 2.
  so_fld-low+4 = sy-datum+4.
  so_fld-high+0(4) = sy-datum+0(4).
  so_fld-high+4 = '1231'.
  APPEND so_fld.

  ts_info-activetab = 'FLD'.
  ts_info-dynnr = '1200'.
  "PBO

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GR1'.
        screen-active = gv_chg.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.

  " PAI

AT SELECTION-SCREEN.
  CHECK sy-dynnr = '1000'.
  CASE sscrfields-ucomm.
    WHEN 'ON'.
      IF gv_chg = '0'.
        gv_chg = '1'.
      ELSE.
        gv_chg = '0'.
      ENDIF.
  ENDCASE.
