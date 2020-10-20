***********************************************************
*     test class template
***********************************************************

CLASS ltcl_spplu DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test1_ok  FOR TESTING RAISING cx_static_check,
      test2_bad FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_spplu IMPLEMENTATION.
  METHOD test1_ok.
    DATA l_result TYPE abap_bool .
    "lt_board = value ty_board( ( x = '0' y = '0' s = '0' ) ( x = '1' y = '0' s = '0' ) ( x = '2' y = '0' s = 'X' )
    "                           ( x = '0' y = '1' s = '0' ) ( x = '1' y = '1' s = 'X' ) ( x = '2' y = '1' s = 'X' )
    "                           ( x = '0' y = '2' s = '0' ) ( x = '1' y = '2' s = '0' ) ( x = '2' y = '2' s = '0' )
    "                          ).
    "ls_cell = lt_board[ x = 1 y = 1 ].
    l_result  = abap_true.

    cl_abap_unit_assert=>assert_equals( msg = 'test1' exp = abap_true    act = l_result ).
  ENDMETHOD.
  METHOD test2_bad.
    DATA l_result TYPE abap_bool .
    l_result  = abap_true.
    cl_abap_unit_assert=>assert_equals( msg = 'test2' exp = abap_false    act = l_result ).
  ENDMETHOD.

ENDCLASS.