# SAPUI5 

## in vscode: 
https://blogs.sap.com/2020/07/18/develop-sap-ui5-apps-using-visual-studio-code/
https://github.com/SaiNithesh/SAPUI5UsingVisualStudio.git 

1. create folder in vscode 
2. install Generators:   ```npm install -g yo @sapui5/generator-sapui5-templates```
3. Enter the command ```yo @sapui5/sapui5-templates``` to choose the SAP UI5 template
    * Enter module name **UI5App**
    * Enter module namespace **app.corp.com**
    * Select template – you can navigate and select using up and down arrows and enter
        * **SAP Fiori Worklist Application**
        * SAP Fiori Master-Detail Application
        * SAP Fiori Worklist Application OData V4
    * Enter remaining details like Title, Description and other details 
4. npm install 
5. npx ui5 serve -o test.html

**abap server deployment**
6. Let us build app using ```ui5 build```, and then dist folder will be created in the root, which we can deploy to ABAP repository.
7. We can deploy app to the ABAP repository using ```nwabap-ui5uploader```. Let us install this locally to out project.
    *  Let us install this locally to out project: ```npm install nwabap-ui5uploader –save-dev```

8. Now create .nwabaprc in the root folder with the below properties
    ```{
        "base": "./dist",
        "conn_usestrictssl" : false,
        "conn_server": "http://<hostname>:<port>/",
        "conn_client" : "client",
        "conn_user": “UserName”,
        "conn_password": “Password”,
        "abap_package": "$TMP",
        "abap_bsp": "ZVSCODE_APP",
        "abap_bsp_text": "UI5 upload through VSCode App"
    }```
9. Add ```"deploy": "npx nwabap upload"``` in the **package.json**.
10. Now let us deploy to ABAP repository using ```npm run upload```


## yeoman generators
https://www.npmjs.com/package/@sap/generator-fiori-elements

# Learning: 
corp long term: technology by sap: ABAP in the cloud  + fiori elements 
https://open.sap.com/courses/abap1
https://open.sap.com/courses/fiori-ea1
https://open.sap.com/courses/cp13
https://open.sap.com/courses/devops1

corp short term: 
CDS mit HANA...  (maybe)
Odatav2 + SAPUI5 
https://open.sap.com/courses/ui52
