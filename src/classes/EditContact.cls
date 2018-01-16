public with sharing class EditContact {

    private ApexPages.StandardController controller;
    private Contact contact;
    private List<Contact> ContactInfluenced;
    private List<Contact> ContactInfluences;
    public String IdtoDel {get; set;}
    public Contact_Influence__c CIs {get; set;}
    public Contact_Influence__c CId {get; set;}
    
   
    

    public EditContact(ApexPages.StandardController controller) {
        this.controller = controller;
        
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible() ){
        this.contact =  [SELECT name, id, accountid FROM Contact WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        }
        
        load(this.contact.id);
        this.CIs = new Contact_Influence__c();
        
        if (Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isCreateable()){
        this.CIs.Contact_Influenced__c = this.contact.id;}
        
        this.CId = new Contact_Influence__c();
        
        if (Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isCreateable()){
            this.CId.Contact_Influences__c = this.contact.id;}

    }

    public Contact getcontact(){
        return contact;
    }

    private Boolean load(String id){

        ContactInfluenced = new List<Contact>();
        
        List<Contact_Influence__c> contects = new List<Contact_Influence__c>();
        
        if(Schema.sObjectType.Contact_Influence__c.isAccessible() && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible()
         && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible()){    
        contects = [SELECT Contact_Influenced__c, Contact_Influences__c 
                                       FROM Contact_Influence__c 
                                       WHERE Contact_Influences__c = :id]; }   
            
            
        Contact contects2 = new Contact();    
            
        for( Contact_Influence__c ci: contects){
            
            if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible() ){
            contects2 = [SELECT Id, Name  FROM Contact WHERE Id = :ci.Contact_Influenced__c];
            }
            
           ContactInfluenced.add(contects2);
                                      
        }
        
        ContactInfluences = new List<Contact>();
            
        List<Contact_Influence__c> contects3 = new List<Contact_Influence__c>();
        
        if(Schema.sObjectType.Contact_Influence__c.isAccessible() && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible()
         && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible()){
        contects3 = [ SELECT Contact_Influenced__c, Contact_Influences__c FROM Contact_Influence__c 
                                      WHERE Contact_Influenced__c = :id];
        }
        
        Contact contects4 = new Contact(); 
            
        for( Contact_Influence__c ci: contects3){
            
            if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible() ){
            contects4 = [SELECT Id, Name  FROM Contact WHERE Id = :ci.Contact_Influences__c];
            }
            
           ContactInfluences.add(contects4);
                                      
        }
        
        return true; //Why this? no clue why null isn't available
    }

    public List<Contact> getContactInfluenced(){
        return ContactInfluenced;
    }
    public List<Contact> getContactInfluences(){
        return ContactInfluences;
    }

    public PageReference delCId(){
    
        this.IdtoDel = Apexpages.currentPage().getParameters().get('IdtoDelete');  
        
        Contact_Influence__c toDel = new Contact_Influence__c();
        
        if(Schema.sObjectType.Contact_Influence__c.isAccessible()){
        toDel= [ SELECT id FROM Contact_Influence__c 
                                     WHERE Contact_Influences__c = :this.contact.id AND Contact_Influenced__c = :IdtoDel limit 1];
        }
        
        try {
            
            if(Contact_Influence__c.sObjectType.getDescribe().isDeletable()){
                delete toDel;
            }
            
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        
        load(this.contact.id);
        

        
        return null;    
    }


    public PageReference delCIs(){
    

        this.IdtoDel = Apexpages.currentPage().getParameters().get('IdtoDelete');  
    
        Contact_Influence__c toDel2= new Contact_Influence__c();
        
        if(Schema.sObjectType.Contact_Influence__c.isAccessible()){
        toDel2= [ SELECT id FROM Contact_Influence__c 
                                     WHERE Contact_Influenced__c = :this.contact.id AND Contact_Influences__c = :IdtoDel  limit 1];
        }
        
        try {
            
            if(Contact_Influence__c.sObjectType.getDescribe().isDeletable()){
                delete toDel2;
            }
            
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        
        load(this.contact.id);
        
        return null;       
    }

    public PageReference InsertCIs(){
        if(this.CIs.Contact_Influences__c == null) {
            return null;
        }

        system.debug('InsertCIs');
        system.debug('InsertCIs2 '+this.CIs.Contact_Influences__c+'---'+this.contact.Id);
        
        
        Contact targetContact = new Contact();
        
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible() ){
        targetContact = [SELECT name, id, accountid FROM Contact WHERE Id = :this.CIs.Contact_Influences__c];
        }
        
        Boolean noErrors = true;
        if(targetContact.Id==this.contact.Id) {
            contact.addError(Label.SCP_noMismoContacto);
            noErrors = false;
        }
        
        if(targetContact.AccountId!=this.contact.AccountId) {
            contact.addError(Label.Influence_Same_Account);
            noErrors = false;
        }
        
        if(noErrors){
            try {
		        
                if (Schema.sObjectType.Contact_Influence__c.isCreateable()){
                    insert this.CIs;
                }
                    
                this.CIs = null;        
	            this.CIs = new Contact_Influence__c();
	            this.CIs.Contact_Influenced__c = this.contact.id;
	            
	            load(this.contact.id);
		    } catch(DmlException ex){
		        ApexPages.addMessages(ex);
		    }
        }        
        return null;
    }
    
    public PageReference InsertCId(){
        if(this.CId.Contact_Influenced__c == null) {
            return null;
        }
        
        system.debug('InsertCId');
        system.debug('InsertCId2 '+this.CId.Contact_Influenced__c+'---'+this.contact.Id);
        
        Contact targetContact = new Contact();
        
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible() ){
        targetContact = [SELECT name, id, accountid FROM Contact WHERE Id = :this.CId.Contact_Influenced__c];
        }
        
        Boolean noErrors = true;
        if(targetContact.Id==this.contact.Id) {
            contact.addError(Label.SCP_noMismoContacto);
            noErrors = false;
        }
        
        if(targetContact.AccountId!=this.contact.AccountId) {
            contact.addError(Label.Influence_Same_Account);
            noErrors = false;
        }
        
        if(noErrors){
            try {
                
                if (Schema.sObjectType.Contact_Influence__c.isCreateable()){
                    insert this.CId;
                }
                
	            this.CId = null;        
	            this.CId = new Contact_Influence__c();
	            this.CId.Contact_Influences__c = this.contact.id;
	        
	            load(this.contact.id);
            } catch(DmlException ex){
		        ApexPages.addMessages(ex);
		    }
        
        }
        
        return null;
    }
   
    public PageReference saveAndRedirect() {
        //update contact;
        PageReference GoToPage = new PageReference('/apex/accountOrganizationChartWindow?id='+this.contact.accountid);
        GoToPage.setRedirect(true);
        return GoToPage;
    }
}