importClass(com.sap.gateway.ip.core.customdev.util.Message);
importClass(java.util.HashMap);
function processData(message) {
 //body
 var body = message.getBody();
 message.setBody("Hello world from IFlow");
 
 return message;
}