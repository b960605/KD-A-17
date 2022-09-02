*&---------------------------------------------------------------------*
*& Include ZRSA17_25_TOP                            - Report ZRSA17_25
*&---------------------------------------------------------------------*
REPORT zrsa17_25.


*DATA: BEGIN OF gs_sflight,
*        carrid     TYPE sflight-carrid,
*        connid     TYPE sflight-connid,
*        fldate     TYPE sflight-fldate,
*        price      TYPE sflight-price,
*        currency   TYPE sflight-currency,
*        seatsocc   TYPE sflight-seatsocc,
*        seatsmax   TYPE sflight-seatsmax,
*        seatsocc_b TYPE sflight-seatsocc_b,
*        seatsmax_b TYPE sflight-seatsmax_b,
*        seatsocc_f TYPE sflight-seatsocc_f,
*        seatsmax_f TYPE sflight-seatsmax_f,
*      END OF gs_sflight.
*DATA gt_sflight LIKE TABLE OF gs_sflight.
*
DATA: BEGIN OF gs_spfli,
        carrid   TYPE spfli-carrid,
        connid   TYPE spfli-connid,
        cityfrom TYPE spfli-cityfrom,
        cityto   TYPE spfli-cityto,
      END OF gs_spfli.
DATA gt_spfli LIKE TABLE OF gs_spfli.

DATA: BEGIN OF gs_scarr,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
      END OF gs_scarr.
DATA gt_scarr LIKE TABLE OF gs_scarr.

PARAMETERS: pa_car  LIKE sflight-carrid,
            pa_con1 LIKE sflight-connid,
            pa_con2 LIKE sflight-connid.

*DATA: BEGIN OF gs_list,
*        carrid       TYPE sflight-carrid,
*        carrname     TYPE scarr-carrname,
*        connid       TYPE sflight-connid,
*        cityfrom     TYPE spfli-cityfrom,
*        cityto       TYPE spfli-cityto,
*        fldate       TYPE sflight-fldate,
*        price        TYPE sflight-price,
*        currency     TYPE sflight-currency,
*        seatsocc     TYPE sflight-seatsocc,
*        seatsmax     TYPE sflight-seatsmax,
*        seatremain   LIKE sflight-seatsocc,
*        seatsocc_b   TYPE sflight-seatsocc_b,
*        seatsmax_b   TYPE sflight-seatsmax_b,
*        seatremain_b LIKE sflight-seatsocc,
*        seatsocc_f   TYPE sflight-seatsocc_f,
*        seatsmax_f   TYPE sflight-seatsmax_f,
*        seatremain_f LIKE sflight-seatsocc,
*      END OF gs_list.

DATA: gs_list TYPE zssa1702,
      gt_list LIKE TABLE OF gs_list.
