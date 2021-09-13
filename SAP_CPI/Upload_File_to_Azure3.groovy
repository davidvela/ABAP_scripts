import com.sap.gateway.ip.core.customdev.util.Message
import java.io.*
import com.microsoft.azure.storage.*
import com.microsoft.azure.storage.blob.*
//Secure Parameter
import com.sap.it.api.ITApiFactory;
import com.sap.it.api.securestore.SecureStoreService;
import com.sap.it.api.securestore.UserCredential;
import java.nio.charset.StandardCharsets

	
def Message processData(Message message) {
    def body = message.getBody(java.lang.String) as String
    // def body = ";test;123;12321;" as String

    def service = ITApiFactory.getApi(SecureStoreService.class, null);
    def credential = service.getUserCredential("SSOTDataLake");
    if (credential == null) {
            throw new IllegalStateException("No credential found for alias 'SSOTDataLake'");
    } 
    
    String user = credential.getUsername();
    String password = new String(credential.getPassword());
    
    String lLocation = "landing/GLOBAL/test"
    String fileName = "test.csv"

    String accountName = user
    String accountKey = password
    String storageConnectionString = "DefaultEndpointsProtocol=https;" + "AccountName=" + accountName+ ";" + "AccountKey=" + accountKey

    CloudStorageAccount account = CloudStorageAccount.parse(storageConnectionString)
    CloudBlobClient serviceClient = account.createCloudBlobClient()

    CloudBlobContainer container = serviceClient.getContainerReference(lLocation)

    String fileContent = body
    // byte[] fileBytes = fileContent.getBytes()
    byte[] fileBytes = fileContent.getBytes(StandardCharsets.UTF_8)


    CloudBlockBlob blob = container.getBlockBlobReference(fileName)
    blob.uploadFromByteArray(fileBytes, 0, fileBytes.length)

    blob.getProperties().setContentType("text/csv;charset=utf-8")
    blob.uploadProperties()

    message.setBody("OK")

    return message;
}