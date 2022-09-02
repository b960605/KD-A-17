*&---------------------------------------------------------------------*
*& Report ZRSA17_M03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_m03top                           .    " Global Data

* INCLUDE ZRSA17_M03O01                           .  " PBO-Modules
* INCLUDE ZRSA17_M03I01                           .  " PAI-Modules
* INCLUDE ZRSA17_M03F01                           .  " FORM-Routines

*SELECT SINGLE pernr ename depid gender
*  FROM ztsa2001
*  INTO gs_emp
*  WHERE pernr = '20220001'.

SELECT *
  FROM ztsa2001
  INTO CORRESPONDING FIELDS OF TABLE gt_emp.

CLEAR : gs_emp.
LOOP AT gt_emp INTO gs_emp.
  CASE gs_emp-gender.
    WHEN '1'.
      gs_emp-gender_t = '남성'.
    WHEN '2'.
      gs_emp-gender_t = '여성'.
  ENDCASE.

  MODIFY gt_emp FROM gs_emp.
  CLEAR gs_emp.
ENDLOOP.

DATA: lt_emp TYPE TABLE OF ts_emp.

lt_emp = gt_emp.

SORT lt_emp BY depid.
DELETE ADJACENT DUPLICATES FROM lt_emp COMPARING depid.
cl_demo_output=>display_data( lt_emp ).
SELECT *
  FROM ztsa2002
  INTO CORRESPONDING FIELDS OF TABLE gt_dep
  FOR ALL ENTRIES IN lt_emp
  WHERE depid = lt_emp-depid.


CLEAR gs_emp.
LOOP AT gt_emp INTO gs_emp.
  READ TABLE gt_dep INTO gs_dep WITH KEY depid = gs_emp-depid.
  gs_emp-phone = gs_dep-phone.
  MODIFY gt_emp FROM gs_emp.
  CLEAR: gs_dep.
ENDLOOP.
CLEAR gs_emp.

cl_demo_output=>display_data( gt_emp ).
