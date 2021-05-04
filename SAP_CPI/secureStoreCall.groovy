//Secure Parameter
import com.sap.it.api.ITApiFactory;
import com.sap.it.api.securestore.SecureStoreService;
import com.sap.it.api.securestore.UserCredential;
def Message processData(Message message) {
        def service = ITApiFactory.getApi(SecureStoreService.class, null);
        def credential = service.getUserCredential("BS_Password");
        if (credential == null) {
            throw new IllegalStateException("No credential found for alias 'BS_Password'");
        } 
} 
String user = credential.getUsername();
String password = new String(credential.getPassword());
