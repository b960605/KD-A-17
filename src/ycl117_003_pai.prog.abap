*&---------------------------------------------------------------------*
*& Include          YCL117_002_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  SAVE_OK = OK_CODE.
  CLEAR OK_CODE.

  CASE SAVE_OK.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
      OK_CODE = SAVE_OK.
  ENDCASE.

  CLEAR SAVE_OK.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  SAVE_OK = OK_CODE.
  CLEAR OK_CODE.

  CASE SAVE_OK.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      PERFORM SELECT_DATA.
    WHEN OTHERS.
      OK_CODE = SAVE_OK.
  ENDCASE.

  CLEAR SAVE_OK.

ENDMODULE.
