*&---------------------------------------------------------------------*
*& Include          MZSA1705_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
*  MESSAGE i016(pn) WITH sy-ucomm.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'ENTER'.
      " Get emp name
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.
    WHEN 'SEARCH'.
      " Get emp name
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.
      " Get Employee Info
      PERFORM get_emp_info USING zssa0073-pernr
                           CHANGING zssa0070.
    WHEN 'DEP'. "Popup
      SELECT SINGLE *
        FROM ztsa0002
        INTO CORRESPONDING FIELDS OF zssa0071
        WHERE depid = zssa0070-depid.
      CALL SCREEN 0101 STARTING AT 10 10. " starting at 은 팝업이 나타나는 위치.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  CASE sy-ucomm.
    WHEN 'CLOSE'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
