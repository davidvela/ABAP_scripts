# SFLIGHT
**Simplified flight data model for this openSAP course**
    
01. The Business Scenario
02. Creating the Database Tables
03. Creating the Core Data Services (CDS) Data Model
04. Defining the CDS Data Model Projection 
05. Enriching the Projected Data Model with UI Metadata
06. Creating and Previewing the OData UI Service
07. Implementing Basic Authorizations

**code spnippets** 

## 02 -- creating DB tables: 
new package: ZRAP_TRAVEL_1234
Add existing package: /DMO/FLIGHT  
/DMO/FLIGHT > /DMO/FLIGHT_LEGACY > Dictionary > Database Tables: 
- /DMO/BOOKING
- /DMO/TRAVEL
-- 
* ZRAP_TRAVEL_1234 > New DB tables: 
    - ZRAP_ATRAV_1234 : Travel Data
    - ZRAP_ABOOK_1234 : Booking Data
``` define table xxxx { key col1 : type not null; col2 : typel }   ``` 

* create Data generation ABAP class: ZCL_GENERATE_DEMO_DATA_1324 : Generate travel and booking demo data 

## 03 -- create CDS Data Model - BO 

- COMMMON DATA MODEL:   declarative approach for defining domain-specific semantically rich data models close to conceptual thinking 
                        Making data models easier to define, understand and query 
- IMPROVED PORGRAMMING MODEL: offers rich set of built-in-funcitons and expressions and has its own data controlled language to restrict access to the data 
    * relations between business entities on data model level -> can be define using CDS associations
    * domain specific semantics can be added to data models -> CDS annotations
    * different modelling entities: 
        * CDS vies for standard view building 
        * CDS view extension for the modification-free enhancement of CDS data model 
        * CDS table functions for accesing advance SAP HANA capabillities such as data mining or predicitive analytics 
- CAPTURE BUSINESS INTENT -> Reduce complexity extending SQL 

-- exercise: create CDS view entities: 
- **ZI_RAP_Travel_1234**    : Travel view  -- define view Entity template 
- **ZI_RAP_Booking_1234**   : Booking view -- define view Entity template


``` define root view entitiy xxx as select from db as yy  ```
``` composition [0..*] of xxxx as zzz ```
``` association [0..1] to 1111 as 11 on @projection.col1 = 11.column1 ``` Projection list 
``` { key col1 as c1, col2 as c2, _association1, _as2, } ```
``` @Semantics.amount.currencyCode : 'CurrencyCode' ``` --> automated update of admin fields on every operation. 

CDS entities successor of ABAP dictionary views, authorization check 
ADT syntax check, Unit testing ... 

-- demo: 
right click on travel table and select new data definition... 

display data in ADT allow you to navigate to othre data -- associations
make travel view as root and set travel view as parent for booking view

## 04 CDS Projections
CDS-based data model projection -- allows a denormalization and enrichment of the underlying data model. -- additional data and some consumption and object strucutre-related metadata
``` define root view entity ZC_XXX as projection on YYY as Y ```
``` { key key1, @semantics col1, col2, _association1 : xxx } ```

``` @Search.defaultSearchElement: true Col1 ``` 
``` @Consumtion.valueMapDefinition: [{entity:{name: 'zzzz', element: 'colID'}}] ```
-- 
CDS Metadata Extension (MDEs) -- separated from busines object related annotations 
stablish conjusction of a field with its descriptive language independent text units @Consumption annotations. 

-- execise projections: S/4 HANA namespace 
Consumption Views -- Namespace follow wiht letter C
Select CDS view -> new Data Definition -- ZC_XXXX 
- **ZC_TRAVEL_1234**  : Travel BO Projection  view -- Define Projection View Template
- **ZC_BOOKING_1234** : Booking BO Projection view -- Define Projection View Template

metadata extensions: 
- @AccessControl.authorizationCheck: #CHECK
- @Metadata.allowExternsion: true
- @Search.searhcable: true


## 05 CDS Projection Enrichment with UI Metadata 
DATA MODEL PROJECTION 
CDS metadata Extension MDE: 
* separation of concerns 
    - Keep view definition distinct from UI specific annotations 
    - Use of View Definition with various set of metadata
* simplied change management 
    - change annotations without modifying underlying CDS entitiy 

more than one CDS Metadata Extension for 1 CDS View 

-- ex
1. right click in CDS View: ZI_RAP_XXX and select new metadata Extension
    - ZC_RAP_TRAVEL_123 : UI annotations for ZC_RAP_Travel_#### -- Annotate View template
    - ZC_RAP_BOOKING_123: UI annotations for ZC_RAP_Booking_### -- Annotate View template

layer -> priority of the metadata, #CORE: Lowest priotity #CUSTOMER the highest
@UI Header data 
@UI.Facets - Navigation, position and level for each element 

Projection -> open active annotations


# 06 - OData UI service 
SERVICE DEFINITION - define scope 
SERVICE BINFING - bind to scenario and protocol *ODATA
PREVIEW 

-- ex: 
1. right click on travel BO projection view ZC_RAP_xxxx > New Service Definition 
    - ZUI_RAP_Travel_1234  Serv Def for ZC_RAP_Travel  Define Service Template
    ``` { expose CDS entities/Projections/views as alias; ... } ``` 
2. right click in service definition and click in **New Service Binding** 
    - ZUI_RAP_TRAVEL_02_1234 : OData V2 UI Service for SAP Fiori Travel App -- Binding type ODATA V2 UI
    - different versions of Service Binding
3. Preview Button -> show an SAPUI5 App - Navigate to Object Page 
    - Search is apply into several different columns 

## 07 Authorizations/Roles




# end 