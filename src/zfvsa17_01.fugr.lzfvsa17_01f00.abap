*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSA1703........................................*
FORM GET_DATA_ZVSA1703.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA1701 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA1703 .
ZVSA1703-MANDT =
ZTSA1701-MANDT .
ZVSA1703-PERNR =
ZTSA1701-PERNR .
ZVSA1703-ENAME =
ZTSA1701-ENAME .
ZVSA1703-ENTDT =
ZTSA1701-ENTDT .
ZVSA1703-GENDER =
ZTSA1701-GENDER .
ZVSA1703-DEPNR =
ZTSA1701-DEPNR .
<VIM_TOTAL_STRUC> = ZVSA1703.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA1703 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA1703.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA1703-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1701 WHERE
  PERNR = ZVSA1703-PERNR .
    IF SY-SUBRC = 0.
    DELETE ZTSA1701 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1701 WHERE
  PERNR = ZVSA1703-PERNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA1701.
    ENDIF.
ZTSA1701-MANDT =
ZVSA1703-MANDT .
ZTSA1701-PERNR =
ZVSA1703-PERNR .
ZTSA1701-ENAME =
ZVSA1703-ENAME .
ZTSA1701-ENTDT =
ZVSA1703-ENTDT .
ZTSA1701-GENDER =
ZVSA1703-GENDER .
ZTSA1701-DEPNR =
ZVSA1703-DEPNR .
    IF SY-SUBRC = 0.
    UPDATE ZTSA1701 ##WARN_OK.
    ELSE.
    INSERT ZTSA1701 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA1703-UPD_FLAG,
STATUS_ZVSA1703-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA1703.
  SELECT SINGLE * FROM ZTSA1701 WHERE
PERNR = ZVSA1703-PERNR .
ZVSA1703-MANDT =
ZTSA1701-MANDT .
ZVSA1703-PERNR =
ZTSA1701-PERNR .
ZVSA1703-ENAME =
ZTSA1701-ENAME .
ZVSA1703-ENTDT =
ZTSA1701-ENTDT .
ZVSA1703-GENDER =
ZTSA1701-GENDER .
ZVSA1703-DEPNR =
ZTSA1701-DEPNR .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA1703 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA1703-PERNR TO
ZTSA1701-PERNR .
MOVE ZVSA1703-MANDT TO
ZTSA1701-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA1701'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA1701 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA1701'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZVSA1704........................................*
FORM GET_DATA_ZVSA1704.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA1702 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA1704 .
ZVSA1704-MANDT =
ZTSA1702-MANDT .
ZVSA1704-DEPNR =
ZTSA1702-DEPNR .
ZVSA1704-DPHONE =
ZTSA1702-DPHONE .
    SELECT SINGLE * FROM ZTSA1702_T WHERE
DEPNR = ZTSA1702-DEPNR AND
SPRAS = SY-LANGU .
    IF SY-SUBRC EQ 0.
ZVSA1704-DNAME =
ZTSA1702_T-DNAME .
    ENDIF.
<VIM_TOTAL_STRUC> = ZVSA1704.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA1704 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA1704.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA1704-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1702 WHERE
  DEPNR = ZVSA1704-DEPNR .
    IF SY-SUBRC = 0.
    DELETE ZTSA1702 .
    ENDIF.
    DELETE FROM ZTSA1702_T WHERE
    DEPNR = ZTSA1702-DEPNR .
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1702 WHERE
  DEPNR = ZVSA1704-DEPNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA1702.
    ENDIF.
ZTSA1702-MANDT =
ZVSA1704-MANDT .
ZTSA1702-DEPNR =
ZVSA1704-DEPNR .
ZTSA1702-DPHONE =
ZVSA1704-DPHONE .
    IF SY-SUBRC = 0.
    UPDATE ZTSA1702 ##WARN_OK.
    ELSE.
    INSERT ZTSA1702 .
    ENDIF.
    SELECT SINGLE FOR UPDATE * FROM ZTSA1702_T WHERE
    DEPNR = ZTSA1702-DEPNR AND
    SPRAS = SY-LANGU .
      IF SY-SUBRC <> 0.   "insert preprocessing: init WA
        CLEAR ZTSA1702_T.
ZTSA1702_T-DEPNR =
ZTSA1702-DEPNR .
ZTSA1702_T-SPRAS =
SY-LANGU .
      ENDIF.
ZTSA1702_T-DNAME =
ZVSA1704-DNAME .
    IF SY-SUBRC = 0.
    UPDATE ZTSA1702_T ##WARN_OK.
    ELSE.
    INSERT ZTSA1702_T .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA1704-UPD_FLAG,
