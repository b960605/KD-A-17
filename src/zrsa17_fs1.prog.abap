*&---------------------------------------------------------------------*
*& Report ZRSA17_FS1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ztsa17_fs1top                           .    " Global Data

INCLUDE ztsa17_fs1o01                           .  " PBO-Modules
INCLUDE ztsa17_fs1i01                           .  " PAI-Modules
INCLUDE ztsa17_fs1f01                           .  " FORM-Routines

INITIALIZATION.
  SELECT *
    FROM ztspfli_t03
    INTO TABLE gt_spfli
    WHERE carrid IN so_car
    AND   connid IN so_con.

START-OF-SELECTION.

  CALL FUNCTION 'NAMETAB_GET'
    EXPORTING
      langu          = sy-langu
*     ONLY           = ' '
      tabname        = 'ZTSPFLI_T03'
* IMPORTING
*     HEADER         =
*     RC             =
    TABLES
      nametab        = gt_nametab
    EXCEPTIONS
      internal_error = 1
*     TABLE_HAS_NO_FIELDS       = 2
*     TABLE_NOT_ACTIV           = 3
*     NO_TEXTS_FOUND = 4
*     OTHERS         = 5
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_nametab INTO gs_nametab WHERE fieldname NE 'MANDT'.
    gs_fcat-fieldname = gs_nametab-fieldname.
    gs_fcat-ref_table = 'ZTSPFLI_T03'.
    gs_fcat-ref_field = gs_nametab-fieldname.
    gs_fcat-coltext = gs_nametab-fieldname.
    gs_fcat-col_opt = 'X'.
    IF gs_nametab-fieldname(3) CS 'WTG'.
      gs_fcat-cfieldname = gs_nametab-reffield.
    ENDIF.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
  ENDLOOP.
  IF sy-subrc = 0.
    gs_fcat-fieldname = 'SUM'.
    gs_fcat-cfieldname = 'WAERS'.
    gs_fcat-coltext = 'Sum Amount'.
    gs_fcat-col_pos = 24.
    APPEND gs_fcat TO gt_fcat.
  ENDIF.

  LOOP AT gt_spfli INTO gs_spfli.

    LOOP AT gt_fcat ASSIGNING <lf>.
      IF <lf>-fieldname CS 'WTG'.
        ASSIGN COMPONENT <lf>-fieldname OF STRUCTURE gs_spfli TO <fs>.
        gs_spfli-sum = gs_spfli-sum + <fs>.
      ENDIF.
    ENDLOOP.
    MODIFY gt_spfli FROM gs_spfli.
  ENDLOOP.

*  LOOP AT gt_spfli INTO gs_spfli.
*    CLEAR: nn, fname.
*    DO 7 TIMES.
*      nn = nn + 1.
*      CONCATENATE 'GS_SPFLI-WTG' nn INTO fname.
*      CONDENSE fname.
*
*      ASSIGN (fname) TO <fs>.
*      gs_spfli-sum = gs_spfli-sum + <fs>.
*    ENDDO.
*
*    MODIFY gt_spfli FROM gs_spfli.
*    CLEAR gs_spfli.
*  ENDLOOP.

  CALL SCREEN 100.
