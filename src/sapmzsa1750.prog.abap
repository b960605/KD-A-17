*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1750
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1750_top                            .    " Global Data

INCLUDE mzsa1750_o01                            .  " PBO-Modules
INCLUDE mzsa1750_i01                            .  " PAI-Modules
INCLUDE mzsa1750_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.
  zssa1750-carrid = 'AA'.
  zssa1750-mealno = '00000007'.
  gv_r1 = 'X'.
