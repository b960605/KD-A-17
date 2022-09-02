*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_A17_02I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA: lv_ans TYPE c LENGTH 1.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM' " DB에 바로 반영하기 전에 한번더 확인하는 절차
        EXPORTING
          titlebar              = 'Data Save'
          text_question         = 'Do you want to save?'
          text_button_1         = 'Yes'(001)
          text_button_2         = 'No'(002)
          display_cancel_button = ' '
        IMPORTING
          answer                = lv_ans
       EXCEPTIONS
         TEXT_NOT_FOUND        = 1
         OTHERS                = 2
        .
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF lv_ans = '1'. " YES
        PERFORM data_save.
      ENDIF.
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
