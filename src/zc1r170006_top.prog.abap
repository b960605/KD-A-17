*&---------------------------------------------------------------------*
*& Include ZC1R170006_TOP                           - Report ZC1R170006
*&---------------------------------------------------------------------*
REPORT zc1r170006 MESSAGE-ID zmcsa17.

TABLES : scarr, sflight.

DATA: BEGIN OF gs_list,
        carrid    TYPE scarr-carrid,
        carrname  TYPE scarr-carrname,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        planetype TYPE sflight-planetype,
        price     TYPE sflight-price,
        currency  TYPE sflight-currency,
        url       TYPE scarr-url,
      END OF gs_list,

      gt_list   LIKE TABLE OF gs_list,

      gv_okcode TYPE sy-ucomm.

*  ALV 관련
DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,

      gs_layo       TYPE lvc_s_layo,
      gt_fcat       TYPE lvc_t_fcat,
      gs_fcat       TYPE lvc_s_fcat,
      gs_variant    TYPE disvariant.

* Plane Info POPUP SCREEN ALV 관련

DATA: gt_plane            TYPE TABLE OF saplane,
      gs_plane            TYPE saplane,

      gcl_container_p_pop TYPE REF TO cl_gui_custom_container,
      gcl_grid_p_pop      TYPE REF TO cl_gui_alv_grid,

      gt_fcat_p_pop       TYPE lvc_t_fcat,
      gs_fcat_p_pop       TYPE lvc_s_fcat,
      gs_layo_p_pop       TYPE lvc_s_layo.

* Booking Info POPUP SCREEN ALV 관련
  data: gt_sbook type TABLE of sbook,
        gs_sbook type sbook,

      gcl_container_b_pop TYPE REF TO cl_gui_custom_container,
      gcl_grid_b_pop      TYPE REF TO cl_gui_alv_grid,

      gt_fcat_b_pop       TYPE lvc_t_fcat,
      gs_fcat_b_pop       TYPE lvc_s_fcat,
      gs_layo_b_pop       TYPE lvc_s_layo.


DEFINE _clear.
  CLEAR   &1.
  REFRESH &1.
end-OF-DEFINITION.
