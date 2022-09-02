*&---------------------------------------------------------------------*
*& Report ZRSAMEN10_17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsamen10_17top                         .    " Global Data

INCLUDE zrsamen10_17o01                         .  " PBO-Modules
INCLUDE zrsamen10_17i01                         .  " PAI-Modules
INCLUDE zrsamen10_17f01                         .  " FORM-Routines

INITIALIZATION.
  SELECT kunnr name1
    FROM kna1
    INTO CORRESPONDING FIELDS OF TABLE gt_kna1.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.
