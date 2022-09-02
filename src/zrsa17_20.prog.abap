*&---------------------------------------------------------------------*
*& Report ZRSA17_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_20.

DATA: BEGIN OF gs_info,
        carrid    TYPE spfli-carrid,
        carrname  TYPE scarr-carrname,
        connid    TYPE spfli-connid,
        countryfr TYPE spfli-countryfr,
        countryto TYPE spfli-countryto,
        atype     TYPE c LENGTH 10,
      END OF gs_info.

DATA gt_info LIKE TABLE OF gs_info.

PERFORM get_spfli USING '0017' gs_info.

PERFORM get_spfli USING '0064' gs_info.

PERFORM get_spfli USING '0555' gs_info.

LOOP AT gt_info INTO gs_info.
  IF gs_info-countryfr = gs_info-countryto.
    gs_info-atype = '국내선'.
  ELSE.
    gs_info-atype = '해외선'.
  ENDIF.
  MODIFY gt_info FROM gs_info.
ENDLOOP.

LOOP AT gt_info INTO gs_info.
  SELECT SINGLE carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF gs_info
    WHERE carrid = gs_info-carrid.

  MODIFY gt_info FROM gs_info.
ENDLOOP.

cl_demo_output=>display_data( gt_info ).

*&---------------------------------------------------------------------*
*& Form get_spfli
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM get_spfli  USING    VALUE(p_a)
                         p_info.
  SELECT SINGLE carrid connid countryfr countryto
  FROM spfli
  INTO CORRESPONDING FIELDS OF p_info
  WHERE connid = p_a.

  APPEND p_info TO gt_info.
  CLEAR p_info.
ENDFORM.
