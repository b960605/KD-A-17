*&---------------------------------------------------------------------*
*& Include          YCL117_001_F01
*&---------------------------------------------------------------------*
FORM SET_TEXT .

  TEXTT01 = 'Condition'.

ENDFORM.

FORM SELECT_DATA .

  REFRESH GT_SCARR. " Internal Table의 내용을 초기화 ( Header-line table은 clear 쓰면 header-line이 초기화 돼버림 ).

  SELECT *
    FROM SCARR
   WHERE CARRID   IN @S_CARRID
     AND CARRNAME IN @S_CARRNM
    INTO TABLE @GT_SCARR.
  " 신문법에서는 필드 간 계산이 가능하다
  " 신문법에서는 select case when ~~~ then ~~~ else ~~~ end -> 식의 SQL이 가능하다

  IF GT_SCARR IS INITIAL.
    MESSAGE S001.
    LEAVE LIST-PROCESSING.
  ENDIF.

  SORT GT_SCARR BY CARRID.

ENDFORM.

FORM DISPLAY_SCREEN_0100 .

  CREATE OBJECT GCL_CON
    EXPORTING
      REPID                       = SY-REPID         " Report to Which This Docking Control is Linked
      DYNNR                       = SY-DYNNR         " Screen to Which This Docking Control is Linked
      EXTENSION                   = 3000             " Control Extension
    EXCEPTIONS
      CNTL_ERROR                  = 1                " Invalid Parent Control
      CNTL_SYSTEM_ERROR           = 2                " System Error
      CREATE_ERROR                = 3                " Create Error
      LIFETIME_ERROR              = 4                " Lifetime Error
      LIFETIME_DYNPRO_DYNPRO_LINK = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6.

  CREATE OBJECT GCL_SPLIT
    EXPORTING
      PARENT            = GCL_CON            " 나눌 Container를 지정한다
      ROWS              = 2                  " Number of Rows to be displayed
      COLUMNS           = 1                  " Number of Columns to be Displayed
    EXCEPTIONS
      CNTL_ERROR        = 1                  " See Superclass
      CNTL_SYSTEM_ERROR = 2                  " See Superclass
      OTHERS            = 3.

  GCL_SPLIT->SET_ROW_HEIGHT(
    EXPORTING
      ID                = 1                " Row ID
      HEIGHT            = 10               " Height
    EXCEPTIONS
      CNTL_ERROR        = 1                " See CL_GUI_CONTROL
      CNTL_SYSTEM_ERROR = 2                " See CL_GUI_CONTROL
      OTHERS            = 3
  ).

  GCL_CON_TOP = GCL_SPLIT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GCL_CON_ALV = GCL_SPLIT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).

*--------------- 바로위의 방식을 이렇게도 쓸 수 있음 -------------------------
*    gcl_con_top = gcl_split->get_container(
*        EXPORTING
*          row       = 1                " Row
*          column    = 1                " Column
**    RECEIVING
**      container =                  " Container
*      ).
*------------------------------------------------------------------------------
*    gcl_split->get_container(
*      EXPORTING
*        row       = 1                 " Row
*        column    = 1                " Column
*      RECEIVING
*        container = gcl_con_top                 " Container
*    ).
*------------------------------------------------------------------------------

  CREATE OBJECT GCL_ALV
    EXPORTING
      I_PARENT          = GCL_CON_ALV      " Parent Container
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1                " Error when creating the control
      ERROR_CNTL_INIT   = 2                " Error While Initializing Control
      ERROR_CNTL_LINK   = 3                " Error While Linking Control
      ERROR_DP_CREATE   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.

*--------------- 바로위의 방식을 이렇게도 쓸 수 있음 -------------------------
*    gcl_alv = new cl_gui_alv_grid( I_PARENT = gcl_con_alv ).
*    gcl_alv = new #( I_PARENT = gcl_con_alv ).
*------------------------------------------------------------------------------
ENDFORM.

FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA      = ABAP_ON.
  GS_LAYOUT-SEL_MODE   = 'D'. " A->행열선택 B->단일행선택 C->복수행 D->셀단위까지
  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.

ENDFORM.

FORM SET_ALV_FCAT_0100 .

  DATA LT_FCAT TYPE KKBLO_T_FIELDCAT.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID          " Internal table declaration program
*     i_tabname              = 'GS_SCARR'       " structure가 들어가야함
      I_STRUCNAME            = 'SCARR'
      I_INCLNAME             = SY-REPID
      I_BYPASSING_BUFFER     = ABAP_ON           " 버퍼를 무시한다 ( 메모리에서 값을 불러오지 않는다 )
      I_BUFFER_ACTIVE        = ABAP_OFF          " 가져온 값을 메모리에 저장하지 않을 것
    CHANGING
      CT_FIELDCAT            = LT_FCAT           " Field Catalog with Field Descriptions
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      OTHERS                 = 2.

  IF LT_FCAT IS NOT INITIAL.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO' " KKBLO 에서 LVC로 전환하겠다. Conversion 과정
      EXPORTING
        IT_FIELDCAT_KKBLO = LT_FCAT
      IMPORTING
        ET_FIELDCAT_LVC   = GT_FCAT
      EXCEPTIONS
        IT_DATA_MISSING   = 1
        OTHERS            = 2.
*    MOVE-CORRESPONDING lt_fcat TO gt_fcat.
  ELSE.
    MESSAGE E001 WITH '필드 카탈로그 구성 중 오류가 발생했습니다.'.
  ENDIF.
ENDFORM.

FORM DISPLAY_ALV_0100 .

  CALL METHOD GCL_ALV->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT                     = GS_LAYOUT        " Layout
    CHANGING
      IT_OUTTAB                     = GT_SCARR[]       " Output Table
      IT_FIELDCATALOG               = GT_FCAT[]        " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1  " Wrong Parameter
      PROGRAM_ERROR                 = 2  " Program Errors
      TOO_MANY_LINES                = 3  " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.

ENDFORM.
