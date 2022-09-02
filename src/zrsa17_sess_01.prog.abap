*&---------------------------------------------------------------------*
*& Report ZRSA17_SESS_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_sess_01.

DATA: gs_data     TYPE zssa17_sess_01,

      gt_data     LIKE TABLE OF gs_data,

      gs_data_tmp LIKE gs_data,

      gv_loekz    TYPE eloek,

      gv_statu    TYPE astat,

      gv_bpumz    TYPE ekpo-bpumz,

      gv_bpumn    TYPE ekpo-bpumn,

      gv_loekz2   LIKE gv_loekz,

      gv_statu2   LIKE gv_statu,

      gv_bpumz2   LIKE gv_bpumz,

      gv_bpumn2   LIKE gv_bpumn.


gs_data-bukrs = '0320'.
gs_data-belnr-zeile = 3.
gs_data-belnr-ebelp = 12345.

APPEND gs_data TO gt_data.

gt_data = VALUE #( BASE gt_data
                  ( bukrs = '1234'
                    belnr-ebelp = 23456
                    belnr-zeile = 6 )
                  ( bukrs = '5647'
                    belnr-ebelp = 34567
                    belnr-zeile = 10 )
                                         ).

DATA gt_data2 WITH HEADER LINE LIKE gt_data.

gt_data2-bukrs = '0320'.
gt_data2-belnr-zeile = 3.
gt_data2-belnr-ebelp = 12345.

APPEND gt_data2.

SELECT carrid, connid, currency, planetype, seatsocc_b
  FROM sflight
  INTO TABLE @DATA(gt_flight)
  WHERE currency  = 'USD'
  AND   planetype = '747-400'.


DATA: gs_flight LIKE LINE OF gt_flight.

LOOP AT gt_flight INTO gs_flight WHERE carrid = 'UA'.

  gs_flight-seatsocc_b = gs_flight-seatsocc_b + 10.
  MODIFY gt_flight FROM gs_flight INDEX sy-tabix TRANSPORTING seatsocc_b.
  CLEAR gs_flight.

ENDLOOP.

cl_demo_output=>display( gt_flight ).
