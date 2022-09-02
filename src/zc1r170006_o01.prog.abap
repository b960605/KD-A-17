*&---------------------------------------------------------------------*
*& Include          ZC1R170006_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR  'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYO OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layo OUTPUT.

  PERFORM set_fcat_layo.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_screen OUTPUT.

  PERFORM display_screen.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
  SET PF-STATUS 'S0101'.
  SET TITLEBAR  'T0101'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYO_P_POP OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layo_p_pop OUTPUT.

  PERFORM set_fcat_layo_pop USING gs_layo_p_pop.

  IF gt_fcat_p_pop IS INITIAL.
    PERFORM set_fcat_p_pop USING :
          'X' 'PLANETYPE' ' ' 'SAPLANE' 'PLANETYPE',
          ' ' 'SEATSMAX'  ' ' 'SAPLANE' 'SEATSMAX',
          ' ' 'TANKCAP'   ' ' 'SAPLANE' 'TANKCAP',
          ' ' 'CAP_UNIT'  ' ' 'SAPLANE' 'CAP_UNIT',
          ' ' 'WEIGHT'    ' ' 'SAPLANE' 'WEIGHT',
          ' ' 'WEI_UNIT'  ' ' 'SAPLANE' 'WEI_UNIT',
          ' ' 'PRODUCER'  ' ' 'SAPLANE' 'PRODUCER'.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SCREEN_P_POP OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_screen_p_pop OUTPUT.

  PERFORM display_screen_p_pop.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0102 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0102 OUTPUT.
  SET PF-STATUS 'S0102'.
  SET TITLEBAR  'T0102'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYO_B_POP OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layo_b_pop OUTPUT.

  PERFORM set_fcat_layo_pop USING gs_layo_b_pop.

  IF gt_fcat_b_pop IS INITIAL.
    PERFORM set_fcat_b_pop USING:
          'X' 'CARRID'   ' ' 'SBOOK' 'CARRID',
          'X' 'CONNID'   ' ' 'SBOOK' 'CONNID',
          'X' 'FLDATE'   ' ' 'SBOOK' 'FLDATE',
          'X' 'BOOKID'   ' ' 'SBOOK' 'BOOKID',
          ' ' 'CUSTOMID' ' ' 'SBOOK' 'CUSTOMID',
          ' ' 'CUSTTYPE' ' ' 'SBOOK' 'CUSTTYPE',
          ' ' 'SMOKER'   ' ' 'SBOOK' 'SMOKER'.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SCREEN_B_POP OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_screen_b_pop OUTPUT.

  PERFORM display_screen_b_pop.

ENDMODULE.
