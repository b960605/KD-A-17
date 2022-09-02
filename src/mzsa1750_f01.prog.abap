*&---------------------------------------------------------------------*
*& Include          MZSA1750_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_flight_meal
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& Form get_meal_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1750_CARRID
*&      --> ZSSA1750_MEALNO
*&      --> ZSSA1751_CARRID
*&      --> ZSSA1751_MEALNUMBER
*&      --> SY_LANGU
*&      --> ZSSA1751_TEXT
*&      <-- ZSSA1751
*&---------------------------------------------------------------------*
FORM get_meal_info  USING    VALUE(p_carrid0)
                             VALUE(p_mealno)
                             p_carrid1
                             p_mealnumber
                             VALUE(p_langu)
                    CHANGING ps_meal_info TYPE zssa1751.
  SELECT SINGLE *
    FROM smeal
    INTO CORRESPONDING FIELDS OF ps_meal_info
    WHERE carrid = p_carrid0
    AND mealnumber = p_mealno.

  SELECT SINGLE text
    FROM smealt
    INTO CORRESPONDING FIELDS OF ps_meal_info
    WHERE carrid = p_carrid1
    AND mealnumber = p_mealnumber
    AND sprache = p_langu.

  SELECT SINGLE carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF ps_meal_info
    WHERE carrid = p_carrid1.

  SELECT SINGLE lifnr price waers
    FROM ztsa17ven
    INTO CORRESPONDING FIELDS OF ps_meal_info
    WHERE mealno = p_mealnumber
    AND carrid = p_carrid1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_vendor_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1751_LIFNR
*&      --> ZSSA1752_LAND1
*&      --> SY_LANGU
*&      <-- ZSSA1752
*&---------------------------------------------------------------------*
FORM get_vendor_info  USING    VALUE(p_lifnr)
                               p_land1
                               VALUE(p_langu)
                      CHANGING p_vendor_info TYPE zssa1752.
  SELECT SINGLE *
    FROM ztsa17ven
    INTO CORRESPONDING FIELDS OF p_vendor_info
    WHERE lifnr = p_lifnr.

  SELECT SINGLE landx
    FROM t005t
    INTO CORRESPONDING FIELDS OF p_vendor_info
    WHERE land1 = p_land1
    AND spras = p_langu.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_domain
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> ZSSA1751_MEALTYPE
*&      <-- ZSSA1751_MTEXT
*&---------------------------------------------------------------------*
FORM get_domain  USING    VALUE(p_dom)
                          VALUE(p_mealtype)
                 CHANGING p_domtext.

  DATA: lt_domain TYPE TABLE OF dd07v,
        ls_domain LIKE LINE OF lt_domain.
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = p_dom
*     TEXT            = 'X'
*     FILL_DD07L_TAB  = ' '
    TABLES
      values_tab      = lt_domain
*     values_dd07l    =
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE lt_domain WITH KEY domvalue_l = p_mealtype INTO ls_domain.
  p_domtext = ls_domain-ddtext.
  CLEAR: lt_domain, ls_domain.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZZSA1750_LIFNR
*&      <-- ZSSA1751_MEALNUMBER
*&---------------------------------------------------------------------*
FORM get_meal_data  USING    VALUE(p_lifnr)
                    CHANGING VALUE(p_mealnumber).
  SELECT SINGLE mealno
        FROM ztsa17ven
        INTO p_mealnumber
        WHERE lifnr = p_lifnr.


ENDFORM.
