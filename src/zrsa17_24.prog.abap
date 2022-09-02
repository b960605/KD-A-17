*&---------------------------------------------------------------------*
*& Report ZRSA17_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_24_top                           .    " Global Data

* INCLUDE ZRSA17_24_O01                           .  " PBO-Modules
* INCLUDE ZRSA17_24_I01                           .  " PAI-Modules
INCLUDE zrsa17_24_f01                           .  " FORM-Routines

"Event - event들은 다른 이벤트가 시작되면 자동으로 종료.

*LOAD-OF-PROGRAM. -> INITIALIZATION과 기능이 같음. Runtime에 한 번만 실행됨. (Type 1이 아닌 경우에 사용. ex . Module Pool ...

INITIALIZATION. "Runtime에 딱 한번 실행되는 Event (Type가 1일 때만 사용 - Executable Program에서만 사용 가능.
*  SELECT SINGLE carrid connid
*    FROM spfli
*    INTO (pa_car, pa_con).
  IF sy-uname = 'KD-A-17'.
    pa_car = 'AA'.
    pa_con = '0017'.
  ENDIF.

AT SELECTION-SCREEN OUTPUT. "PBO process before output (A-S-S-O)


AT SELECTION-SCREEN. "PAI process after input   "e나 w를 사용
  IF pa_con IS INITIAL.
    MESSAGE w016(pn) WITH 'Check'. "e를 쓰면 이 이후로 진행을 막음. w는 약한 경고(주황색)-한 번 더 시도하면 진행.

*    STOP을 통해서 팝업 후에 멈추게 해줄 수 있음.
*    MESSAGE i016(pn) WITH 'Check'.
*    STOP.
  ENDIF.

START-OF-SELECTION. "i나 s를 사용
  PERFORM get_info.
  WRITE 'text'.
*  if gt_info is not initial.
*    cl_demo_output=>display_data( gt_info ).
*  else.
*  endif.

  IF gt_info IS INITIAL.
    "S, I, E, W, A, X
    MESSAGE i016(pn) WITH 'Data is not found.'. "information message 띄움
*    MESSAGE s016(pn) WITH 'Data is not found.'. 다음화면에 상태 출력
*    MESSAGE e016(pn) WITH 'Data is not found.'. 에러(닫아버림)
*    MESSAGE a016(pn) WITH 'Data is not found.'. 중요한 오류기 때문에 처음부터 다시하라고 닫아버리는 방향을 유도
*    MESSAGE x016(pn) WITH 'Data is not found.'. 숏덤프 띄워버림
    RETURN. "해당 블럭을 빠져나감 여기서는 START-OF-SELECTION 을 빠져나감. Event같은 경우에는 빠져나가서 AT SELECTION-SCREEN을 탐.
  ELSE.
  ENDIF.
  cl_demo_output=>display_data( gt_info ).

*  subroutine으로 Get Info들을 바꿔주고, Loop에서 SELECT를 사용하지 않고 Internal Table에 얼마안되는 정보를 담아서 Read Table을 이용해보자.
