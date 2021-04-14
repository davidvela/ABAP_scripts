import com.sap.gateway.ip.core.customdev.util.Message
import java.io.*
import com.microsoft.azure.storage.*
import com.microsoft.azure.storage.blob.*

def Message processData(Message message) {
    def body = message.getBody(java.lang.String) as String

    String accountName = "your_azure_account_name"
    String accountKey = "your_azure_account_key"
    String storageConnectionString = "DefaultEndpointsProtocol=http;" + "AccountName=" + accountName+ ";" + "AccountKey=" + accountKey

    CloudStorageAccount account = CloudStorageAccount.parse(storageConnectionString)
    CloudBlobClient serviceClient = account.createCloudBlobClient()

    CloudBlobContainer container = serviceClient.getContainerReference("azurefoldername/containername")

    String fileName = "filename.csv"
    String fileContent = body
    byte[] fileBytes = fileContent.getBytes()

    CloudBlockBlob blob = container.getBlockBlobReference(fileName)
    blob.uploadFromByteArray(fileBytes, 0, fileBytes.length)

    blob.getProperties().setContentType("text/csv;charset=utf-8")
    blob.uploadProperties()

    message.setBody("OK")

    return message;
}