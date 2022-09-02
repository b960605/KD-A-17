*&---------------------------------------------------------------------*
*& Report ZRSA17_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_06.

PARAMETERS pa_i TYPE i.
PARAMETERS pa_class TYPE c LENGTH 1. "A, B, C, D만 입력 가능.

DATA gv_result LIKE pa_i. "사용자에게 입력받은 값을 변경하지 않기 위해서 새롭게 선언하는 게 좋음.

* 10보다 크면 출력
* 20보다 크다면, 10을 추가로 더해서 출력.
*IF pa_i > 20.
*  ADD 10 TO pa_i.
*  WRITE pa_i.
*ELSEIF pa_i > 10.
*  WRITE pa_i.
*ENDIF.

*IF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*ELSE.
*  IF pa_i > 10.
*    WRITE pa_i.
*  ENDIF.
*ENDIF.

* 10보다 크면 출력
* 20보다 크다면, 10을 추가로 더해서 출력.
*A반이라면 입력한 값에 모두 100을 추가하세요.

IF pa_i > 20.
  gv_result = pa_i + 10.

ELSEIF pa_i > 10.
  gv_result = pa_i.

ELSE.

ENDIF.

CASE pa_class.
  WHEN 'A'.
    gv_result = gv_result + 100.
    WRITE gv_result.
  WHEN OTHERS.
    WRITE gv_result.
ENDCASE.
