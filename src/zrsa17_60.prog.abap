*&---------------------------------------------------------------------*
*& Report ZRSA17_60
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_60_top                           .    " Global Data

INCLUDE zrsa17_60_o01                           .  " PBO-Modules
INCLUDE zrsa17_60_i01                           .  " PAI-Modules
INCLUDE zrsa17_60_f01                           .  " FORM-Routines

INITIALIZATION. "ABAP은 절차적이지만 Event는 정해진 순서대로 실행됨.
  "기본값 설정
  PERFORM set_init.

AT SELECTION-SCREEN OUTPUT. "PBO
  MESSAGE s000(zmcsa17) WITH 'PBO'.

AT SELECTION-SCREEN. "PAI

START-OF-SELECTION.
  SELECT SINGLE *
    FROM sflight "같은 것에 넣으면 INTO를 생략해도 됨.
*    INTO sflight
    WHERE carrid = pa_car
    AND connid = pa_con
  AND fldate IN so_dat. "여러 조건이 들어갈 수도 있으니 Internal Table로 쓰임 - 대괄호가 생략된 형태.

  CALL SCREEN 100.
    MESSAGE s000(zmcsa17) WITH 'After Call Screen'.
