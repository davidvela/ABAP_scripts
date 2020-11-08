projection;

define behavior for ZC_RAP_Travel_#### alias Travel
use etag
{
  use create;
  use update;
  use delete;

  use association _Booking { create; }
}

define behavior for ZC_RAP_Booking_#### alias Booking
use etag
{
  use update;
  use delete;

  use association _Travel;
}