*&---------------------------------------------------------------------*
*& Include ZBC405_A17TOP                            - Report ZBC405_A17
*&---------------------------------------------------------------------*
REPORT zbc405_a17.

DATA: gs_flight TYPE dv_flights.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS pa_car TYPE sflight-carrid MEMORY ID car OBLIGATORY DEFAULT 'LH' VALUE CHECK.
  PARAMETERS pa_con TYPE sflight-connid MEMORY ID con.
SELECTION-SCREEN END OF BLOCK b1.
PARAMETERS pa_str TYPE string LOWER CASE MODIF ID mod.

PARAMETERS pa_chk AS CHECKBOX DEFAULT 'X' MODIF ID mod.
*SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_rad1 RADIOBUTTON GROUP rd1,
            p_rad2 RADIOBUTTON GROUP rd1,
            p_rad3 RADIOBUTTON GROUP rd1.
*SELECTION-SCREEN END OF LINE.
SELECT-OPTIONS: so_fld FOR gs_flight-fldate.
