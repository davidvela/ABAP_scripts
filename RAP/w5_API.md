# W5 - Service Consumption and Web APIs
1. The Business Scenario
2. Creating the Service Consumption Model
3. Defining the Custom CDS Entity
4. Creating the Implementation Class
5. Enhancing the Flight Model with External Data
6. Creating and Previewing the OData UI Service
7. Creating and Previewing the OData Web API
8. Consuming the Web API with SAP Analytics Cloud -- SAC


## 1 The Business Scenario
parts of master data **Agency** will be read remote back end service.  1:n 
sap odata in sap cloud platform 
adapt existing validation; -> Service Binding -- 
1. download $metada
2. service consumption model -> custom CDS entity -> Implement ABAP class - call remote OData WS
3. enahnce data model -> service definition
unit 7 and 8 -> Web API -> service Binding OData V2 web API => SAP Analytics Cloud - **SAC**

## 2 Creating the Service Consumption Model
service consumption model -- set of artifacts generated in ADT - on the basis of a $metadata or a WSDL file ->provide generic client for remote consumption 
supported procols: OData and SOAP *planned for RFC as well 
EDMX File > service consumption -- planned to be changed to redude amount of repository objects 
develop abap class to test 
**** 
url: https://sapes5.sapdevcenter.com/sap/opu/odata/sap/ZAGENCYCDS_SRV/$metadata

ADT - New repository object -> service consumption model: ZSC_RAP_AGENCY_1234 (OData or Web Sercices)
Service Metadata -> 1 entity generated -> Artifact: ZZ_TRAVEL_AGENCY_ES5 -> Service definition and data definition 
each operation: CRUD sample coded generated
*** 
new abap class: ZCL_CE_RAP_AGENCY_1234 --> custom entity implementation 
* get_entities 
odata client proxy --> create_request_for_read 

## 3 Defining the Custom CDS Entity
Custom entity uses abap class to read the data 
``` @ObjectModel.query.implmentedBy: 'ABAP:ZCL_PROD_VIA_ODATA' ``` 
abap class -> interface: IF_RAP_QUERY_PROVIDER 
custom entities - same level as projection view 
similar to abstract entity 
* new data definition -- template for custom entity with parameters -> remove with parameter statement 

## 4 Creating the Implementation Class ~7m
implement interface: IF_RAP_QUERY_PROVIDER
method: select -- 2 io_request, io_response -- exceptions: cx_rap_query_filter_no_range 
* get_filter()->get_as_ranges()
* response -> set_total and set_data

## 5 Enhancing the Flight Model with External Data ~6m
changes in: travel interface view, travel projection view and behaviour implementation

1. custom entity: no alias for fields in custom entity -> adapt condition in association in the interface view also definition value help
2. change condition in interface view, remove agencyName -- custom entity cannot be used as part of the view. 
3. change validateAgency method  -> get_agencies, AGENCYID 

## 6 Creating and Previewing the OData UI Service ~6m
Test using SAP Fiori UI - preview 
1. change service definition -> ``` expose zce_rap_agency as Agency ``` 
2. preview app  --> double click in agency -- AgencyId 

-- no code files for unit 7 and 8 -> all in the cloud ... 
## 7 Creating and Previewing the OData Web API ~17m
required by services -- 
web apis -- content ids and release and versions 

* new service Binding 
* preview in browser 
* communication arrangement for inbound communications 
    * communication scenario unsing ADT -> inbound serice definition -> roles 
    * communication system -> definition - users 
    * communication users 

exercise
* new service definition -> because you may need different requirements - no need to publish all entities 
* right click projection view -> new service definition -- **ZAPI_RAP_Travel_1234**  ``` expose ZC_RAP ... as travel ``` alias 
* create service binging : ZAPI_RAP_Travel_1234 -> type **Odata V2 - web api** 
-- finish 7:00 
when we use comsuption view - also value help are published // not published additional metadata for the value helps 
supress value help -> different projection layer 

* create communication scenario -> ZCS_TRAVEL_1234
    * Inbound tab: 0001 -- ZAPI_RAP_TRAVEL_1234_IWSG    (Surface Group)
    * publish locally 
* fiori launchpad -- communication Management 
    1. communication user -> user 20 characters -> propose password 
        * CC000002   -- Communication User 
        * CBa2193i21 -- Business Users 
    2. communication system 
        * new -> OPENSAP / OPENSAP --> inbound only check  
        * inbound tab : add communication user
    3. communication arragngements
        * based on communication sceneraio

**test** 
--- 

## 8 Consuming the Web API with SAP Analytics Cloud ~17m
1:00 
No hands on ... functionallities of SAC that are not available in trial version

SAP Analytics Cloud 
* SaaS - Software as a Service; 
* UNIFIED 
* CONNECTED 
* DIGITAL BOARDROOM

--- demo
1. odata coinnection
2. create model 
    * select columns 
    * right side statistics 
    * create model -> files view 
3. model ->data preview  -- data management - often update 
4. create story --> where data comes to life 
    * explore data for reporting, explore and analysis 
    * dimensions -- columns 
    * measures -- total fee total price 
5. copy to new canvas page 
    * add text, picture... 
    * page can have multiple canvas 

top of iceberg of SAC 
ML, algoritms , predictive analytics 


# ZEND -- 
final exam next... 