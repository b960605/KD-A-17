*&---------------------------------------------------------------------*
*& Report ZRSA17EXEX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17exex.

DATA gv_c TYPE i.
PARAMETERS pa_a TYPE i.


DO pa_a TIMES.
  gv_c = gv_c + 1.
  DO pa_a - gv_c TIMES.
    WRITE ' '.
  ENDDO.
  DO gv_c TIMES.
    WRITE '*'.
  ENDDO.
  NEW-LINE.
ENDDO.
