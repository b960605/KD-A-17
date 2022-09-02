*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA1703........................................*
TABLES: ZVSA1703, *ZVSA1703. "view work areas
CONTROLS: TCTRL_ZVSA1703
TYPE TABLEVIEW USING SCREEN '0010'.
DATA: BEGIN OF STATUS_ZVSA1703. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1703.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1703_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1703.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1703_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1703_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1703.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1703_TOTAL.

*...processing: ZVSA1704........................................*
TABLES: ZVSA1704, *ZVSA1704. "view work areas
CONTROLS: TCTRL_ZVSA1704
TYPE TABLEVIEW USING SCREEN '0020'.
DATA: BEGIN OF STATUS_ZVSA1704. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1704.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1704_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1704.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1704_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1704_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1704.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1704_TOTAL.

*...processing: ZVSA1799........................................*
TABLES: ZVSA1799, *ZVSA1799. "view work areas
CONTROLS: TCTRL_ZVSA1799
TYPE TABLEVIEW USING SCREEN '0040'.
DATA: BEGIN OF STATUS_ZVSA1799. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA1799.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA1799_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA1799.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1799_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA1799_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA1799.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA1799_TOTAL.

*...processing: ZVSA17PRO.......................................*
TABLES: ZVSA17PRO, *ZVSA17PRO. "view work areas
CONTROLS: TCTRL_ZVSA17PRO
TYPE TABLEVIEW USING SCREEN '0030'.
DATA: BEGIN OF STATUS_ZVSA17PRO. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA17PRO.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA17PRO_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA17PRO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17PRO_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA17PRO_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA17PRO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17PRO_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA1701                       .
TABLES: ZTSA1702                       .
TABLES: ZTSA1702_T                     .
TABLES: ZTSA1799                       .
TABLES: ZTSA17PRO                      .
TABLES: ZTSA17PRO_T                    .
