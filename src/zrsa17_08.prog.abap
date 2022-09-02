*&---------------------------------------------------------------------*
*& Report ZRSA17_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_08.

PARAMETERS pa_code TYPE c LENGTH 4 DEFAULT 'SYNC'.
PARAMETERS pa_date TYPE sy-datum.
DATA gv_cond_d1 LIKE pa_date.

gv_cond_d1 = sy-datum + 7.

CASE pa_code.
  WHEN 'SYNC'.
    IF pa_date > gv_cond_d1.
      WRITE 'ABAP Dictionary'(t02).
    ELSE.
      WRITE 'ABAP Workbench'(to1).
    ENDIF.
  WHEN OTHERS.
    WRITE '다음 기회에 수강'(t03).
ENDCASE.
