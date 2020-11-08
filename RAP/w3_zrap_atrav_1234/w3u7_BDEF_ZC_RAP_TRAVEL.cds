
projection;
use draft;

define behavior for ZC_RAP_Travel_#### alias Travel
//use etag
{
  use create;
  use update;
  use delete;
  use association _Booking { create; with draft; }

  use action acceptTravel;
  use action rejectTravel;
}


define behavior for ZC_RAP_Booking_#### alias Booking
//use etag
{
  use update;
  use delete;

  use association _Travel { with draft; }
}