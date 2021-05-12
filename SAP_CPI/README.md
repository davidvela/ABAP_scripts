# SAP CPI integrations 
Index: 
* Push_File_to_azure_blob

roles: https://help.sap.com/viewer/368c481cd6954bdfa5d0435479fd4eaf/Cloud/en-US/5d46e56550a048e99995f23e1e20083a.html

# Projects:

## Connect CPI to Dynamics

* 1 get token 
* 2 set up header token and do call.

form data issues and anomaly:
https://blogs.sap.com/2019/11/14/what-is-form-data-and-how-to-send-it-from-sap-cloud-platform-integration-cpi/
https://blogs.sap.com/2019/02/25/quick-trick-sci-fetch-token-oauth-in-the-iflow/


https://stackoverflow.com/questions/44305351/how-do-you-send-data-in-a-request-body-using-httpurlconnection
https://gist.github.com/vladfau/c6b6debd5903dcbf2308162337b1a323


### ISSUE: OAUTH2 in CPI with Secret Key. 
CPI converts to ASCII Hexadecimal the following characters: 
~ => 126 => %7E
! => 33  => %21 

solution: 
1. Change secret key and avoid those characters
2. custom iFlow in CPI 
3. Create OSS ticket to SAP 

https://www.browserling.com/tools/text-to-ascii
https://www.rapidtables.com/convert/number/decimal-to-hex.html


## Push File to azure blob
https://blogs.sap.com/2019/08/30/how-to-connect-azure-using-scpi-upload-file-to-azure-blob/
Upload_File_to_azure.groovy
sender => HTTPS (deactivate CSRF Protected)
setup: https://blogs.sap.com/2021/03/17/connect-to-azureblob-from-cpi-using-azure-storage-jar/
1. Step: Downloaded Azure Storage Client SDK from 
https://mvnrepository.com/artifact/com.microsoft.azure/azure-storage/
2. Step: Upload: azure-storage-8,6,5.jar file as resource-archive to the iFlow
3. Step: Add properties using groovy or content modifier.
    * IntegrationFlow>Externalized Parameters
        * AddTimestamp
        * AzureAccountKey
        * AzureAccountName
        * ContainerRef
        * Filename
    * Content Modifier: 
        * Create Filename constant -- value 
        * Create ...
4. Step: Upload Upload_File_to_Azure2.groovy script to the container

### CPI Adapter 
https://blogs.sap.com/2020/10/21/connecting-to-azure-blob-storage-from-sap-cloud-platform-integration-using-camel-azure-component/
Maven project: 

## REST API 

# CPI / PI 
change ESR in SAP : 
SPROXY -> Utilities -> settings -> Proxy Generation tab -> option: Enterprise Service Browser = ESR Browser

**CPI auth_client** 
https://blogs.sap.com/2018/03/12/part-1-secure-connectivity-oauth-to-sap-cloud-platform-integration/

## CPI Adapters
https://tools.hana.ondemand.com/#cloudintegration
Eclipse Platform	Oxygen (4.7) 
https://www.eclipse.org/downloads/packages/release/oxygen/3a/eclipse-jee-oxygen-3a
https://tools.hana.ondemand.com/oxygen
SAP Cloud Integration Tools

## Apache Camel 
Camel Adapters: 
https://github.com/apache/camel/tree/master/components
https://camel.apache.org/components/latest/


## SOAP -- tocdes
https://answers.sap.com/questions/2434806/xi-monitoring-transaction-code.html
sxmb_ifr-- launch integration builder/ configuration
**Proxy Generation**
SPROXY--Proxy generation

**Monitering features:**
sxmb_moni-- monitering of messages
SXMB_MONI_BPE--Business process monitering
SXMS_SAMON--- monitor for sync-async communication

**Adminsitration of XI**
sxmb_adm-- Administration

**QUEUE MONITORING**
SMQ1 Outbound queue
SMQ2 Inbound Queue

**IDoc's& RFC's related**
idx1, idx2 for IDoc meta data
SM58--RFC error Log

**Others**
SWELS---Event trace switching on and off.
SXI_MAPPING_TEST To test mappings
SXI_CACHE To check directory cache
