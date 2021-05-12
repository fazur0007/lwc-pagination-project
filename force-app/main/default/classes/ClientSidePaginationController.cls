public with sharing class ClientSidePaginationController {
    public class DataTableWrapper{
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String Name {get;set;}
        @AuraEnabled public String FirstName {get;set;}
        @AuraEnabled public String LastName {get;set;}
        @AuraEnabled public String Phone {get;set;}
        @AuraEnabled public String Email {get;set;}
    }

    @AuraEnabled(cacheable=false)
    public static List<DataTableWrapper>  fetchRecords(){
        return getRandomEmployees(100);
    }

    private static  List<DataTableWrapper>  getRandomEmployees(Integer recToReturn){
        List<DataTableWrapper> lstRet = new List<DataTableWrapper>();
        for(Integer i=0;i<recToReturn;i++){
            DataTableWrapper obj = new DataTableWrapper();
            obj.Id = generateRandomString(15);
            obj.Name = generateRandomString(18);
            obj.FirstName = generateRandomString(18);
            obj.LastName = generateRandomString(18);
            obj.Phone = generateRandomString(18);
            obj.Email = generateRandomString(18)+'@yopmail.com';
            lstRet.add(obj);
        }   
        return lstRet;
    }
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}