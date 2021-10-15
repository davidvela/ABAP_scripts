@AbapCatalog.sqlViewName: 'YACDVTSFLIGHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'YAC: DVT FLIGTHS'
define view yac_dvt_sflight as select from sflight as _Flight
association [0..1] to scarr as _Airline on  $projection.carrid = _Airline.carrid
{//SFLIGHT
            mandt,
            carrid,
            _Airline.carrname,  
            connid,
            fldate,
            @Semantics.amount.currencyCode: 'currency'
            price,
            currency,
            planetype,
            seatsmax,
            seatsocc,
            paymentsum,
            seatsmax_b,
            seatsocc_b,
            seatsmax_f,
            seatsocc_f, 
//* Associations *//           
            _Airline
            
    
}