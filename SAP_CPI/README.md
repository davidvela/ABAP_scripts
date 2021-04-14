# SAP CPI integrations 
Index: 
* Push_File_to_azure_blob

roles: https://help.sap.com/viewer/368c481cd6954bdfa5d0435479fd4eaf/Cloud/en-US/5d46e56550a048e99995f23e1e20083a.html

# Projects:
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
