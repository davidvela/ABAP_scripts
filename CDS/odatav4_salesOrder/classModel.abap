class zcl_e2e001_odata_v4_so_model definition.  


ENDCLASS. 

class zcl_e2e001_odata_v4_so_model implementation.  

    method /iwbep/if_v4_mp_basic~define.
        define_salesorder( io_model ).
        define_salesorderitem( io_model ).
    endmethod.

    method define_salesorder.
        data: lt_primitive_properties type /iwbep/if_v4_med_element=>ty_t_med_prim_property,
              lo_entity_set           type ref to /iwbep/if_v4_med_entity_set,
              lo_nav_prop             type ref to /iwbep/if_v4_med_nav_prop,
              lo_entity_type          type ref to /iwbep/if_v4_med_entity_type,
              lv_referenced_cds_view  type gty_cds_views-salesorder  . 
              " As internal ABAP name we use the name of the CDS view
    
    
        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "   Create entity type
        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        lo_entity_type = io_model->create_entity_type_by_struct(
                          exporting
                            iv_entity_type_name          = gcs_entity_type_names-internal-salesorder
                            is_structure                 = lv_referenced_cds_view
                            iv_add_conv_to_prim_props    = abap_true
                            iv_add_f4_help_to_prim_props = abap_true
                            iv_gen_prim_props            = abap_true ).
    
        lo_primitive_property = lo_entity_type->get_primitive_property( 'SALESORDER' ).
        lo_primitive_property->set_is_key( ).

        lo_nav_prop = lo_entity_type->create_navigation_property( gcs_nav_prop_names-internal-salesorder_to_items ).
        lo_nav_prop->set_edm_name( gcs_nav_prop_names-edm-salesorder_to_items ).

        lo_nav_prop->set_target_entity_type_name( gcs_entity_type_names-internal-salesorderitem ).
        lo_nav_prop->set_target_multiplicity( /iwbep/if_v4_med_element=>gcs_med_nav_multiplicity-to_many_optional ).
        lo_nav_prop->set_on_delete_action( /iwbep/if_v4_med_element=>gcs_med_on_delete_action-none ).
    


        
    endmethod. 


ENDCLASS. 
 

