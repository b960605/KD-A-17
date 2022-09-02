*&---------------------------------------------------------------------*
*& Include          MZSA1704_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'SEARCH'.
      PERFORM get_data USING ztsa1701-pernr
                       CHANGING ztsa1701.


      DATA: lt_domain TYPE TABLE OF dd07v,
            ls_domain LIKE LINE OF lt_domain.

      CALL FUNCTION 'GET_DOMAIN_VALUES'
        EXPORTING
          domname         = 'ZDGENDER_A17'
*         TEXT            = 'X'
*         FILL_DD07L_TAB  = ' '
        TABLES
          values_tab      = lt_domain
*         VALUES_DD07L    =
        EXCEPTIONS
          no_values_found = 1
          OTHERS          = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      READ TABLE lt_domain WITH KEY domvalue_l = ztsa1701-gender
      INTO ls_domain.

      ztsa1701-gender_t = ls_domain-ddtext.

      SELECT SINGLE *
        FROM ztsa1702
        INTO ztsa1702
        WHERE depnr = ztsa1701-depnr.

      SELECT SINGLE dname
        FROM ztsa1702_t
        INTO CORRESPONDING FIELDS OF ztsa1702_t
        WHERE depnr = ztsa1702-depnr AND spras = sy-langu.

*      CALL SCREEN 200.
*      CLEAR: ztsa1701, ztsa1702_t, ztsa1702.
      IF ztsa1701-ename IS NOT INITIAL.
        SET SCREEN 200.
        LEAVE SCREEN.
      ELSE.
        MESSAGE s000(zmcsa17) WITH 'No Data'.
      ENDIF.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      CLEAR: ztsa1701, ztsa1702_t, ztsa1702.
      LEAVE TO SCREEN 100.
  ENDCASE.
ENDMODULE.
