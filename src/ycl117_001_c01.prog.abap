*&---------------------------------------------------------------------*
*& Include          YCL117_001_C01
*&---------------------------------------------------------------------*

* ---- Container Types
* 1) Custom Container
* 2) Dockcing Container -> 언제든지 어떤 이벤트에 화면을 추가가 가능함.
* 3) Splitter Container -> To split other containers

DATA : gcl_con     TYPE REF TO cl_gui_docking_container,
       gcl_split   TYPE REF TO cl_gui_splitter_container,
       gcl_con_top TYPE REF TO cl_gui_container,             " Spliter의 위에 올 container
       gcl_con_alv TYPE REF TO cl_gui_container,
       gcl_alv     TYPE REF TO cl_gui_alv_grid,

       gs_layout   TYPE lvc_s_layo,
       gt_fcat     TYPE lvc_t_fcat,
       gs_fcat     TYPE lvc_s_fcat,

       gs_variant  TYPE disvariant,
       gv_save. " Variant Save Type
