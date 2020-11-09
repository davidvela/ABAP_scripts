# W3 - SFLIGHT
**Simplified flight data model for this openSAP course**   
01. The Enhanced Business Scenario
02. Defining the Basic Business Object Behavior (BOB)
03. Creating the Business Object Behavior Projection
04. Enhancing the BO Behavior with App-Specific Logic
05. Understanding Entity Manipulation Language (EML)
06. Implementing the Business Object Behavior (ABAP)
07. Enabling the Draft Handling
08. Troubleshooting Your SAP Fiori App

BOB = Busines Object Behaviour 

# 01 Enhance BS
draft enablement => allow end user to store changed data in backend 
CDS Data model -> CDS Behaviour definition -> ABAP Code  -> Auht. Object 
                     CRUD Operations (ABAP), determinations, validations

# 02 Basic BOB Behaviour definition 
ZI_RAP_TRAVEL (Data Definition) -> right click new behaviour Definition. 
identical name as root CDS view. 
Implementation type = Managed! 

``` alias Travel and Booking entities. ``` 
``` persistent table -> DB tables  ```  
``` lock master ``` ``` lock dependent association defined in CDS view```
manage runtime to provide the key 
**optimistic lockling** -> etag master LocalLastChangedAt
mapping information because of alias 

no change in the preview because projection has not been implemented

# 03 BOB Projection Behaviour 
projecting operations CRUD 
right click in consumption root CDS view -> new Behaviour Definition
implementation type = projection (identical name as root CDS V)
1. alias Travel, Booking 
2. use etag
now create, delete and update operations are enabled. 

# 04 EML -- Entity Manipulation Language 
determination, validation or action to BOB Definition
EML 
* extension of ABAP Language (with an SQL like syntax)
* control transactional BO behaviour in RAP context 
* standard EML API (type safe read and modifying access to RAP BO)
* generic EML implementation (generic integration RAP BO into other frameworks)
* Data consistency ensured by database LUW (Commit operation rerquired to persist changes)

01. READ operation - read from transactional buffer, if it's not present -> read DB 
    * specify table of keys 
02. MODIFY - CREATE operation -> changes in trasactional buffer until COMMIT statement is performed (DB)
03. MODIFY DELETE -> delete instances 
04. MODIFY EXECUTE ACTION operation -> execute actions that can change data


## execise 
1. create class: ZCL_RAP_EML_1234 ; desc: EML Test
2. PUBLIC SECTION -> interface: if_oo_adt_classrun. 
3. method: if_oo_adt_classrun~main 
4. steps in ABAP: 
    1. read entities ... ENTITY ... FROM value #( ( TravelUUID = '21312321' ) ) " TRAVEL ID = 000010 
    2. read entities ... ENTITY ...FIELDS you want to read with value #( ( TravelUUID = '21312321' ) ) " TRAVEL ID = 000010 
    3. read entities ... ENTITY ...ALL FIELDS WITH value #( ( TravelUUID = '21312321' ) ) " TRAVEL ID = 000010 
    4. read from associations ENTITY travel BY \Booking
    5. FAILED DATA in case there are errors (NOT FOUND )
    6. MODIFY Update -- > UPDATE SET FIELDS WITH VALUE #( ( XXX )); 6a no commit -> no change; 6b COMMIT ENITTIES ... 
    7. MODIFY create -> new record 
    8. MODIFY Delete
... 


RESULTS DATA(travels)
out->write( travels ).

