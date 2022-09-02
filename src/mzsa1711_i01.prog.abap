*&---------------------------------------------------------------------*
*& Include          MZSA1710_I01
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
    WHEN 'ENTER'.
    WHEN 'SEARCH'.
      " Get Connection Info
      PERFORM get_conn_info USING zssa1780-carrid
                                  zssa1780-connid
                            CHANGING zssa1782
                                     gv_subrc.
      IF gv_subrc <> 0.
        MESSAGE i016(pn) WITH 'No Data'.
        RETURN.
      ENDIF.

      " Get Airline Info
      PERFORM get_airlline_info.
*      IF zssa1782 IS NOT INITIAL.
*        " Get Airline Info
*        PERFORM get_airlline_info.
*      ELSE.
*        CLEAR zssa1781.
*        MESSAGE i016(pn) WITH 'No Data'.
*      ENDIF.

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
