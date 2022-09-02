*&---------------------------------------------------------------------*
*& Include          MZSA1750_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'ENTER'.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      " Search by Meal
      IF gv_r1 = 'X'.
        CLEAR: zssa1752, zssa1751, zssa1750-lifnr.

        " Flight Meal Info
        PERFORM get_meal_info USING zssa1750-carrid
                                    zssa1750-mealno
                                    zssa1751-carrid
                                    zssa1751-mealnumber
                                    sy-langu
                              CHANGING zssa1751.

        IF zssa1751-text IS INITIAL.
          MESSAGE i016(pn) WITH 'No Data is found.'.
          CLEAR zssa1751.
          RETURN.
        ENDIF.

        PERFORM get_domain USING 'S_MEALTYPE'
                                 zssa1751-mealtype
                           CHANGING zssa1751-mtext.


        " Vendor Info
        PERFORM get_vendor_info USING zssa1751-lifnr
                                      zssa1752-land1
                                      sy-langu
                                CHANGING zssa1752.

        PERFORM get_domain USING 'ZDVENCA_A17'
                                 zssa1752-venca
                           CHANGING zssa1752-vtext.
        " Search by Vendor
      ELSEIF gv_r2 = 'X'.
        CLEAR: zssa1752, zssa1751, zssa1750-carrid, zssa1750-mealno.

        " Get Meal Info
        PERFORM get_meal_data USING zssa1750-lifnr
                              CHANGING zssa1751-mealnumber.
        SELECT SINGLE *
          FROM ztsa17ven
          INTO CORRESPONDING FIELDS OF zssa1751
          WHERE lifnr = zssa1750-lifnr.

        SELECT SINGLE mealtype
          FROM smeal
          INTO zssa1751-mealtype
          WHERE carrid = zssa1751-carrid.

        SELECT SINGLE text
          FROM smealt
          INTO zssa1751-text
          WHERE carrid = zssa1751-carrid.

        PERFORM get_domain USING 'S_MEALTYPE'
                                 zssa1751-mealtype
                 CHANGING zssa1751-mtext.

        IF zssa1751-text IS INITIAL.
          MESSAGE i016(pn) WITH 'No Data is found.'.
          CLEAR zssa1751.
          RETURN.
        ENDIF.



        " Get Vendor Info
        SELECT SINGLE *
          FROM ztsa17ven
          INTO CORRESPONDING FIELDS OF zssa1752
          WHERE lifnr = zssa1750-lifnr.

        PERFORM get_domain USING 'ZDVENCA_A17'
                                  zssa1752-venca
                   CHANGING zssa1752-vtext.
        SELECT SINGLE landx
          FROM t005t
          INTO zssa1752-landx
          WHERE land1 = zssa1752-land1
          AND spras = sy-langu.



      ENDIF.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_AIRLINE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_airline INPUT.
  IF zssa1750-carrid = 'AB'.
    MESSAGE e016(pn) WITH 'Data is not found!'.
  ENDIF.
ENDMODULE.
