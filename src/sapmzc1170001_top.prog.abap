*&---------------------------------------------------------------------*
*& Include SAPMZC1170001_TOP                        - Module Pool      SAPMZC1170001
*&---------------------------------------------------------------------*
PROGRAM sapmzc1170001 MESSAGE-ID zmcsa17.

*tables: ZTSA17_MAR.

DATA: BEGIN OF gs_data,
        matnr TYPE ztsa17_mar-matnr, "Material
        werks TYPE ztsa17_mar-werks, "Plant
        mtart TYPE ztsa17_mar-mtart, "Mat.Type
        matkl TYPE ztsa17_mar-matkl, "Mat.Group
        menge TYPE ztsa17_mar-menge, "Quantity
        meins TYPE ztsa17_mar-meins, "Unit
        dmbtr TYPE ztsa17_mar-dmbtr, "Price
        waers TYPE ztsa17_mar-waers, "Currency
      END OF gs_data,

      gt_data   LIKE TABLE OF gs_data,

      gv_okcode TYPE sy-ucomm.


*     ALV 관련
DATA: gcl_container TYPE REF TO cl_gui_custom_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,

      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant.
