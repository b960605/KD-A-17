*&---------------------------------------------------------------------*
*& Include          MZSA1708_I01
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
      CLEAR: gs_emp.

      SELECT SINGLE ename
        FROM ztsa1701
        INTO CORRESPONDING FIELDS OF gs_emp
        WHERE pernr = zssa1735-pernr.

    WHEN 'SEARCH'.
      SELECT SINGLE *
        FROM ztsa1701
        INTO CORRESPONDING FIELDS OF zssa1735
        WHERE pernr = zssa1735-pernr.

      CASE zssa1735-gender.
        WHEN '1'.
          gv_r2 = 'X'.
        WHEN '2'.
          gv_r3 = 'X'.
        WHEN OTHERS.
          gv_r1 = 'X'.
      ENDCASE.

      SELECT SINGLE *
        FROM ztsa1702
        INTO CORRESPONDING FIELDS OF zssa1736
        WHERE depnr = zssa1735-depnr.

      SELECT SINGLE dname
        FROM ztsa1702_t
        INTO zssa1736-dname
        WHERE depnr = zssa1735-depnr AND spras = sy-langu.

      CALL SCREEN 200.


  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
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
      LEAVE TO SCREEN 100.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_A  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_a INPUT.
  IF zssa1735-pernr+6(2) = '07' OR zssa1735-pernr+6(2) = '08'.
    MESSAGE e016(pn) WITH 'Impossible to Access'.
  ENDIF.

ENDMODULE.
