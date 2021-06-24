// w2 - unit 1 
// Step 1. Add title and subtitle to the object page header
...

@UI: {
    headerInfo: {
        typeName: 'Travel',
        typeNamePlural: 'Travels',
        title: {
            type: #STANDARD, value: 'Description'
        },
        description: {
            value: 'TravelID'
        }
    },
...

//Step 2. Add data points to the object page header
...
annotate view ZC_FE_TRAVEL_###### with
{

    @UI.facet: [
      {
          id: 'TravelHeaderPrice',
          purpose: #HEADER,
          type: #DATAPOINT_REFERENCE,
          position: 10,
          targetQualifier: 'PriceData'
      },
      {
          id: 'TravelHeaderOverallStatus',
          purpose: #HEADER,
          type: #DATAPOINT_REFERENCE,
          position: 20,
          targetQualifier: 'StatusData'
       }
  ]

  @UI.lineItem: [{ position: 10}]
  TravelID;  
  ...      
...
@UI.lineItem: [{ position: 70}]
@UI.dataPoint: { qualifier: 'PriceData', title: 'Total Price'}
TotalPrice;
...

...
@UI.lineItem: [{ position: 80, criticality: 'OverallStatusCriticality' }]
@UI.selectionField: [{ position: 30}]
@UI.textArrangement: #TEXT_ONLY
@UI.dataPoint: { qualifier: 'StatusData', title: 'Status', criticality: 'OverallStatusCriticality' }
OverallStatus;
...

// Step 3. Add a new section with title "General Information"

...
annotate view ZC_FE_TRAVEL_###### with
{

  @UI.facet: [
  ...

    {
      label: 'General Information',
      id: 'GeneralInfo',
      type: #COLLECTION,
      position: 10
    },
    {
      label: 'General',
      id: 'Travel',
      type: #IDENTIFICATION_REFERENCE,
      purpose: #STANDARD,
      parentId: 'GeneralInfo',
      position: 10
    }
  ]

...

}

annotate view ZC_FE_TRAVEL_###### with
{

...

  @UI.lineItem: [{ position: 10}]
  TravelID;

  @UI.identification: [{ position: 10 }]
  Description;

  @UI.lineItem: [{ position: 20}]
  @UI.selectionField: [{ position: 10}]
  @UI.identification: [{ position: 30 }]
  AgencyID;

  @UI.lineItem: [{ position: 30}]
  @UI.selectionField: [{ position: 20}]
  @UI.identification: [{ position: 20 }]
  CustomerID;
...
}

//Step 4. Add two additional field groups to section "General Information"
annotate view ZC_FE_TRAVEL_###### with
{

  @UI.facet: [
    {

    ...
    {
      id: 'Dates',
      purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE,
      parentId: 'GeneralInfo',
      label: 'Dates',
      position: 30,
      targetQualifier: 'DatesGroup'
    },
    {
      id: 'Prices',
      purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE,
      parentId: 'GeneralInfo',
      label: 'Prices',
      position: 20,
      targetQualifier: 'PricesGroup'
    }
  ]
...

}

// EM
 ...

 @UI.lineItem: [{ position: 40}]
 @UI.fieldGroup: [{ qualifier: 'DatesGroup', position: 10 }]
 BeginDate;

 @UI.lineItem: [{ position: 50}]
 @UI.fieldGroup: [{ qualifier: 'DatesGroup', position: 20 }]
 EndDate;

 @UI.lineItem: [{ position: 60}]
 @UI.fieldGroup: [ { qualifier: 'PricesGroup', position: 10} ]
 BookingFee;

 @UI.lineItem: [{ position: 70}]  
 @UI.dataPoint: { qualifier: 'PriceData', title: 'Total Price'}
 @UI.fieldGroup: [{ qualifier: 'PricesGroup', position: 20 }]
 TotalPrice;
 ...

//Step 5. Show the Bookings Table in a new section
...
annotate view ZC_FE_TRAVEL_###### with
{
  ...
  @UI.facet: [
    ...
    {
      id: 'Booking',
      purpose: #STANDARD,
      type: #LINEITEM_REFERENCE,
      label: 'Bookings',
      position: 20,
      targetElement: '_Booking'
    }
  ]
...

@Metadata.layer: #CORE

annotate view ZC_FE_BOOKING_######
  with
{
    @UI.lineItem: [ { position: 10 } ]
    BookingID;

    @UI.lineItem: [ { position: 20 } ]
    BookingDate;

    @UI.lineItem: [ { position: 30 } ]
    CustomerID;

    @UI.lineItem: [ { position: 40 } ]
    CarrierID;

    @UI.lineItem: [ { position: 50 } ]
    ConnectionID;

    @UI.lineItem: [ { position: 60 } ]
    FlightDate;

    @UI.lineItem: [ { position: 70 } ]
    FlightPrice;

}


@EndUserText.label: 'Customer'
@ObjectModel.text.element: ['LastName']
CustomerID,
_Customer.LastName as LastName,

@EndUserText.label: 'Airline'
@ObjectModel.text.element: ['CarrierName']
CarrierID,
_Carrier.Name as CarrierName,


// Step 6. Airline pictures in Bookings table
  @UI.lineItem: [ { position: 05, label: ' ', value: '_Carrier.AirlinePicURL' } ]
    _Carrier;

    }
