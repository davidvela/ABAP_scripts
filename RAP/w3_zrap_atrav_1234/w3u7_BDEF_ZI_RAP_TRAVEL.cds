managed;
with draft;

define behavior for ZI_RAP_Travel_#### alias Travel
implementation in class zbp_i_rap_travel_#### unique
persistent table zrap_atrav_####
draft table zrap_dtrav_####
lock master total etag LastChangedAt
authorization master ( instance )
etag master LocalLastChangedAt
{
  create;
  update;
  delete;
  association _Booking { create; with draft; }

  field ( numbering : managed, readonly ) TravelUUID;
  field ( readonly  ) TravelId, TotalPrice, TravelStatus;
  field ( readonly  ) LastChangedAt, LastChangedBy, CreatedAt, CreatedBy, LocalLastChangedAt;
  field ( mandatory ) AgencyID, CustomerID;

  action ( features : instance ) acceptTravel result [1] $self;
  action ( features : instance ) rejectTravel result [1] $self;
  internal action recalcTotalPrice;

  determination setInitialStatus    on modify { create; }
  determination calculateTotalPrice on modify { field BookingFee, CurrencyCode; }
  determination calculateTravelID   on save   { create; }

  validation validateAgency   on save { field AgencyID; create; }
  validation validateCustomer on save { field CustomerID; create; }
  validation validateDates    on save { field BeginDate, EndDate; create; }

  draft determine action Prepare  {
    validation validateAgency;
    validation validateCustomer;
    validation validateDates;
  }

  mapping for zrap_atrav_####
  {
    TravelUUID         = travel_uuid;
    TravelID           = travel_id;
    AgencyID           = agency_id;
    CustomerID         = customer_id;
    BeginDate          = begin_date;
    EndDate            = end_date;
    BookingFee         = booking_fee;
    TotalPrice         = total_price;
    CurrencyCode       = currency_code;
    Description        = description;
    TravelStatus       = overall_status;
    CreatedBy          = created_by;
    CreatedAt          = created_at;
    LastChangedBy      = last_changed_by;
    LastChangedAt      = last_changed_at;
    LocalLastChangedAt = local_last_changed_at;
  }
}

define behavior for ZI_RAP_Booking_#### alias Booking
implementation in class zbp_i_rap_booking_#### unique
persistent table zrap_abook_####
draft table zrap_dbook_####
lock dependent by _Travel
authorization dependent by _Travel
etag master LocalLastChangedAt
{
  update;
  delete;

  association _Travel { with draft; }

  field ( numbering : managed, readonly ) BookingUUID;
  field ( readonly ) TravelUUID, BookingId;
  field ( readonly ) CreatedBy, LastChangedBy, LocalLastChangedAt;

  determination calculateBookingID  on modify { create; }
  determination calculateTotalPrice on modify { field FlightPrice, CurrencyCode; }

  mapping for zrap_abook_####
  {
    BookingUUID        = booking_uuid;
    TravelUUID         = travel_uuid;
    BookingID          = booking_id;
    BookingDate        = booking_date;
    CustomerID         = customer_id;
    CarrierID          = carrier_id;
    ConnectionID       = connection_id;
    FlightDate         = flight_date;
    FlightPrice        = flight_price;
    CurrencyCode       = currency_code;
    CreatedBy          = created_by;
    LastChangedBy      = last_changed_by;
    LocalLastChangedAt = local_last_changed_at;
  }
}