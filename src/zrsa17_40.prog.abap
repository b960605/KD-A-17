*&---------------------------------------------------------------------*
*& Report ZRSA17_40
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa17_40_top                           .    " Global Data

* INCLUDE ZRSA17_40_O01                           .  " PBO-Modules
* INCLUDE ZRSA17_40_I01                           .  " PAI-Modules
INCLUDE zrsa17_40_f01                           .  " FORM-Routines

INITIALIZATION.
  pa_maj = 'D220101'.

START-OF-SELECTION.
  SELECT *
    FROM ztsa17std
    INTO CORRESPONDING FIELDS OF TABLE gt_info
    WHERE depid = pa_maj.

  SELECT SINGLE depnm
    FROM ztsa17dep
    INTO gv_depnm
    WHERE depid = pa_maj.

  SELECT SINGLE majnm
    FROM ztsa17dep_t
    INTO gv_majnm
    WHERE depid = pa_maj AND spras = 'E'.


  LOOP AT gt_info INTO gs_info.
    gs_info-depnm = gv_depnm.
    gs_info-majnm = gv_majnm.

    CASE gs_info-depnm.
      WHEN 'G01'.
        gs_info-depnm_t = '경상대'.
      WHEN 'G02'.
        gs_info-depnm_t = '공과대'.
      WHEN 'G03'.
        gs_info-depnm_t = '교육대'.
    ENDCASE.

    CASE gs_info-gender.
      WHEN '1'.
        gs_info-gender_t = '남성'.
      WHEN '2'.
        gs_info-gender_t = '여성'.
    ENDCASE.
    MODIFY gt_info FROM gs_info.
    CLEAR gs_info.
  ENDLOOP.

  IF sy-subrc = 0.
    cl_demo_output=>display_data( gt_info ).
  ELSE.
    MESSAGE i016(pn) WITH 'Data is not found'.
    RETURN.
  ENDIF.
