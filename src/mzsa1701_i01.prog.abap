*&---------------------------------------------------------------------*
*& Include          MZSA1701_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm. " User Command
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0. "Screen0로 가라. - 이전 화면으로 간다. 여기서는 더이상 갈 Screen이 없기 때문에 프로그램 종료와 같은 기능을 함.
*      SET SCREEN 0.
*      LEAVE SCREEN.
    WHEN 'EXIT'.
      LEAVE PROGRAM. "Program을 종료
    WHEN 'SEARCH'.
      "Get Data
      PERFORM get_data USING gv_pno
                       CHANGING zssa0031.

  ENDCASE.
ENDMODULE.
