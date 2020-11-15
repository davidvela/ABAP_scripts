# W4 - SFLIGHT
levarage existing busines logic: TRAVEL and BOOKING
CRUD operations reused in existing logic like BAPI-like FM 
legacy UI 
**unmanaged scenario** -- similar app to w2 and w3  -> **Brown field scenarios** - existing business legacy code
development flaw similar -> difference in Behaviour definition and Behaviour implementation
Behaviour implementation-> METHOD create. ... CALL function ... 

Index: 
1. The Business Scenario
2. Creating the CDS Data Model
3. Defining and Implementing the Business Object Behavior
4. Creating the Business Object Projection
5. Building and Previewing the OData UI Service

@Andre Fische - SAP GW and CP

# 02 -> CDS Data Model 
existing DB and existing Business Logic
/DMO/FLIGHT_LEGACY -->DB: /DMO/TRAVEL, /DMO/BOOKING  
FM: /DMO/FLIGHT_TRAVEL_CREATE,UPDATE,DELETE,READ, from buffer 
SAVE -> Buffer into DB 

Select table /DMO/TRAVEL -> New Data Definition -> 
* package: /ZRAP_TRAVEL_U_1234
* Interface: ZI_RAP_Travel_U_1234
* new entity -> finished. 
-> Booking table -> package, interface view -> ZI_RAP_... 
... 
association -> parent travel to child booking -> 
``` composition [0..*] of booking ... _Booking ```
root warning -> ``` define root view ... keyword ``` 

# 03 -> Business Object Behaviour 
**Unmanaged** implementation 
Behaviour implementation definition and class, 
CRUD methods 
+ test class -> test Business Objects 

* New Behavior definition and choose Unmanaged 
* BDEF File -> separate behaviour implementation classes for travel and booking 
* ``` lock master and etag master lastchangeddat ``` 
* Mandatory fields --> create booking only possible from travel
* Mapping of fields 
* create missing Control Structures for the mapping 
    * zsrap_booking_x;travel_x with fields **xsdboolean** 
* implement classes
    * zbp_i_rap_travel_w 
        * create -> coding -- 
    * zbp_i_rap_booking_w


# 04 -> Busines Object Projection 
server specific layer -- UI annotations, calculations, defaulting
Fiori UI, stable Web API -> no need UI Annotations 
Web APIS -> Week 5 

CDS interface view -> projection views with CDS V as DS 
* define projection view 
    * customerID = Airline ID 
* metadata Extensions -> UI based annotations from Projection views 
    * select projection definition 2click- (same name) -> 
    * annotate view -> metadata layer core -> 
    * cds view -> ``` @Metadata.allowExtensions: true ```
*  new behaviour projection definition for projection travel 
    * projection - alias; use etag 
* redirected to any parent 

# 05 -> OData UI Service 
service definition and binding 
Fiori elements UI Preview 
* right click in projection view -> new service definition
    * ZUI_RAP_Travel_U_1234
    * ZAPI_RAV_Travel_U_1234 for web API 
* new service binding: 
    * ZUI_RAP_Travel_U_02_1234 
    * 02 - Odata protocol v2
    * activate local service endpoint 
*      





