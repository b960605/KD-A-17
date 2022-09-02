*&---------------------------------------------------------------------*
*& Report ZC1R170006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r170006_top                          .    " Global Data

INCLUDE zc1r170006_c01                          .    " Event Class
INCLUDE zc1r170006_s01                          .    " Selection-Screen
INCLUDE zc1r170006_o01                          .    " PBO-Modules
INCLUDE zc1r170006_i01                          .    " PAI-Modules
INCLUDE zc1r170006_f01                          .    " FORM-Routines

START-OF-SELECTION.

  PERFORM get_flight_info.

  CALL SCREEN '0100'.
