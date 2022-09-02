*&---------------------------------------------------------------------*
*& Report ZRSA17_ABAP3_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_abap3_06.

DATA: BEGIN OF ls_scarr,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF ls_scarr,

      lt_scarr LIKE TABLE OF ls_scarr.

SELECT carrid carrname url
  INTO CORRESPONDING FIELDS OF TABLE lt_scarr
  FROM scarr.


* ----------- New Syntax ------------------

SELECT carrid, carrname, url
  INTO TABLE @DATA(lt_scarr2)
  FROM scarr.
" 선언하면서 ITAB이 만들어진다. 만들면서 DB테이블의 필드들의 도메인까지 모두 가져와버림.
" @ SQL에서 신문법을 이용할 때는 꼭 붙여줘야한다.

*--------------------------------------------------------------------

READ TABLE lt_scarr INTO ls_scarr WITH KEY carrid = 'AA'.

* ----------- New Syntax ------------------

READ TABLE lt_scarr2 INTO DATA(ls_scarr2) WITH KEY carrid = 'AA'.
" 선언하지 않아도 ls_scarr2가 자동으로 생성.

*LOOP AT lt_scarr2 INTO DATA(ls_scarr2).
*
*ENDLOOP.

*--------------------------------------------------------------------

DATA: lv_carrid   TYPE scarr-carrid,
      lv_carrname TYPE scarr-carrname.

SELECT SINGLE carrid carrname
  INTO (lv_carrid, lv_carrname)
  FROM scarr
  WHERE carrid = 'AA'.

* ----------- New Syntax ------------------

SELECT SINGLE carrid, carrname
  INTO (@DATA(lv_carrid2), @DATA(lv_carrname2))
  FROM scarr
  WHERE carrid = 'AA'.

*--------------------------------------------------------------------

DATA: BEGIN OF ls_scarr3,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF ls_scarr3.

ls_scarr3-carrid = 'AA'.
ls_scarr3-carrname = 'America Airline'.
ls_scarr3-url = 'www.aa.com'.

* ----------- New Syntax ------------------

ls_scarr3 = VALUE #( carrid   = 'AA'
                     carrname = 'America Airline'
                     url      = 'www.aa.com').
" #은 VALUE 괄호 안의 구조를 ls_scarr3 과 같은 구조와 쓰겠다. 라는 의미. 괄호안에서 ctrl + space 하면 구조 내의 것만 나옴.
" VALUE 내에 기술되지 않은 필드가 있으면 initial value가 들어가게 됨.


" 한 필드만 바꾸고 싶을때
*ls_scarr3-carrid = 'KA'.
ls_scarr3 = VALUE #( BASE ls_scarr3
                     carrid = 'KA' ).

*--------------------------------------------------------------------

DATA: BEGIN OF ls_scarr4,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF ls_scarr4,

      lt_scarr4 LIKE TABLE OF ls_scarr4.

ls_scarr4-carrid   = 'AA'.
ls_scarr4-carrname = 'America Airline'.
ls_scarr4-url      = 'www.aa.com'.

APPEND ls_scarr4 TO lt_scarr4.
CLEAR ls_scarr4.

ls_scarr4-carrid   = 'KA'.
ls_scarr4-carrname = 'Korean Airline'.
ls_scarr4-url      = 'www.ka.com'.

APPEND ls_scarr4 TO lt_scarr4.
CLEAR ls_scarr4.

* ----------- New Syntax ------------------

lt_scarr4 = VALUE #(
                    ( carrid = 'AA'
                      carrname = 'America Airline'
                      url = 'www.aa.com'
                      )
                    ( carrid = 'KA'
                      carrname = 'Korean Airline'
                      url = 'www.ka.com'
                      )
                     ). " 신문법을 이용하면 WA없어도 데이터 append가 가능하다.

lt_scarr4 = VALUE #( BASE lt_scarr4 "-> 기존의 ITAB의 Row들을 모두 유지.
                    ( carrid = 'LH'
                      carrname = 'Luft Hansa'
                      url = 'www.lh.com'
                      )
                     ).

*loop at itab into wa. -> Loop 문에서 lt_scarr4에 적재하는 방식.
*
*  lt_scarr4 = VALUE #( BASE lt_scarr4
*                      ( carrid   = wa-carrid
*                        carrname = wa-carrname
*                        url      = wa-url
*                       )
*                      ).
*
*ENDLOOP.

*--------------------------------------------------------------------

MOVE-CORRESPONDING ls_scarr3 TO ls_scarr4.

* ----------- New Syntax ------------------

ls_scarr4 = CORRESPONDING #( ls_scarr3 ).

*--------------------------------------------------------------------

*********** DB 테이블과 ITAB의 조인 방법 *************
* -> For all entries in

DATA: BEGIN OF ls_key,
        carrid TYPE sflight-carrid,
        connid TYPE sflight-connid,
        fldate TYPE sflight-fldate,
      END OF ls_key,

      lt_key   LIKE TABLE OF ls_key,
      lt_sbook TYPE TABLE OF sbook.

SELECT carrid connid fldate
  INTO CORRESPONDING FIELDS OF TABLE lt_key
  FROM sflight
  WHERE carrid = 'AA'.

*  FOR ALL ENTRIES 의 선제조건
*  1. 반드시 정렬 먼저 할 것
*  2. 정렬 후 중복제거 할 것
*  3. ITAB이 비어있는지 체크하고 수행할 것 : 비어있으면 안됨.

SORT lt_key BY carrid connid fldate.
DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.
*
IF lt_key IS NOT INITIAL.
  SELECT carrid connid fldate bookid customid custtype
    INTO CORRESPONDING FIELDS OF TABLE lt_sbook
    FROM sbook
    FOR ALL ENTRIES IN lt_key
    WHERE carrid   = lt_key-carrid
    AND   connid   = lt_key-connid
    AND   fldate   = lt_key-fldate
    AND   customid = '00000279'.
ENDIF.

* ----------- New Syntax ------------------

SELECT a~carrid, a~connid, a~fldate, a~bookid, a~customid
  FROM sbook AS a
  INNER JOIN @lt_key AS b
  ON  a~carrid = b~carrid
  AND a~connid = b~connid
  AND a~fldate = b~fldate
  WHERE a~customid = '00000279'
  INTO TABLE @DATA(lt_sbook2).

*--------------------------------------------------------------------

SORT lt_sbook2 BY connid DESCENDING.
READ TABLE lt_sbook2 INTO DATA(ls_sbook2) INDEX 1.

* ----------- New Syntax ------------------

SELECT MAX( connid ) AS connid
  FROM @lt_sbook2 AS a " Alias 를 무조건 써야함
  INTO @DATA(lv_max).

*--------------------------------------------------------------------

* ----------- New Syntax ------------------
SELECT CASE carrid
  WHEN 'AA' THEN 'BB'
  ELSE carrid
  END AS carrid, connid, price, currency, fldate
  INTO TABLE @DATA(lt_sflight)
    FROM sflight.
