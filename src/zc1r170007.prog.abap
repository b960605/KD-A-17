*&---------------------------------------------------------------------*
*& Report ZC1R170007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r170007_top                          .    " Global Data
INCLUDE zc1r170007_s01                          .    " Selection Screen
INCLUDE zc1r170007_c01                          .    " Local Class
INCLUDE zc1r170007_o01                          .    " PBO-Modules
INCLUDE zc1r170007_i01                          .    " PAI-Modules
INCLUDE zc1r170007_f01                          .    " FORM-Routines

INITIALIZATION.

  PERFORM init_param.

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN '0100'.
