*&---------------------------------------------------------------------*
*& Report ZC1R170008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r170008_top                          .  " Global Data
INCLUDE zc1r170008_c01                          .  " Local Class
INCLUDE zc1r170008_s01                          .  " Selection-screen

INCLUDE zc1r170008_o01                          .  " PBO-Modules
INCLUDE zc1r170008_i01                          .  " PAI-Modules
INCLUDE zc1r170008_f01                          .  " FORM-Routines

START-OF-SELECTION.

  PERFORM get_emp_data.
  PERFORM set_style. " STYLE 세팅하고 LAYOUT에 설정.

  CALL SCREEN '0100'.
