*&---------------------------------------------------------------------*
*& Report ZRSA17_14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_14.

*transparent table = structure type 종류 중의 하나.
DATA gs_scarr TYPE scarr.

PARAMETERS pa_carr LIKE gs_scarr-carrid. "type scarr-carrid 로 해도 무관

SELECT SINGLE carrid carrname currcode
  FROM scarr
  INTO CORRESPONDING FIELDS OF gs_scarr "뽑아낸 컴포넌트들을 앞부터 채우기 때문에 다르게 출력됨.
  WHERE carrid = pa_carr.

WRITE: gs_scarr-carrid, gs_scarr-carrname, gs_scarr-currcode.

"TYPES 방식으로 structure variable 선언하는 방식
*TYPES: BEGIN OF ts_cat,
*         home TYPE c LENGTH 10,
*         name TYPE c LENGTH 10,
*         age  TYPE i,
*       END OF ts_cat.
*
*DATA gs_cat TYPE ts_cat.
*
*WRITE gs_cat-age.

*DATA: gv_cat_name TYPE c LENGTH 10,
*      gv_cat_age  TYPE i.
*
"DATA BEGIN OF 로 structure variable 선언하는 방식
*DATA: BEGIN OF gs_cat,
*        name TYPE c LENGTH 10,
*        age  TYPE i,
*      END OF gs_cat.
