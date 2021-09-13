/*
 The integration developer needs to create the method processData 
 This method takes Message object of package com.sap.gateway.ip.core.customdev.util 
which includes helper methods useful for the content developer:
The methods available are:
    public java.lang.Object getBody()
	public void setBody(java.lang.Object exchangeBody)
    public java.util.Map<java.lang.String,java.lang.Object> getHeaders()
    public void setHeaders(java.util.Map<java.lang.String,java.lang.Object> exchangeHeaders)
    public void setHeader(java.lang.String name, java.lang.Object value)
    public java.util.Map<java.lang.String,java.lang.Object> getProperties()
    public void setProperties(java.util.Map<java.lang.String,java.lang.Object> exchangeProperties) 
    public void setProperty(java.lang.String name, java.lang.Object value)
    public java.util.List<com.sap.gateway.ip.core.customdev.util.SoapHeader> getSoapHeaders()
    public void setSoapHeaders(java.util.List<com.sap.gateway.ip.core.customdev.util.SoapHeader> soapHeaders) 
       public void clearSoapHeaders()
 */
// import com.sap.gateway.ip.core.customdev.util.Message;
// import java.util.HashMap;
// def Message processData(Message message) {
//     //Body 
//       def body = message.getBody();
//       message.setBody(body + "Body is modified");
//       //Headers 
//       def map = message.getHeaders();
//       def value = map.get("oldHeader");
//       message.setHeader("oldHeader", value + "modified");
//       message.setHeader("newHeader", "newHeader");
//       //Properties 
//       map = message.getProperties();
//       value = map.get("oldProperty");
//       message.setProperty("oldProperty", value + "modified");
//       message.setProperty("newProperty", "newProperty");
//       return message;
// }
import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
import org.apache.olingo.odata2.api.uri.UriInfo;
import com.sap.gateway.ip.core.customdev.logging.*;

def Message processData(Message message) {


// 	def uriInfo = message.getHeaders().get("UriInfo");
//     	def keyPredList = uriInfo.getKeyPredicates();				
// 		def k=0;
// 		for(item in keyPredList)
// 		{			
// 			message.setHeader("Key_"+item.getProperty().getName(),item.getLiteral());
// 		}

	//Get Headers 
	def map = message.getHeaders();
	def value = map.get("CamelHttpPath");
	def aTab = value.split('/'); 
	// check counter of elements 

	if ( aTab[0] == "testSet" ){
	message.setHeader("pEntity","testSet");
    // scape $ in groovy string
// 	message.setHeader("pQuery",  "$filter=DATE_EXT eq '20210104'&$select=SOURCE,DATE_EXT");
// 	message.setHeader("pQuery",  "$top=3");
// 	message.setHeader("pQuery",  "%24filter%3DDATE_EXT%20eq%20%2720210104%27%26%24select%3DSOURCE,DATE_EXT");
    message.setHeader("pQuery",  "\$filter=DATE_EXT%20eq%20%27" + aTab[1] + "%27&\$select=SOURCE,DATE_EXT");
    } else {
	    message.setHeader("pEntity","othertestSet");
        message.setHeader("pQuery",  "\$filter=DATE_EXT%20eq%20%2720210104%27&\$select=SOURCE,DATE_EXT");
	}
	
// 	message.setProperty("pEntity", "SSOTLogSet");
// 	message.setProperty("pQuery",  "$filter=DATE_EXT eq '20210104'&$select=SOURCE,DATE_EXT");

	
switch ( x ) {
    case "foo":
        result = "found foo"
        // lets fall through
    case "bar":
        result += "bar"
    default:
        result = "default"
}


	return message;
}

