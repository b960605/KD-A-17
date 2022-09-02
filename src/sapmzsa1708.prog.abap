*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1708
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1708_top                            .    " Global Data

INCLUDE mzsa1708_o01                            .  " PBO-Modules
INCLUDE mzsa1708_i01                            .  " PAI-Modules
INCLUDE mzsa1708_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.
  SELECT *
    FROM ztsa1701 UP TO 1 ROWS
    INTO CORRESPONDING FIELDS OF zssa1735.
  ENDSELECT.
