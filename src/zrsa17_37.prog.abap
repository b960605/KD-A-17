*&---------------------------------------------------------------------*
*& Report ZRSA17_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_37.

DATA: gs_info TYPE zvsa1702, "Database View( Structure type )
      gt_info LIKE TABLE OF gs_info.

*PARAMETERS pa_dep LIKE gs_info-depnr.

START-OF-SELECTION.
*  SELECT *
*    FROM zvsa1702
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*    WHERE depnr = pa_dep.

  "Database View를 안만들고 OPEN SQL에서 Inner Join을 하는 방법.
*  SELECT *
*    FROM ztsa1701 INNER JOIN ztsa1702
*      ON ztsa1701~depnr = ztsa1702~depnr
**물결을 통해서 조건 설정 / Database View에서 Inner Join을 할때는 mandt도 이어주지만 applicaition에서 Join을 하면 mandt가 자옫ㅇ으로 설정.
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*    WHERE ztsa1701~depnr = pa_dep.

*  SELECT pernr ename a~depnr dphone
*    FROM ztsa1701 AS a INNER JOIN ztsa1702 AS b "AS로 짧게 부를 수 있음.
*    ON a~depnr = b~depnr
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*    WHERE a~depnr = pa_dep.

  SELECT *
    FROM ztsa1701 AS emp LEFT OUTER JOIN ztsa1702 AS dep
    ON emp~depnr = dep~depnr
    INTO CORRESPONDING FIELDS OF TABLE gt_info.

  cl_demo_output=>display_data( gt_info ).
