public with sharing class accountValueChainTableController {
    
    public Account account {get;set;}
    public Boolean canEdit {get;set;}
    public VCFunction__c newFunction {get;set;}
    public List<ValueChainWrapper> valueChainWrapperList {get;set;}
    public List<VCFunction__c> functionSortList; 
    private String dblClickToCreate = Label.dblClickToAddValue;
    public Id functionId {get;set;}
    public Id vcId {get;set;}    

    public accountValueChainTableController() {        
        
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()
        && Schema.sObjectType.Account.fields.parentId.isAccessible()
        && Schema.sObjectType.Account.fields.Industry.isAccessible()
        && Schema.sObjectType.Account.fields.Region__c.isAccessible()
        && Schema.sObjectType.Account.fields.External_Analysts_vision__c.isAccessible()
        && Schema.sObjectType.Account.fields.Strategic_Context__c.isAccessible()
        && Schema.sObjectType.Account.fields.Buying_Criteria__c.isAccessible()
        && Schema.sObjectType.Account.fields.Strategic_Context_Last_Update__c.isAccessible()){
        account = [SELECT name, id, parentId, Industry,Region__c, External_Analysts_vision__c, Strategic_Context__c, Buying_Criteria__c, Strategic_Context_Last_Update__c FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];    
        }
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);        
        init();        
    }
    
    public List<String> getFunctionList() {
        List<String> l = new List<String>();
        l.add('Function 1');
        l.add('Function 2');
        return l;
    }
    
    private void init() {
        newFunction = new VCFunction__c(name = '', account__c = account.id);
        
        Map<Id,List<Value_Chain__c>> valueChainMap = new Map<Id,List<Value_Chain__c>>();
        
        if(Schema.sObjectType.VCFunction__c.isAccessible() && Schema.sObjectType.VCFunction__c.fields.Name.isAccessible() ){
        functionSortList = [Select id, name from VCFunction__c where account__c = :account.id order by CreatedDate];
        }
        Map<Id,VCFunction__c> functionMap = new Map<Id,VCFunction__c>();
        for (VCFunction__c f :functionSortList) {
            functionMap.put(f.id,f);
        }        
        
        //Map<Id,VCFunction__c> functionMap = new Map<Id,VCFunction__c>([Select id, name from VCFunction__c where account__c = :account.id order by CreatedDate]);
        

        for (VCFunction__c f :functionSortList) {
            if (valueChainMap.get(f.id) == null) {
               valueChainMap.put(f.id, new List<Value_Chain__c>());
            }            
        }
        system.debug('>>>>> functionMap: ' + functionMap);
        system.debug('>>>>> valueChainMap: ' + valueChainMap);
        
        
        List<Value_Chain__c> vcs = new List<Value_Chain__c>();
        
        if(Schema.sObjectType.Value_Chain__c.isAccessible() && Schema.sObjectType.Value_Chain__c.fields.Name.isAccessible()
        && Schema.sObjectType.Value_Chain__c.fields.value__c.isAccessible()
        && Schema.sObjectType.Value_Chain__c.fields.function__c.isAccessible()){
        vcs = [select id, name, value__c, function__c, (select capability__c, capability__r.Name, capability__r.value__c from value_chain__r) from Value_Chain__c where function__c in :functionMap.keySet() order by CreatedDate];        
        }
        for (Value_Chain__c vc :vcs) {
            if (valueChainMap.get(vc.function__c) == null) {
               valueChainMap.put(vc.function__c, new List<Value_Chain__c>());
            }
            valueChainMap.get(vc.function__c).add(vc);
        }         
                
        valueChainWrapperList = new List<ValueChainWrapper>();
        
        for (VCFunction__c function :functionSortList) {
            if (canEdit) {
                valueChainMap.get(function.Id).add(new Value_Chain__c(value__c = dblClickToCreate, function__c = function.Id));
            }
            ValueChainWrapper vcw = new ValueChainWrapper(functionMap.get(function.Id),valueChainMap.get(function.Id)); 
            valueChainWrapperList.add(vcw);
        }
        /*
        for (Id functionId :valueChainMap.keySet()) {
            valueChainMap.get(functionId).add(new Value_Chain__c(value__c = dblClickToCreate, function__c = functionId));
            ValueChainWrapper vcw = new ValueChainWrapper(functionMap.get(functionId),valueChainMap.get(functionId)); 
            valueChainWrapperList.add(vcw);
        }
        */
        system.debug('>>>>> valueChainMap.keySet(): ' + valueChainMap.keySet());
        system.debug('>>>>> valueChainWrapperList: ' + valueChainWrapperList);
        
    }

    public PageReference newFunction() {         
        if (newFunction.name != '' && newFunction.name != null) {
            
            if(Schema.sObjectType.VCFunction__c.fields.name.isCreateable() &&
            Schema.sObjectType.VCFunction__c.fields.account__c.isCreateable() &&
            Schema.sObjectType.VCFunction__c.isCreateable()){
                insert newFunction; 
            }
                  
        }
        init();
        return null;
    }
    
    public PageReference saveChanges() {
        List<Value_Chain__c> valueChainToUpdate = new List<Value_Chain__c>();
        //List<Value_Chain__c> valueChainToInsert = new List<Value_Chain__c>();
        List<VCFunction__c> functionToUpdate = new List<VCFunction__c>();
        
        for (ValueChainWrapper vcw :valueChainWrapperList) {
            functionToUpdate.add(vcw.function);
            for (Value_Chain__c vc :vcw.valueChainList) {
                if (vc.value__c != dblClickToCreate) {
                    valueChainToUpdate.add(vc);
                }
            }
        }
        
        if(Schema.sObjectType.Value_Chain__c.isCreateable()
        && Schema.sObjectType.Value_Chain__c.fields.name.isCreateable()
        && Schema.sObjectType.Value_Chain__c.fields.value__c.isCreateable()
        && Schema.sObjectType.Value_Chain__c.fields.function__c.isCreateable()
        && Schema.sObjectType.Value_Chain__c.isUpdateable()
        && Schema.sObjectType.Value_Chain__c.fields.name.isUpdateable()
        && Schema.sObjectType.Value_Chain__c.fields.value__c.isUpdateable()
        && Schema.sObjectType.Value_Chain__c.fields.function__c.isUpdateable())  
        upsert valueChainToUpdate;
        
        if(Schema.sObjectType.VCFunction__c.fields.name.isUpdateable() &&
            Schema.sObjectType.VCFunction__c.fields.account__c.isUpdateable() &&
            Schema.sObjectType.VCFunction__c.isUpdateable()){
        update functionToUpdate;
            }
        init();
        return null;
    }
    
    public PageReference deleteFunction() {
        VCFunction__c f = new VCFunction__c(id = functionId);
        if(VCFunction__c.sObjectType.getDescribe().isDeletable()){
            delete f;
        }
        init();
        return null;
    }

    public PageReference deleteVC() {
        Value_Chain__c vc = new Value_Chain__c(id = vcId);
        if(Value_Chain__c.sObjectType.getDescribe().isDeletable()){
            delete vc;
        }
        init();
        return null;
    }
    
    public List<ValueChainWrapper> getValueChainWrapperList() {
        return ValueChainWrapperList;
    }    

}