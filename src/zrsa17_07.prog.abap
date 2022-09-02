*&---------------------------------------------------------------------*
*& Report ZRSA17_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_07.

PARAMETERS pa_date TYPE sy-datum.
PARAMETERS pa_crs TYPE c LENGTH 4 DEFAULT 'SYNC'.
DATA gv_user_date TYPE d.
DATA gv_today TYPE d VALUE '20220620'.
*WRITE gv_today.
DATA gv_crs TYPE c LENGTH 20 VALUE 'ABAP Workbench'.
MOVE pa_date TO gv_user_date.

IF pa_crs IS NOT INITIAL.
  CASE pa_crs.
    WHEN 'SYNC'.
      IF gv_user_date - gv_today > 365.
        gv_crs = '취업'.

      ELSEIF gv_user_date - gv_today > 7.
        gv_crs = 'ABAP Dictionary'.

      ELSEIF gv_user_date - gv_today <= 7 AND gv_user_date - gv_today > 0.
        gv_crs = 'SAPUI5'.

      ELSE.
        gv_crs = '교육 준비중'.

      ENDIF.
    WHEN OTHERS.
      gv_crs = '다음 기회에 수강'.
  ENDCASE.
  WRITE gv_crs.
ELSE.
  WRITE gv_crs.
ENDIF.
