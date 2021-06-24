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

## W3 - Analytical List Page
* Analytical List Page:
https://sapui5.hana.ondemand.com/#/topic/3d33684b08ca4490b26a844b6ce19b83
* Overview Pages:
https://sapui5.hana.ondemand.com/#/topic/c64ef8c6c65d4effbfd512e9c9aa5044
