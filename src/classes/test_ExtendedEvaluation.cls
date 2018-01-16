@isTest
private class test_ExtendedEvaluation {

    static testMethod void myUnitTest() {
      
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.industry = 'Banking';
        
        insert cuenta;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Open';
        opp.CloseDate = System.Today();
        opp.accountId = cuenta.id;
        insert opp;
        

        Contact contacto = new Contact();
        contacto.LastName = 'test';
        contacto.AccountId = cuenta.id;
        insert contacto;
        
        Contact contacto2 = new Contact();
        contacto2.LastName = 'test';
        contacto2.AccountId = cuenta.id;
        contacto2.ReportsToId = contacto.id;
        insert contacto2;

        Contact contacto3 = new Contact();
        contacto3.LastName = 'test';
        contacto3.AccountId = cuenta.id;
        contacto3.ReportsToId = contacto.id;
        insert contacto3;
        
        Contact_Influence__c ci = new Contact_Influence__c();
        ci.Contact_Influenced__c = contacto.id;
        ci.Contact_Influences__c = contacto2.id;
        insert ci;
        
        Contact_Influence__c ci2 = new Contact_Influence__c();
        ci2.Contact_Influenced__c = contacto3.id;
        ci2.Contact_Influences__c = contacto.id;
        insert ci2;
        
        Contact_Assessment__c ca = new Contact_Assessment__c();
        ca.Contact__c = contacto.id;
        ca.Opportunity__c = opp.id;
        insert ca;
        
        Contact_Assessment__c ca2 = new Contact_Assessment__c();
        ca2.Contact__c = contacto2.id;
        ca2.Opportunity__c = opp.id;
        ca2.Focus__c = 'End User';
        ca2.Influence__c = 'Negative';
        ca2.Attitudes__c = 'Negative';
        ca2.Authority__c = 'Positive';
        ca2.Buying_Cycle__c = 'Assessments of Alternatives';
        ca2.Our_Relationship__c = 'Positive';
        ca2.Competing_Company_Relationship__c = 'Negative';
        insert ca2;

        Acciones__c accion = new Acciones__c();
        accion.accion__c = 'Focus';
        accion.tipo__c = 'End User';
        accion.descripcion__c = 'Desc Focus';
        insert accion;
        
        Acciones__c accion2 = new Acciones__c();
        accion2.accion__c = 'Attitudes';
        accion2.tipo__c = 'Negative';
        accion2.descripcion__c = 'Desc Atitude';
        insert accion2;
        

        //ExtendedEvaluation ee = new ExtendedEvaluation(ca);
        
        //ee.getAcciones();
        
        System.currentPagereference().getParameters().put('id',ca.id);
        
        ExtendedEvaluation ee1 = new ExtendedEvaluation(null,null,null,null);
        ExtendedEvaluation ee2 = new ExtendedEvaluation(null,null,null);        
        
        ExtendedEvaluation ee = new ExtendedEvaluation();
        system.assertEquals(1,ee.getContactInfluenced().size());
        system.assertEquals(contacto3.id,ee.getContactInfluenced().get(0).id);

        system.assertEquals(1,ee.getContactInfluences().size());
        system.assertEquals(contacto2.id,ee.getContactInfluences().get(0).id);

        
        System.currentPagereference().getParameters().put('id',ca2.id);
        ExtendedEvaluation ee3 = new ExtendedEvaluation();
        
        system.assertEquals(ca2.id,ee3.getContactEval().id);
        
        system.assertEquals(1,ee3.getActionsFocus().split('<br/>').size());
        system.assertEquals(accion.descripcion__c + '<br/>',ee3.getActionsFocus());

        system.assertEquals(1,ee3.getActionsAttitudes().split('<br/>').size());
        system.assertEquals(accion2.descripcion__c + '<br/>',ee3.getActionsAttitudes());
        
        system.assertEquals('Positive',ee3.getRelationship());
        
    }
}