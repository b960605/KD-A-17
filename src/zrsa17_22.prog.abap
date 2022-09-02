*&---------------------------------------------------------------------*
*& Report ZRSA17_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_22.

DATA: gs_list TYPE scarr,
      gt_list LIKE TABLE OF gs_list.

CLEAR: gs_list, gt_list.
*SELECT * "select문도 반복문임.
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF gs_list
*  WHERE carrid BETWEEN 'AA' AND 'UA'.
*  APPEND gs_list TO gt_list.
*  CLEAR gs_list.
*ENDSELECT. "database interface를 경유하기 때문에 잘 쓰지 않는 방식.
SELECT carrid carrname
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE gt_list "table 뒤에는 internal table이 온다. Structure가 들어가려면 SELECT SINGLE를 쓰거나 ENDSELECT. 로 반복문화
  WHERE carrid BETWEEN 'AA' AND 'UA'.

WRITE sy-subrc. "데이터가 있으면 0
WRITE sy-dbcnt. "table의 rows 수. SELECT의 반복 수라고 볼 수 있다.
*APPEND gs_list TO gt_list. "SELECT도 반복문 개념이기 때문에 마지막 값만 가지게 됨.

cl_demo_output=>display_data( gt_list ).
