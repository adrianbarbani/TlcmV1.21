public with sharing  class accountCapabilityMatrixController {

    public Account account {get;set;}
    public Boolean canEdit {get;set;}
    public CapabilityArea__c newCapabilityArea {get;set;}
    public List<CapabilityWrapper> CapabilityWrapperList {get;set;}
    public List<CapabilityArea__c> capabilityAreaList; 
    private String dblClickToCreate = Label.dblClickToAddCapability;
    public Id capabilityAreaId {get;set;}
    public Id capabilityId {get;set;}    

    public accountCapabilityMatrixController() { 
        
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.parentId.isAccessible() && Schema.sObjectType.Account.fields.Industry.isAccessible() && Schema.sObjectType.Account.fields.Region__c.isAccessible() && Schema.sObjectType.Account.fields.External_Analysts_vision__c.isAccessible() && Schema.sObjectType.Account.fields.Strategic_Context__c.isAccessible() && Schema.sObjectType.Account.fields.Buying_Criteria__c.isAccessible() && Schema.sObjectType.Account.fields.Strategic_Context_Last_Update__c.isAccessible() ){
        account = [SELECT name, id, parentId, Industry,Region__c, External_Analysts_vision__c, Strategic_Context__c, Buying_Criteria__c, Strategic_Context_Last_Update__c FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];    
        }
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);        
        init();        
    }

    private void init() {
        if(Schema.sObjectType.CapabilityArea__c.fields.name.isCreateable() && Schema.sObjectType.CapabilityArea__c.fields.account__c.isCreateable())
        newCapabilityArea = new CapabilityArea__c(name = '', account__c = account.id);
        
        Map<Id,List<Capability__c>> capabilityMap = new Map<Id,List<Capability__c>>();
        
         if(Schema.sObjectType.CapabilityArea__c.isAccessible() && Schema.sObjectType.CapabilityArea__c.fields.name.isAccessible() && Schema.sObjectType.CapabilityArea__c.fields.account__c.isAccessible()){
        capabilityAreaList = [Select id, name, account__c from CapabilityArea__c where account__c = :account.id or account__c = null order by CreatedDate];
         }
        Map<Id,CapabilityArea__c> capabilityAreaMap = new Map<Id,CapabilityArea__c>();
        for (CapabilityArea__c f :capabilityAreaList) {
            capabilityAreaMap.put(f.id,f);
        }        
        
        //Map<Id,CapabilityArea__c> capabilityAreaMap = new Map<Id,CapabilityArea__c>([Select id, name from CapabilityArea__c where account__c = :account.id order by CreatedDate]);
        

        for (CapabilityArea__c f :capabilityAreaList) {
            if (capabilityMap.get(f.id) == null) {
               capabilityMap.put(f.id, new List<Capability__c>());
            }            
        }
        system.debug('>>>>> capabilityAreaMap: ' + capabilityAreaMap);
        system.debug('>>>>> capabilityMap: ' + capabilityMap);
        
        List<Capability__c> vcs = new List<Capability__c>();
        
         if(Schema.sObjectType.Capability__c.isAccessible() && Schema.sObjectType.Capability__c.fields.name.isAccessible() && Schema.sObjectType.Capability__c.fields.value__c.isAccessible() && Schema.sObjectType.Capability__c.fields.capabilityArea__c.isAccessible()){
         vcs = [select id, name, value__c, capabilityArea__c, (select value_chain__c, value_chain__r.Name, value_chain__r.value__c from capability__r) from Capability__c where capabilityArea__c in :capabilityAreaMap.keySet() and account__c = :account.id order by CreatedDate];        
         }
        for (Capability__c vc :vcs) {
            if (capabilityMap.get(vc.capabilityArea__c) == null) {
               capabilityMap.put(vc.capabilityArea__c, new List<Capability__c>());
            }
            capabilityMap.get(vc.capabilityArea__c).add(vc);
        }         
                
        CapabilityWrapperList = new List<CapabilityWrapper>();
        
        for (CapabilityArea__c capabilityArea :capabilityAreaList) {
            if (canEdit) {
                capabilityMap.get(capabilityArea.Id).add(new Capability__c(value__c = dblClickToCreate, capabilityArea__c = capabilityArea.Id, account__c = account.id));
            }
            CapabilityWrapper cw = new CapabilityWrapper(capabilityAreaMap.get(capabilityArea.Id),capabilityMap.get(capabilityArea.Id)); 
            CapabilityWrapperList.add(cw);
        }

        system.debug('>>>>> capabilityMap.keySet(): ' + capabilityMap.keySet());
        system.debug('>>>>> CapabilityWrapperList: ' + CapabilityWrapperList);
        
    }

    public PageReference newCapabilityArea() {         
        if (newCapabilityArea.name != null && newCapabilityArea.name != '') {
            if (Schema.sObjectType.CapabilityArea__c.isCreateable()){
                insert newCapabilityArea;
            }
        }
        init();
        return null;
    }
    
    public PageReference saveChanges() {
        List<Capability__c> capabilityToUpdate = new List<Capability__c>();
        //List<Capability__c> capabilityToInsert = new List<Capability__c>();
        List<CapabilityArea__c> capabilityAreaToUpdate = new List<CapabilityArea__c>();
        
        for (CapabilityWrapper cw :CapabilityWrapperList) {
            capabilityAreaToUpdate.add(cw.capabilityArea);
            for (Capability__c vc :cw.capabilityList) {
                if (vc.value__c != dblClickToCreate) {
                    capabilityToUpdate.add(vc);
                }
            }
        }
        
        if(Schema.sObjectType.Capability__c.fields.value__c.isUpdateable() &&
           Schema.sObjectType.Capability__c.isUpdateable() &&
           Schema.sObjectType.Capability__c.fields.value__c.isCreateable() &&
           Schema.sObjectType.Capability__c.isCreateable() )
        upsert capabilityToUpdate;
        
        if(Schema.sObjectType.Capability__c.fields.value__c.isUpdateable() &&
           Schema.sObjectType.Capability__c.isUpdateable() )
        update capabilityAreaToUpdate;
                
        init();
        return null;
    }
    
    public PageReference deletecapabilityArea() {
        CapabilityArea__c f = new CapabilityArea__c(id = capabilityAreaId);
        
        if(CapabilityArea__c.sObjectType.getDescribe().isDeletable()){
            delete f;
        }
        
        init();
        return null;
    }

    public PageReference deleteVC() {
        Capability__c c = new Capability__c(id = capabilityId);
        
        if(Capability__c.sObjectType.getDescribe().isDeletable()){
            delete c;
        }
        
        init();
        return null;
    }
    
    public List<CapabilityWrapper> getCapabilityWrapperList() {
        return CapabilityWrapperList;
    } 

}