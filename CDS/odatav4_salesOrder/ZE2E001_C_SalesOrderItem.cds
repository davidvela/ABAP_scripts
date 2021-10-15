
@AbapCatalog.sqlViewName: 'ZE2E001CSOI'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'OData V4 Demo Service - SalesOrder Items'
define view Ze2e001_C_Salesorderitem 
 as select from SEPM_I_SalesOrderItem_E
  association [0..*] to SEPM_I_SalesOrderItemText_E as _Text on  $projection.SalesOrder     = _Text.SalesOrder
                                                             and $projection.SalesOrderItem = _Text.SalesOrderItem
{
      //SEPM_I_SalesOrderItem_E
  key SalesOrder,
  key SalesOrderItem,
      Product,
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      GrossAmountInTransacCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      NetAmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmountInTransactionCurrency,
      ProductAvailabilityStatus,
      OpportunityItem,
      /* Associations */
      _Text
}