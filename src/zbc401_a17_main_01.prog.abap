*&---------------------------------------------------------------------*
*& Report ZBC401_A17_MAIN_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a17_main_01.

DATA: go_airplane TYPE REF TO zcl_airplane_a17.

CREATE OBJECT go_airplane
  EXPORTING
    iv_name         = 'AA'
    iv_planetype    = '747-400'
  EXCEPTIONS
    wrong_planetype = 1
*   others          = 2
  .
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.


CALL METHOD go_airplane->display_attributes.
CALL METHOD zcl_airplane_a17=>display_n_o_airplanes.

CREATE OBJECT go_airplane
  EXPORTING
    iv_name         = 'LH'
    iv_planetype    = '747-200F'
  EXCEPTIONS
    wrong_planetype = 1
*   others          = 2
  .
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

CALL METHOD go_airplane->display_attributes.
CALL METHOD zcl_airplane_a17=>display_n_o_airplanes.

CREATE OBJECT go_airplane
  EXPORTING
    iv_name         = 'LH Berlin'
    iv_planetype    = 'A321-200'
  EXCEPTIONS
    wrong_planetype = 1
   others          = 2
  .
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

*
CALL METHOD go_airplane->display_attributes.
CALL METHOD zcl_airplane_a17=>display_n_o_airplanes.
