# sender: HTTP
/api/getOperation/*

# receiver: OData
Address: full 
on premise, Authentication, credential 
Processing: 
${header.CamelHttpPath}
${header.CamelHttpQuery}

# XML to JSON Converter 


# groovy to split header 

# Headers 
Headers: CamelHttpUri|CamelHttpQuery|CamelHttpMethod|CamelHttpPath
