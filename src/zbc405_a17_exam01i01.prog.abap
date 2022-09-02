*&---------------------------------------------------------------------*
*& Include          ZBC405_A17_EXAM01I01
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
    WHEN 'SAVE'.
      DATA: lv_ans TYPE c LENGTH 1.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Data Save'
          text_question         = 'Do you want to save in DB?'
          text_button_1         = 'YES'(001)
          text_button_2         = 'NO'(002)
          display_cancel_button = ' '
        IMPORTING
          answer                = lv_ans
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF lv_ans = '1'.

        LOOP AT gt_spfli INTO gs_spfli WHERE modified = 'X'.
          UPDATE ztspfli_a17
          SET fltime = gs_spfli-fltime
              deptime = gs_spfli-deptime
              arrtime = gs_spfli-arrtime
              period = gs_spfli-period
          WHERE carrid = gs_spfli-carrid
          AND   connid = gs_spfli-connid.
          CLEAR gs_spfli.
        ENDLOOP.
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
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Leave Screen'
          text_question         = 'Do you want to leave screen?'
          text_button_1         = 'YES'(001)
          text_button_2         = 'NO'(002)
          display_cancel_button = ' '
        IMPORTING
          answer                = lv_ans
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF lv_ans = '1'.
        LEAVE PROGRAM.
      ENDIF.
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
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_SEL_OPT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_sel_opt INPUT.

  IF ztspfli_a17-carrid IS NOT INITIAL.
    gs_so_car-low = ztspfli_a17-carrid.
    gs_so_car-sign = 'I'.
    gs_so_car-option = 'EQ'.
    APPEND gs_so_car TO gt_so_car.
    CLEAR gs_so_car.
  ELSE.
    CLEAR: gt_so_car, gs_so_car.
  ENDIF.

  IF ztspfli_a17-connid IS NOT INITIAL.
    gs_so_con-low = ztspfli_a17-connid.
    gs_so_con-sign = 'I'.
    gs_so_con-option = 'EQ'.
    APPEND gs_so_con TO gt_so_con.
    CLEAR gs_so_con.
  ELSE.
    CLEAR: gs_so_con, gt_so_con.
  ENDIF.

  SELECT *
    FROM spfli
    INTO CORRESPONDING FIELDS OF TABLE gt_spfli
    WHERE carrid IN gt_so_car
    AND   connid IN gt_so_con.

  LOOP AT gt_spfli INTO gs_spfli.

    " IORD
    IF gs_spfli-countryfr = gs_spfli-countryto.
      gs_spfli-iord = 'D'.
    ELSE.
      gs_spfli-iord = 'I'.
    ENDIF.
    IF gs_spfli-iord = 'D'.
      gs_col-fname = 'IORD'.
      gs_col-color-col = col_total.
      gs_col-color-int = '1'.
      gs_col-color-inv = '1'.
      APPEND gs_col TO gs_spfli-gt_col.
      CLEAR gs_col.
    ELSEIF gs_spfli-iord = 'I'.
      gs_col-fname = 'IORD'.
      gs_col-color-col = col_positive.
      gs_col-color-int = '1'.
      gs_col-color-inv = '1'.
      APPEND gs_col TO gs_spfli-gt_col.
      CLEAR gs_col.
    ENDIF.

    " fltype icon
    IF gs_spfli-fltype = 'X'.
      gs_spfli-fticon = icon_ws_plane.
    ENDIF.

    " Time  zone
    READ TABLE gt_sairp INTO gs_sairp WITH KEY id = gs_spfli-airpfrom.
    gs_spfli-frtzone = gs_sairp-time_zone.
    CLEAR gs_sairp.
    READ TABLE gt_sairp INTO gs_sairp WITH KEY id = gs_spfli-airpto.
    gs_spfli-totzone = gs_sairp-time_zone.
    CLEAR gs_sairp.

    " Excp handling
    IF gs_spfli-period GE 2.
      gs_spfli-light = '1'.
    ELSEIF gs_spfli-period = 1.
      gs_spfli-light = '2'.
    ELSEIF gs_spfli-period = 0.
      gs_spfli-light = '3'.
    ENDIF.
    MODIFY gt_spfli FROM gs_spfli.
    CLEAR gs_spfli.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CREATE_DROPDOWN_BOX  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_dropdown_box INPUT.
  TYPES: BEGIN OF conn_line,
           conn TYPE spfli-connid,
         END OF conn_line.


  DATA conn_list TYPE STANDARD TABLE OF conn_line.


  SELECT connid
              FROM ztspfli_a17
              INTO TABLE conn_list
             WHERE carrid = ztspfli_a17-carrid.




  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CONNID'
      value_org       = 'S'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZTSPFLI_A17-CONNID'  " 선택한 필드의 값이 입력될 화면의 필드
    TABLES
      value_tab       = conn_list
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
ENDMODULE.
