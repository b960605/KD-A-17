*&---------------------------------------------------------------------*
*& Report ZC1R170001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r170001_top                          .    " Global Data

INCLUDE zc1r170001_s01                          .  " Selection Screen
INCLUDE zc1r170001_o01                          .  " PBO-Modules
INCLUDE zc1r170001_i01                          .  " PAI-Modules
INCLUDE zc1r170001_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_param.


START-OF-SELECTION.
  PERFORM get_data.


  CALL SCREEN '0100'.
