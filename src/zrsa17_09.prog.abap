*&---------------------------------------------------------------------*
*& Report ZRSA17_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_09.

DATA gv_d TYPE sy-datum.

gv_d = sy-datum - 365.

*CLEAR gv_d.

IF gv_d IS INITIAL.
  WRITE 'No Date'.
ELSE.
  WRITE 'Exist Date'.
ENDIF.


*DATA gv_cnt TYPE i.
*
*DO 10 TIMES.
*  gv_cnt = gv_cnt + 1.
*  WRITE gv_cnt.
*  DO 5 TIMES.
*    WRITE sy-index.
*  ENDDO.
*  NEW-LINE.
*ENDDO.
