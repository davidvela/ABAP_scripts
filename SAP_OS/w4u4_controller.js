onShareClick: function (oEvent) {
    var oExtensionApi = this.base.templateBaseExtension.getExtensionAPI();
    var aSelection = oExtensionApi.getSelectedContexts();
    if (aSelection.length > 0) {
        var sTo = "nobody@sap.com";
        var sSubject = "Look at these products"
        var sProducts = aSelection.reduce(function (sText, oSelectedContext) {
            var mSelectedData = oSelectedContext.getObject();
            return sText + mSelectedData.Product + " | " + mSelectedData.Price + " | " + mSelectedData.Currency + "\n";
        }, "");

        sap.m.URLHelper.triggerEmail(sTo, sSubject, sProducts);
    }
}