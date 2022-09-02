*&---------------------------------------------------------------------*
*& Include ZC1R170007_TOP                           - Report ZC1R170007
*&---------------------------------------------------------------------*
REPORT zc1r170007 MESSAGE-ID zmcsa17.

TABLES bkpf.

DATA: BEGIN OF gs_data,
        belnr TYPE bseg-belnr, "전표번호
        buzei TYPE bseg-buzei, "전표순번
        blart TYPE bkpf-blart, "전표유형
        budat TYPE bkpf-budat, "전기일자
        shkzg TYPE bseg-shkzg, "차대지시자
        dmbtr TYPE bseg-dmbtr, "전표금액
        waers TYPE bkpf-waers, "통화키
        hkont TYPE bseg-hkont, "G/L 계정
      END OF gs_data,

      gt_data   LIKE TABLE OF gs_data,

      gv_okcode TYPE sy-ucomm.

*      ALV 관련
DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_layo       TYPE lvc_s_layo,
      gs_variant    TYPE disvariant.


DEFINE _clear.
  CLEAR   &1.
  REFRESH &2.
end-OF-DEFINITION.
