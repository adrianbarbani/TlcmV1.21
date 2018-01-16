public with sharing class OpportunityEvaluations {
    public String contactIdToEvaluate {
        get;
        // *** setter is NOT being called ***
        set {
            contactIdToEvaluate = value;
        }
    }

    public String delid {
        get;
        // *** setter is NOT being called ***
        set {
            delid = value;
        }
    }
    
    public Contact contactToEvaluate {get; set;}
    public Contact_Assessment__c newEval { get; set; }
    public Opportunity opportunity {get; set;}
    public List<Contact_Assessment__c> evaluated {get; set;}
    public Account account {get; set;}    
    public Boolean canEdit {get;set;}
    public List<Contact> contatsFromParents {get;set;}
    public List<Id> accountInheritanceIds;

	public Id objectId {get;set;} 
	public String objectAPIName {get;set;}

    public OpportunityEvaluations(){
    	
    	objectId = (Id) ApexPages.currentPage().getParameters().get('Id');
    	objectAPIName = objectId.getSObjectType().getDescribe().getName();
    	
    	if (objectAPIName == 'Opportunity') { 
    	    
    	    if(Schema.sObjectType.Opportunity.isAccessible()
    	    && Schema.sObjectType.Opportunity.fields.name.isAccessible()
    	    && Schema.sObjectType.Opportunity.fields.id.isAccessible()
    	    && Schema.sObjectType.Opportunity.fields.accountId.isAccessible()
    	    && Schema.sObjectType.Opportunity.fields.Description.isAccessible()){
            	this.opportunity = [SELECT name, id, accountId,Description FROM Opportunity WHERE Id = :objectId];
    	    }
    	    
    	    if(Schema.sObjectType.Account.isAccessible()
    	    && Schema.sObjectType.Account.fields.name.isAccessible()
    	    && Schema.sObjectType.Account.fields.parentId.isAccessible()
    	    && Schema.sObjectType.Account.fields.Industry.isAccessible()
    	    && Schema.sObjectType.Account.fields.Region__c.isAccessible()){
    	        
	        this.account = [SELECT name, id, parentId, Industry, Region__c, parent.name FROM Account WHERE Id = :opportunity.accountId];
    	    }
    	    
    	    if(Schema.sObjectType.Contact_Assessment__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isAccessible()
    	    && Schema.sObjectType.Contact.fields.Name.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isAccessible()){
    	        
    	        this.evaluated = [SELECT Id, Attitudes__c, Authority__c, Contact__c, 
    	        Contact__r.Name, Contact__r.Account.name , Focus__c, Generation__c, Influence__c, 
    	        Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c FROM Contact_Assessment__c WHERE Contact__r.active__c = true and Opportunity__c = :opportunity.Id ORDER BY id];
    	    }
    	        
    	    } else if (objectAPIName == 'Account') {
    		
    		if(Schema.sObjectType.Account.isAccessible()
    		&& Schema.sObjectType.Account.fields.name.isAccessible()
    		&& Schema.sObjectType.Account.fields.Industry.isAccessible()
    		&& Schema.sObjectType.Account.fields.Region__c.isAccessible()){
    		this.account = [SELECT name, id, parentId, Industry, Region__c, parent.name FROM Account WHERE Id = :objectId];
    		}
    		
    		if(Schema.sObjectType.Contact_Assessment__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isAccessible()
    	    && Schema.sObjectType.Contact.fields.Name.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isAccessible()){
    	        
    		this.evaluated = [SELECT Id, Attitudes__c, Authority__c, Contact__c, Contact__r.Name, Contact__r.Account.name , Focus__c, Generation__c, Influence__c, Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c FROM Contact_Assessment__c WHERE account__c = :account.Id and Contact__r.active__c = true ORDER BY id];
    		}
    		    
    		}
        this.newEval = new Contact_Assessment__c();
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);        
        if (this.account.parentId != null) {
            
            if(Schema.sObjectType.Account.isAccessible()
            && Schema.sObjectType.Account.fields.parentId.isAccessible()){
          getContactsFromParent([select id, parentId from Account where id = :this.account.parentId]);
            }
        }

    }
    
    public PageReference copyRDM() {
    	
    	if (objectAPIName == 'Opportunity') {
            
            if(Contact_Assessment__c.sObjectType.getDescribe().isDeletable()){
                if(Schema.sObjectType.Contact_Assessment__c.isAccessible()){
                delete [SELECT Id 
                        FROM Contact_Assessment__c 
                        WHERE Opportunity__c = :opportunity.Id];
                }
            }
            
    		List<Contact_Assessment__c> newContactAssesments = new List<Contact_Assessment__c>();
    		
    		if(Schema.sObjectType.Contact_Assessment__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isAccessible()
    	    && Schema.sObjectType.Contact.fields.Name.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isAccessible()
    	    && Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isAccessible()){
    	        
    		for (Contact_Assessment__c contAssesment :[SELECT Id, Attitudes__c, Authority__c, Contact__c, Contact__r.Name, Contact__r.Account.name , Focus__c, Generation__c, Influence__c, Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c FROM Contact_Assessment__c WHERE account__c = :opportunity.accountId]) {
    			Contact_Assessment__c newContAssesment = new Contact_Assessment__c();
    			
                if(Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isCreateable()){
                    newContAssesment.Attitudes__c = contAssesment.Attitudes__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isCreateable()){
                    newContAssesment.Authority__c = contAssesment.Authority__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isCreateable()){
                    newContAssesment.Contact__c = contAssesment.Contact__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isCreateable()){
                    newContAssesment.Focus__c = contAssesment.Focus__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isCreateable()){
                    newContAssesment.Generation__c = contAssesment.Generation__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isCreateable()){
                    newContAssesment.Influence__c = contAssesment.Influence__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isCreateable()){
                    newContAssesment.Our_Relationship__c = contAssesment.Our_Relationship__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isCreateable()){
                    newContAssesment.Competing_Company_Relationship__c = contAssesment.Competing_Company_Relationship__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isCreateable()){
                    newContAssesment.Buying_Cycle__c = contAssesment.Buying_Cycle__c;
                }
                
                if(Schema.sObjectType.Contact_Assessment__c.fields.Opportunity__c.isCreateable()){
                    newContAssesment.Opportunity__c = opportunity.id;
                }
                
    			newContactAssesments.add(newContAssesment);
    		}
    		}
    		
    		if(Schema.sObjectType.Contact_Assessment__c.isCreateable()){
    		insert newContactAssesments;
    		}
    		
    	}
    	
    	return null;
    }    
    
    public String getFooterStyle(){
    
        if(this.newEval == null)
            return 'HiddenFooter';
        else
            return 'Footer';
    
    }


    public String getSoqlForNotEvaluatedContacts(){
    
        
        String ret = '' ;

        
        for(Contact_Assessment__c c : evaluated){
        
            ret = ret + ' AND Id != \'' + c.Contact__c +'\'';
            
        }
    
        return ret;
    }
    
    public List<Contact> getNotEvaluated() {
        //I look up each contact on this account and see if they are already evaluated, if they aren't I return them in a list.
 
        if(Schema.sObjectType.Contact.isAccessible()
    	    && Schema.sObjectType.Contact.fields.Name.isAccessible()){
        return  Database.query('SELECT  Id, Name, Title   FROM Contact WHERE active__c = true and AccountId = \'' + account.id + '\'' + getSoqlForNotEvaluatedContacts());
    	    }else{
    	        return new List<Contact>();
    	    }
 
    }

  public void getContactsFromParent(Account a) {    
    if (accountInheritanceIds == null) {
      accountInheritanceIds = new List<Id>();    
    }
    accountInheritanceIds.add(a.Id);
    if(a.parentId == null){      
	List<Id> evaluatedIdList = new List<Id>();
	for(Contact_Assessment__c c : evaluated){
		evaluatedIdList.add(c.Contact__c);
	}
	if(Schema.sObjectType.Contact.isAccessible()
	&& Schema.sObjectType.Contact.fields.Name.isAccessible()
	&& Schema.sObjectType.Account.fields.Name.isAccessible()){
      contatsFromParents = [Select Id, Name, Account.Name From Contact where  AccountId in :accountInheritanceIds and active__c = true and id not in :evaluatedIdList];
	}
	    
	} else {
	    if(Schema.sObjectType.Account.isAccessible()
	    && Schema.sObjectType.Account.fields.parentId.isAccessible()){
      getContactsFromParent([Select Id, parentId FROM Account WHERE Id = :a.parentId]);
	    }
    }
  }
  
  /*
    public List<Contact> getParentNotEvaluated() {
        //I look up each contact on this account and see if they are already evaluated, if they aren't I return them in a list.
        if(account.parentId != null)
            return  Database.query('SELECT  Id, Name   FROM Contact WHERE AccountId = \'' + account.parentId + '\'' + getSoqlForNotEvaluatedContacts());                
        else
            return null;

    }
    */

    public PageReference InsertEvaluation() {
        newEval.Buying_Cycle__c = 'Awareness of Needs';  
        insert newEval;
        newEval = null;
        contactToEvaluate = null;
        contactidToEvaluate = null;
        if (objectAPIName == 'Opportunity') {
            if(Schema.sObjectType.Contact_Assessment__c.isAccessible())
        	this.evaluated = [SELECT Id, Attitudes__c, Authority__c, Contact__c, Contact__r.Name, Contact__r.Account.name , Focus__c, Generation__c, Influence__c, Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c FROM Contact_Assessment__c WHERE Opportunity__c = :opportunity.Id and Contact__r.active__c = true ORDER BY id];        
        } else if (objectAPIName == 'Account') {
            if(Schema.sObjectType.Contact_Assessment__c.isAccessible())
        	this.evaluated = [SELECT Id, Attitudes__c, Authority__c, Contact__c, Contact__r.Name, Contact__r.Account.name , Focus__c, Generation__c, Influence__c, Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c FROM Contact_Assessment__c WHERE Account__c = :account.Id and Contact__r.active__c = true ORDER BY id];
        }
        if (this.account.parentId != null) {
            if(Schema.sObjectType.account.isAccessible())
          getContactsFromParent([select id, parentId from Account where id = :this.account.parentId]);
        }
        
        return null;
    }


    public PageReference SaveChanges() {
        
        Boolean errors = false;
        
        for(Contact_Assessment__c c : evaluated){
        	if (c.Focus__c == null) {
        		errors = true;
        		c.Focus__c.addError('Debe escribir un valor');
        	}
        	if (c.Attitudes__c == null) {
        		errors = true;
        		c.Attitudes__c.addError('Debe escribir un valor');
        	}
        	if (c.Authority__c == null) {
        		errors = true;
        		c.Authority__c.addError('Debe escribir un valor');
        	}
        	if (c.Influence__c == null) {
        		errors = true;
        		c.Influence__c.addError('Debe escribir un valor');
        	}
        	if (c.Our_Relationship__c == null) {
        		errors = true;
        		c.Our_Relationship__c.addError('Debe escribir un valor');
        	}
        	if (c.Competing_Company_Relationship__c == null) {
        		errors = true;
        		c.Competing_Company_Relationship__c.addError('Debe escribir un valor');
        	}
        	if (c.Generation__c == null) {
        		errors = true;
        		c.Generation__c.addError('Debe escribir un valor');
        	}
        	if (c.Buying_Cycle__c == null) {
        		errors = true;
        		c.Buying_Cycle__c.addError('Debe escribir un valor');
        	}	
        } 
        
        if (!errors) {
            
            if(Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isUpdateable()
            && Schema.sObjectType.Contact_Assessment__c.isUpdateable())
        	update evaluated;
        }
        return null;
    }
    


    public PageReference popContactEvaluation() {
    	
        this.newEval = new Contact_Assessment__c();
        if(Schema.sObjectType.Contact.isAccessible()
        && Schema.sObjectType.Contact.fields.name.isAccessible()
        && Schema.sObjectType.Account.fields.name.isAccessible())
        this.contactToEvaluate = [SELECT id, name, Account.Name FROM Contact WHERE id = :contactIdToEvaluate];
        
        if(Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isCreateable()){
            newEval.Contact__c = contactToEvaluate.id;        
        }
        
        if (objectAPIName == 'Opportunity') {
            
            if(Schema.sObjectType.Contact_Assessment__c.fields.Opportunity__c.isCreateable()){
                newEval.Opportunity__c = opportunity.id;
            }
            
        } else if (objectAPIName == 'Account') {
            
            if(Schema.sObjectType.Contact_Assessment__c.fields.account__c.isCreateable()){
                newEval.account__c = account.id;
            }
        }
        
        return null;
    }
    
    public PageReference popContactEvaluationFromX() {
        
        if(Schema.sObjectType.Contact.isAccessible()
        && Schema.sObjectType.Contact.fields.name.isAccessible()
        && Schema.sObjectType.Account.fields.name.isAccessible()){
        this.contactToEvaluate = [SELECT id, name, Account.Name FROM Contact WHERE id = :newEval.Contact__c];
        }
        
        if (objectAPIName == 'Opportunity') {
        	this.newEval.Opportunity__c = opportunity.id;        
        } else if (objectAPIName == 'Account') {
        	this.newEval.account__c = account.id;
        }
        return null;
    }
    
    public PageReference DeleteEvaluation() {
        System.debug('delid:' + this.delid);
        
        if(Contact_Assessment__c.sObjectType.getDescribe().isDeletable()){
            if(Schema.sObjectType.Contact_Assessment__c.isAccessible()){
            delete [SELECT id FROM Contact_Assessment__c WHERE id = :this.delid];
            }
        }
        
        if (objectAPIName == 'Opportunity') {
            if(Schema.sObjectType.Contact_Assessment__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isAccessible()
            && Schema.sObjectType.contact.fields.Name.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isAccessible())
        	this.evaluated = [SELECT Id, Attitudes__c, Authority__c, Contact__c, Contact__r.Name, Contact__r.Account.name , 
        	Focus__c, Generation__c, Influence__c, Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c FROM Contact_Assessment__c WHERE Opportunity__c = :opportunity.Id and Contact__r.active__c = true ORDER BY id];        
        } else if (objectAPIName == 'Account') {
            if(Schema.sObjectType.Contact_Assessment__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isAccessible()
            && Schema.sObjectType.contact.fields.Name.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isAccessible())
        	this.evaluated = [SELECT Id, Attitudes__c, Authority__c, Contact__c, Contact__r.Name, Contact__r.Account.name , Focus__c, Generation__c, Influence__c, Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c FROM Contact_Assessment__c WHERE Account__c = :account.Id and Contact__r.active__c = true ORDER BY id];
        }
        
        if (this.account.parentId != null) {
            if(Schema.sObjectType.account.isAccessible()
            && Schema.sObjectType.account.fields.parentId.isAccessible())
          getContactsFromParent([select id, parentId from Account where id = :this.account.parentId]);
        }
        
        return null;
    }


}