*&---------------------------------------------------------------------*
*& Include          MZSA1790_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1790_CARRID
*&      <-- ZSSA1790_CARRNAME
*&---------------------------------------------------------------------*
FORM get_airline_name  USING    VALUE(p_carrid)
                       CHANGING p_carrname.
  CLEAR p_carrname.
  SELECT SINGLE carrname
    FROM scarr
    INTO p_carrname
    WHERE carrid = p_carrid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1790_MEALNUMBER
*&      --> ZSSA1790_CARRID
*&      --> SY_LANGU
*&      <-- ZSSA1790_MEALNUMBER_T
*&---------------------------------------------------------------------*
FORM get_meal_text  USING    VALUE(p_mealno)
                             VALUE(p_carrid)
                             VALUE(p_langu)
                    CHANGING VALUE(p_meal_t).

  CLEAR p_meal_t.
  SELECT SINGLE text
    FROM smealt
    INTO p_meal_t
    WHERE mealnumber = p_mealno
      AND carrid = p_carrid
      AND sprache = p_langu.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1790_CARRID
*&      --> ZSSA1790_MEALNUMBER
*&      <-- ZSSA1791
*&---------------------------------------------------------------------*
FORM get_meal_info  USING    VALUE(p_carrid)
                             VALUE(p_mealno)
                             VALUE(p_langu)
                    CHANGING ps_info TYPE zssa1791.
  " Get Airline Name
  READ TABLE gt_carr WITH KEY carrid = p_carrid INTO gs_carr.
  zssa1790-carrname = gs_carr-carrname.
  CLEAR gs_carr.


  " Get Meal Name
  PERFORM get_meal_text USING p_mealno
                              zssa1790-carrid
                              p_langu
                        CHANGING zssa1790-mealnumber_t.
  CLEAR ps_info.
  SELECT SINGLE *
    FROM smeal
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = p_carrid
    AND mealnumber = p_mealno.

  " Airline Name
  READ TABLE gt_carr WITH KEY carrid = ps_info-carrid INTO gs_carr.
  ps_info-carrname = gs_carr-carrname.
  CLEAR gs_carr.

  " Meal Text
  PERFORM get_meal_text USING ps_info-mealnumber
                              ps_info-carrid
                              p_langu
                        CHANGING ps_info-mealnumber_t.

  " Get Price
  " Flag(V,M), Vendor ID, Airline Code, Meal Number
  DATA ls_vendor_info TYPE zssa1792.
  PERFORM get_vendor_info USING 'M' "meal number
                                ps_info-carrid
                                ps_info-mealnumber
                          CHANGING ls_vendor_info.
  ps_info-price = ls_vendor_info-price.
  ps_info-waers = ls_vendor_info-waers.

  PERFORM get_domain_text USING 'S_MEALTYPE'
                                ps_info-mealtype
                          CHANGING ps_info-mealtype_t.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_vendor_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> PS_INFO_CARRID
*&      --> PS_INFO_MEALNUMBER
*&      <-- LS_VENDOR_INFO
*&---------------------------------------------------------------------*
FORM get_vendor_info  USING    VALUE(p_flag)
                               VALUE(p_code1)
                               VALUE(p_code2)
                      CHANGING ps_vendor_info TYPE zssa1792.

  CLEAR ps_vendor_info.

  DATA:BEGIN OF ls_cond,
         lifnr  TYPE ztsa1799-lifnr,
         carrid TYPE ztsa1799-carrid,
         mealno TYPE ztsa1799-mealnumber,
       END OF ls_cond.

  CASE p_flag.
    WHEN 'V'. "Vendor
      ls_cond-lifnr = p_code1.
      SELECT SINGLE *
        FROM ztsa1799
        INTO CORRESPONDING FIELDS OF ps_vendor_info
        WHERE lifnr = ls_cond-lifnr.
    WHEN 'M'. "Meal Number
      ls_cond-carrid = p_code1.
      ls_cond-mealno = p_code2.
      SELECT SINGLE *
        FROM ztsa1799
        INTO CORRESPONDING FIELDS OF ps_vendor_info
        WHERE carrid = ls_cond-carrid
        AND mealnumber = ls_cond-mealno.

    WHEN OTHERS.
      RETURN.
  ENDCASE.

  " Vendor Category Text
  PERFORM get_domain_text USING 'ZDVENCA_A17'
                                ps_vendor_info-venca
                          CHANGING ps_vendor_info-venca_t.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_domain_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_domain_text USING VALUE(p_domname)
                           VALUE(p_code)
                     CHANGING VALUE(p_text).
  DATA lv_domname TYPE dd07l-domname.
  lv_domname = p_domname.
  DATA lt_dom_value TYPE TABLE OF dd07v.
  DATA ls_dom_value LIKE LINE OF lt_dom_value.

  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = lv_domname
*     TEXT            = 'X'
*     FILL_DD07L_TAB  = ' '
    TABLES
      values_tab      = lt_dom_value
*     VALUES_DD07L    =
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE lt_dom_value WITH KEY domvalue_l = p_code INTO ls_dom_value.

  IF sy-subrc = 0.
    p_text = ls_dom_value-ddtext.
  ENDIF.
ENDFORM.