STATUS_ZVSA1704-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA1704.
  SELECT SINGLE * FROM ZTSA1702 WHERE
DEPNR = ZVSA1704-DEPNR .
ZVSA1704-MANDT =
ZTSA1702-MANDT .
ZVSA1704-DEPNR =
ZTSA1702-DEPNR .
ZVSA1704-DPHONE =
ZTSA1702-DPHONE .
    SELECT SINGLE * FROM ZTSA1702_T WHERE
DEPNR = ZTSA1702-DEPNR AND
SPRAS = SY-LANGU .
    IF SY-SUBRC EQ 0.
ZVSA1704-DNAME =
ZTSA1702_T-DNAME .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVSA1704-DNAME .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA1704 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA1704-DEPNR TO
ZTSA1702-DEPNR .
MOVE ZVSA1704-MANDT TO
ZTSA1702-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA1702'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA1702 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA1702'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

MOVE ZTSA1702-DEPNR TO
ZTSA1702_T-DEPNR .
MOVE SY-LANGU TO
ZTSA1702_T-SPRAS .
MOVE ZVSA1704-MANDT TO
ZTSA1702_T-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA1702_T'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA1702_T TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA1702_T'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZVSA1799........................................*
FORM GET_DATA_ZVSA1799.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA1799 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA1799 .
ZVSA1799-MANDT =
ZTSA1799-MANDT .
ZVSA1799-LIFNR =
ZTSA1799-LIFNR .
ZVSA1799-LAND1 =
ZTSA1799-LAND1 .
ZVSA1799-NAME1 =
ZTSA1799-NAME1 .
ZVSA1799-NAME2 =
ZTSA1799-NAME2 .
ZVSA1799-VENCA =
ZTSA1799-VENCA .
ZVSA1799-CARRID =
ZTSA1799-CARRID .
ZVSA1799-MEALNUMBER =
ZTSA1799-MEALNUMBER .
ZVSA1799-PRICE =
ZTSA1799-PRICE .
ZVSA1799-WAERS =
ZTSA1799-WAERS .
<VIM_TOTAL_STRUC> = ZVSA1799.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA1799 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA1799.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA1799-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1799 WHERE
  LIFNR = ZVSA1799-LIFNR .
    IF SY-SUBRC = 0.
    DELETE ZTSA1799 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA1799 WHERE
  LIFNR = ZVSA1799-LIFNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA1799.
    ENDIF.
ZTSA1799-MANDT =
ZVSA1799-MANDT .
ZTSA1799-LIFNR =
ZVSA1799-LIFNR .
ZTSA1799-LAND1 =
ZVSA1799-LAND1 .
ZTSA1799-NAME1 =
ZVSA1799-NAME1 .
ZTSA1799-NAME2 =
ZVSA1799-NAME2 .
ZTSA1799-VENCA =
ZVSA1799-VENCA .
ZTSA1799-CARRID =
ZVSA1799-CARRID .
ZTSA1799-MEALNUMBER =
ZVSA1799-MEALNUMBER .
ZTSA1799-PRICE =
ZVSA1799-PRICE .
ZTSA1799-WAERS =
ZVSA1799-WAERS .
    IF SY-SUBRC = 0.
    UPDATE ZTSA1799 ##WARN_OK.
    ELSE.
    INSERT ZTSA1799 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA1799-UPD_FLAG,
STATUS_ZVSA1799-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA1799.
  SELECT SINGLE * FROM ZTSA1799 WHERE
LIFNR = ZVSA1799-LIFNR .
ZVSA1799-MANDT =
ZTSA1799-MANDT .
ZVSA1799-LIFNR =
ZTSA1799-LIFNR .
ZVSA1799-LAND1 =
ZTSA1799-LAND1 .
ZVSA1799-NAME1 =
ZTSA1799-NAME1 .
ZVSA1799-NAME2 =
ZTSA1799-NAME2 .
ZVSA1799-VENCA =
ZTSA1799-VENCA .
ZVSA1799-CARRID =
ZTSA1799-CARRID .
ZVSA1799-MEALNUMBER =
ZTSA1799-MEALNUMBER .
ZVSA1799-PRICE =
ZTSA1799-PRICE .
ZVSA1799-WAERS =
ZTSA1799-WAERS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA1799 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA1799-LIFNR TO
ZTSA1799-LIFNR .
MOVE ZVSA1799-MANDT TO
ZTSA1799-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA1799'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA1799 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA1799'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZVSA17PRO.......................................*
FORM GET_DATA_ZVSA17PRO.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA17PRO WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA17PRO .
ZVSA17PRO-MANDT =
ZTSA17PRO-MANDT .
ZVSA17PRO-PROID =
ZTSA17PRO-PROID .
ZVSA17PRO-PROTY =
ZTSA17PRO-PROTY .
ZVSA17PRO-OPRICE =
ZTSA17PRO-OPRICE .
ZVSA17PRO-WAERS =
ZTSA17PRO-WAERS .
ZVSA17PRO-PERNR =
ZTSA17PRO-PERNR .
    SELECT SINGLE * FROM ZTSA17PRO_T WHERE
