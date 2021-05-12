import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
def Message processData(Message message) {
    //Body 
       def body = message.getBody(String);
       body = body.replaceAll("\n", "\r\n");
       body = """--cpi\r\nContent-Disposition: form-data; name="envelope"\r\n\r\n\r\n""" + body + """\r\n\r\n--cpi--"""

       message.setBody(body);
       return message;
}

// cpi anomaly: 
// HTTP 400 error “Unable to parse multipart body”. 
// This happens for example when you leave out the newline between Content-Disposition and 
// the ExampleValue in the example above.

/*
form-data: 
Content-Disposition: form-data; name="formElement"

ExampleValue
--cpi--

header: Content-Type: multipart/form-data; boundary=cpi

*/