*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSAPLANE_A17...................................*
DATA:  BEGIN OF STATUS_ZTSAPLANE_A17                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSAPLANE_A17                 .
CONTROLS: TCTRL_ZTSAPLANE_A17
            TYPE TABLEVIEW USING SCREEN '0040'.
*...processing: ZVSA17_SCARR....................................*
TABLES: ZVSA17_SCARR, *ZVSA17_SCARR. "view work areas
CONTROLS: TCTRL_ZVSA17_SCARR
TYPE TABLEVIEW USING SCREEN '0020'.
DATA: BEGIN OF STATUS_ZVSA17_SCARR. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA17_SCARR.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA17_SCARR_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA17_SCARR.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17_SCARR_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA17_SCARR_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA17_SCARR.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17_SCARR_TOTAL.

*...processing: ZVSA17_SFLIGHT..................................*
TABLES: ZVSA17_SFLIGHT, *ZVSA17_SFLIGHT. "view work areas
CONTROLS: TCTRL_ZVSA17_SFLIGHT
TYPE TABLEVIEW USING SCREEN '0030'.
DATA: BEGIN OF STATUS_ZVSA17_SFLIGHT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA17_SFLIGHT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA17_SFLIGHT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA17_SFLIGHT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17_SFLIGHT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA17_SFLIGHT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA17_SFLIGHT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17_SFLIGHT_TOTAL.

*...processing: ZVSA17_SPFLI....................................*
TABLES: ZVSA17_SPFLI, *ZVSA17_SPFLI. "view work areas
CONTROLS: TCTRL_ZVSA17_SPFLI
TYPE TABLEVIEW USING SCREEN '0010'.
DATA: BEGIN OF STATUS_ZVSA17_SPFLI. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA17_SPFLI.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA17_SPFLI_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA17_SPFLI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17_SPFLI_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA17_SPFLI_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA17_SPFLI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA17_SPFLI_TOTAL.

*.........table declarations:.................................*
TABLES: *ZTSAPLANE_A17                 .
TABLES: ZTSAPLANE_A17                  .
TABLES: ZTSCARR_A17                    .
TABLES: ZTSFLIGHT_A17                  .
TABLES: ZTSPFLI_A17                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
