*&---------------------------------------------------------------------*
*& Report ZRCA17_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca17_01.
*DATA gv_num TYPE i.
*DO 6 TIMES.
*  gv_num = gv_num + 1.
*  WRITE sy-index. "structure variable. 순서를 증가시키는.
*  IF gv_num > 3. EXIT. ENDIF.
*  WRITE gv_num.
*  NEW-LINE.
*ENDDO.

*DATA gv_gender TYPE gender. "data element, domain의 이미 만들어진 gender 양식을 가져온다.
*DATA gv_gender TYPE c LENGTH 1. "M, F
*
*gv_gender = 'M'.
*CASE gv_gender.
*  WHEN 'M'.
*
*  WHEN 'F'.
*
*  WHEN OTHERS.
*
*ENDCASE.
*
**IF gv_gender = 'M'. "알파벳도  >= 와 같은 연산자 이용 가능.
**
**ELSEIF gv_gender = 'F'.
**
**ELSE.
**
**ENDIF.
*
*gv_gender = 'F'.


**<내가 한거>
*DATA gv_num TYPE i.
*DATA gv_num2 TYPE i.
*PARAMETERS pa_num TYPE i.
*PARAMETERS pa_grd TYPE i.
*DATA gv_grdnum TYPE i.
*
*gv_grdnum = pa_grd * 2 + 1.
*
*IF pa_num GE 9.
*  pa_num = 9.
*ENDIF.
*
*IF pa_grd NE 6 AND pa_num LE gv_grdnum.
*  DO pa_num TIMES.
*    gv_num = gv_num + 1.
*
*      DO 9 TIMES.
*        gv_num2 = gv_num2 + gv_num.
*        WRITE gv_num2.
*      ENDDO.
*      CLEAR gv_num2.
*
*    NEW-LINE.
*  ENDDO.
*
*ELSEIF pa_grd NE 6 AND pa_num GT gv_grdnum.
*  DO gv_grdnum TIMES.
*    gv_num = gv_num + 1.
*
*      DO 9 TIMES.
*        gv_num2 = gv_num2 + gv_num.
*        WRITE gv_num2.
*      ENDDO.
*      CLEAR gv_num2.
*
*    NEW-LINE.
*  ENDDO.
*ELSE.
*  DO 9 TIMES.
*    gv_num = gv_num + 1.
*
*      DO 9 TIMES.
*        gv_num2 = gv_num2 + gv_num.
*        WRITE gv_num2.
*      ENDDO.
*      CLEAR gv_num2.
*
*    NEW-LINE.
*  ENDDO.
*
*ENDIF.


*<강사님 방식>

DATA gv_step TYPE i.
DATA gv_cal TYPE i.
DATA gv_lev TYPE i.
PARAMETERS pa_req LIKE gv_lev.
PARAMETERS pa_syear(1) TYPE c.
DATA gv_new_lev LIKE gv_lev.

CLEAR gv_new_lev.

CASE pa_syear.
  WHEN '1'.
    IF pa_req >= 3.
      gv_new_lev = 3.
    ELSE.
      gv_new_lev = pa_req.
    ENDIF.
  WHEN '2'.
    IF pa_req >= 5.
      gv_new_lev = 5.
    ELSE.
      gv_new_lev = pa_req.
    ENDIF.
  WHEN '3'.
    IF pa_req >= 7.
      gv_new_lev = 7.
    ELSE.
      gv_new_lev = pa_req.
    ENDIF.
  WHEN '4'.
    IF pa_req >= 9.
      gv_new_lev = 9.
    ELSE.
      gv_new_lev = pa_req.
    ENDIF.
  WHEN '5'.
    IF pa_req >= 9.
      gv_new_lev = 9.
    ELSE.
      gv_new_lev = pa_req.
    ENDIF.
  WHEN '6'.
    gv_new_lev = 9.

  WHEN OTHERS.
    MESSAGE 'Message Test' TYPE 'I'. " I -> 멈추고 메세지를 보내줘. 그리고 다음 단계로. / E -> 상태바에 메세지를 보내줘. / A -> 틀리면 닫아야함.(사용자에게 설명을 잘 해줘야함.) / S -> 성공처리 해주면서 메세지 보냄.
ENDCASE.

WRITE 'Times Table'.
NEW-LINE.

CLEAR : pa_req, pa_syear.

*if pa_req > pa_syear * 2 + 1.
*  pa_req = pa_syear * 2 + 1.
*elseif .
*endif.

DO gv_new_lev TIMES.
  CLEAR gv_step.
  gv_lev = gv_lev + 1.
  DO 9 TIMES.
    gv_step = gv_step + 1.
    CLEAR gv_cal.
    gv_cal = gv_lev * gv_step.
    WRITE : gv_lev, '*', gv_step, ' = ' , gv_cal.
    CLEAR gv_cal.
    NEW-LINE.
  ENDDO.
  CLEAR gv_step.
  WRITE '==========================================='.
  NEW-LINE.
ENDDO.
