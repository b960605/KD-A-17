*&---------------------------------------------------------------------*
*& Report ZC1R170004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r170004_top.  " Global Data
INCLUDE zc1r170004_s01.  " Selection Screen
INCLUDE zc1r170004_c01.  " Event Class
INCLUDE zc1r170004_o01.  " PBO-Modules
INCLUDE zc1r170004_i01.  " PAI-Modules
INCLUDE zc1r170004_f01.  " FORM-Routines

INITIALIZATION.

  PERFORM init_get_data.

START-OF-SELECTION.

  PERFORM get_bom_data.

  CALL SCREEN 0100.
