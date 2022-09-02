*&---------------------------------------------------------------------*
*& Report ZC1R170002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r170002_top                          .    " Global Data
INCLUDE zc1r170002_s01.                          .    " Selection Screen

INCLUDE zc1r170002_o01                          .  " PBO-Modules
INCLUDE zc1r170002_i01                          .  " PAI-Modules
INCLUDE zc1r170002_f01                          .  " FORM-Routines

INITIALIZATION.

  PERFORM init_param.

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN '0100'.
