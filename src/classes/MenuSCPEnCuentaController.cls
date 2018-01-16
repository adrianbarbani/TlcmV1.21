public with sharing class MenuSCPEnCuentaController {

    //public Account Acct {get; set;}
    public Boolean hasPermission {get; set;}
    public Boolean hasPermissionRegion {get; set;}
    public String Acctid {get; set;}
    
    public MenuSCPEnCuentaController(){
        
        //Acct = [ SELECT id, name FROM Account WHERE id = :ApexPages.currentPage().getParameters().get('Id')];
        Acctid = ApexPages.currentPage().getParameters().get('Id');
        
        List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
        
        if(Schema.sObjectType.PermissionSetAssignment.isAccessible()
        && Schema.sObjectType.PermissionSetAssignment.fields.PermissionSetId.isAccessible()
        && Schema.sObjectType.PermissionSet.fields.Name.isAccessible())
        psaList = [SELECT PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND (PermissionSet.Name = 'Admin_SCP' or PermissionSet.Name = 'Admin_SCP_Region')];
        
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
    }    

}