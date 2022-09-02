*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1705
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1705_top                            .    " Global Data

INCLUDE mzsa1705_o01                            .  " PBO-Modules
INCLUDE mzsa1705_i01                            .  " PAI-Modules
INCLUDE mzsa1705_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.
perform set_default CHANGING zssa0073.
