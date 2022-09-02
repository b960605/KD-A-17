*&---------------------------------------------------------------------*
*& Report ZRSA17_ABAP3_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_abap3_02.

DATA: BEGIN OF gs_data,
        ktopl TYPE ska1-ktopl,
        ktplt TYPE t004t-ktplt,
        saknr TYPE ska1-saknr,
        txt20 TYPE skat-txt20,
        ktoks TYPE ska1-ktoks,
        txt30 TYPE t077z-txt30,
      END OF gs_data,

      gt_data  LIKE TABLE OF gs_data,

      gs_t004t TYPE t004t,
      gt_t004t TYPE TABLE OF t004t,

      gs_skat  TYPE skat,
      gt_skat  TYPE TABLE OF skat,

      gs_t077z TYPE t077z,
      gt_t077z TYPE TABLE OF t077z.

DATA lv_tabix LIKE sy-tabix.


SELECT ktopl saknr ktoks
  FROM ska1
  INTO CORRESPONDING FIELDS OF TABLE gt_data
  WHERE ktopl = 'WEG'.

SELECT ktopl ktplt
  FROM t004t
  INTO CORRESPONDING FIELDS OF TABLE gt_t004t
  WHERE spras = sy-langu.

SELECT saknr txt20
  FROM skat
  INTO CORRESPONDING FIELDS OF TABLE gt_skat
  WHERE spras = sy-langu.

SELECT ktoks txt30
  FROM t077z
  INTO CORRESPONDING FIELDS OF TABLE gt_t077z
  WHERE spras = sy-langu.

LOOP AT gt_data INTO gs_data.

  lv_tabix = sy-tabix.

  READ TABLE gt_t004t INTO gs_t004t WITH KEY ktopl = gs_data-ktopl.
  IF gs_t004t IS NOT INITIAL.
    gs_data-ktplt = gs_t004t-ktplt.
    CLEAR gs_t004t.
  ENDIF.

  READ TABLE gt_skat INTO gs_skat WITH KEY saknr = gs_data-saknr.
  IF gs_skat IS NOT INITIAL.
    gs_data-txt20 = gs_skat-txt20.
    CLEAR gs_skat.
  ENDIF.

  READ TABLE gt_t077z INTO gs_t077z WITH KEY ktoks = gs_data-ktoks.
  IF gs_t077z IS NOT INITIAL.
    gs_data-txt30 = gs_t077z-txt30.
  ENDIF.

  IF    gs_data-ktplt IS INITIAL
    AND gs_data-txt20 IS INITIAL
    AND gs_data-txt30 IS INITIAL.
  ELSE.
    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING ktplt txt20 txt30.
  ENDIF.
  CLEAR gs_data.
ENDLOOP.

cl_demo_output=>display_data( gt_data ).
