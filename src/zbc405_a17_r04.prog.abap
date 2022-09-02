*&---------------------------------------------------------------------*
*& Report ZBC405_A20_R04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZBC405_A17_R04_TOP.
*INCLUDE zbc405_a20_r04_top                      .    " Global Data

INCLUDE ZBC405_A17_R04_C01.
*INCLUDE zbc405_a20_r04_c01                      .  " Local Class
INCLUDE ZBC405_A17_R04_O01.
*INCLUDE zbc405_a20_r04_o01                      .  " PBO-Modules
INCLUDE ZBC405_A17_R04_I01.
*INCLUDE zbc405_a20_r04_i01                      .  " PAI-Modules
INCLUDE ZBC405_A17_R04_F01.
*INCLUDE zbc405_a20_r04_f01                      .  " FORM-Routines

INITIALIZATION.
  gs_variant-report = sy-cprog.  "=sy-repid.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_var.
  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'
    CHANGING
      cs_variant  = gs_variant.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_var = gs_variant-variant.
  ENDIF.


START-OF-SELECTION.
perform get_data.

call screen 100.
