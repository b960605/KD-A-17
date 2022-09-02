*&---------------------------------------------------------------------*
*& Report ZRSA17_50
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_50_top                           .    " Global Data

* INCLUDE ZRSA17_50_O01                           .  " PBO-Modules
* INCLUDE ZRSA17_50_I01                           .  " PAI-Modules
INCLUDE zrsa17_50_f01                           .  " FORM-Routines

INITIALIZATION.
  pa_emp = '20220001'.

START-OF-SELECTION.

  SELECT *
    FROM ztsa17pro
    INTO CORRESPONDING FIELDS OF TABLE gt_list
    WHERE pernr = pa_emp.

*  select *
*    from ztsa1701
*    into CORRESPONDING FIELDS OF table gt_dep
*    where depnr =



  LOOP AT gt_list INTO gs_list.
    SELECT SINGLE *
     FROM ztsa1701
     INTO CORRESPONDING FIELDS OF gs_list
     WHERE pernr = gs_list-pernr.

    SELECT SINGLE depnr
      FROM ztsa1702
      INTO CORRESPONDING FIELDS OF gs_list
      WHERE depnr = gs_list-depnr.

    SELECT SINGLE *
      FROM ztsa1702_t
      INTO CORRESPONDING FIELDS OF gs_list
      WHERE depnr = gs_list-depnr AND spras = '3'.

    SELECT SINGLE *
      FROM ztsa17pro_t
      INTO CORRESPONDING FIELDS OF gs_list
      WHERE proid = gs_list-proid AND spras = '3'.

    CASE gs_list-proty.
      WHEN 'C01'.
        gs_list-proty_t = '스낵'.
      WHEN 'C02'.
        gs_list-proty_t = '음료'.
      WHEN 'C03'.
        gs_list-proty_t = '식품'.
    ENDCASE.

    MODIFY gt_list FROM gs_list.
    CLEAR gs_list.
  ENDLOOP.

*  cl_demo_output=>display_data( gt_list ).

  cl_salv_table=>factory(
    IMPORTING r_salv_table = go_salv
    CHANGING t_table = gt_list

  ).
  go_salv->display( ).
