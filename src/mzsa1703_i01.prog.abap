*&---------------------------------------------------------------------*
*& Include          MZSA1703_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'SEARCH'.

      CALL SCREEN 200.
      LEAVE SCREEN.
      MESSAGE i000(zmcsa17) WITH 'call'.
      PERFORM get_airline_name USING gv_carrid
                         CHANGING gv_carrname.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
*      CALL SCREEN 100.
*      SET SCREEN 100.
*
*      MESSAGE i000(zmcsa17) WITH 'TEST'.
*      LEAVE SCREEN.
*      LEAVE TO SCREEN 100. "set screen + leave screen
  ENDCASE.
ENDMODULE.
