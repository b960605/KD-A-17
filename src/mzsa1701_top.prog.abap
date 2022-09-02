*&---------------------------------------------------------------------*
*& Include MZSA1701_TOP                             - Module Pool      SAPMZSA1701
*&---------------------------------------------------------------------*
PROGRAM sapmzsa1701.

"Condition
DATA gv_pno TYPE ztsa0001-pernr.

" Employee Info
*DATA gs_info TYPE zssa1730.
TABLES zssa0031. " TABLES 뒤에는 일반적인 Structure type이 올 수 있음. Structure와 이름이 같은 <변수>가 선언됨.
