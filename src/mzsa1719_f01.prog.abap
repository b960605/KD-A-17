*&---------------------------------------------------------------------*
*& Include          MZSA1719_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_emp_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1734_PERNR
*&      --> ZSSA1735_GENDER
*&      <-- ZSSA1735
*&      <-- GV_R1
*&      <-- GV_R2
*&      <-- GV_R3
*&---------------------------------------------------------------------*
FORM get_emp_info  USING    VALUE(p_pernr)
                            VALUE(p_gender)
                   CHANGING p_emp_info TYPE zssa1735
                            VALUE(p_r1)
                            VALUE(p_r2)
                            VALUE(p_r3).
  SELECT SINGLE *
  FROM ztsa1701
  INTO CORRESPONDING FIELDS OF p_emp_info
  WHERE pernr = p_pernr.
  CASE p_gender.
    WHEN '1'.
      p_r2 = 'X'.
    WHEN '2'.
      p_r3 = 'X'.
    WHEN OTHERS.
      p_r1 = 'X'.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_dep_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA1735_DEPNR
*&      <-- ZSSA1736
*&      <-- SY_LANGU
*&---------------------------------------------------------------------*
FORM get_dep_info  USING    p_depnr
                   CHANGING ps_info TYPE zssa1736
                            p_langu.
  SELECT SINGLE *
    FROM ztsa1702
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE depnr = p_depnr.

  SELECT SINGLE *
    FROM ztsa1702_t
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE depnr = p_depnr
    AND spras = p_langu.
ENDFORM.
