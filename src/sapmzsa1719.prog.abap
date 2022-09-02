*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1719
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1719_top                            .    " Global Data

INCLUDE mzsa1719_o01                            .  " PBO-Modules
INCLUDE mzsa1719_i01                            .  " PAI-Modules
INCLUDE mzsa1719_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.

  SELECT SINGLE *
    FROM ztsa1701
    INTO CORRESPONDING FIELDS OF zssa1734.
