CLASS zws_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zws_dpc
  CREATE PUBLIC .
  PUBLIC SECTION.
  PROTECTED SECTION.
  METHODS: 
      salesorderset_get_entityset REDEFINITION,
      salesorderset_get_entity    REDEFINITION,
      employees_get_entityset     REDEFINITION,
      employees_get_entity        REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.

CLASS ymv_so_tracking_dpc_ext IMPLEMENTATION.
  METHOD salesorderset_get_entityset.
**********************************************************************
* SALES ORDERS - ENTITYSET
**********************************************************************
    IF it_filter_select_options IS NOT INITIAL.
      DATA(ls_filt) = it_filter_select_options[ 1 ].
      SELECT * FROM vbak INTO CORRESPONDING FIELDS OF TABLE et_entityset UP TO 10 ROWS WHERE vkorg IN ls_filt-select_options..
    ELSE.
      SELECT * FROM vbak INTO CORRESPONDING FIELDS OF TABLE et_entityset UP TO 10 ROWS.
    ENDIF.
  ENDMETHOD.

  METHOD salesorderset_get_entity.
**********************************************************************
* SO
**********************************************************************
    DATA l_vbeln TYPE vbeln.
    TRY.
        DATA(l_key) = it_key_tab[ name = 'VBELN'   ]-value .
        l_vbeln = l_key.
        l_vbeln = |{ l_key ALPHA = IN }|.
        SELECT SINGLE * FROM vbak INTO CORRESPONDING FIELDS OF er_entity WHERE vbeln = l_vbeln..
      CATCH cx_root..
    ENDTRY.


  ENDMETHOD.

  METHOD employees_get_entityset.
**********************************************************************
* DUMMY FOR TIMELINE
**********************************************************************
    DATA l_vbeln TYPE vbeln.
    IF it_key_tab IS NOT INITIAL.
      TRY.
          DATA(l_key) = it_key_tab[ name = 'VBELN'   ]-value .
          l_vbeln = l_key.
          l_vbeln = |{ l_key ALPHA = IN }|.
        CATCH cx_root..

      ENDTRY.
    ELSE.
      l_vbeln = '1'.
    ENDIF.

    et_entityset = VALUE #(  ( vbeln = l_vbeln  employeeid = '1' lastname = 'ABC' firstname = 'David' title = 'title' titleofcourtesy = 'Mr' hiredate = '20200101' address = 'asda' city = 'Luzern' notes = 'testahsadjkhsakhasdjk')
                             ( vbeln = l_vbeln  employeeid = '2' lastname = 'asdklsajkl' firstname = 'David' title = 'title' titleofcourtesy = 'Mr' hiredate = '20200101' address = 'asda' city = 'Luzern' notes = 'testahsadjkhsakhasdjk')

                            ).

  ENDMETHOD.

  METHOD employees_get_entity.
**********************************************************************
* DUMMY FOR TIMELINE
**********************************************************************
    er_entity = VALUE #( vbeln = '1'  employeeid = '1' lastname = 'ABC' firstname = 'David' title = 'title' titleofcourtesy = 'Mr' hiredate = '20200101' address = 'asda' city = 'Luzern' notes = 'testahsadjkhsakhasdjk').

  ENDMETHOD..
ENDCLASS.