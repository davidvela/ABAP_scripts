*&---------------------------------------------------------------------*
*& Report yae_dvt4_glife
*&---------------------------------------------------------------------*
*& Game of Life ... testing + displaying 3x3
*&---------------------------------------------------------------------*
report yae_dvt4_glife.


types:begin of ty_cell,
        x type i,
        y type i,
        s type abap_bool,
      end of ty_cell,
      ty_board type table of ty_cell with non-unique key table_line..


data: gt_board type ty_board,
      gs_cell  type ty_cell.

gs_cell-x = 0. gs_cell-y = 2. gs_cell-s = 'X'.  append gs_cell to gt_board.
gs_cell-x = 1. gs_cell-y = 1. gs_cell-s = 'X'.  append gs_cell to gt_board.  "<---


class game definition.
  public section.
    data i_board type ty_board.
    methods:
      constructor importing board type ty_board,
      is_alive importing cell type ty_cell returning value(r_alive) type abap_bool.

endclass.

class game implementation.
  method is_alive.
    data l_na type i. "neighboars alive

    " if the board contains only the living cells
    "    if ( line_exists( i_board[ x =  cell-x y = cell-y + 1 ]  ) ).
    "    endif.


    if i_board[ x =  cell-x + 1     y = cell-y + 0      ]-s = abap_true. l_na = l_na + 1.  endif.
    if i_board[ x =  cell-x + 1     y = cell-y + 1      ]-s = abap_true. l_na = l_na + 1.  endif.
    if i_board[ x =  cell-x + 0     y = cell-y + 1      ]-s = abap_true. l_na = l_na + 1.  endif.
    if i_board[ x =  cell-x - 1     y = cell-y + 1      ]-s = abap_true. l_na = l_na + 1.  endif.
    if i_board[ x =  cell-x - 1     y = cell-y + 0      ]-s = abap_true. l_na = l_na + 1.  endif.
    if i_board[ x =  cell-x - 1     y = cell-y - 1      ]-s = abap_true. l_na = l_na + 1.  endif.
    if i_board[ x =  cell-x + 0     y = cell-y - 1      ]-s = abap_true. l_na = l_na + 1.  endif.
    if i_board[ x =  cell-x + 1     y = cell-y - 1      ]-s = abap_true. l_na = l_na + 1.  endif.


    " if the board contains all the cells

   "     r_alive = abap_false.
    if l_na < 2 or l_na > 3.
    else.
      case cell-s.
        when abap_true. " Alive
          r_alive = abap_true.
        when abap_false. "death
          if  l_na = 3.
            r_alive = abap_true.
          endif.
      endcase.
    endif.



  endmethod.
  method constructor.
    i_board = board.
  endmethod.

endclass.


class ltcl_game definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      board1 for testing raising cx_static_check,
      board2 for testing raising cx_static_check.
endclass.


