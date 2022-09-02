*&---------------------------------------------------------------------*
*& Include ZBC405_A17_01TOP                         - Report ZBC405_A17_01
*&---------------------------------------------------------------------*
REPORT zbc405_a17_01.

DATA gs_flight TYPE dv_flights.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: so_car FOR gs_flight-carrid,
                  so_con FOR gs_flight-connid,
                  so_dat FOR gs_flight-fldate NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t02.
  SELECTION-SCREEN BEGIN OF LINE.

    SELECTION-SCREEN COMMENT 2(5) TEXT-001.
    PARAMETERS: pa_r1 RADIOBUTTON GROUP r1.

    SELECTION-SCREEN COMMENT pos_low(8) TEXT-002.
    PARAMETERS pa_r2 RADIOBUTTON GROUP r1.

    SELECTION-SCREEN COMMENT pos_high(13) TEXT-003.
    PARAMETERS pa_r3 RADIOBUTTON GROUP r1.

  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.
