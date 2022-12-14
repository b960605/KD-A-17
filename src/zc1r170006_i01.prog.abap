*&---------------------------------------------------------------------*
*& Include          ZC1R170006_I01
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
*&---------------------------------------------------------------------*
*&      Module  EXIT_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0101 INPUT.

  CALL METHOD : gcl_grid_p_pop->free( ), gcl_container_p_pop->free( ).

  FREE: gcl_grid_p_pop, gcl_container_p_pop.

  LEAVE TO SCREEN 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0102 INPUT.

  CALL METHOD : gcl_grid_b_pop->free( ), gcl_container_b_pop->free( ).

  FREE: gcl_grid_b_pop, gcl_container_b_pop.

  LEAVE TO SCREEN 0.

ENDMODULE.
