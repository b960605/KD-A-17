*&---------------------------------------------------------------------*
*& Report ZRSA17_33
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_33.

PARAMETERS pa_dep TYPE ztsa1702-depnr.

DATA: gt_emp TYPE TABLE OF zssa1706,
      gs_emp LIKE LINE OF gt_emp.

DATA gs_dep TYPE zssa1707.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa1702
    INTO CORRESPONDING FIELDS OF gs_dep
    WHERE depnr = pa_dep.

  cl_demo_output=>display_data( gs_dep ).

  SELECT *
    FROM ztsa1701
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE depnr = gs_dep-depnr.
  cl_demo_output=>display_data( gt_emp ).
