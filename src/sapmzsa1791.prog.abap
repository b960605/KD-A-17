*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1790
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1791_top.
*INCLUDE MZSA1790_TOP                            .    " Global Data

INCLUDE mzsa1791_o01.
* INCLUDE MZSA1790_O01                            .  " PBO-Modules
INCLUDE mzsa1791_i01.
* INCLUDE MZSA1790_I01                            .  " PAI-Modules
INCLUDE mzsa1791_f01.
* INCLUDE MZSA1790_F01                            .  " FORM-Routines
LOAD-OF-PROGRAM.
  SELECT carrid carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF TABLE gt_carr.
