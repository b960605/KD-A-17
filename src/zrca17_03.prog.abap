*&---------------------------------------------------------------------*
*& Report ZRCA17_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca17_03.

PARAMETERS pa_car TYPE scarr-carrid. "Char 3
*PARAMETERS pa_car1 type c length 3. "진행해보면 f4, f1으로 도움을 받을 수 없음

DATA gs_info TYPE scarr. "gs - global structure variable. 변수가 여러 개로 묶여있는 경우. mandt carrid carrname ,,, 를 가지고 있는 변수.

CLEAR gs_info.
SELECT SINGLE carrid carrname
  FROM scarr
  INTO CORRESPONDING FIELDS OF gs_info "필드 앞쪽부터가 아니라 같은 필드이름을 가진 곳에 넣어줘.
*  INTO gs_info "앞쪽부터 넣어줘.
  WHERE carrid = pa_car.

IF sy-subrc = 0.
  WRITE : gs_info-mandt, gs_info-carrid, gs_info-carrname, gs_info-currcode. "스트럭쳐 변수-컴포넌트 연결은 -를 통해서.
ELSE.
  MESSAGE 'Message Test' TYPE 'I'.
ENDIF.
