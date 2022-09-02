*&---------------------------------------------------------------------*
*& Include          YCL117_002_F01
*&---------------------------------------------------------------------*
FORM REFRESH_GRID_0100 .

  CHECK GCL_ALV IS BOUND.

  DATA: LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GCL_ALV->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE      = LS_STABLE " 새로고침이 되어도 현재위치에 있을 것이냐
      I_SOFT_REFRESH = SPACE     " SPACE : 설정된 필터나, 정렬정보를 초기화
      " 'X'   : 설정된 필터나 정렬을 유지함.
    EXCEPTIONS
      FINISHED       = 1
      OTHERS         = 2.

ENDFORM.

FORM CREATE_OBJECT_0100 .

  CREATE OBJECT GCL_CON
    EXPORTING
      CONTAINER_NAME              = 'MY_CONTAINER'
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.

  CREATE OBJECT GCL_ALV
    EXPORTING
      I_PARENT          = GCL_CON
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.

ENDFORM.

FORM  SELECT_DATA .

  REFRESH GT_SCARR.

*  RANGES : LR_CARRID   FOR SCARR-CARRID,
*           LR_CARRNAME FOR SCARR-CARRNAME. " Select-option 처럼 이용하기 위해서
*
*  IF SCARR-CARRID IS INITIAL AND SCARR-CARRNAME IS INITIAL.
*
*
*  ELSEIF SCARR-CARRID IS INITIAL.
*
*    LR_CARRNAME-SIGN   = 'I'.
*    LR_CARRNAME-OPTION = 'EQ'.
*    LR_CARRNAME-LOW    = SCARR-CARRNAME.
*    APPEND LR_CARRNAME.
*    CLEAR  LR_CARRNAME.
*
*  ELSEIF SCARR-CARRNAME IS INITIAL.
*
*    LR_CARRID-SIGN = 'I'.
*    LR_CARRID-OPTION = 'EQ'.
*    LR_CARRID-LOW = SCARR-CARRID.
*    APPEND LR_CARRID.
*    CLEAR  LR_CARRID.
*
*  ELSE.
*
*    LR_CARRNAME-SIGN   = 'I'.
*    LR_CARRNAME-OPTION = 'EQ'.
*    LR_CARRNAME-LOW    = SCARR-CARRNAME.
*    APPEND LR_CARRNAME.
*    CLEAR  LR_CARRNAME.
*
*    LR_CARRID-SIGN = 'I'.
*    LR_CARRID-OPTION = 'EQ'.
*    LR_CARRID-LOW = SCARR-CARRID.
*    APPEND LR_CARRID.
*    CLEAR  LR_CARRID.
*
*  ENDIF.

  SELECT *
    FROM SCARR
    WHERE CARRID   IN @s_carrid
      AND CARRNAME IN @s_CARRNM
     INTO TABLE @GT_SCARR.

ENDFORM.

FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.
  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'.
  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.

ENDFORM.

FORM SET_ALV_FIELDCAT_0100 .

  DATA : LT_FCAT TYPE KKBLO_T_FIELDCAT.

  REFRESH GT_FCAT.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID  " Internal table declaration program
*     I_TABNAME              =          " Name of table to be displayed
      I_STRUCNAME            = 'SCARR'
      I_INCLNAME             = SY-REPID
      I_BYPASSING_BUFFER     = ABAP_ON   " Ignore buffer while reading
      I_BUFFER_ACTIVE        = ABAP_OFF
    CHANGING
      CT_FIELDCAT            = LT_FCAT   " Field Catalog with Field Descriptions
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      OTHERS                 = 2.

  IF LT_FCAT[] IS INITIAL.
    MESSAGE E000 WITH 'ALV 필드 카탈로그 구성이 실패했습니다.'.
  ELSE.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        IT_FIELDCAT_KKBLO = LT_FCAT
      IMPORTING
        ET_FIELDCAT_LVC   = GT_FCAT.
  ENDIF.
ENDFORM.

FORM DISPLAY_ALV_0100 .

  CALL METHOD GCL_ALV->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT                     = GS_LAYOUT
    CHANGING
      IT_OUTTAB                     = GT_SCARR
      IT_FIELDCATALOG               = GT_FCAT
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

ENDFORM.
