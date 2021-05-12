//wrong: 
// import groovy.json.*
// import com.sap.gateway.ip.core.customdev.util.Message
// import groovy.json.JsonSlurper
// def json = messageExchange.response.contentAsString
// def root = new JsonSlurper().parseText(json)
// log.info ("token:" + root.token)
// messageExchange.modelItem.testStep.testCase.testSuite.project.setPropertyValue("X-AUTH-TOKEN", root.token)

// correct
import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
import groovy.json.*;
def Message processData(Message message) {
    //Body 
       def body = message.getBody(String.class);
       def jsonSlurper = new JsonSlurper()
       def list = jsonSlurper.parseText(body)
       if ( list.token == null || list.token == "" )
        message.setHeader("X-AUTH-TOKEN","")
       else
      message.setHeader("X-AUTH-TOKEN",list.token.toString())
    return message;
}