class ltcl_game implementation.

  method board1.
    data l_board type string.
    l_board = '000010001'.

    data: lt_board type ty_board,
          ls_cell  type ty_cell.

   "ls_cell  = value ty_cell( x = '1' y = '1' s = 'X' ).
    lt_board = value ty_board( ( x = '0' y = '0' s = '0' ) ( x = '1' y = '0' s = '0' ) ( x = '2' y = '0' s = 'X' )
                               ( x = '0' y = '1' s = '0' ) ( x = '1' y = '1' s = 'X' ) ( x = '2' y = '1' s = '0' )
                               ( x = '0' y = '2' s = '0' ) ( x = '1' y = '2' s = '0' ) ( x = '2' y = '2' s = '0' )
                              ).
    ls_cell = lt_board[ x = 1 y = 1 ].

    "ls_cell-x = 0. ls_cell-y = 0. ls_cell-s = ''.       append ls_cell to lt_board. "0
    "ls_cell-x = 0. ls_cell-y = 1. ls_cell-s = ''.       append ls_cell to lt_board. "1
    "ls_cell-x = 0. ls_cell-y = 2. ls_cell-s = 'X'.      append ls_cell to lt_board. "2
    "ls_cell-x = 1. ls_cell-y = 0. ls_cell-s = ''.       append ls_cell to lt_board. "3
    "ls_cell-x = 1. ls_cell-y = 1. ls_cell-s = 'X'.      append ls_cell to lt_board. "4   <---
    "ls_cell-x = 1. ls_cell-y = 2. ls_cell-s = ''.       append ls_cell to lt_board. "5
    "ls_cell-x = 2. ls_cell-y = 0. ls_cell-s = ''.       append ls_cell to lt_board. "6
    "ls_cell-x = 2. ls_cell-y = 1. ls_cell-s = ''.       append ls_cell to lt_board. "7
    "ls_cell-x = 2. ls_cell-y = 2. ls_cell-s = ''.       append ls_cell to lt_board. "8

    "ls_cell-x = 1. ls_cell-y = 1. ls_cell-s = 'X'.

    data(lo_game) = new game( lt_board ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = abap_false    act = lo_game->is_alive( ls_cell ) ).

  endmethod.


  method board2.
    data l_board type string.
    data: lt_board type ty_board,
          ls_cell  type ty_cell.
    lt_board = value ty_board( ( x = '0' y = '0' s = '0' ) ( x = '1' y = '0' s = '0' ) ( x = '2' y = '0' s = 'X' )
                               ( x = '0' y = '1' s = '0' ) ( x = '1' y = '1' s = 'X' ) ( x = '2' y = '1' s = 'X' )
                               ( x = '0' y = '2' s = '0' ) ( x = '1' y = '2' s = '0' ) ( x = '2' y = '2' s = '0' )
                              ).
    ls_cell = lt_board[ x = 1 y = 1 ].
    data(lo_game) = new game( lt_board ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = abap_true    act = lo_game->is_alive( ls_cell ) ).
  endmethod.



endclass.

 data: lt_board type ty_board,
        ls_cell  type ty_cell.

start-of-selection.

  write 'Game of life'. new-line.


 "case 1
  lt_board = value ty_board(     ( x = '0' y = '0' s = '' ) ( x = '1' y = '0' s = '' )  ( x = '2' y = '0' s = 'X' )
                                 ( x = '0' y = '1' s = '' ) ( x = '1' y = '1' s = 'X' ) ( x = '2' y = '1' s = '' )
                                 ( x = '0' y = '2' s = '' ) ( x = '1' y = '2' s = '' )  ( x = '2' y = '2' s = '' ) ).
 "case 3
  lt_board = value ty_board(     ( x = '0' y = '0' s = 'X' ) ( x = '1' y = '0' s = 'X' ) ( x = '2' y = '0' s = 'X' )
                                 ( x = '0' y = '1' s = 'X' ) ( x = '1' y = '1' s = 'X' ) ( x = '2' y = '1' s = 'X' )
                                 ( x = '0' y = '2' s = 'X' ) ( x = '1' y = '2' s = 'X' ) ( x = '2' y = '2' s = 'X' ) ).
 "case 4
  lt_board = value ty_board(     ( x = '0' y = '0' s = '' )  ( x = '1' y = '0' s = 'X' )  ( x = '2' y = '0' s = 'X' )
                                 ( x = '0' y = '1' s = 'X' ) ( x = '1' y = '1' s = '' )   ( x = '2' y = '1' s = '' )
                                 ( x = '0' y = '2' s = '' )  ( x = '1' y = '2' s = '' )   ( x = '2' y = '2' s = '' ) ).


  sort lt_board by y descending x ascending.
  perform print_board.
            new-line.
            new-line.

  write 'New board'. new-line.
    read table lt_board with key x = 1 y = 1 assigning field-symbol(<fs_c>).
    data(lo_game) = new game( lt_board ).
    <fs_c>-s =  lo_game->is_alive( <fs_c> )  .
    perform print_board.

form print_board.
    loop at lt_board into data(ls_c).
    if ls_cell is initial.
       ls_cell = ls_c.
    else.
        if ls_cell-y <> ls_c-y.
            new-line.
            ls_cell = ls_c.
        endif.
    endif.

   " write ls_c-s && '-'.
    if ls_c-s =  abap_true.
        write '1-'.
    else.
       write '0-'.
    endif.


  endloop.


  endform.