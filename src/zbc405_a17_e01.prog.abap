*&---------------------------------------------------------------------*
*& Include          ZBC405_A17_E01
*&---------------------------------------------------------------------*

SELECT *
  FROM dv_flights
  INTO gs_flight
  WHERE carrid = pa_car
    AND connid = pa_con
    AND fldate IN so_fld.

  WRITE: /10(5) gs_flight-carrid,
          16(5) gs_flight-connid,
          22 gs_flight-fldate,
           gs_flight-countryfr,
           gs_flight-cityfrom,
           gs_flight-airpfrom,
           gs_flight-countryto,
           gs_flight-cityto,
           gs_flight-airpto,
           gs_flight-seatsmax,
           gs_flight-seatsocc,
           gs_flight-price CURRENCY gs_flight-currency,
           gs_flight-currency.
ENDSELECT.

INITIALIZATION.

  LOOP AT SCREEN.
    IF screen-group1 = 'MOD'.
      screen-input = 0.
      screen-output = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  so_fld-low = sy-datum.
  so_fld-high = sy-datum + 30.

  so_fld-sign = 'I'.
  so_fld-option = 'BT'.

  APPEND so_fld.
