*&---------------------------------------------------------------------*
*& Include          ZC1R170007_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

  CALL METHOD : gcl_grid->free( ), gcl_container->free( ).

  FREE: gcl_grid, gcl_container.

  LEAVE TO SCREEN 0.

ENDMODULE.
