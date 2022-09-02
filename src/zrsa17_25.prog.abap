*&---------------------------------------------------------------------*
*& Report ZRSA17_25
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_25_top                           .    " Global Data

* INCLUDE ZRSA17_25_O01                           .  " PBO-Modules
* INCLUDE ZRSA17_25_I01                           .  " PAI-Modules
INCLUDE zrsa17_25_f01                           .  " FORM-Routines

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_list
    WHERE carrid = pa_car
      AND connid BETWEEN pa_con1 AND pa_con2.

  SELECT carrid carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF TABLE gt_scarr.
  READ TABLE gt_scarr WITH KEY carrid = pa_car
    INTO gs_scarr.

  SELECT carrid connid cityfrom cityto
    FROM spfli
    INTO CORRESPONDING FIELDS OF TABLE gt_spfli
    WHERE carrid = pa_car
    AND connid BETWEEN pa_con1 AND pa_con2.





  LOOP AT gt_list INTO gs_list.
    "get carrname
    gs_list-carrname = gs_scarr-carrname.
    "get city info
    READ TABLE gt_spfli WITH KEY connid = gs_list-connid
    INTO gs_spfli.
    gs_list-cityfrom = gs_spfli-cityfrom.
    gs_list-cityto = gs_spfli-cityto.

    IF gs_list-seatsocc EQ 0.
      gs_list-seatremain = 0.
      gs_list-seatremain_b = 0.
      gs_list-seatremain_f = 0.
    ELSE.
      gs_list-seatremain = gs_list-seatsmax - gs_list-seatsocc.
      gs_list-seatremain_b = gs_list-seatsmax_b - gs_list-seatsocc_b.
      gs_list-seatremain_f = gs_list-seatsmax_f - gs_list-seatsocc_f.
    ENDIF.

    MODIFY gt_list FROM gs_list.
    CLEAR gs_list.

  ENDLOOP.


*  IF gt_list IS NOT INITIAL.
*    cl_demo_output=>display_data( gt_list ).
*  ELSE.
*    MESSAGE i016(pn) WITH 'Data is not found.'.
*  ENDIF.
  IF gt_list IS INITIAL.
    "S, I, E, W, A, X
    MESSAGE i016(pn) WITH 'Data is not found.'. "information message 띄움
*    MESSAGE s016(pn) WITH 'Data is not found.'. 다음화면에 상태 출력
*    MESSAGE e016(pn) WITH 'Data is not found.'. 에러(닫아버림)
*    MESSAGE a016(pn) WITH 'Data is not found.'. 중요한 오류기 때문에 처음부터 다시하라고 닫아버리는 방향을 유도
*    MESSAGE x016(pn) WITH 'Data is not found.'. 숏덤프 띄워버림
    RETURN. "해당 블럭을 빠져나감 여기서는 START-OF-SELECTION 을 빠져나감. Event같은 경우에는 빠져나가서 AT SELECTION-SCREEN을 탐.
  ELSE.
    cl_demo_output=>display_data( gt_list ).
  ENDIF.
