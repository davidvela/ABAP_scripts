# SFLIGHT
**Simplified flight data model for this openSAP course**
    
01. The Business Scenario
02. Creating the Database Tables
03. Creating the Core Data Services (CDS) Data Model
04. Defining the CDS Data Model Projection
06. Enriching the Projected Data Model with UI Metadata
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

## 03 CDS Projections

# end 