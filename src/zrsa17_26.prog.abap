*&---------------------------------------------------------------------*
*& Report ZRSA17_26
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_26_top                           .    " Global Data

* INCLUDE ZRSA17_26_O01                           .  " PBO-Modules
* INCLUDE ZRSA17_26_I01                           .  " PAI-Modules
INCLUDE zrsa17_26_f01                           .  " FORM-Routines

START-OF-SELECTION.
  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_info
    WHERE carrid = pa_car
    AND connid IN so_con[].

  cl_demo_output=>display_data( gt_info ).
