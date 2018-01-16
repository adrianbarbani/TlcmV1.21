public with sharing class  CapabilityWrapper {
    public CapabilityArea__c capabilityArea {get;set;}
    public List<Capability__c> capabilityList {get;set;}

    public CapabilityWrapper(CapabilityArea__c ca, List<Capability__c> cl) {
        capabilityArea = ca;
        capabilityList = cl;
    }
}