PROID = ZTSA17PRO-PROID AND
SPRAS = SY-LANGU .
    IF SY-SUBRC EQ 0.
ZVSA17PRO-PRONM =
ZTSA17PRO_T-PRONM .
    ENDIF.
<VIM_TOTAL_STRUC> = ZVSA17PRO.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA17PRO .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA17PRO.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA17PRO-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA17PRO WHERE
  PROID = ZVSA17PRO-PROID .
    IF SY-SUBRC = 0.
    DELETE ZTSA17PRO .
    ENDIF.
    DELETE FROM ZTSA17PRO_T WHERE
    PROID = ZTSA17PRO-PROID .
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA17PRO WHERE
  PROID = ZVSA17PRO-PROID .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA17PRO.
    ENDIF.
ZTSA17PRO-MANDT =
ZVSA17PRO-MANDT .
ZTSA17PRO-PROID =
ZVSA17PRO-PROID .
ZTSA17PRO-PROTY =
ZVSA17PRO-PROTY .
ZTSA17PRO-OPRICE =
ZVSA17PRO-OPRICE .
ZTSA17PRO-WAERS =
ZVSA17PRO-WAERS .
ZTSA17PRO-PERNR =
ZVSA17PRO-PERNR .
    IF SY-SUBRC = 0.
    UPDATE ZTSA17PRO ##WARN_OK.
    ELSE.
    INSERT ZTSA17PRO .
    ENDIF.
    SELECT SINGLE FOR UPDATE * FROM ZTSA17PRO_T WHERE
    PROID = ZTSA17PRO-PROID AND
    SPRAS = SY-LANGU .
      IF SY-SUBRC <> 0.   "insert preprocessing: init WA
        CLEAR ZTSA17PRO_T.
ZTSA17PRO_T-PROID =
ZTSA17PRO-PROID .
ZTSA17PRO_T-SPRAS =
SY-LANGU .
      ENDIF.
ZTSA17PRO_T-PRONM =
ZVSA17PRO-PRONM .
    IF SY-SUBRC = 0.
    UPDATE ZTSA17PRO_T ##WARN_OK.
    ELSE.
    INSERT ZTSA17PRO_T .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA17PRO-UPD_FLAG,
STATUS_ZVSA17PRO-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA17PRO.
  SELECT SINGLE * FROM ZTSA17PRO WHERE
PROID = ZVSA17PRO-PROID .
ZVSA17PRO-MANDT =
ZTSA17PRO-MANDT .
ZVSA17PRO-PROID =
ZTSA17PRO-PROID .
ZVSA17PRO-PROTY =
ZTSA17PRO-PROTY .
ZVSA17PRO-OPRICE =
ZTSA17PRO-OPRICE .
ZVSA17PRO-WAERS =
ZTSA17PRO-WAERS .
ZVSA17PRO-PERNR =
ZTSA17PRO-PERNR .
    SELECT SINGLE * FROM ZTSA17PRO_T WHERE
PROID = ZTSA17PRO-PROID AND
SPRAS = SY-LANGU .
    IF SY-SUBRC EQ 0.
ZVSA17PRO-PRONM =
ZTSA17PRO_T-PRONM .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVSA17PRO-PRONM .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA17PRO USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA17PRO-PROID TO
ZTSA17PRO-PROID .
MOVE ZVSA17PRO-MANDT TO
ZTSA17PRO-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA17PRO'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA17PRO TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA17PRO'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

MOVE ZTSA17PRO-PROID TO
ZTSA17PRO_T-PROID .
MOVE SY-LANGU TO
ZTSA17PRO_T-SPRAS .
MOVE ZVSA17PRO-MANDT TO
ZTSA17PRO_T-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA17PRO_T'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA17PRO_T TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA17PRO_T'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
