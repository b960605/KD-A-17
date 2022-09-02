*&---------------------------------------------------------------------*
*& Report ZBC405_ALV_A17_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc405_alv_a17_02top                    .    " Global Data
INCLUDE zbc405_alv_a17_class.
INCLUDE zbc405_alv_a17_02o01                    .  " PBO-Modules
INCLUDE zbc405_alv_a17_02i01                    .  " PAI-Modules
INCLUDE zbc405_alv_a17_02f01                    .  " FORM-Routines

INITIALIZATION.
  gs_vari-report = sy-cprog.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_layo.
  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F' " F4
    CHANGING
      cs_variant  = gs_vari.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_layo = gs_vari-variant.
  ENDIF.

AT SELECTION-SCREEN OUTPUT. " PBO


AT SELECTION-SCREEN.   " PAI

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.
