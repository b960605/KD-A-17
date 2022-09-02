*&---------------------------------------------------------------------*
*& Include          MZSA1710_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airlline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airlline_info .
  CLEAR zssa1781.
  SELECT SINGLE *
    FROM scarr
    INTO CORRESPONDING FIELDS OF zssa1781
    WHERE carrid = zssa1780-carrid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_conn_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1780_CARRID
*&      --> ZSSA1780_CONNID
*&      <-- ZSSA1782
*&---------------------------------------------------------------------*
FORM get_conn_info  USING    VALUE(p_carrid)
                             VALUE(p_connid)
                    CHANGING ps_info TYPE zssa1782
                             p_subrc.
  CLEAR: p_subrc, zssa1781, ps_info.
  SELECT SINGLE *
    FROM spfli
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = p_carrid
      AND connid = p_connid.

  IF ps_info IS INITIAL.
    p_subrc = '4'.
  ENDIF.



ENDFORM.
