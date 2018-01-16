public with sharing class ExtendedEvaluation {

    public Contact_Assessment__c ContactEval {get;set;}
    public  List<Contact> ContactInfluenced;
    public  List<Contact> ContactInfluences;
    private List<Acciones__c> AllActions;
    
    public ExtendedEvaluation(){
        
        if(Schema.sObjectType.Contact_Assessment__c.isAccessible() && Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isAccessible()
        && Schema.sObjectType.Contact_Assessment__c.fields.Opportunity__c.isAccessible()){
        this.ContactEval = [SELECT  Id, Contact__c, Contact__r.name, Contact__r.Account.name,
                           Contact__r.Closest_Account_Team_Member__r.name, Focus__c , Attitudes__c,
                           Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c ,
                           Generation__c, Authority__c, Influence__c, Opportunity__c,
                           Opportunity__r.Buying_Cycle__c   FROM Contact_Assessment__c
                           WHERE id = :ApexPages.currentPage().getParameters().get('id')];
        }
        
        if(Schema.sObjectType.Acciones__c.isAccessible() && Schema.sObjectType.Acciones__c.fields.Descripcion__c.isAccessible()
        && Schema.sObjectType.Acciones__c.fields.Accion__c.isAccessible()
        && Schema.sObjectType.Acciones__c.fields.Tipo__c.isAccessible()){
        this.AllActions = [SELECT Descripcion__c, Accion__c, Tipo__c  FROM Acciones__c limit 10000];   
        }
        
        load(ContactEval.Contact__c,null);
                
    }
    
    public ExtendedEvaluation(Contact_Assessment__c CA,List<Acciones__c> AllActions, List<Contact> ContactInfluenced, List<Contact> ContactInfluences){
        this.ContactEval = CA;
        
        this.AllActions = AllActions;

        this.ContactInfluenced = ContactInfluenced;
        
        this.ContactInfluences = ContactInfluences;
        
    }
    
    public ExtendedEvaluation(Contact_Assessment__c CA,List<Contact> AllContcts,List<Acciones__c> AllActions){
        this.ContactEval = CA;
        
        this.AllActions = AllActions;

        load(this.ContactEval.Contact__c,AllContcts);
        
    }     
    
    public Contact_Assessment__c getContactEval() {
        
        return ContactEval;
    }

    private void load(String id,List<Contact> AllContcts){
    
            
        ContactInfluenced = new List<Contact>();
        
        List<Id> contactInfluencedIds = new List<Id>(); 
         
       List<Contact_Influence__c> contects = new List<Contact_Influence__c>();     
        
        if(Schema.sObjectType.Contact_Influence__c.isAccessible() && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible()
        && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible()){ 
       contects = [ SELECT Contact_Influenced__c, Contact_Influences__c FROM Contact_Influence__c 
                                      WHERE Contact_Influences__c = :id];
    }
            
        for( Contact_Influence__c ci: contects){

           contactInfluencedIds.add(ci.Contact_Influenced__c);                           
        } 
        
        List<Contact> centects = new List<Contact>();
        
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible() ){
        centects = [SELECT Id, Name  FROM Contact WHERE Id in :contactInfluencedIds];
        }
        
        ContactInfluenced.addAll(centects);
        
        
        ContactInfluences = new List<Contact>();
        
        List<Id> contactInfluencesIds = new List<Id>();
        
        List<Contact_Influence__c> inflenced = new List<Contact_Influence__c>();
        
        if(Schema.sObjectType.Contact_Influence__c.isAccessible() && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible()
        && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible()){    
        inflenced = [ SELECT Contact_Influenced__c, Contact_Influences__c FROM Contact_Influence__c 
                                      WHERE Contact_Influenced__c = :id];    
        }
        
        for( Contact_Influence__c ci: inflenced){

           contactInfluencesIds.add(ci.Contact_Influences__c);                           
        }
        
        
        List<Contact> centects2 = new List<Contact>();
        
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible() ){
        centects2 = [SELECT Id, Name  FROM Contact WHERE Id in :contactInfluencesIds];
        }
        
        ContactInfluences.addAll(centects2);
    }    
    
    public List<String> getAcciones(){
        List<String> temp = new List<String>();
        temp.add('Focus: ' + ContactEval.Focus__c);
        
        this.getActions('Focus',ContactEval.Focus__c,temp);
        
        temp.add('Attitudes: ' + ContactEval.Attitudes__c);
        
        this.getActions('Attitudes',ContactEval.Attitudes__c,temp);
        
        temp.add('Influence: ' + ContactEval.Influence__c);
        temp.add('Authority: ' + ContactEval.Authority__c);
        
        String tmpstr;
        
        if(ContactEval.Authority__c == 'High')
            tmpstr = 'A+';
        else
            tmpstr = 'A-';
            
        if(ContactEval.Influence__c == 'High')
            tmpstr += ' I+';
        else
            tmpstr += ' I-';
            
        this.getActions('Authority',tmpstr,temp);    

        temp.add('Our relationship with the contact: ' + ContactEval.Our_Relationship__c);
        temp.add('Our competion\'s relationship with the contact: ' + ContactEval.Competing_Company_Relationship__c);
        
        temp.add('Final Relationship Leverage: ' + this.getRelationship());
            
        this.getActions('Relationship Leverage',this.getRelationship(),temp);
        
        temp.add('Project buying cycle: ' + ContactEval.Opportunity__r.Buying_Cycle__c);
        temp.add('Contact buying cycle: ' + ContactEval.Buying_Cycle__c);
        
        if (ContactEval.Opportunity__r.Buying_Cycle__c != ContactEval.Buying_Cycle__c) {
            temp.add('Attention buying cycles of the project and the contact are diferent.');
        }

        return temp;
    }
    
    public String getActionsFocus(){
    
        String ret = '';
        List<String> temp = new List<String>();
        
        this.getActions('Focus',ContactEval.Focus__c,temp);
    
        for(String s : temp)
            ret = ret + s + '<br/>';
            
        return ret;
    }
    
    
    public String getActionsAttitudes(){
    
        String ret = '';
        List<String> temp = new List<String>();
        
        this.getActions('Attitudes',ContactEval.Attitudes__c,temp);
    
        for(String s : temp)
            ret = ret + s + '<br/>';
            
        return ret;
    }
    
    public String getRelationship(){
    
        //Calculate relationship from relationship matrix. TODO: add more types of positive/negative realtionship depending if ++ + 0 - --
    
        if( 
            ((ContactEval.Our_Relationship__c == 'Positive' ) && ( ContactEval.Competing_Company_Relationship__c == 'Neutral' ||  ContactEval.Competing_Company_Relationship__c == 'Negative')) ||
            ((ContactEval.Our_Relationship__c == 'Neutral'  ) && (ContactEval.Competing_Company_Relationship__c == 'Negative'))
            
          )
            return 'Positive';
        
        if( 
            ((ContactEval.Our_Relationship__c == 'Negative' ) && ( ContactEval.Competing_Company_Relationship__c == 'Neutral' ||  ContactEval.Competing_Company_Relationship__c == 'Positive')) ||
            ((ContactEval.Our_Relationship__c == 'Neutral'  ) && (ContactEval.Competing_Company_Relationship__c == 'Positive'))
            
          )
            return 'Negative';

        
            return 'Neutral';
    
    
    }
    
    public void getActions(String Accion, String Tipo, List<String> l){
        
         for( Acciones__c a: AllActions){
           
               if((a.Accion__c == Accion) && (a.Tipo__c == Tipo)){
                   l.add(a.Descripcion__c);
               }   
           }           
        
    } 

    public List<Contact> getContactInfluenced(){
        return ContactInfluenced;
    }
    public List<Contact> getContactInfluences(){
        return ContactInfluences;
    }

}