# 05 Enhancing BOB with App sp. logic   
determination, validation and actions 
Behaviour definition and Behaviour Projection 
1. Behaviour Implementation  ZI --> ``` implementation in class zbp_i_rap_travel/booking unique ``` 
2. field (readonly), mandatory, managed ... 
3. action ( feaures: instance ) acceptTravel result [1] $self; 
4. determination setInitialStatus on modify { create } 
5. determination calculateTotalPrice on modify // on save ... 
6. administrative fields: ``` field (readonly) CreatedBy, LastChangedBy, ... 

Behaviour Implementation
1. project new actions use action accpetTravel 

Open Metadata Extension 
``` lineItem ... new actions  ``` 

# 06 Implementing BPI  Behaviour Pools Implementation 
BEHAVIOUR IMPLEMENTAITON ABAP 
Behaviour Pool
1. MESSAGE CLASS : ZRAP_MSG_1234 // 5 messages 
2. New ABAP Exception Class: ZCM_RAP_1234 RAP Messages, Superclass: CX_STATIC_CHECK  
    * PUBLIC SECTION -> INTERFACE if_abap_behv_message -> add constant for 5 messages ( msgid msgno attr1 attr2 ... )
    * constructor, 
3. Open Behaviour Definition (ZI) -> use wizard to create implementations Classes: ZBP_I_RAP_TRAVEL/BOOKING ...  
    1. Generate local class inherinting from cl_abap_behaviour_handler 
    2. private section -> constants for travel status 
    3. implement acceptTravel method -> MODIFY ENTITIES **IN LOCAL MODE** -- change read-only fields while skipping feature authorization control // return result= $self to the BDEF . 
    4. %tky - transactional key = %key 
    5. CancelTravel 
    6. ValidateAgency -> READ ENTITIES ...  FIELDS ( AgencyID )
    7. validateCustomre ; ValidateDates ... 
    8. calculateTotalPrice -> EXECUTE internalAction=recalcTotalPrice REPORTED DATA(execute_reported)
    9. recalcTotalPrice method -> ... 
    10. get_features  LET is_accepted ... is_rejected
4. ZBP_BOOKING 
    1. CalculateBookingID  -> READ ENTITIES -> 
    2. calculateTotalPrice -> ENTITY TRAVEL recalcTotalPrice ...
5. Authorization Master ; Authorization dependent by _Travel ... 
    1. Add missing authorization method into the class ZBP_TRAVEL... 
    2. Get authorizations FOR AUTHORIZATION 
        1. is_create_granted, is_delete_granted, is_update_granted ... auhorization object create_granted = abap_true. 

DEMO 
create travel, create booking ... error - price is not automatically refresh! 

# 07 Draft Handling 
ENABLERS FOR CLOUD AND MODERN UX 
- Cloud env. expects high availabillity, continous delivery and low TCO _ total cost of ownership 
    * RESTful avoid problematic server stickiness by stroducing a stateless communication 
    * Draft fills the gap between stateless communication and stateful applicatoin 
- MODERN UX REQUIRES MULI-DEVICE SUPPORT and DATA LOSS PREVENTION without connection timeouts 
    * Draft persist the state device-independently in a non=process relevant way 
    * RESTful makes the draft avilable as an addresable resource 
- GUIDING PRINCIPLE 
    * Draft is the persisted transactional buffer 

separate draft tables, persited transactional buffer -- no DB modification until COMMMIT is made
* stateless trasactional app -> EDIT -> SAVE (later - BE saved)
    * impact for end user -> no feedback (message, feautre control) until SAVE is triggered
    * optimistic lock (ETag)
*  fraft enabled app  --> all operations saved at the same time. 
    * impact -> early feedback from calculations, and validations in the BE including feature control 
    * Draft automatically supports data loss preventinon, continuous work and device switch 
    * exclusive lock - not bound to sessions **durable locks**


## exercice: 
CDS Behaviour definition, ABAP Code, Behaviour projection ... 
1. BDEF ZI -> ```with draft``` 
    * specifiy draft table DBs: ```draft table zrap_dtrav_1234```  -> quick fix control 1 ... 
    * association xxx { create, with draft; }
    * lock master total etag LastChnagedAt 
2. BDEF ZC -> projection ``` use draft' ```  use association with draft // disable etag 
3. Behaviour Implementation ABAP 
    * GET_AUTHORIZATIONS -- action Prepare, Edit 

New Filter Editing Status : All, Only Draft ... 

DEMO -- Fiori app with Draft 

# 08 Troubleshooting 
ADT Troubleshooting tools for ABAP
1. ABAP debugger -> Break point 
2. Dynamic Logpoints
3. ABAP Profiling 
4. Gateway Error Log -> ADT reader 
5. Error Log
6. ADT Feed Reader
7. Brower's Debug Console.  (F12 - Network Calls)

ADT Troubleshooting tools for ABAP CDS
1. Data Preview 
2. Dictionary Log -> Activation of CDS views
3. Annotation Propagation  -> annottions 
4. Active Annotations 
5. ACtivation Graph

DEMO: 
* Behaviour implementation class -> acceptTravel Action implementation breakpoint 
* tky - draft and not draft records 
* breakpoint in get_features -> keys -> all active records and then draft records
* variable **F2** -> **info - ABAP Element info**
CDS Views
* Relationship Explorer -> show relationship between entities (link with Editor active)
* open behaviour definition -> open method implementatoin from Relationshiop explorer -> used objects 
Browser F12 button: -> Network -> monitor HTTP request 
* filter odata -> $metadata Status 304 Not modified -> file taken from cache
* 2 file annotations file > XML annotations 
* Go button to perform query -> $batch /// travelPrepare -> acitvate -> getTravel 
ADT 
* travel projection view -> data explorer ->  show entries -> Navigate between association
* show distint values right click // quick filter 
* copy all rows as ABAP value statement -> copy all values in ABAP Syntax
* SQL Console -> define sql statement
Active annotations -> Valid Active annotations; actions, 
 

# end 