*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA17VEN.......................................*
TABLES: ZVSA17VEN, *ZVSA17VEN. "view work areas
CONTROLS: TCTRL_ZVSA17VEN
TYPE TABLEVIEW USING SCREEN '0010'.
DATA: BEGIN OF STATUS_ZVSA17VEN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA17VEN.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA17VEN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA17VEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17VEN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA17VEN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA17VEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17VEN_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA17VEN                      .
