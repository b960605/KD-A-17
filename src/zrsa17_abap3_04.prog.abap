*&---------------------------------------------------------------------*
*& Report ZRSA17_ABAP3_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_abap3_04.

TABLES sbook.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS      pa_car TYPE sbook-carrid OBLIGATORY DEFAULT 'AA'.

  SELECT-OPTIONS  so_con FOR  sbook-connid OBLIGATORY DEFAULT '0017'..

  PARAMETERS      pa_ctp TYPE sbook-custtype AS LISTBOX DEFAULT 'B' VISIBLE LENGTH 18 OBLIGATORY.

  SELECT-OPTIONS: so_fld FOR sbook-fldate DEFAULT sy-datlo, " 현지 날짜 / 현지 시간 -> sy-timlo
                  so_bid FOR sbook-bookid,
                  so_cid FOR sbook-customid NO INTERVALS NO-EXTENSION.

SELECTION-SCREEN END OF BLOCK b1.

DATA: BEGIN OF gs_sbook,
        carrid   TYPE sbook-carrid,
        connid   TYPE sbook-connid,
        fldate   TYPE sbook-fldate,
        bookid   TYPE sbook-bookid,
        customid TYPE sbook-customid,
        custtype TYPE sbook-custtype,
        invoice  TYPE sbook-invoice,
        class    TYPE sbook-class,
      END OF gs_sbook,
      gt_sbook LIKE TABLE OF gs_sbook.

DATA gv_tabix LIKE sy-tabix.

REFRESH: gt_sbook.
CLEAR  : gs_sbook.

SELECT carrid   connid   fldate  bookid
       customid custtype invoice class
  FROM sbook
  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
  WHERE carrid    = pa_car
  AND   connid   IN so_con
  AND   fldate   IN so_fld
  AND   customid IN so_cid
  AND   bookid   IN so_bid
  AND   custtype  = pa_ctp.

IF sy-subrc <> 0.

  MESSAGE i000(zmcsa17) WITH 'No data'.
  LEAVE LIST-PROCESSING.

ELSE.

  LOOP AT gt_sbook INTO gs_sbook.
    gv_tabix = sy-tabix.

    CASE gs_sbook-invoice.

      WHEN 'X'.
        gs_sbook-class = 'F'.

        MODIFY gt_sbook FROM gs_sbook INDEX gv_tabix TRANSPORTING class.
        CLEAR gs_sbook.
    ENDCASE.
  ENDLOOP.

  cl_demo_output=>display_data( gt_sbook ).

ENDIF.
