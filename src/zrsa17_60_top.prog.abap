*&---------------------------------------------------------------------*
*& Include ZRSA17_60_TOP                            - Report ZRSA17_60
*&---------------------------------------------------------------------*
REPORT zrsa17_60.

TABLES: sflight. "TABLES 는 일반적인 구조의 변수를 선언. TYPE이름과 변수이름이 같은.

PARAMETERS: pa_car TYPE spfli-carrid,
            pa_con TYPE spfli-connid.

SELECT-OPTIONS so_dat FOR sflight-fldate.
