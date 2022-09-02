*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1704
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1704_top                            .    " Global Data

INCLUDE mzsa1704_o01                            .  " PBO-Modules
INCLUDE mzsa1704_i01                            .  " PAI-Modules
INCLUDE mzsa1704_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.

  SELECT SINGLE pernr
    FROM ztsa1701
    INTO ztsa1701-pernr.
