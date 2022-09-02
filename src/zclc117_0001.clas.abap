class ZCLC117_0001 definition
  public
  final
  create public .

public section.

  methods GET_AIRLINE_INFO
    importing
      !PI_CARRID type SCARR-CARRID
    exporting
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100
    changing
      !ET_AIRLINE type ZC1TT17001 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC117_0001 IMPLEMENTATION.


  METHOD get_airline_info.

    IF pi_carrid IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e01.
      EXIT.
    ENDIF.

    SELECT carrid carrname currcode url
      FROM scarr
      INTO CORRESPONDING FIELDS OF TABLE et_airline
      WHERE carrid = pi_carrid.

    IF et_airline IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e02.
      EXIT.
    ELSE.
      pe_code = 'S'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
