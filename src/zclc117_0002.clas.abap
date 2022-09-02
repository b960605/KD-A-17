class ZCLC117_0002 definition
  public
  final
  create public .

public section.

  methods GET_MATERIAL_TEXT
    importing
      !PI_MATNR type MARA-MATNR
      !PI_SPRAS type MAKT-SPRAS
    exporting
      !PE_MAKTX type MAKT-MAKTX
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC117_0002 IMPLEMENTATION.


  METHOD get_material_text.

    IF pi_matnr IS INITIAL OR pi_spras IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e01.
      EXIT.
    ENDIF.

    SELECT SINGLE maktx
      INTO pe_maktx
      FROM makt
     WHERE matnr = pi_matnr
       AND spras = pi_spras.

    IF pe_maktx IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e02.
      EXIT.

    ELSE.
      pe_code = 'S'.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
