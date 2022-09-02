class ZCL_IM_BC425IM_A17 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_BOOK17 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BC425IM_A17 IMPLEMENTATION.


  method IF_EX_BADI_BOOK17~CHANGE_VLINE.
    c_pos = c_pos + 27.
  endmethod.


  METHOD if_ex_badi_book17~output.
    DATA gv_name TYPE scustom-name.

    SELECT name
      FROM scustom
      INTO gv_name
      WHERE id = i_booking-customid.
    ENDSELECT.

    WRITE: gv_name, i_booking-order_date.
  ENDMETHOD.
ENDCLASS.
