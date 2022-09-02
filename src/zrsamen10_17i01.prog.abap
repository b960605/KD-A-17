*&---------------------------------------------------------------------*
*& Include          ZRSAMEN10_17I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SELECT'.
      DATA: lv_versn TYPE zverst17-versn.

      lv_versn = zverst17-versn.

      refresh gt_vrmat.

      LOOP AT gt_vrmat2 INTO gs_vrmat2 WHERE versn = lv_versn.
        APPEND gs_vrmat2 TO gt_vrmat.
      ENDLOOP.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
