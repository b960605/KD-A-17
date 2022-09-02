*&---------------------------------------------------------------------*
*& Report ZRSA17_ABAP3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_abap3.

*DATA: gv_char(20),
*      gv_p(5)    TYPE p DECIMALS 2,
*      gv_n(8)    TYPE n.
*
*DATA: gv_c2(10),
*      gv_n2(10) TYPE n,
*      gv_i1 TYPE i,
*      gv_p2(5) TYPE p DECIMALS 2.
*
*gv_p2 = '1.25'.
*gv_i1 = 25.
*gv_n2 = 365.
*gv_c2 = 'ABCDEFGHIJ'.
*
*WRITE: gv_c2, gv_n2, gv_i1, gv_p2.

*DATA: gs_emp TYPE ztsa1701,
*      gt_emp TYPE TABLE OF ztsa1701.
*
*DATA: BEGIN OF gs_mat,
*        matnr TYPE mara-matnr,
*        werks TYPE marc-werks,
*        mtart TYPE mara-mtart,
*        matkl TYPE mara-matkl,
*        ekgrp TYPE marc-ekgrp,
*        pstat TYPE marc-pstat,
*      END OF gs_mat.
*
*DATA gt_mat LIKE TABLE OF gs_mat.


*-------------------------------------- internal

*DATA: gs_sbook TYPE sbook,
*      gt_sbook TYPE TABLE OF sbook.
*
*SELECT carrid connid fldate bookid customid
*       custtype invoice class smoker
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
*  WHERE carrid = 'DL'
*    AND custtype = 'P'
*    AND order_date = '20201227'.
*
*IF sy-subrc <> 0.
*  MESSAGE s001(oo).
*  LEAVE LIST-PROCESSING. " = STOP.
*ENDIF.
*
*DATA lv_tabix TYPE sy-tabix.
*
*LOOP AT gt_sbook INTO gs_sbook.
*
*  lv_tabix = sy-tabix.
*
*  CASE gs_sbook-smoker.
*    WHEN 'X'.
*      CASE gs_sbook-invoice.
*        WHEN 'X'.
*          gs_sbook-class = 'F'.
*          MODIFY gt_sbook FROM gs_sbook INDEX lv_tabix
*          TRANSPORTING class. " 안전장치
*      ENDCASE.
*  ENDCASE.
*
*ENDLOOP.
*
**LOOP AT gt_sbook INTO gs_sbook WHERE smoker = 'X' AND invoice = 'X'.
**  gs_sbook-class = 'F'.
**  MODIFY gt_sbook FROM gs_sbook.
**ENDLOOP.
*
*CLEAR gs_sbook.
*
*cl_demo_output=>display_data( gt_sbook ).

*-------------------------------------------------------------- internal Table 2

*DATA: BEGIN OF gs_fli,
*        carrid     TYPE sflight-carrid,
*        connid     TYPE sflight-connid,
*        fldate     TYPE sflight-fldate,
*        currency   TYPE sflight-currency,
*        planetype  TYPE sflight-planetype,
*        seatsocc_b TYPE sflight-seatsocc_b,
*      END OF gs_fli,
*      gt_fli LIKE TABLE OF gs_fli.
*
*CLEAR gs_fli.
*REFRESH gt_fli.
*
*DATA: lv_tabix TYPE sy-tabix.

*SELECT  carrid connid fldate currency planetype seatsocc_b
*  FROM  sflight
*  INTO CORRESPONDING FIELDS OF TABLE gt_fli
*  WHERE currency  = 'USD'
*  AND   planetype = '747-400'.
*
*LOOP AT gt_fli INTO gs_fli.
*
*  lv_tabix = sy-tabix.
*
*  CASE gs_fli-carrid.
*    WHEN 'UA'.
*      gs_fli-seatsocc_b = gs_fli-seatsocc_b + 5.
*      MODIFY gt_fli FROM gs_fli INDEX lv_tabix
*      TRANSPORTING seatsocc_b.
*  ENDCASE.
*ENDLOOP.
*
*cl_demo_output=>display_data( gt_fli ).

*-------------------------------------------------------------------

*DATA: BEGIN OF gs_mara,
*        matnr TYPE mara-matnr,
*        maktx TYPE makt-maktx,
*        mtart TYPE mara-mtart,
*        matkl TYPE mara-matkl,
*      END OF gs_mara,
*
*      gt_mara LIKE TABLE OF gs_mara,
*
*      BEGIN OF gs_makt,
*        matnr TYPE makt-matnr,
*        maktx TYPE makt-maktx,
*      END OF gs_makt,
*
*      gt_makt LIKE TABLE OF gs_makt.
*
*DATA lv_tabix LIKE sy-tabix.
*
*REFRESH: gt_mara, gt_makt.
*
*SELECT matnr mtart matkl
*  FROM mara
*  INTO CORRESPONDING FIELDS OF TABLE gt_mara.
*
*IF sy-subrc <> 0.
*  MESSAGE s003(oo).
*ENDIF.
*
*SELECT matnr maktx
*  FROM makt
*  INTO CORRESPONDING FIELDS OF TABLE gt_makt
*  WHERE spras = sy-langu.
*
*IF sy-subrc <> 0.
*  MESSAGE s003(oo).
*ENDIF.
*
*LOOP AT gt_mara INTO gs_mara.
*  lv_tabix = sy-tabix.
*
*  READ TABLE gt_makt INTO gs_makt WITH KEY matnr = gs_mara-matnr.
*  IF gs_makt IS NOT INITIAL.
*    gs_mara-maktx = gs_makt-maktx.
*    MODIFY gt_mara FROM gs_mara INDEX lv_tabix TRANSPORTING maktx.
*    CLEAR gs_makt.
*  ENDIF.
*ENDLOOP.
*
*cl_demo_output=>display_data( gt_mara ).

