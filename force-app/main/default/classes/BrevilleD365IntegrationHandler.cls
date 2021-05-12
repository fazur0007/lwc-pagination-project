/*
    @className: BrevilleD365IntegrationHandler
    @description: D365 integration hanler
    @author: Fazurulla Ganganapalli
    @History : 
*/
public class BrevilleD365IntegrationHandler
{
    @AuraEnabled
    public static BrevilleD365IntegrationWrapper getD365Invoices()
    {
        String vendorAccount = 'VEN31827';
        String dataAreaId = 'bus';
        String endpoint = 'https://breville.operations.dynamics.com/data/VendorInvoiceHeaders?cross-company=true&$filter=dataAreaId%20eq%20%27' + dataAreaId + '%27%20and%20VendorAccount%20eq%20%27' + vendorAccount + '%27';
        String accessToken = BrevilleIntegrationUtility.getAccessToken();
        if (String.isNotBlank(accessToken))
        {
            Map<String, String> configUtilityMap = new Map<String, String>{
                'requestPayload'   => null,
                'endpoint'         => endpoint,
                'accessToken'      => accessToken,
                'method'           => BrevilleIntegrationUtility.REQ_GET
            };
            String responsePayload = BrevilleIntegrationUtility.MakeCalloutUtility(configUtilityMap);
            if (String.isNotBlank(responsePayload))
            {
                BrevilleD365IntegrationWrapper wrapperObject = parseInvoices(responsePayload);
                if (wrapperObject != null)
                {
                    for (BrevilleD365IntegrationWrapper.cls_value wrapperRecord: wrapperObject.value)
                    {
                        //@TBD future logic
                    }
                }
                return wrapperObject;
            }
        }
        return null;
    }
    @AuraEnabled
    public static PurchaseOrderWrapper getInvoicePurchaseOrders(String PurchaseOrder)
    {
        String endpoint = 'https://breville.operations.dynamics.com/data/VendorInvoiceLines?cross-company=true&$filter=PurchaseOrder%20eq%20%27' + PurchaseOrder + '%27';
        String accessToken = BrevilleIntegrationUtility.getAccessToken();
        if (String.isNotBlank(accessToken))
        {
            Map<String, String> configUtilityMap = new Map<String, String>{
                'requestPayload'   => null,
                'endpoint'         => endpoint,
                'accessToken'      => accessToken,
                'method'           => BrevilleIntegrationUtility.REQ_GET
            };
            String responsePayload = BrevilleIntegrationUtility.MakeCalloutUtility(configUtilityMap);
            if (String.isNotBlank(responsePayload))
            {
                PurchaseOrderWrapper wrapperObject = parsePurchaseOrders(responsePayload);
                if (wrapperObject != null)
                {
                    for (PurchaseOrderWrapper.cls_value wrapperRecord: wrapperObject.value)
                    {
                        //@TBD future logic
                    }
                }
                return wrapperObject;
            }
        }
        return null;
    }
    public static BrevilleD365IntegrationWrapper parseInvoices(String json)
    {
        return (BrevilleD365IntegrationWrapper) System.JSON.deserialize(json, BrevilleD365IntegrationWrapper.class);
    }
    public static PurchaseOrderWrapper parsePurchaseOrders(String json)
    {
        return (PurchaseOrderWrapper) System.JSON.deserialize(json, PurchaseOrderWrapper.class);
    }
}