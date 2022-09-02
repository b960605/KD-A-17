*&---------------------------------------------------------------------*
*& Include          YCL117_001_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE textt01.

  SELECT-OPTIONS : s_carrid FOR scarr-carrid,
                   s_carrnm FOR scarr-carrname.

SELECTION-SCREEN END OF BLOCK b1.
