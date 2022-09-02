*&---------------------------------------------------------------------*
*& Include YCL117_002_TOP                           - Module Pool      YCL117_002
*&---------------------------------------------------------------------*
PROGRAM YCL117_002 MESSAGE-ID ZMCSA17.

TABLES SCARR.

DATA: OK_CODE  TYPE SY-UCOMM,
      SAVE_OK  TYPE SY-UCOMM,

      GT_SCARR TYPE TABLE OF SCARR.
