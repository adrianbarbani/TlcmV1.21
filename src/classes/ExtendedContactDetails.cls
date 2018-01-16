public with sharing class ExtendedContactDetails{

    public Contact contact;
    public Contact ReportsTo;
    public List<Contact> ReportedBy;
    public List<Contact> ContactInfluenced;
    public List<Contact> ContactInfluences;
    
 
    public ExtendedContactDetails(){
    
        //load(ApexPages.currentPage().getParameters().get('Id'));
            
    }
       
    public ExtendedContactDetails(Contact c,List<Contact_Influence__c> cis,List<Contact> AllContacts, Map<Id, Contact> contactMap){

       this.contact = c;
       load(c.Id,cis,AllContacts,contactMap);

    }

    private void load(String id, List<Contact_Influence__c> cis,List<Contact> AllContacts, Map<Id, Contact> contactMap){

        if(this.contact.ReportsToId != null){
        
            for(Contact c : AllContacts)
                if( c.id == this.contact.ReportsToId){
                    ReportsTo = c;
                    break;
                }
        } else {
           ReportsTo = null;
        } 
        
        ReportedBy = new List<Contact>();
        for(Contact c : AllContacts) {
            if( c.ReportsToId == id) {
                ReportedBy.add(c);
            }
        }
                
        ContactInfluenced = new List<Contact>();
            
        for( Contact_Influence__c ci: cis){                                      
			if(ci.Contact_Influences__c == id) {
				//ContactInfluenced.add([SELECT Id, Name  FROM Contact WHERE Id = :ci.Contact_Influenced__c]);
				ContactInfluenced.add(contactMap.get(ci.Contact_Influenced__c));
			}                                      
        }
        
        ContactInfluences = new List<Contact>();
            
        for( Contact_Influence__c ci: cis){                                      
			if(ci.Contact_Influenced__c == id) {
				//ContactInfluences.add([SELECT Id, Name  FROM Contact WHERE Id = :ci.Contact_Influences__c]);
				ContactInfluences.add(contactMap.get(ci.Contact_Influences__c));
			}                                      
        }               
    }

    public Contact getContact(){
        return contact;
    }
    public Contact getReportsTo(){
        return ReportsTo;
    }
    public List<Contact> getReportedBy(){
        return ReportedBy;
    }
    public List<Contact> getContactInfluenced(){
        return ContactInfluenced;
    }
    public List<Contact> getContactInfluences(){
        return ContactInfluences;
    }
    
}