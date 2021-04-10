# Integration Advisor Capability of SAP Integration Suite
by Gunther Stuhec, Annemarie Kiefer, Michelle Luft
23.03.2021 - 20.04.2021 (4w)

https://open.sap.com/courses/s4h20

## index: 
Week 1: Introduction
Week 2: Main Pillars in Detail
Week 3: Build an End-to-End Scenario
Week 4: Final Exam

### W1 - 
Motivation: 
**Functional Specification: (50%) - Business Domain Experts!**
* MIG - Interface or Message Implementation Guidelines for Source and Target
* MAG - Mappign Guideline 
Technial Implemenetation and Runtime Artifacts: 15% - Integration Experts
Integration tools: CPI, PI
Scripts: XSLT, JS, Groovy, ABAP, JAVA
**Integration Advisor** 
help during Functional Specification -> ML, suggestions 
Integration Content, Standard & Libraries 
13 different type systems: (library)
ASC X12, cXML(Ariba), ISO, Odette, VDA, S/4HANA ... 
-> MIGs  => MAGs
documentation export... 
example: ASC X12

### W2
creating MIG -- standard msg interface 
business context 
custom structures --> XML Schemas (XSD) -- custom_message-> customSegment -> custom Elemetn -> CodeValue (library of custom messages)
video 3 --> create mapping guidelines MAG -- global param, code val mapping, functions. 
s/4 hana : 
communication arrangements -> scenarios
communication systems

### W3 
MIG -- order - outbound for S/4 HANA cloud -- qualifiers, codelists, add values... 
MIG -- X12 - inbound (target partner) --  get proposal -- set qualifiers markets
MAG -- order and X12 -- concatenation, date convertion, code list mapping, phone number xlt conversion
SAP CI - Integration flow - runtime artifacts (Discover for IA)
SAP CI - Source and Target -- Number Ranges, Security Material email address for X12 (connect SOAP sender and Mail Receiver)
S/4 HANA cloud - master data record for supplier in USA // commnication system, communication arrangement of CPI / 
    Business rules - output parameters => EDI channel
CPI - Cetificate to user mappings - upload certificate 
S/4 HANA configuration and test scenario -- Purchase order - SOAP


# other: 
## course summary: 
Customers want to exchange business data between their **SAP S/4HANA** Cloud and other SAP and non-SAP systems in their enterprise or at their trading partners via business-to-business. In particular, they want to create and enable the required integration content for exchanging the data as soon as possible. The problem is that all these systems/applications have **different, heterogeneous domain models**, meaning the effort required to integrate them is always high when using the classic integration tools. To overcome this, the Integration Advisor capability of SAP Integration Suite (short: Integration Advisor) unifies all the necessary components, with a strong focus on usability, understandability, reusability, flexibility, transparency, and speed based on a **comprehensive knowledge base** and **machine learning**.

In this course, you’ll learn how you can use the completely new paradigm provided by the Integration Advisor to quickly define, maintain, share, and deploy integration content to SAP Integration Suite Cloud Integration. You’ll learn how to create **functional interface definitions and mapping guidelines**, which will then be automatically generated and enabled in SAP Integration Suite Cloud Integration in order to build end-to-end integration scenarios between SAP S/4HANA and external A2A/B2B systems.