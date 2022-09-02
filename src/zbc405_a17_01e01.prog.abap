*&---------------------------------------------------------------------*
*& Include          ZBC405_A17_01E01
*&---------------------------------------------------------------------*

INITIALIZATION.
  so_dat-low = '20200901'.
  so_dat-high = so_dat-low + 1000.

  so_dat-sign = 'I'.
  so_dat-option = 'BT'.

  APPEND so_dat.
  CLEAR so_dat.

  so_car-low = 'AZ'.
  so_car-high = 'QF'.
  so_car-sign = 'E'.
  so_car-option = 'EQ'.
  APPEND so_car.
  CLEAR so_car.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  CASE 'X'.
    WHEN pa_r1.
      CLEAR gs_flight.
      SELECT *
        FROM dv_flights
        INTO CORRESPONDING FIELDS OF gs_flight
        WHERE carrid IN so_car
        AND   connid IN so_con
        AND   fldate IN so_dat.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-countryto,
                 gs_flight-cityfrom,
                 gs_flight-cityto,
                 gs_flight-airpfrom,
                 gs_flight-airpto.
        CLEAR gs_flight.
      ENDSELECT.

    WHEN pa_r2.
      CLEAR gs_flight.
      SELECT *
        FROM dv_flights
        INTO CORRESPONDING FIELDS OF gs_flight
        WHERE carrid IN so_car
        AND   connid IN so_con
        AND   fldate IN so_dat
        AND   countryfr = dv_flights~countryto.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-countryto,
                 gs_flight-cityfrom,
                 gs_flight-cityto,
                 gs_flight-airpfrom,
                 gs_flight-airpto.
        CLEAR gs_flight.
      ENDSELECT.

    WHEN pa_r3.
      CLEAR gs_flight.
      SELECT *
        FROM dv_flights
        INTO gs_flight
        WHERE carrid IN so_car
        AND   connid IN so_con
        AND   fldate IN so_dat
        AND   countryfr <> dv_flights~countryto.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-countryto,
                 gs_flight-cityfrom,
                 gs_flight-cityto,
                 gs_flight-airpfrom,
                 gs_flight-airpto.
        CLEAR gs_flight.
      ENDSELECT.

  ENDCASE.
