*&---------------------------------------------------------------------*
*& Report ZBC400_SA17_COMPUTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_sa17_compute.

PARAMETERS pa_int1 TYPE i.
PARAMETERS pa_int2 TYPE i.
PARAMETERS pa_op TYPE c.


DATA gv_result TYPE p DECIMALS 2 LENGTH 10.

PERFORM calcu USING pa_int1 pa_int2 pa_op
              CHANGING gv_result.

*&---------------------------------------------------------------------*
*& Form calcu
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM calcu USING VALUE(p_int1) TYPE i
                 VALUE(p_int2) TYPE i
                 VALUE(p_op) TYPE c
           CHANGING VALUE(p_result).
  IF p_int2 IS INITIAL AND p_op = '/'.
    WRITE 'ERROR : divide by zero.'(t04).
  ELSE.
    CASE p_op.
      WHEN '+'.
        p_result = p_int1 + p_int2.
        WRITE:'결과는'(t01),p_result,'입니다.'(t02).
      WHEN '-'.
        p_result = p_int1 - p_int2.
        WRITE:'결과는'(t01),p_result,'입니다.'(t02).
      WHEN '*'.
        p_result = p_int1 * p_int2.
        WRITE:'결과는'(t01),p_result,'입니다.'(t02).
      WHEN '/'.
        p_result = p_int1 / p_int2.
        WRITE:'결과는'(t01),p_result,'입니다.'(t02).
      WHEN OTHERS.
        WRITE 'ERROR : Invalid Arithmatic Operator.'(t03).
    ENDCASE.
  ENDIF.
ENDFORM.
