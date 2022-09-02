*&---------------------------------------------------------------------*
*& Report ZRSA1790
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa1790.

TABLES ztsa1799.
" Final Output
DATA gs_data LIKE zssa0093.
DATA gt_data LIKE TABLE OF gs_data.
" Input from User
PARAMETERS pa_car   TYPE ztsa1799-carrid.
SELECT-OPTIONS so_meal FOR ztsa1799-mealnumber DEFAULT '1' TO '29'.
PARAMETERS pa_venca TYPE ztsa1799-venca AS LISTBOX VISIBLE LENGTH 20.
" Carrname
DATA gs_carr LIKE scarr.
DATA gt_carr LIKE TABLE OF gs_carr.

INITIALIZATION.
  " Carrname
  SELECT carrid carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF TABLE gt_carr.
  " Set Default
  pa_car = 'AA'.
  pa_venca = ''.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  CLEAR gt_data.
  IF pa_venca <> ''. "Undefined면 모두 표시
    SELECT *
      FROM ztsa1799
      INTO CORRESPONDING FIELDS OF TABLE gt_data
      WHERE carrid = pa_car
      AND mealnumber IN so_meal
      AND venca = pa_venca.
  ELSE.
    SELECT *
      FROM ztsa1799
      INTO CORRESPONDING FIELDS OF TABLE gt_data
      WHERE carrid = pa_car
      AND mealnumber IN so_meal.
  ENDIF.

  LOOP AT gt_data INTO gs_data.
    " Get carrname
    READ TABLE gt_carr WITH KEY carrid = gs_data-carrid INTO gs_carr.
    gs_data-carrname = gs_carr-carrname.
    CLEAR gs_carr.
    " Get land1_T
    SELECT SINGLE landx
      FROM t005t
      INTO gs_data-land1_t
      WHERE land1 = gs_data-land1
      AND spras = sy-langu.
    " Get Mealnumber_t
    SELECT SINGLE text
      FROM smealt
      INTO gs_data-mealnumber_t
      WHERE carrid = gs_data-carrid
      AND mealnumber = gs_data-mealnumber
      AND sprache = sy-langu.
    " Get Venca_t
    DATA lt_dom_value TYPE TABLE OF dd07v.
    DATA ls_dom_value LIKE LINE OF lt_dom_value.
    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = 'ZDVENCA_A17'
*       TEXT            = 'X'
*       FILL_DD07L_TAB  = ' '
      TABLES
        values_tab      = lt_dom_value
*       VALUES_DD07L    =
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    READ TABLE lt_dom_value WITH KEY domvalue_l = gs_data-venca
    INTO ls_dom_value.
    gs_data-venca_t = ls_dom_value-ddtext.

    MODIFY gt_data FROM gs_data.
    CLEAR gs_data.
  ENDLOOP.

  cl_demo_output=>display_data( gt_data ).
