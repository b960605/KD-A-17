*&---------------------------------------------------------------------*
*& Include ZRSA17_26_TOP                            - Report ZRSA17_26
*&---------------------------------------------------------------------*
REPORT zrsa17_26.

" Type 선언
TYPES: BEGIN OF ts_info,
         carrid   TYPE sflight-carrid,
         connid   TYPE sflight-connid,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto,
         fldate   TYPE sflight-fldate, "key field들
       END OF ts_info,
       tt_info TYPE TABLE OF ts_info. "Table Type 선언

* Data Object
DATA: gt_info TYPE tt_info,
      gs_info LIKE LINE OF gt_info.

*Selection Screens
PARAMETERS: pa_car  TYPE sflight-carrid.
*            pa_con1 TYPE sflight-connid,
*            pa_con2 TYPE sflight-connid.
SELECT-OPTIONS so_con FOR gs_info-connid. "for 뒤에는 변수가 와야함 / 선언되는 변수 so_con은 Internal table
