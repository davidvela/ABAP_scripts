managed; // implementation in class zbp_i_rap_travel_#### unique;

define behavior for ZI_RAP_Travel_#### alias Travel
persistent table zrap_atrav_####
lock master
//authorization master ( instance )
etag master LocalLastChangedAt
{
  create;
  update;
  delete;
  association _Booking { create; }

  field ( numbering : managed, readonly ) TravelUUID;

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
persistent table zrap_abook_####
lock dependent by _Travel
//authorization dependent by <association>
etag master LocalLastChangedAt
{
  association _Travel;

  update;
  delete;

  field ( numbering : managed, readonly ) BookingUUID;
  field ( readonly ) TravelUUID;

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
