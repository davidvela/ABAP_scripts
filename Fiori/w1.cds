// Step 3. Add table columns and filter bar selection fields
@UI.lineItem: [{ position: 20 }]
AgencyID;

@UI.lineItem: [{ position: 30 }]
CustomerID;

@UI.lineItem: [{ position: 40 }]
BeginDate;

@UI.lineItem: [{ position: 50 }]
EndDate;

@UI.lineItem: [{ position: 60 }]
BookingFee;

@UI.lineItem: [{ position: 70 }]
TotalPrice;

@UI.lineItem: [{ position: 80 }]
OverallStatus;

@UI.lineItem: [{ position: 90 }]
LocalLastChangedAt;

//Step 4. Add header information and default sorting
@Metadata.layer: #CORE

@UI: {
    headerInfo: {
        typeName: 'Travel',
        typeNamePlural: 'Travels'
    },
    presentationVariant: [{
        sortOrder: [{
            by: 'LocalLastChangedAt',
            direction: #DESC
        }],
        visualizations: [{
            type: #AS_LINEITEM
        }]
    }]
}

annotate view ZC_FE_TRAVEL_###### with
{
...

//Step 5. Refine columns having IDs
@EndUserText.label: 'Travel'
@ObjectModel.text.element:  [ 'Description' ]
TravelID,
@EndUserText.label: 'Agency'
@ObjectModel.text.element: ['AgencyName']
AgencyID,
_Agency.Name as AgencyName,
@EndUserText.label: 'Customer'
@ObjectModel.text.element: ['LastName']
CustomerID,
_Customer.LastName as LastName,
@EndUserText.label: 'Status'
OverallStatus,
@EndUserText.label: 'Last Changed At'
LocalLastChangedAt,
// -- view 
...
@Search.searchable: true

@ObjectModel.semanticKey: ['TravelID']

define root view entity ZC_FE_TRAVEL_######
...

//Step 6. Implement value help for selection fields Customer and Status
@EndUserText.label: 'Customer'
@ObjectModel.text.element: ['LastName']
@Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'  } }]
CustomerID,
_Customer.LastName as LastName,

// project view 
...
@EndUserText.label: 'Status'
@Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_FE_STAT_######', element: 'TravelStatusId'  } }]
OverallStatus,
...

// cds view 
...
@EndUserText.label: 'Travel Status view entity'
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
define view ZI_FE_STAT_######
...

// Step 7. Description instead of Codes for the status field
define root view entity ZI_FE_TRAVEL_######
  as select from ZFE_ATRAV_######
  association [0..1] to /DMO/I_Agency as _Agency on $projection.AgencyID = _Agency.AgencyID
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
  association [0..1] to /DMO/I_Customer as _Customer on $projection.CustomerID = _Customer.CustomerID
  association [0..1] to ZI_FE_STAT_###### as _TravelStatus on $projection.OverallStatus = _TravelStatus.TravelStatusId
  composition [0..*] of ZI_FE_Booking_###### as _Booking
  {
    key TRAVEL_UUID as TravelUUID,
    ...

    ...
    _Customer,
    _TravelStatus
  }

@EndUserText.label: 'Status'
@ObjectModel.text.element: ['TravelStatusText']
@Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_FE_STAT_######', element: 'TravelStatusId'  } }]
OverallStatus,
_TravelStatus.TravelStatusText as TravelStatusText,


@UI.lineItem: [{ position: 80 }]
@UI.selectionField: [{ position: 30 }]
@UI.textArrangement: #TEXT_ONLY
OverallStatus;

// Step 8. Implement a conditional status emphasis
...
description as Description,

overall_status as OverallStatus,
case overall_status
  when 'O'  then 2    -- 'open'       | 2: yellow colour
  when 'A'  then 3    -- 'accepted'   | 3: green colour
  when 'X'  then 1    -- 'rejected'   | 1: red colour
            else 0    -- 'nothing'    | 0: unknown
end                   as OverallStatusCriticality,

@Semantics.user.createdBy: true
created_by as CreatedBy,
...

...
@ObjectModel.text.element: ['TravelStatusText']
@Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_FE_STAT_######', element: 'TravelStatusId'  } }]
OverallStatus,
_TravelStatus.TravelStatusText as TravelStatusText,

OverallStatusCriticality,

CreatedBy,
...

...
@UI.lineItem: [{ position: 70 }]
TotalPrice;

@UI.lineItem: [{ position: 80, criticality: 'OverallStatusCriticality' }]
@UI.selectionField: [{ position: 30 }]
@UI.textArrangement: #TEXT_ONLY
OverallStatus;

@UI.lineItem: [{ position: 90 }]
LocalLastChangedAt;
...
