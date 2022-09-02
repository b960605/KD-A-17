*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1702
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1702_top                         .    " Global Data

INCLUDE mzsa1702_o01                         .  " PBO-Modules
INCLUDE mzsa1702_i01                         .  " PAI-Modules
INCLUDE mzsa1702_f01                         .  " FORM-Routines

LOAD-OF-PROGRAM.
  PERFORM set_default.
