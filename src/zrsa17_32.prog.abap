*&---------------------------------------------------------------------*
*& Report ZRSA17_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_32.

"Emp Info
DATA gs_emp TYPE zssa1710.
*data gs_emp type zssa1706.
*data gs_dep type zssa1707.

PARAMETERS pa_pernr LIKE gs_emp-pernr.

INITIALIZATION.
  pa_pernr = '20220001'.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa1701 "Employee Table
    INTO CORRESPONDING FIELDS OF gs_emp
    WHERE pernr = pa_pernr.

  IF gs_emp IS INITIAL.
    "Data is not found
    MESSAGE i001(zmcsa17).
    RETURN.
  ENDIF.
*  cl_demo_output=>display_data( gs_emp ).

  WRITE gs_emp-depnr.
  NEW-LINE.
  WRITE gs_emp-dep-depnr."Nested Structure

  SELECT SINGLE *
    FROM ztsa1702
    INTO gs_emp-dep
    WHERE depnr = gs_emp-depnr.

  cl_demo_output=>display_data( gs_emp-dep ).
