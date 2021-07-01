# Fiori apps 
## Open SAP course: 

**Developing and Extending SAP Fiori Elements AppsSAP Fiori Experts**
https://github.com/SAP-samples/fiori-elements-opensap
### W1 - Introduction, List Report
* https://community.sap.com/topics/fiori-elements
* https://wiki.scn.sap.com/wiki/display/Fiori/Fiori+elements
* Building fiori apps pdf: https://d.dam.sap.com/a/7JMn4gA/SAP%20FIori%20elements%20expert%20paper%20May%202021.pdf
* https://blogs.sap.com/2021/05/10/our-top-7-picks-for-user-experience-trainings-on-opensap/?update=updated
* https://www.odata.org/
* https://www.odata.org/getting-started/understand-odata-in-6-steps/
* https://github.com/oasis-tcs/odata-vocabularies
* https://www.sap.com/products/business-technology-platform/trial.html
* https://developers.sap.com/tutorials/abap-environment-restful-programming-model.html


* List Report Element: 
https://sapui5.hana.ondemand.com/#/topic/1cf5c7f5b81c4cb3ba98fd14314d4504

**notes**
https://open.sap.com/courses/fiori-ea1
Fiori mapping with RAP - but RAP will not be covered in the course. 
MSE - Meta data Extension
in eclipse. 
@metadata.layer: #CORE 
@UI.HeaderInfo: {typeNamePlural: 'Traves'}
@UI.lineItem [{position:10}] travelID; 

### W2 - Object Page
* List Report Element: 
https://sapui5.hana.ondemand.com/#/topic/1cf5c7f5b81c4cb3ba98fd14314d4504
* Object Page Elements
https://sapui5.hana.ondemand.com/#/topic/645e27ae85d54c8cbc3f6722184a24a1 
* SAP Fiori Feature Map
https://sapui5.netweaver.ondemand.com/#/topic/62d3f7c2a9424864921184fd6c7002eb
* example: 
    * fiori table: https://experience.sap.com/fiori-design-web/responsive-table/

* Extending Genrated Apps using App Extensions: 
https://sapui5.netweaver.ondemand.com/#/topic/340cdb2ba97c4843979f905a70a327ee

l1 - object page 
title description
total price, status 
    FACETS - purpose (HEADER), type (DATAPOINT_REFERENCE)
@UI.dataPoint: {qualifier}
section: COLLECTION facet, GeneralInfo, purpose STANDARD,
FIELDGROUP reference
Fieldgroup annotation
table bookings: LINE ITEM REFERENCE 
@UI.lineItem Annotation
**precondition** semanticURL : true 

**Feature Map**
Define and Adaptatins 

## W3 - Analytical List Page (ALP), Overview Page
* Analytical List Page:
https://sapui5.hana.ondemand.com/#/topic/3d33684b08ca4490b26a844b6ce19b83
* Overview Pages:
https://sapui5.hana.ondemand.com/#/topic/c64ef8c6c65d4effbfd512e9c9aa5044

### ALP
guided development 
XML Annotations 
1. table -> @UI.LineItem 
2. chart -> @UI.Chart ALP -> title, entity, properties... 
3. Filter -> @UI.SelectionFields
4. Visual Filter -> @UI.Chart, UI.PresentationVariant
    1. chart -> Qualifier 
    2. presentation variant -> 
    3. Mapping: Booking type, booking year ... 
5. Common.FilterDefaultValue = 2021

### Overview Page -> Cards
1. create overview page: 5 steps 
    1. step: entity type ... 
    2. presentation variant -> Flight price, 
    3. ... 
    4. UI.identification -> navigation booking analysis 
    5. anlaytical pccard parameters -> Booking, Spending on Flights ... => JSON
2. add Odata V4 -> Manifest -> add new service 
    1. Create local annotation file 
3. add table card to an overview page based on OData v4: 6 steps
    1. select entity, data point parameters 
    2. Qualifiers: AcceptedTravels and rejectedTravels, column parameters, DataFieldAnnotation, -- Line Items, 
    3. Filters: SelectOptions
    4. UI.Identification -> collection 
    5. card file settings: title, entity, ... JSON
    6. card tabs JSON: Accepted, Rejected, Open/In Progress 
4. add Quick Links card and chart card ... 


### deploy apps
deployee 3 apps. 




# W4 Extending a Standard SAP Fiori App
* SAPUI5 flexibility documentation "All you need to know"
https://help.sap.com/viewer/UI5_Flex
* Video SAPUI5 Flexibility – Key User Adaptation
https://www.youtube.com/watch?v=VrFVB1b4kAI
* openSAP Microlearning: Adapting the UI of List Report Apps - SAP S/4HANA User Experience
https://microlearning.opensap.com/media/socialsharingtw/1_lm5i2aj9
* SAPUI5 flexibility Demo Apps

* SAPUI5 flexibility Road Map

* Enable your own custom apps for SAPUI5 flexibility
https://ui5.sap.com/#/topic/f51dbb78e7d5448e838cdc04bdf65403


## Adapting the App from the UI -> Key Users 

## Adaptation Project 
manifest.appdescr_variant file.

Extending apps as a developer: fragment and controller : Advance extensions