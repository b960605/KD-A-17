*&---------------------------------------------------------------------*
*& Report ZRSA17_ABAP3_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_abap3_05.

TABLES: sbook, sflight.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS     pa_car  TYPE sflight-carrid OBLIGATORY DEFAULT 'AA'.

  SELECT-OPTIONS so_con  FOR  sflight-connid OBLIGATORY DEFAULT '0017'.

  PARAMETERS     pa_pty  TYPE sflight-planetype AS LISTBOX VISIBLE LENGTH 20 DEFAULT '747-400'.

  SELECT-OPTIONS so_bid  FOR  sbook-bookid.

SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_car.
  PERFORM f4_carrid.

START-OF-SELECTION.

  DATA: BEGIN OF gs_data1,
          carrid    TYPE sflight-carrid,
          connid    TYPE sflight-connid,
          fldate    TYPE sflight-fldate,
          planetype TYPE sflight-planetype,
          currency  TYPE sflight-currency,
          bookid    TYPE sbook-bookid,
          customid  TYPE sbook-customid,
          custtype  TYPE sbook-custtype,
          class     TYPE sbook-class,
          agencynum TYPE sbook-agencynum,
        END OF gs_data1,

        gt_data1 LIKE TABLE OF gs_data1,

        BEGIN OF gs_data2,
          carrid    TYPE sflight-carrid,
          connid    TYPE sflight-connid,
          fldate    TYPE sflight-fldate,
          bookid    TYPE sbook-bookid,
          customid  TYPE sbook-customid,
          custtype  TYPE sbook-custtype,
          agencynum TYPE sbook-agencynum,
        END OF gs_data2,

        gt_data2 LIKE TABLE OF gs_data2.

  REFRESH: gt_data1, gt_data2.


  SELECT a~carrid a~connid a~fldate a~planetype a~currency
         b~bookid b~customid b~custtype b~class b~agencynum
    INTO CORRESPONDING FIELDS OF TABLE gt_data1
    FROM       sflight AS a
    INNER JOIN sbook AS b

    ON    a~carrid     = b~carrid
    AND   a~connid     = b~connid
    AND   a~fldate     = b~fldate

    WHERE a~carrid     = pa_car
    AND   a~connid    IN so_con
    AND   a~planetype  = pa_pty
    AND   b~bookid    IN so_bid.

  IF sy-subrc <> 0.

    MESSAGE i000(zmcsa17) WITH 'No data'.
    LEAVE LIST-PROCESSING.

  ELSE.

    LOOP AT gt_data1 INTO gs_data1.
      CASE gs_data1-custtype.
        WHEN 'B'.
          MOVE-CORRESPONDING gs_data1 TO gs_data2.
          APPEND gs_data2 TO gt_data2.
          CLEAR  gs_data2.
      ENDCASE.
    ENDLOOP.
  ENDIF.

  IF gt_data2 IS NOT INITIAL.
    SORT gt_data2 BY carrid connid fldate.
    DELETE ADJACENT DUPLICATES FROM gt_data2 COMPARING carrid connid fldate.

    cl_demo_output=>display_data( gt_data2 ).
  ELSE.
    MESSAGE i000(zmcsa17) WITH 'No data'.
  ENDIF.
*&---------------------------------------------------------------------*
*& Form f4_carrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_carrid .

  DATA: BEGIN OF ls_carrid,
          carrid   TYPE scarr-carrid,
          carrname TYPE scarr-carrname,
          currcode TYPE scarr-currcode,
          url      TYPE scarr-url,
        END OF ls_carrid,

        lt_carrid LIKE TABLE OF ls_carrid.

  REFRESH lt_carrid.

  SELECT carrid carrname currcode url
    FROM scarr
    INTO CORRESPONDING FIELDS OF TABLE lt_carrid.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'CARRID'       "선택화면 화면으로 세팅할 ITAB의 필드
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'PA_CAR'       "서치헬프 화면에서 선택한 데이터가 들어갈 화면의 필드
      window_title = 'Airline List'
*     WINDOW_TITLE = TEXT-t02
      value_org    = 'S'
*      display      = 'X'           "Display용만 되고 세팅이 불가능. 인풋이 막힌 필드에서 값이 들어가는 것을 방지하는 용도.
    TABLES
      value_tab    = lt_carrid.

ENDFORM.
*
*DATA: gt_s
*      gs_scarr LIKE LINE OF gt_scarr.
**
*gs_scarr-carrid = 'AA'.
*gs_scarr-carrname = 'ABC'.
**
*APPEND gs_scarr TO gt_scarr.
**APPEND gs_scarr TO gt_scarr.
*
*cl_demo_output=>display( gt_scarr ).
