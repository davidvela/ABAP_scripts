@AbapCatalog.sqlViewName: 'ZV_BOOKING_XXX'
@AbapCatalog.compiler.compareFilter : true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label : 'Data Definition Booking'
@Search.searchable : true
define view ZI_BOOKING_XXX
   as select from ztbooking_xxx as Booking
   association [0..1] to I_Country  as _Country  on $projection.country = _Country.country
   association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency

   {
     key booking              as Booking,
         @Search.defaultSearchElement: true
         customername         as CustomerName,
         numberofpassengers   as NumberOfPassengers,
         emailaddress         as EmailAddress,
         country,
         dateofbooking        as DateOfBooking,
         dateoftravel         as DateOfTravel,
         @Semantics.amount.currencyCode: 'CurrencyCode'
         cost,
         @Semantics.currencyCode: true
         currencycode          as CurrencyCode,
         lastchangedat         as LastChangedAt,

         _Country,
         _Currency       
}