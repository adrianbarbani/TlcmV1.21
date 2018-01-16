public  with sharing class ValueChainWrapper {
    public VCFunction__c function {get;set;}
    public List<Value_Chain__c> valueChainList {get;set;}

    public ValueChainWrapper(VCFunction__c f, List<Value_Chain__c> vcl) {
        function = f;
        valueChainList = vcl;
    }
}