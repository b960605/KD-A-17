*&---------------------------------------------------------------------*
*& Report ZC1R170005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r170005_top                          .    " Global Data

INCLUDE zc1r170005_s01                          .    " Selection screen
INCLUDE zc1r170005_c01                          .    " Event Class
INCLUDE zc1r170005_o01                          .    " PBO-Modules
INCLUDE zc1r170005_i01                          .    " PAI-Modules
INCLUDE zc1r170005_f01                          .    " FORM-Routines

START-OF-SELECTION.

  PERFORM get_flight_list.
  PERFORM set_carrname.

  CALL SCREEN '0100'.
