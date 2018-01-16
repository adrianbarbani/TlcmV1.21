public with sharing class FastTaskController {

    public Task task {get;set;}
    
    public String PageName {get;set;}
    public String accountId {get;set;}
    public String oppId {get;set;}
    public String done {get;set;}
    public String msj {get;set;}
    public Date duedate {get;set;}

    
    public FastTaskController(){
        
        task = new Task();
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
  
  
    }
    
    public Boolean getcanEdit(){
    
        userActions temp = new userActions();
        return temp.checkWrite(accountId);
    
    }
    

    public PageReference savetask() {
    	
    	Task temp;
        if (oppId!=null && oppId != '') {
        	temp = new Task(subject = PageName, WhatId = oppId, Description = msj, ActivityDate = task.ActivityDate);
        } else {
        	temp = new Task(subject = PageName, WhatId = accountId, Description = msj, ActivityDate = task.ActivityDate);
        }
                    if(Schema.sObjectType.Task.fields.subject.isCreateable() &&
                Schema.sObjectType.Task.fields.WhatId.isCreateable() && 
                Schema.sObjectType.Task.fields.Description.isCreateable() &&
                Schema.sObjectType.Task.fields.ActivityDate.isCreateable() &&
                Schema.sObjectType.Task.isCreateable())
        insert temp;
        done = 'Sent';

        task = new Task();
        msj = '';

        return null;
    }   
}