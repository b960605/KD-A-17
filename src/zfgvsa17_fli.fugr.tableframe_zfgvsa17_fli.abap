*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZFGVSA17_FLI
*   generation date: 2022.08.23 at 09:33:54
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZFGVSA17_FLI       .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
