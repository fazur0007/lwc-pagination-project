/*
    @className: BrevilleIntegrationUtility
    @description: Utility methods for REST Services
    @author: Fazurulla Ganganapalli
    @History : 
*/
Public class BrevilleIntegrationUtility {

    /**
    * Status codes for response
        * 2xx: Success category
        * 3xx: Redirection category (not considered in the util)
        * 4xx: Client error category
        * 5xx: Server error category
    * Codes handled by Salesforce are
        * 401: Session or Token expired
        * 503: Too many requests or service is down for maintenance
    */
    public static FINAL Integer STATUS_OK         = 200; // success on GET, PATCH, HEAD request
    public static FINAL Integer STATUS_OK_PATCH   = 201; // success on PATCH Request
    public static FINAL Integer STATUS_OK_DELETE  = 204; // success on DELETE request
    
    public static FINAL Integer STATUS_BAD        = 400; // bad request
    public static FINAL Integer STATUS_FORBIDDEN  = 403; // insufficient access 
    public static FINAL Integer STATUS_NOTFOUND   = 404; // resource not found
    public static FINAL Integer STATUS_CONFLICT   = 409; // conflict occured
    
    public static FINAL Integer STATUS_ISE        = 500; // salesforce server error
    
    /** Request types */
    public static FINAL String REQ_GET = 'GET';
    public static FINAL String REQ_PUT = 'PUT';
    public static FINAL String REQ_POST = 'POST';
    public static FINAL String REQ_PATCH = 'PATCH';
    public static FINAL String REQ_DELETE = 'DELETE';
    
    Public Static String clientId = 'b1bc0415-f2f9-45f2-9248-a11ada02f0c2';
    Public Static String clientSecret = 'Cs1/gCiUcQtgxOQ3nBL8483lyasYvpzudAGWGYks/sw=';
    Public Static String resource = 'https://breville.operations.dynamics.com';
    Public Static String tenant_id = '3bc317b4-2fb3-45e8-9410-9824eeb72e16';
    Public Static String reqbody = 'grant_type=client_credentials&client_id=' + clientId + '&client_secret=' + clientSecret + '&resource=' + resource + '&tenant_id=' + tenant_id;
    
    public static string getAccessToken() {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint('https://login.microsoftonline.com/3bc317b4-2fb3-45e8-9410-9824eeb72e16/oauth2/token');
        HttpResponse res = h.send(req);
        if (res.getstatuscode() == STATUS_OK) {
            GrantAccessToken accessToken = (GrantAccessToken) JSON.deserialize(res.getbody(),GrantAccessToken.class);
            if (accessToken.access_token != null) {
                return accessToken.access_token;
            } else {
                return null;
            }
        }
        return null;
    } 
    public class GrantAccessToken {
        public String token_type {get;set;}
        public String expires_in {get;set;}
        public String resource {get;set;}
        public String expires_on {get;set;}
        public String access_token {get;set;}
    }  
     
    public static String MakeCalloutUtility(Map<String, String> configUtilityMap)
    {
        if (Limits.getCallouts() >= Limits.getLimitCallouts())
        {
            throw new AuraHandledException('Maximum number of callouts has been reached.');
        } else {
            Http h2 = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Authorization', 'Bearer ' + configUtilityMap.get('accessToken'));
            request.setHeader('Content-Type', 'application/json; charset=utf-8');
            request.setHeader('accept', 'applicatin/json');
            request.setMethod(configUtilityMap.get('method'));
            
            if (configUtilityMap.get('requestPayload') != null)
                request.setBody(configUtilityMap.get('requestPayload'));
            request.setEndpoint(configUtilityMap.get('endpoint'));
            try
            {
                response = h2.send(request);
                if (response.getStatusCode() == STATUS_OK || response.getStatusCode() == STATUS_OK_PATCH) {
                    return response.getbody().
                        replace('"@odata.context"', '"odata_context"').
                        replace('"@odata.etag"', '"odata_etag"').
                        replace('"Currency"', '"Currency_D"').
                        replace('"Date"', '"Date_D"');
                } else {
                        Integer statusCode = response.getStatusCode();
                        String err = 'Error occured with : Status Code - ' + String.valueOf(statusCode);
                        if (statusCode == 401)
                            err += ': Unauthorized. The request requires user authentication.';
                        else if (statusCode == 403)
                            err += ': Forbidden. The API understood the request, but is refusing to fulfill it. Most commonly, this means that the user has exceeded their request limit or does not have permissions to access this API.';
                        else if (statusCode == 500)
                            err += ': Server Error. The API encountered an unexpected condition which prevented it from fulfilling the request.';
                        else if (statusCode == 503)
                            err += ': Service Unavailable. The API is unavailable to handle the request due to a temporary overloading or maintenance of the server.';
                        else
                            err += '.';
                }
                return null;
            }
            catch (exception e)
            {
                system.debug('success json code::' + response.getStatusCode());
                system.debug(e.getMessage());
                return null;
            }
        }
    }
}