*&---------------------------------------------------------------------*
*& Include          ZRSA17_31F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_default USING VALUE(p_datum)
                       VALUE(p_days)
                 CHANGING VALUE(p_ent_b)
                          VALUE(p_ent_e).
  p_ent_b = p_datum - p_days.
  p_ent_e = p_datum.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data USING VALUE(p_ent_b)
                    VALUE(p_ent_e)
              CHANGING p_empt TYPE zssa1704_T.
  SELECT *
    FROM ztsa1701
    INTO CORRESPONDING FIELDS OF TABLE p_empt
    WHERE entdt BETWEEN p_ent_b AND p_ent_e.

  LOOP AT p_empt INTO gs_emp.
    IF gs_emp-gender = 'F'.
      gs_emp-gender_t = 'Female'.
    ELSEIF gs_emp-gender = 'M'.
      gs_emp-gender_t = 'Male'.
    ELSE.
    ENDIF.
    MODIFY p_empt FROM gs_emp.
    CLEAR gs_emp.
  ENDLOOP.
ENDFORM.
