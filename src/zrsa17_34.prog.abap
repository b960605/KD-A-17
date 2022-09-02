*&---------------------------------------------------------------------*
*& Report ZRSA17_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_34.

PARAMETERS pa_dep TYPE ztsa1702-depnr.

" Dep Info
DATA gs_dep TYPE zssa0011.
DATA gt_dep LIKE TABLE OF gs_dep.

"Emp Info ( Structure Variable )
DATA gs_emp LIKE LINE OF gs_dep-emp_list.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa1702
    INTO CORRESPONDING FIELDS OF gs_dep
    WHERE depnr = pa_dep.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

*  get employee list
*  SELECT *
*    FROM ztsa1701
*    INTO CORRESPONDING FIELDS OF TABLE gs_dep-emp_list
*    WHERE depnr = gs_dep-depnr.

  LOOP AT gs_dep-emp_list INTO gs_emp.

    MODIFY gs_dep-emp_list FROM gs_emp.
    CLEAR gs_emp.
  ENDLOOP.

  cl_demo_output=>display_data( gs_dep-emp_list ).
