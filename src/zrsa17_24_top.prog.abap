*&---------------------------------------------------------------------*
*& Include ZRSA17_24_TOP                            - Report ZRSA17_24
*&---------------------------------------------------------------------*
REPORT zrsa17_24.

*TOP에서는 global 변수만 선언

"Schedule date Info
DATA: gt_info TYPE TABLE OF zsinfo00,
      gs_info LIKE LINE OF gt_info.

"Selcetion Screen
PARAMETERS: pa_car TYPE sbook-carrid,
            pa_con TYPE sbook-connid.
