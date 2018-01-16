public with sharing class adminRegions {

    public List<ShareWrapper> todos {get;set;}
    public Region__Share newRS {get;set;}
    
    public String seleccionado { get; set; }
    
    public String parent_s { get; set; }
    public String user_s { get; set; }
    public Account dummyAccount { get; set; }
    
    public adminRegions(){
    
        load();
    }
    
    public void load(){
        
        newRS = new Region__Share();
        todos = new List<ShareWrapper>();
        parent_s='0';
        user_s='0';
        dummyAccount = new Account();
        
        List<Region__Share> temp = new List<Region__Share>();
        
        if(Schema.sObjectType.Region__Share.isAccessible() && Schema.sObjectType.Region__Share.fields.ParentId.isAccessible()
        && Schema.sObjectType.Region__Share.fields.UserOrGroupId.isAccessible()
        && Schema.sObjectType.Region__Share.fields.AccessLevel.isAccessible()
        && Schema.sObjectType.Region__Share.fields.RowCause.isAccessible()
        && Schema.sObjectType.Region__Share.fields.LastModifiedDate.isAccessible()
        && Schema.sObjectType.Region__Share.fields.LastModifiedById.isAccessible()
        && Schema.sObjectType.Region__Share.fields.IsDeleted.isAccessible()){
        temp = [select Id, ParentId, Parent.name, UserOrGroupId, AccessLevel, RowCause, LastModifiedDate, LastModifiedById, IsDeleted from Region__Share WHERE AccessLevel = 'Edit'  ORDER BY Parent.name];
        }
        
        List<User> tempuser = new List<User>();
        
        if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.fields.Username.isAccessible()
        && Schema.sObjectType.User.fields.LastName.isAccessible()
        && Schema.sObjectType.User.fields.FirstName.isAccessible()
        && Schema.sObjectType.User.fields.Email.isAccessible()
        && Schema.sObjectType.User.fields.UserRoleId.isAccessible()
        && Schema.sObjectType.User.fields.LocaleSidKey.isAccessible()
        && Schema.sObjectType.User.fields.ProfileId.isAccessible()){
        tempuser = [select Id, Username, LastName, FirstName, Email,  UserRoleId, LocaleSidKey, ProfileId from User limit 10000];
        }
        for(Region__Share t : temp)
            for(User tu : tempuser)
                if(t.UserOrGroupId == tu.id){
                    todos.add(new ShareWrapper(t,tu));
                    break;
                }
    }
    
    public List<SelectOption> getRegions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','Select Region'));
        
        List<Region__c> temp = new List<Region__c>();
        
        if(Schema.sObjectType.Region__c.isAccessible() && Schema.sObjectType.Region__c.fields.Name.isAccessible() ){
        temp =  [SELECT Name,Id From Region__c ORDER BY Name ASC limit 999];
        }
        
       for( Region__c c : temp)
       {
          options.add(new SelectOption(c.Id,c.Name));
       }  
       return options;
        
    }
   
    public PageReference del(){
 		
 		try {   
        	
           Region__Share aBorrar = new Region__Share();
           if(Schema.sObjectType.Region__Share.isAccessible()){
           aBorrar = [ SELECT id FROM Region__Share WHERE Id = :seleccionado];
           }
           if(Schema.sObjectType.Region__Share.isDeletable()){
               delete aBorrar;
               
           }
                     
        } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        load();
        return null;       
    }
    
    public PageReference InsertNew() {
        
        user_s = dummyAccount.ownerId;
        if(user_s!='0' && parent_s!='0'){
            //valido que la region y usuario sean legitimos.
            
            List<User> tempuser = new List<User>();
            
            if(Schema.sObjectType.User.isAccessible()){
            tempuser = [select id from User where id = :user_s];
            }
            
            List<Region__C> tempregion = new List<Region__C>();
            if(Schema.sObjectType.Region__C.isAccessible()){
            tempregion = [select id, OwnerId from Region__C where id = :parent_s];
            }
            
            if(tempuser.size() == 0 || tempregion.size()  == 0)
                return null;
                        
            if (tempregion.get(0).OwnerId != user_s) {
                if(Schema.sObjectType.Region__Share.fields.AccessLevel.isCreateable())
                newRS.AccessLevel = 'Edit';
                if(Schema.sObjectType.Region__Share.fields.UserOrGroupId.isCreateable())
                newRS.UserOrGroupId=user_s;
                if(Schema.sObjectType.Region__Share.fields.ParentId.isCreateable())
                newRS.ParentId=parent_s;            
                try {
                    
                    if(Schema.sObjectType.Region__Share.isCreateable()){
                	    insert newRS;
                    }
                    
                } catch(DmlException ex){
			        ApexPages.addMessages(ex);
			    }                    
                load();
            } else {                                                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.share_region_to_owner));
            }                       
        }        
        return null;
    }
    
    public class ShareWrapper{
        public Region__Share share {get;set;}
        public User user {get;set;}
    
        public ShareWrapper(Region__Share rs, User u){
        
            this.share = rs;
            this.user = u;
        }
    
    }
}