*&---------------------------------------------------------------------*
*& Report ZRSA17_12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_12.

DATA gv_carrname TYPE scarr-carrname.
PARAMETERS pa_carr TYPE scarr-carrid.

PERFORM get_airline_name USING pa_carr
                         CHANGING gv_carrname.

WRITE gv_carrname.

*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_name USING VALUE(p_code)
*                      CHANGING VALUE(p_carrname).
                      CHANGING p_carrname.
  SELECT SINGLE carrname
    FROM scarr
    INTO p_carrname
    WHERE carrid = p_code.
  WRITE 'Test gv_carrname:'.
  WRITE gv_carrname. "call by value and result를 쓰면 result를 돌려주는 것은 ENDFORM 시점에서 이루어지기 때문에 gv_carrname이 subroutine안에서는 Initial value를 가진다.
*  call by reference로 바꾸면 값이 출력(실시간으로 바깥 변수에 집어넣음)
ENDFORM.
