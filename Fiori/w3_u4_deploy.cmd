@REM EU
cf login -a https://api.cf.eu10.hana.ondemand.com
@REM USA
cf login -a https://api.cf.us10.hana.ondemand.com

@REM Step 2. Add deploy config to bookinganalysis
@REM  = Cloud Foundry ; abap-cloud-default_abap-trial(SCP); 
cd bookinganalysis
npx fiori add deploy-config

@REM Step 3. Add SAP Fiori launchpad config to bookinganalysis
@REM Semantic object = Booking, Ation = analysis; Title  = Booking Analysis ; Subtitle (optional) skip! press enter
npx fiori add flp-config

@REM Step 4. Build and deploy the application bookinganalysis
@REM Multi Target Application (MTA). = CF
@REM 1 build, 2 deploy  
npm run build:mta
npm run deploy

@REM Step 5. Add deploy config to travellist
cd ../travellist
npx fiori add deploy-config
Please choose the target: Cloud Foundry
Destination name: abap-cloud-default_abap-trial(SCP)
Add application to managed application router?: Yes

@REM Step 6. Add SAP Fiori launchpad config to travellist
npx fiori add flp-config
Semantic Object: Travel
Action: manage
Title Travel: List
Subtitle: (optional) 

@REM Step 7. Build and deploy the application travellist
npm run build:mta
npm run deploy

@REM Step 8. Add deploy config to traveloverview
cd ../traveloverview
npx fiori add deploy-config
Please choose the target: Cloud Foundry
Destination name: abap-cloud-default_abap-trial(SCP)
Add application to managed application router?: Yes

@REM Step 9. Add SAP Fiori launchpad config to traveloverview
npx fiori add flp-config
Semantic Object: Travel
Action: overview
Title: Travel Overview
Subtitle (optional): 

@REM Step 10. Build and deploy the application traveloverview
npm run build:mta
npm run deploy

@REM Step 11. Creating a SAP Fiori launchpad and adding the applications
...