*&---------------------------------------------------------------------*
*& Report ZRSA17_21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_21.

TYPES: BEGIN OF ts_info,
         carrid    TYPE spfli-carrid,
         carrname  TYPE scarr-carrname,
         connid    TYPE spfli-connid,
         countryfr TYPE spfli-countryfr,
         countryto TYPE spfli-countryto,
         atype, "type c length 1
         atype_t   TYPE c LENGTH 10,
       END OF ts_info. "Local Structure type -> 일반적으로는 ABAP Dictionary에서 만들어서 global type으로 이용함.

* Connection Internal Table 선언
*DATA gt_info type <table_type>.
DATA gt_info TYPE TABLE OF ts_info. "spfli는 structure variable이기 때문에 type table of 로 선언.

* Structure Variable 선언
DATA gs_info TYPE ts_info. "선언방식은 여러가지지만 서로 연결성을 고려해서 변화의 연쇄작용을 고려해서 선언하는 것이 좋음.
*DATA: gs_info LIKE LINE OF gt_info.
**      ,gt_info like Table of gs_info.

PARAMETERS pa_car LIKE gs_info-carrid.
*
*PERFORM get_spfli USING 'AA' '0017' 'US' 'US'.
*
*PERFORM get_spfli USING 'AA' '0064' 'US' 'US'.

SELECT carrid connid countryfr countryto
  FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE carrid = pa_car.

LOOP AT gt_info INTO gs_info.
  IF gs_info-countryfr = gs_info-countryto.
    gs_info-atype = 'D'.
    gs_info-atype_t = '국내선'.
  ELSE.
    gs_info-atype = 'I'.
    gs_info-atype_t = '해외선'.
  ENDIF.

  "Get carrname
  SELECT SINGLE carrname
    FROM scarr
    INTO gs_info-carrname
    WHERE carrid = gs_info-carrid.

  MODIFY gt_info FROM gs_info TRANSPORTING atype carrname atype_t. "붙이면 해당 필드만 바꿔주세요.
  CLEAR gs_info.

ENDLOOP.

SORT gt_info BY atype ASCENDING. "DESCENDING 내림차순

cl_demo_output=>display_data( gt_info ).

*&---------------------------------------------------------------------*
*& Form get_spfli
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_spfli USING VALUE(p_carrid)
                     VALUE(p_connid)
                     VALUE(p_countryfr)
                     VALUE(p_countryto).
  DATA ls_info LIKE LINE OF gt_info. "로컬 변수 선언해서 사용하면 바로 사라지기 때문에 clear 안써도 되지만 과하게 하기 위해서 clear 이용.
  CLEAR ls_info.
*gs_info = 'AA'. " Structure Variable의 가장 앞 field에 들어가게됨.
  ls_info-carrid = p_carrid.
  ls_info-connid = p_connid. "Numeric 4자리
  ls_info-countryfr = p_countryfr.
  ls_info-countryto = p_countryto.
  APPEND ls_info TO gt_info.
  CLEAR ls_info.

ENDFORM.
