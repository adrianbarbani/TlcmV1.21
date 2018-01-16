global with sharing class AccountOrganizationChart {

    private ApexPages.StandardController controller;
    private final Account acct;
    public Account account {get;set;}
    private Integer querys = 0;
    private List<Contact> allContacts;
    private List<Contact> inOrgContacts;
    private List<Contact_Influence__c> allContactInfluences;
    public set<String> contactosEnFalse {get;set;}
    
    public AccountOrganizationChart(ApexPages.StandardController controller) {
    
        this.controller = controller;
        //this.acct = (Account)controller.getRecord();
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() ){
        this.acct = [select id, name from account where id = :((Account)controller.getRecord()).id];}
        account = acct;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ''));
    }   
  
  	public AccountOrganizationChart() {
  		Id objectId = ApexPages.currentPage().getParameters().get('Id');
  		String objectAPIName = objectId.getSObjectType().getDescribe().getName();
  		if (objectAPIName == 'Account') {
  			
  			if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() ){
  			this.acct = [SELECT  id, name FROM Account WHERE Id = :objectId];}
  			
  		} else if (objectAPIName == 'Opportunity') {
  			
  			Opportunity opp = new Opportunity();
  			
  			if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.accountId.isAccessible() ){
  			opp = [select accountId from Opportunity where id = :objectId];}
  			
  			if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() ){
  			this.acct = [SELECT id, name FROM Account WHERE Id = :opp.accountId];}
  		}  		
  		account = acct;
  		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ''));
  	}
  
    public List<Contact> getContacts() {
        if (allContacts == null) {
            
            allContacts = [SELECT id,Name,title, Closest_Account_Team_Member__r.name, Picture__c, ReportsToId, inOrg__c FROM Contact WHERE active__c = true and AccountId = :this.acct.id];
            
        }
        
        return allContacts;    
    }
    
    public PageReference saveContacts() { 
        
        system.debug('saveContacts');
        
        //try {
        system.debug(allContacts);
        
        contactosEnFalse = new Set<String>();
        
        /*
        for(Contact cnt: allContacts){
            if(!cnt.inOrg__c){
                if(cnt.ReportsToId!=null){
                    cnt.ReportsToId = null;
                    contactosEnFalse.add(cnt.id);
                }
            }
        }
        
        system.debug(contactosEnFalse);
        for(Contact cnt: allContacts){
            if(contactosEnFalse.contains(cnt.ReportsToId)){
                cnt.inOrg__c = false;
                cnt.ReportsToId = null;
            }
        }*/
        
        desactivarContactos();
 
        update allContacts;
        //} catch(DmlException ex){
        system.debug('no entre');
        //system.debug(ex);
        //ApexPages.addMessages(ex);
        //}
        return null;
    }
    
    public void desactivarContactos(){
        
        for(Contact cnt: allContacts){
            if(!cnt.inOrg__c){
                if(cnt.ReportsToId!=null){
                    cnt.ReportsToId = null;
                    contactosEnFalse.add(cnt.id);
                }
            }
        }
        
        desactivarHijos();
    }
    
    public void desactivarHijos(){
        
        boolean recursivo = false;
        
        if(contactosEnFalse.size()>0){            
            for(Contact cnt: allContacts){
                if(contactosEnFalse.contains(cnt.ReportsToId)){
                    cnt.inOrg__c = false;
                    recursivo = true;
                }
            }
            
            if(recursivo){
               desactivarContactos(); 
            }
        }
    }
    
    public List<Contact> getInOrgContacts() {    	
        inOrgContacts = new List<Contact>();       	    
        for (Contact c :getContacts()) {
    		if (c.inOrg__c) {
				inOrgContacts.add(c);        			
    		}
    	}
        return inOrgContacts;  
    }
    
    public String getList(){
    	List<ContactWrapper> contWrapperList = new List<ContactWrapper>();
    	
    	getContacts();
    	
    	List <Id> contactIds = new List<Id>();
        for (Contact c :getInOrgContacts()) {
            contactIds.add(c.id);
        }
        
        if(Schema.sObjectType.Contact_Influence__c.isAccessible() && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible()
        && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible()){
        allContactInfluences = [SELECT Contact_Influenced__c, Contact_Influences__c FROM Contact_Influence__c 
                                WHERE Contact_Influenced__c in :contactIds or Contact_Influences__c = :contactIds];
        }
        
    	List<Contact> seeds = getContacts(null);
    	
    	for (Contact a : seeds){
    		ContactWrapper contWrapper = new ContactWrapper();
    		contWrapperList.add(contWrapper);
    		
    		contWrapper.c = a;
    		
    		List<Contact_Influence__c> influenceList = getInfluences(a.id);
    		    		
    		contWrapper.Influences = new List<String>();
    		for (Contact_Influence__c ci :influenceList) {
                if (ci.Contact_Influenced__c == a.Id) {
                    contWrapper.Influences.add(ci.Contact_Influences__c);
                }
            }
            
            contWrapper.Influenced = new List<String>();
    		for (Contact_Influence__c ci :influenceList) {
                if (ci.Contact_Influences__c == a.Id) {
                    contWrapper.Influenced.add(ci.Contact_Influenced__c);
                }
            }
            
            contWrapper.childs = getListChilds(a.Id);    		
    	}
    	
    	//return contWrapperList;
    	return  JSON.serializePretty(contWrapperList);
    	
    }
    
    public List<ContactWrapper> getListChilds(String rid){
    	List<ContactWrapper> contWrapperList = new List<ContactWrapper>();
    	
    	for (Contact a : getContacts(rid)) {
    		ContactWrapper contWrapper = new ContactWrapper();
    		contWrapperList.add(contWrapper);
    		
    		contWrapper.c = a;
    		
    		List<Contact_Influence__c> influenceList = getInfluences(a.id);
    		    		
    		contWrapper.Influences = new List<String>();
    		for (Contact_Influence__c ci :influenceList) {
                if (ci.Contact_Influenced__c == a.Id) {
                    contWrapper.Influences.add(ci.Contact_Influences__c);
                }
            }
            
            contWrapper.Influenced = new List<String>();
    		for (Contact_Influence__c ci :influenceList) {
                if (ci.Contact_Influences__c == a.Id) {
                    contWrapper.Influenced.add(ci.Contact_Influenced__c);
                }
            }
            
            contWrapper.childs = getListChilds(a.Id);
    	}
    	
    	return contWrapperList;
    }
    
    private List<Contact_Influence__c> getInfluences(Id contactId) {
        List<Contact_Influence__c> influencesList = new List<Contact_Influence__c>();
        for (Contact_Influence__c ci :allContactInfluences) {
            if (ci.Contact_Influences__c == contactId || ci.Contact_Influenced__c == contactId) {
                influencesList.add(ci);
            }
        }
        return influencesList;
    }

    private List<Contact> getContacts(Id contactId) {
        List<Contact> contactList = new List<Contact>();
        for (Contact cont :getInOrgContacts()) {
            if (cont.ReportsToId == contactId) {
                contactList.add(cont);
            }
        }   
        return contactList;
    }
    
    @RemoteAction
    global static void changeOrg(Id sourceId, Id targetId) {        
        List<Contact> contactToUpdate = new List<Contact>();
        List<Contact> contactess = new List<Contact>();
        
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.ReportsToId.isAccessible() ){
        contactess = [select Id, ReportsToId from Contact where id != :sourceId and id != :targetId and (ReportsToId = :sourceId or ReportsToId = :targetId)];
        }
        
        for (Contact c :contactess) {
            if (c.ReportsToId == sourceId) {
                c.ReportsToId = targetId;
            } else {
                c.ReportsToId = sourceId;
                
            }
            contactToUpdate.add(c);
        }
        
        Contact source;
        Contact target; 
        
        List<Contact> contactess2 = new List<Contact>();
        
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.ReportsToId.isAccessible() ){
        contactess2 = [select Id, ReportsToId from Contact where Id = :sourceId or Id = :targetId];
        }
        
        for (Contact c : contactess2) {
            if (c.Id == sourceId) {
                source = c;
            } else {
                target = c;
            }           
        }
        
        Id aux = source.ReportsToId;
        source.ReportsToId = target.ReportsToId;
        if (target.id != aux) {
            target.ReportsToId = aux;           
        } else {
            target.ReportsToId = source.id;
        }
        contactToUpdate.add(source);
        contactToUpdate.add(target);
        
        try {
            if(Schema.sObjectType.Contact.isUpdateable() && Schema.sObjectType.Contact.fields.Name.isUpdateable()
            && Schema.sObjectType.Contact.fields.title.isUpdateable()
            && Schema.sObjectType.Contact.fields.Picture__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.ReportsToId.isUpdateable()
            && Schema.sObjectType.Contact.fields.inOrg__c.isUpdateable())
	        update contactToUpdate;
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
    }
    
    @RemoteAction
    global static void saveOrg(List<JavascriptObject> jsObject) {
        
        Map<Id,String> contactMap = new Map<Id,String>();
        Map<Id,List<Id>> contactInfluenceMap = new Map<Id,List<Id>>();
        for(JavascriptObject o :jsObject) {
            system.debug('>>>> o: ' + o);
            if (o.value != 'Parent') {
                contactMap.put(o.value,o.parent);
                List<Id> ids = new List<Id>(); 
                for (String s :o.influences.split(',')) {
                    if (s != '') {
                        ids.add(s);
                    }
                }
                contactInfluenceMap.put(o.value, ids);
            }
        }
        system.debug('>>>> contactMap: ' + contactMap);        
        
        List<Contact> contatsToUpdate = new List<Contact>();
        List<Contact> contactess3 = new List<Contact>();
        
        
        contactess3 = [select id, ReportsToId from Contact where id in :contactMap.keySet()];
        
        for(Contact c :contactess3) {
            if (contactMap.get(c.Id) != 'Parent') {
                c.ReportsToId = contactMap.get(c.Id);
            } else {
                c.ReportsToId = null;
            }
            contatsToUpdate.add(c);
        }       
        
        Savepoint sp = Database.setSavepoint();
        try {
            
            
            delete [select id from Contact_Influence__c where Contact_Influences__c in :contactMap.keySet() or Contact_Influenced__c in :contactMap.keySet()];
            
            
            List<Contact_Influence__c> contactInfluenceToInsert = new List<Contact_Influence__c>(); 
            for (ID firstId :contactInfluenceMap.keySet()) {
                for (Id secondId :contactInfluenceMap.get(firstId)) {
                    contactInfluenceToInsert.add(new Contact_Influence__c(Contact_Influenced__c = firstId, Contact_Influences__c = secondId));
                }
            }
            
            
            insert contactInfluenceToInsert;
            
            update contatsToUpdate;
            
            
        } catch(DmlException ex){
            Database.rollback(sp);
            ApexPages.addMessages(ex);
        }             
    }
    
    public PageReference rerenderPageBlock() {
        return null;
    }

    global class JavascriptObject {
        public String value;
        public String parent;   
        public String influences;       
    }
    
    global class ContactWrapper {
    	public Contact c {get;set;}
    	public List<String> Influences {get;set;}
    	public List<String> Influenced {get;set;}
    	public List<ContactWrapper> childs {get;set;}
    	
    	public ContactWrapper() {}    	
    }
    
 }