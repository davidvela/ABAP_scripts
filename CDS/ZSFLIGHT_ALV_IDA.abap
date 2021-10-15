*&---------------------------------------------------------------------*
*& Report yac_dvt_sflight_alv_ida
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yac_dvt_sflight_alv_ida.

CLASS lcl_main DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_main.
    METHODS run.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT r_result.
  ENDMETHOD.
  METHOD run.
    cl_salv_gui_table_ida=>create_for_cds_view('YAC_DVT_SFLIGHT')->fullscreen( )->display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

select * from YAC_DVT_SFLIGHT where carrid = 'AA' 
into table @data(lt_table)  up to 4 rows .
"offset 2. cannot be used in 750, only 751 or 753

BREAK-POINT. 


  lcl_main=>create( )->run( ).