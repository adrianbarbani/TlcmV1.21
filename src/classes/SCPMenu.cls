public with sharing class SCPMenu {

    public String temp {get; set;}
    
    public String ObjectType {get; set;}
    
    public Boolean isAccount {get; set;}
    
    public Account Acct {get; set;}
    
    public String name_account {get; set;}
    
    public Boolean hasPermission {get; set;}
	public Boolean hasPermissionRegion {get; set;}
	
	public Boolean isOpp {get; set;}
	
    public SCPMenu(){
    	
    	List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
    	
    	if(Schema.sObjectType.PermissionSetAssignment.isAccessible() && Schema.sObjectType.PermissionSetAssignment.fields.PermissionSetId.isAccessible()){
    	    psaList = [SELECT PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND (PermissionSet.Name = 'Admin_SCP' or PermissionSet.Name = 'Admin_SCP_Region')];
    	}
    	
        hasPermission = false;
        hasPermissionRegion = false;
        
        if (psaList.size() > 0) {
            for (PermissionSetAssignment psa :psaList) {
            	if (psa.PermissionSet.Name == 'Admin_SCP') {
            		hasPermission = true;		
            	}
            	if (psa.PermissionSet.Name == 'Admin_SCP_Region') {
            		hasPermissionRegion = true;		
            	}
            	if (hasPermission && hasPermissionRegion) {
            		break;
            	}
            }
        }
    	
        if(ApexPages.currentPage().getParameters().get('Id') != null){
            
            Id objectId = (Id) ApexPages.currentPage().getParameters().get('Id');
    		String objectAPIName = objectId.getSObjectType().getDescribe().getName();
            
            isOpp = false;
            if (objectAPIName == 'Opportunity') {
            	isOpp = true;            
            }
            
            isAccount = true;
            
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            Map<String,String> keyPrefixMap = new Map<String,String>{};
            Set<String> keyPrefixSet = gd.keySet();
            for(String sObj : keyPrefixSet){
               Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
               String tempName = r.getName();
               String tempPrefix = r.getKeyPrefix();
               //System.debug('Processing Object['+tempName + '] with Prefix ['+ tempPrefix+']');
               keyPrefixMap.put(tempPrefix,tempName);
            }
            
            
                String tPrefix = ApexPages.currentPage().getParameters().get('Id');
                tPrefix = tPrefix.subString(0,3);
                ObjectType = keyPrefixMap.get(tPrefix);
        
            if(ObjectType=='Contact'){
                
                Contact temp = new Contact();
                
            if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.AccountId.isAccessible()){
                temp = [SELECT AccountId FROM Contact WHERE id = :ApexPages.currentPage().getParameters().get('Id')];
            }
            
            if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.name.isAccessible()){
                Acct = [ SELECT id, name FROM Account WHERE id = :temp.AccountId];
            }
            
            }else if(ObjectType=='Opportunity'){
                
                Opportunity temp = new Opportunity();
                
                if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()){
                temp = [SELECT AccountId FROM Opportunity WHERE id = :ApexPages.currentPage().getParameters().get('Id')];
                }
                
                 if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.name.isAccessible()){
                Acct = [ SELECT id, name FROM Account WHERE id = :temp.AccountId];
                 }
            
            }else{
               
                if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.name.isAccessible()){
                Acct = [ SELECT id, name FROM Account WHERE id = :ApexPages.currentPage().getParameters().get('Id')];
                }
            }
            
            name_account=Acct.Name;
            if(name_account.length()>30)
              name_account=name_account.substring(0,30);
            
        }else{
        
            this.isAccount = false;
        
            Acct = null;
            name_account=null;
    
        }
    }

}