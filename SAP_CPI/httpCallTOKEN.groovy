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
def credential = service.getUserCredential("PowerAppLogin");
if (credential == null) {
            throw new IllegalStateException("No credential found for alias 'PowerAppLogin'");
} 

String user = credential.getUsername();
String password = new String(credential.getPassword());

// Request
def get = new URL("https://login.microsoftonline.com/<tenantid>/oauth2/token").openConnection() as HttpURLConnection;

get.setRequestMethod('POST');
get.setRequestProperty("Accept", '*/*');
get.setRequestProperty("Content-Type", 'multipart/form-data; boundary=cpi');
// get.setRequestProperty('Authorization','Basic' + '<myUserID>:<myPassword>'.bytes.encodeBase64().toString());
// def body = message.getBody(String);
// body = body.replaceAll("\n", "\r\n");
// body = """--cpi\r\nContent-Disposition: form-data; name="envelope"\r\n\r\n\r\n""" + "" + """\r\n\r\n--cpi--""";
body = """--cpi\r\nContent-Disposition: form-data; name="grant_type"\r\n\r\n""" + "client_credentials" + """\r\n--cpi""";
body = body + """\r\nContent-Disposition: form-data; name="resource"\r\n\r\n""" + "https://url.dynamics.com" + """\r\n--cpi""";
body = body + """\r\nContent-Disposition: form-data; name="client_id"\r\n\r\n""" + user + """\r\n--cpi""";
body = body + """\r\nContent-Disposition: form-data; name="client_secret"\r\n\r\n""" + password + """\r\n--cpi""";
messageLog.setStringProperty("log1_body", body);

// set body request:
get.setDoOutput(true);
OutputStream os = get.getOutputStream();
OutputStreamWriter osw = new OutputStreamWriter(os, "UTF-8");    
osw.write(body);
osw.flush();
osw.close();
os.close();  //don't forget to close the OutputStream

// get body response
InputStream osin = get.getInputStream();
InputStreamReader innn = new InputStreamReader(osin, "UTF-8");    
String strcontent = "test";
String decodedString;
while ((decodedString = innn.readLine()) != null) {
//     //System.out.println(decodedString);
    strcontent = strcontent + decodedString; 
}
// def httpResponseScanner = new Scanner(get.getInputStream())
// while(httpResponseScanner.hasNextLine()) {
// //     println(httpResponseScanner.nextLine())
//       strcontent = strcontent + decodedString; 

// }
// httpResponseScanner.close()
innn.close();
messageLog.setStringProperty("log2", strcontent);
messageLog.addAttachmentAsString("log2",  strcontent , "text/plain");


get.connect();


messageLog.setStringProperty( "ResponsePayload:" , getRC.toString() );
messageLog.setStringProperty("log1", "Printing Payload as Attachment");
messageLog.addAttachmentAsString("log1",  getRC.toString() , "text/plain");
def getRC = get.getResponseCode();
if(getRC.equals(200)) {
    // get the token from the JSON response. 
    def jsonSlurper = new JsonSlurper()
    def list = jsonSlurper.parseText(body)
    if ( list.access_token == null || list.access_token == "" )
        // message.setHeader("X-AUTH-TOKEN","")
        message.setHeader("Authorization","")
    else
      message.setHeader("Authorization","Bearer " + list.token.toString())
    return message;
}
message.setBody(getRC);
return message;
}

// dynamics groovy call request
/*POSTMAN
form-data: 
Content-Disposition: form-data; name="formElement"

ExampleValue
--cpi--

header: Content-Type: multipart/form-data; boundary=cpi



POST /aa06dce7-99d7-403b-8a08-0c5f50471e64/oauth2/token HTTP/1.1
Host: login.microsoftonline.com
Cookie: fpc=AgnPzQk4dTpHib45pasw9rG8_e6uAQAAAEE9K9gOAAAA

Content-Length: 527
Content-Type: multipart/form-data; boundary=xcpi

--xcpi--
Content-Disposition: form-data; name="grant_type"

client_credentials
--xcpi--
Content-Disposition: form-data; name="resource"

https://tenantName.api.dynamics.com
--xcpi--
Content-Disposition: form-data; name="client_id"

client id 
--xcpi--

Content-Disposition: form-data; name="client_secret"

secret
--xcpi--

/*