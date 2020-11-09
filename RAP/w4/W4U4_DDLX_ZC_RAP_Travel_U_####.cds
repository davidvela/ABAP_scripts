@Metadata.layer: #CORE
@UI: {
  headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {
      type: #STANDARD,
      label: 'Travel',
      value: 'TravelID'
    }
  },
  presentationVariant: [ { sortOrder: [ { by:         'TravelID',
                                          direction:  #DESC }] }]
}
annotate view ZC_RAP_Travel_U_#### with
{
  @UI.facet: [ { id:            'Travel',
                 purpose:       #STANDARD,
                 type:          #IDENTIFICATION_REFERENCE,
                 label:         'Travel',
                 position:      10 },
               { id:            'Booking',
                 purpose:       #STANDARD,
                 type:          #LINEITEM_REFERENCE,
                 label:         'Booking',
                 position:      20,
                 targetElement: '_Booking'}]

  @UI: { lineItem:        [ { position: 10 } ],
         identification:  [ { position: 10 } ]  }
  TravelID;

  @UI: { lineItem:        [ { position: 20 } ],
         identification:  [ { position: 20 } ]  }
  AgencyID;

  @UI: { lineItem:        [ { position: 30 } ],
         identification:  [ { position: 30 } ]  }
  CustomerID;

  @UI: { lineItem:        [ { position: 40 } ],
         identification:  [ { position: 40 } ]  }
  BeginDate;

  @UI: { lineItem:        [ { position: 50 } ],
         identification:  [ { position: 50 } ]  }
  EndDate;

  @UI: { lineItem:        [ { position: 60 } ],
         identification:  [ { position: 60 } ]  }
  BookingFee;

  @UI: { lineItem:        [ { position: 70 } ],
         identification:  [ { position: 70 } ]  }
  TotalPrice;

  @UI: { identification:  [ { position: 80 } ]  }
  Description;

  @UI: { lineItem:        [ { position: 90 } ],
         identification:  [ { position: 90 } ]  }
  Status;

  @UI.hidden: true
  Createdby;

  @UI.hidden: true
  Createdat;

  @UI.hidden: true
  Lastchangedby;

  @UI.hidden: true
  Lastchangedat;

}