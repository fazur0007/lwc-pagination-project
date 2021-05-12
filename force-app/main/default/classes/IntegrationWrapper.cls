public with sharing class IntegrationWrapper {
    public IntegrationWrapper() {

    }
    public static IntegrationInnerWrapper doWrap(){
        IntegrationInnerWrapper wrapper = new IntegrationInnerWrapper();
        wrapper.FirstName = 'Fazurulla';
        wrapper.LastName = 'Ganganapalli';
        wrapper.EmailId = 'fgangana@breville.com';
        return wrapper;
    }
    public class IntegrationInnerWrapper {
        @AuraEnabled public static String FirstName {get;set;}
        @AuraEnabled public static String LastName {get;set;}
        @AuraEnabled public static String EmailId {get;set;}
    }
}
