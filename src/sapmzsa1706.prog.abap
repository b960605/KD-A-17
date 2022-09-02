*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1705
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1706_top.
*INCLUDE mzsa1705_top                            .    " Global Data

INCLUDE mzsa1706_o01.
*INCLUDE mzsa1705_o01                            .  " PBO-Modules
INCLUDE mzsa1706_i01.
*INCLUDE mzsa1705_i01                            .  " PAI-Modules
INCLUDE mzsa1706_f01.
*INCLUDE mzsa1705_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.
  CLEAR: gv_r1, gv_r2, gv_r3.
  gv_r2 = 'X'.
