*&---------------------------------------------------------------------*
*& Report ZRSA17_30
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_30.

*DATA gv_name TYPE zdname_a17. "Type뒤에 domain은 사용이 불가능하다.
*PARAMETERS pa_name TYPE zename_a17.
*
*TYPES: BEGIN OF ts_info,
*         stdno TYPE n LENGTH 8,
*         sname TYPE c LENGTH 40,
*       END OF ts_info.

*DATA gs_std TYPE ts_info. " 로컬 타입으로 만든 스트럭쳐 변수

"Std Info
DATA gs_std TYPE zssa1701.


gs_std-stdno = '20220001'.
gs_std-sname = 'Kang SK'.
