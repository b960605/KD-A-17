*&---------------------------------------------------------------------*
*& Include          MZSA1719_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.

    WHEN 'SEARCH'.
      CLEAR: gv_r1, gv_r2, gv_r3.
      PERFORM get_emp_info USING zssa1734-pernr
                                 zssa1735-gender
                           CHANGING zssa1735
                                    gv_r1
                                    gv_r2
                                    gv_r3.
      PERFORM get_dep_info USING zssa1735-depnr
                           CHANGING zssa1736
                                    sy-langu.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
