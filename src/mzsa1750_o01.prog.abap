*&---------------------------------------------------------------------*
*& Include          MZSA1750_O01
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
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.
  IF gv_r1 = 'X'.

    LOOP AT SCREEN.
      CASE screen-name.
        WHEN 'ZSSA1750-MEALNO'.
          screen-input = 1.
        WHEN 'ZSSA1750-CARRID'.
          screen-input = 1.
        WHEN 'ZSSA1750-LIFNR'.
          screen-input = 0.
      ENDCASE.
      MODIFY SCREEN.
      CLEAR screen.
    ENDLOOP.
  ELSEIF gv_r2 = 'X'.
    LOOP AT SCREEN.
      CASE screen-name.
        WHEN 'ZSSA1750-MEALNO'.
          screen-input = 0.
        WHEN 'ZSSA1750-CARRID'.
          screen-input = 0.
        WHEN 'ZSSA1750-LIFNR'.
          screen-input = 1.
      ENDCASE.
      MODIFY SCREEN.
      CLEAR screen.
    ENDLOOP.
  ENDIF.
ENDMODULE.
