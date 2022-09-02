*&---------------------------------------------------------------------*
*& Include          ZRSA17_24_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_info .
  CLEAR gt_info.
  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_info
    WHERE carrid = pa_car
      AND connid = pa_con.

  CLEAR gs_info.
  LOOP AT gt_info INTO gs_info.
    "Get Airline Name
    SELECT SINGLE carrname
      FROM scarr
      INTO gs_info-carrname
      WHERE carrid = gs_info-carrid.

    "Get Flight Connection Info
    SELECT SINGLE cityfrom cityto
      FROM spfli
*        INTO CORRESPONDING FIELDS OF gs_info
      INTO ( gs_info-cityfrom, gs_info-cityto ) "이렇게 순서대로 넣어줄 수 있음.
      WHERE carrid = gs_info-carrid
        AND connid = gs_info-connid.

    MODIFY gt_info FROM gs_info INDEX sy-tabix. "INDEX sy-tabix는 생략이 가능.
    CLEAR gs_info.
  ENDLOOP.
ENDFORM.
