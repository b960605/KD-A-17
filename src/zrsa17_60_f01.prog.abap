*&---------------------------------------------------------------------*
*& Include          ZRSA17_60_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_init .
  pa_car ='AA'.
  pa_con = '0017'.

  CLEAR: so_dat[], so_dat. "앞은 Internal Table, 뒤는 Structure Variable
  so_dat-sign = 'I'. "Include의 약자
  so_dat-option = 'BT'. "low와 high 사이를 담을 것이다.
  so_dat-low = sy-datum - 365.
  so_dat-high = sy-datum.
  APPEND so_dat TO so_dat[]. "Header Line이 있는 Internal Table = APPEND so_dat.
  CLEAR so_dat.
ENDFORM.
