*&---------------------------------------------------------------------*
*& Include ZRSA17_40_TOP                            - Report ZRSA17_40
*&---------------------------------------------------------------------*
REPORT zrsa17_40.
"Student - Dep Info
DATA gs_info TYPE zssa17ex.
DATA gt_info LIKE TABLE OF gs_info.
"Selection Screen
PARAMETERS pa_maj LIKE zssa17ex-depid.
"Variable for using
DATA gv_depnm LIKE gs_info-depnm.
DATA gv_majnm LIKE gs_info-majnm.
