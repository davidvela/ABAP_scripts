What is left is to do the following.

Register a service group ZE2E001 using transaction '/iwbep/v4_admin'
Publish the service group using transaction '/iwfnd/v4_admin'
Register the service in the service group ZE2E001 with the name 'ZE2E001_SALESORDER'
For more details see the SAP Online Help.
https://help.sap.com/viewer/68bf513362174d54b58cddec28794093/7.52.0/en-US/54dcfc66cece463e9e25bc17cf5117b9.html

Field	                Value
 Service ID	            ZE2E001_SALESORDER
 Service Version	    1
 Model Provider Class	ZCL_E2E001_ODATA_V4_SO_MODEL
 Data Provider Class	ZCL_E2E001_ODATA_V4_SO_DATA
 Description	        OData V4 demo service
 Package	            ZE2E001