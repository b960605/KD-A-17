*&---------------------------------------------------------------------*
*& Report ZRSAMEN02_A17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsamen02_a17top                        .    " Global Data
INCLUDE ztsamen02_a17_cl.
INCLUDE zrsamen02_a17o01                        .  " PBO-Modules
INCLUDE zrsamen02_a17i01                        .  " PAI-Modules
INCLUDE zrsamen02_a17f01                        .  " FORM-Routines

INITIALIZATION.
  SELECT carrid carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF TABLE gt_car.

  PERFORM make_fcat.
  PERFORM make_layo.
  PERFORM exclude.

START-OF-SELECTION.
  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_finfo
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_fld.

  LOOP AT gt_finfo INTO gs_finfo.
    READ TABLE gt_car INTO gs_car WITH KEY carrid = gs_finfo-carrid.
    gs_finfo-carrname = gs_car-carrname.
    MODIFY gt_finfo FROM gs_finfo.
    CLEAR: gs_car, gs_finfo.
  ENDLOOP.

  CALL SCREEN 100.
