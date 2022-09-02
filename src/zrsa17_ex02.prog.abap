*&---------------------------------------------------------------------*
*& Report ZRSA17_EX02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_ex02.

PARAMETERS pa_a TYPE i.

DATA gv_a TYPE i.

DO pa_a * 2 - 1 TIMES.
  gv_a = gv_a + 1.
  IF pa_a >= gv_a.
    DO pa_a - gv_a  TIMES.
      WRITE ' '.
    ENDDO.
    DO gv_a TIMES.
      WRITE '*'.
    ENDDO.
    NEW-LINE.
  ELSE.
    DO gv_a - pa_a  TIMES.
      WRITE ' '.
    ENDDO.
    DO pa_a * 2 - gv_a TIMES.
      WRITE '*'.
    ENDDO.
    NEW-LINE.
  ENDIF.

ENDDO.
