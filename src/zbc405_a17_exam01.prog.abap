*&---------------------------------------------------------------------*
*& Report ZBC405_A17_EXAM01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc405_a17_exam01top                    .    " Global Data
INCLUDE zbc405_a17_exam01_class.
INCLUDE zbc405_a17_exam01o01                    .  " PBO-Modules
INCLUDE zbc405_a17_exam01i01                    .  " PAI-Modules
INCLUDE zbc405_a17_exam01f01                    .  " FORM-Routines

INITIALIZATION.
  SELECT *
    FROM sairport
    INTO TABLE gt_sairp.

  SELECT *
    FROM scarr
    INTO TABLE gt_scarr.

  gs_vari-report = sy-cprog.

  CALL FUNCTION 'LVC_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = 'A'
    CHANGING
      cs_variant = gs_vari.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_layo = gs_vari-variant.
  ENDIF.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_layo.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'
    CHANGING
      cs_variant  = gs_vari.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_layo = gs_vari-variant.
  ENDIF.

AT SELECTION-SCREEN ON pa_layo.
  CHECK pa_layo IS NOT INITIAL.
  gs_vari-report = sy-cprog.
  gs_vari-variant = pa_layo.

  CALL FUNCTION 'LVC_VARIANT_EXISTENCE_CHECK'
    EXPORTING
      i_save        = ' '
    CHANGING
      cs_variant    = gs_vari
    EXCEPTIONS
      wrong_input   = 1
      not_found     = 2
      program_error = 3
      OTHERS        = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE e000(zmcsa17) WITH 'the Variant does not exist.'.
  ENDIF.


AT SELECTION-SCREEN.

START-OF-SELECTION.

  PERFORM get_data.
  IF pa_sel = 'X'.
    CLEAR gt_spfli.
    CALL SCREEN 200.
  ELSE.
    CALL SCREEN 100.
  ENDIF.
