*&---------------------------------------------------------------------*
*& Include          MZSA1790_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      " Get Airline Name
      READ TABLE gt_carr WITH KEY carrid = zssa1790-carrid INTO gs_carr.
      zssa1790-carrname = gs_carr-carrname.


      " Get Meal Name
      PERFORM get_meal_text USING zssa1790-mealnumber
                                  zssa1790-carrid
                                  sy-langu
                            CHANGING zssa1790-mealnumber_t.


    WHEN 'SEARCH'.

      " Get Meal Info
      PERFORM get_meal_info USING zssa1790-carrid
                                  zssa1790-mealnumber
                                  sy-langu
                            CHANGING zssa1791.
      " Get Vendor Info
      PERFORM get_vendor_info USING 'M'
                                    zssa1790-carrid
                                    zssa1790-mealnumber
                              CHANGING zssa1792.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
