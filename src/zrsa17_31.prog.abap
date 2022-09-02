*&---------------------------------------------------------------------*
*& Report ZRSA17_31
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_31top                            .    " Global Data

* INCLUDE ZRSA17_31O01                            .  " PBO-Modules
* INCLUDE ZRSA17_31I01                            .  " PAI-Modules
INCLUDE zrsa17_31f01                            .  " FORM-Routines

INITIALIZATION.
  PERFORM set_default USING sy-datum '365'
                      CHANGING pa_ent_b pa_ent_e.

START-OF-SELECTION.
  PERFORM get_data USING pa_ent_b pa_ent_e
                   CHANGING gt_emp.
  IF gt_emp IS INITIAL.
    MESSAGE i016(pn) WITH 'Data is not found!'.
    RETURN.
  ENDIF.

  cl_demo_output=>display_data( gt_emp ).
