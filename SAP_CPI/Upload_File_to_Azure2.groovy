
/*
Script to upload files to Azure Blob folder using parameters provided
 */
import com.sap.gateway.ip.core.customdev.util.Message
import java.util.HashMap
import com.microsoft.azure.storage.*
import com.microsoft.azure.storage.blob.*
import java.text.SimpleDateFormat

def Message processData(Message message) {
    def body = message.getBody(java.lang.String) as String
    map = message.getProperties()
    
    String accountName=map.get("AzureAccountName")
    String accountKey = map.get("AzureAccountKey")
    String containerRef =map.get("ContainerRef")
	String fileNameScheme = map.get("Filename")
	String timestamp = map.get("AddTimestamp")
    String storageConnectionString = "DefaultEndpointsProtocol=https;" + "AccountName=" + accountName+ ";" + "AccountKey=" + accountKey

    CloudStorageAccount account = CloudStorageAccount.parse(storageConnectionString)
    CloudBlobClient serviceClient = account.createCloudBlobClient()

    CloudBlobContainer container = serviceClient.getContainerReference(containerRef)
if(timestamp.equals("Y")){
    String pattern = "yyyyMMddHHmmss";
    SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
    String date = simpleDateFormat.format(new Date());
    fileNameScheme = fileNameScheme + "_" + date;
}
    String fileName = fileNameScheme+ ".csv"
    String fileContent = body
    byte[] fileBytes = fileContent.getBytes()

    CloudBlockBlob blob = container.getBlockBlobReference(fileName)
    blob.uploadFromByteArray(fileBytes, 0, fileBytes.length)

    blob.getProperties().setContentType("text/plain;charset=utf-8")
    blob.uploadProperties()
    message.setBody("File is created with name : "+fileName)

    return message;
}