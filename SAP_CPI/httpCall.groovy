import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
import org.apache.camel.*;
import groovy.json.JsonSlurper;

//Secure Parameter
import com.sap.it.api.ITApiFactory;
import com.sap.it.api.securestore.SecureStoreService;
import com.sap.it.api.securestore.UserCredential;

def Message processData(Message message) {
def body = message.getBody(java.lang.String) as String;
def messageLog = messageLogFactory.getMessageLog(message);

// secure store: 
def service = ITApiFactory.getApi(SecureStoreService.class, null);
def credential = service.getUserCredential("BS_Password");
if (credential == null) {
            throw new IllegalStateException("No credential found for alias 'BS_Password'");
} 

String user = credential.getUsername();
String password = new String(credential.getPassword());


// Request
def get = new URL("https://<tenant>-iflmap.hcisbp.eu1.hana.ondemand.com/http/dummy/http").openConnection() as HttpURLConnection;

get.setRequestMethod('GET');
get.setRequestProperty("Accept", 'application/json');
get.setRequestProperty("Content-Type", 'application/json');

get.setRequestProperty('Authorization','Basic' + '<myUserID>:<myPassword>'.bytes.encodeBase64().toString());

get.connect();

def getRC = get.getResponseCode();
if(getRC.equals(200)) {
messageLog.setStringProperty( "ResponsePayload:" , getRC.toString() );
}

// message.setBody(getRC);
// return message;



// def strcontent = get.getOutputStream()
// def root = new JsonSlurper().parseText(json)
// log.info ("token:" + root.token)
// messageExchange.modelItem.testStep.testCase.testSuite.project.setPropertyValue("X-AUTH-TOKEN", root.token)


get.setDoOutput(true);

// BufferedReader in = new BufferedReader(
//                             new InputStreamReader(
//                             get.getInputStream()));


InputStream osin = get.getInputStream();
InputStreamReader innn = new InputStreamReader(osin, "UTF-8");    

String strcontent;
String decodedString;
while ((decodedString = innn.readLine()) != null) {
    //System.out.println(decodedString);
    strcontent = strcontent + decodedString; 
}
innn.close();
messageLog.addAttachmentAsString("log2",  strcontent , "text/plain");


}

BufferedReader in = new BufferedReader(
                            new InputStreamReader(
                            connection.getInputStream()));