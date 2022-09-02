*&---------------------------------------------------------------------*
*& Report ZRSA17_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_23.

DATA: gs_info TYPE zsinfo,
      gt_info LIKE TABLE OF gs_info.

PARAMETERS: pa_cid1 TYPE spfli-carrid,
            pa_cid2 LIKE pa_cid1.

SELECT *
  FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE carrid BETWEEN pa_cid1 AND pa_cid2.

CLEAR gs_info.
DATA lt_info LIKE TABLE OF gs_info.

SELECT carrname carrid
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE lt_info.

LOOP AT gt_info INTO gs_info.
**  SELECT SINGLE carrname
**    FROM scarr
**    INTO CORRESPONDING FIELDS OF gs_info
**    WHERE carrid = gs_info-carrid.
**  MODIFY gt_info FROM gs_info.
**  CLEAR gs_info.
*
  MODIFY gt_info FROM gs_info.
  CLEAR gs_info.
  READ TABLE lt_info WITH KEY carrid = gs_info-carrid
  INTO gs_info.
ENDLOOP.

cl_demo_output=>display_data( gt_info ).
