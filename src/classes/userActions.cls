public with sharing class userActions{
	
	public Static Id accountId {get;set;}
	public Static Id userId {get;set;}
	public Static List<AccountShare> accountShareList {get;set;}

    public Boolean checkWrite(String a){
    
        String uid = UserInfo.getUserId();
        
        List<AccountShare> temp = new List<AccountShare>();
        
        if(Schema.sObjectType.AccountShare.isAccessible() && Schema.sObjectType.AccountShare.fields.AccountAccessLevel.isAccessible() &&
    	    	    Schema.sObjectType.AccountShare.fields.UserOrGroupId.isAccessible() ){
    	    	        
            temp = [SELECT AccountAccessLevel,UserOrGroupId FROM AccountShare WHERE AccountId = : a AND UserOrGroupId = :uid];
    	    
    	    	        
    	    }
    	    	    
        System.Debug(temp);
        
        if(temp.size()==0)
            return false;
        
        if(temp[0].AccountAccessLevel == 'All' || temp[0].AccountAccessLevel == 'Edit')
            return true;
        else
            return false;
    
    }

}