*-----------------------------------------------------------------------------

*DATA: BEGIN OF gs_spfli,
*        carrid   TYPE spfli-carrid,
*        carrname TYPE scarr-carrname,
*        url      TYPE scarr-url,
*        connid   TYPE spfli-connid,
*        airpfrom TYPE spfli-airpfrom,
*        airpto   TYPE spfli-airpto,
*        deptime  TYPE spfli-deptime,
*        arrtime  TYPE spfli-arrtime,
*      END OF gs_spfli,
*
*      gt_spfli LIKE TABLE OF gs_spfli,
*
*      BEGIN OF gs_scarr,
*        carrid   TYPE scarr-carrid,
*        carrname TYPE scarr-carrname,
*        url      TYPE scarr-url,
*      END OF gs_scarr,
*
*      gt_scarr LIKE TABLE OF gs_scarr.
*
*DATA lv_tabix LIKE sy-tabix.
*
*REFRESH: gt_spfli, gt_scarr.
*CLEAR:   gs_spfli, gs_scarr.
*
*
*SELECT carrid carrname url
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF TABLE gt_scarr.
*
*SELECT carrid connid airpfrom airpto deptime arrtime
*  FROM spfli
*  INTO CORRESPONDING FIELDS OF TABLE gt_spfli.
*
*LOOP AT gt_spfli INTO gs_spfli.
*  lv_tabix = sy-tabix.
*
*  READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = gs_spfli-carrid.
*
*  IF gs_scarr IS NOT INITIAL.
*
*    gs_spfli-carrname = gs_scarr-carrname.
*    gs_spfli-url      = gs_scarr-url.
*
*    MODIFY gt_spfli FROM gs_spfli INDEX lv_tabix
*    TRANSPORTING carrname url.
*  ENDIF.
*  CLEAR gs_scarr.
*ENDLOOP.
*CLEAR gs_spfli.
*
*cl_demo_output=>display_data( gt_spfli ).

*-------------------------------------------------------------------------

DATA: BEGIN OF gs_data,
        matnr TYPE mara-matnr,
        maktx TYPE makt-maktx,
        mtart TYPE mara-mtart,
        mtbez TYPE t134t-mtbez,
        mbrsh TYPE mara-mbrsh,
        mbbez TYPE t137t-mbbez,
        tragr TYPE mara-tragr,
        vtext TYPE ttgrt-vtext,
      END OF gs_data,

      gt_data  LIKE TABLE OF gs_data,

      gt_t134t TYPE TABLE OF t134t,
      gs_t134t TYPE t134t,

      gt_t137t TYPE TABLE OF t137t,
      gs_t137t TYPE t137t,

      gt_ttgrt TYPE TABLE OF ttgrt,
      gs_ttgrt TYPE ttgrt.

DATA lv_tabix TYPE sy-tabix.

REFRESH: gt_data, gt_t134t, gt_t137t, gt_ttgrt.

SELECT a~matnr b~maktx a~mtart a~mbrsh a~tragr
  INTO CORRESPONDING FIELDS OF TABLE gt_data
  FROM       mara AS a
  INNER JOIN makt AS b
  ON  a~matnr = b~matnr
  AND b~spras = sy-langu.

SELECT mtart mtbez
  FROM t134t
  INTO CORRESPONDING FIELDS OF TABLE gt_t134t
 WHERE spras = sy-langu.

SELECT mbrsh mbbez
  FROM t137t
  INTO CORRESPONDING FIELDS OF TABLE gt_t137t
 WHERE spras = sy-langu.

SELECT tragr vtext
  FROM ttgrt
  INTO CORRESPONDING FIELDS OF TABLE gt_ttgrt
 WHERE spras = sy-langu.

LOOP AT gt_data INTO gs_data.

  lv_tabix = sy-tabix.

  READ TABLE gt_t134t INTO gs_t134t WITH KEY mtart = gs_data-mtart.

  IF gs_t134t IS NOT INITIAL.
    gs_data-mtbez = gs_t134t-mtbez.
    CLEAR gs_t134t.
  ENDIF.

  READ TABLE gt_t137t INTO gs_t137t WITH KEY mbrsh = gs_data-mbrsh.

  IF gs_t137t IS NOT INITIAL.
    gs_data-mbbez = gs_t137t-mbbez.
    CLEAR gs_t137t.
  ENDIF.

  READ TABLE gt_ttgrt INTO gs_ttgrt WITH KEY tragr = gs_data-tragr.

  IF gs_ttgrt IS NOT INITIAL.
    gs_data-vtext = gs_ttgrt-vtext.
    CLEAR gs_ttgrt.
  ENDIF.

  IF    gs_data-mtbez IS INITIAL
    AND gs_data-mbbez IS INITIAL
    AND gs_data-vtext IS INITIAL.

  ELSE.

    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING mtbez mbbez vtext.

  ENDIF.
ENDLOOP.

CLEAR gs_data.

cl_demo_output=>display_data( gt_data ).
