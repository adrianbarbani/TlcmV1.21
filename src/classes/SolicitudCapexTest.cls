@isTest
public class SolicitudCapexTest {
    
    static testMethod void sendEmail(){
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().withAplicantName('nombre').withAttachBusiness('No').withMultiyearDisposition('No').withOIBDA(2)
            .withRequestedCapex(3).withReviewedByManagement('No').withSolicitationConcept('No').withTIR(5).build();
        
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        // create an attachment
        // generate a random blob to attach.
        Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        
        Attachment att = new Attachment(parentId = solicitud.id, name = 'a name', body = blobValue);
        insert att;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));    
        
        Test.startTest();
        
        system.assertEquals(0, controller.emails.size());
        
        controller.send();
        controller.enviarMail();
               
        
        Test.stopTest(); 
    }
    
    static testMethod void agregarUnEmail(){
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().withAplicantName('nombre').withAttachBusiness('No').withMultiyearDisposition('No').withOIBDA(2)
            .withRequestedCapex(3).withReviewedByManagement('No').withSolicitationConcept('No').withTIR(5).build();
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        Test.startTest();
        
        controller.mailExterno = 'mailTest@test.com';
        controller.agregarMail();
        
        system.assertEquals(1, controller.wrappersMails.size() );
        
        List <SolicitudCapexController.WrapperMail> auxWrapperMail = new List<SolicitudCapexController.WrapperMail>(controller.wrappersMails);
        system.assertEquals('mailTest@test.com', auxWrapperMail[0].email);
        
        Test.stopTest();		        
    }
    
    static testMethod void despuesDeAgregarUnEmailPuedoEliminarlo(){
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().withAplicantName('nombre').withAttachBusiness('No').withMultiyearDisposition('No').withOIBDA(2)
            .withRequestedCapex(3).withReviewedByManagement('No').withSolicitationConcept('No').withTIR(5).build();
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        Test.startTest();
        
        controller.mailExterno = 'mailTest@test.com';
        controller.agregarMail();
        
        system.assertEquals(1, controller.wrappersMails.size() );
        
        List <SolicitudCapexController.WrapperMail> auxWrapperMail = new List<SolicitudCapexController.WrapperMail>(controller.wrappersMails);
        system.assertEquals('mailTest@test.com', auxWrapperMail[0].email);
        
        auxWrapperMail[0].eliminar = true;
        controller.eliminarMail();
        
        system.assertEquals(0, controller.wrappersMails.size() );
        system.assertEquals(0, controller.emails.size() );    
        
        Test.stopTest();	        
        
    }
    
    static testMethod void cuandoCargoUnMailInvalidoYLoEnvioMuestroElError(){
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().withAplicantName('nombre').withAttachBusiness('No').withMultiyearDisposition('No').withOIBDA(2)
            .withRequestedCapex(3).withReviewedByManagement('No').withSolicitationConcept('No').withTIR(5).build();
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        Test.startTest();
        
        controller.mailExterno = '1';
        controller.agregarMail();
        controller.send();
        controller.enviarMail();
        
        system.assert(controller.errors);
        
        Test.stopTest();		        
        
    }
    
    static testMethod void parseoLaListaDeMailsOpcionales(){
        
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().withAplicantName('nombre').withAttachBusiness('No').withMultiyearDisposition('No').withOIBDA(2)
            .withRequestedCapex(3).withReviewedByManagement('No').withSolicitationConcept('No').withTIR(5).build();
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        Email_solicitud_capex__c email = new Email_solicitud_capex__c(name = 'adrian', email__c = 'email@email.com', Solicitud_capex__c = solicitud.id);
        insert email;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        Test.startTest();
        
        system.assertEquals(1, controller.wrappersMails.size());
        system.assertEquals('email@email.com', controller.wrappersMails[0].email);
        
        Test.stopTest();		                
    }
    
    static testMethod void cuandoCargoUnMailOpcionalEsteSeGuardaEnElObjeto(){
        
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().withAplicantName('nombre').withAttachBusiness('No').withMultiyearDisposition('No').withOIBDA(2)
            .withRequestedCapex(3).withReviewedByManagement('No').withSolicitationConcept('No').withTIR(5).build();
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        Test.startTest();
        
        controller.mailExterno = 'a@a.com';
        controller.agregarMail();
        controller.send();
        controller.enviarMail();
        
        controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        system.assertEquals(1, controller.wrappersMails.size());
        system.assertEquals('a@a.com', controller.wrappersMails[0].email);
        
        Test.stopTest();        
    }
    
    static testMethod void puedoEliminarUnMailQueAgregueAnteriormente(){
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().withAplicantName('nombre').withAttachBusiness('No').withMultiyearDisposition('No').withOIBDA(2)
            .withRequestedCapex(3).withReviewedByManagement('No').withSolicitationConcept('No').withTIR(5).build();
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        Test.startTest();
        
        controller.mailExterno = 'mailTest@test.com';
        controller.agregarMail();
        controller.send();
        
        controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        system.assertEquals(1, controller.wrappersMails.size());
        
        controller.wrappersMails[0].eliminar = true;
        controller.eliminarMail();
        
        system.assertEquals(0, controller.wrappersMails.size() );
        system.assertEquals(0, controller.emails.size() );    
        
        Test.stopTest();
    }
    
    static testMethod void agregoUnEmailPorDefault(){
        
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().withAplicantName('nombre').withAttachBusiness('No').withMultiyearDisposition('No').withOIBDA(2)
            .withRequestedCapex(3).withReviewedByManagement('No').withSolicitationConcept('No').withTIR(5).build();
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        destinatario_solicitud_capex__c destinatario = new destinatario_solicitud_capex__c(name = 'test destinatario', email__c = 'test@test.com');
        insert destinatario;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        Test.startTest();
        
        system.assertEquals(1, controller.emails.size() );
        system.assert( controller.emails.contains('test@test.com') );
        
        controller.send();
        controller.enviarMail();    
        
        Test.stopTest();        
    }
    
    static testMethod void seValidanLosDatosObligatorios(){
        Account acc = new Account(name = 'una Cuenta');
        insert acc;
        
        Contact contacto = new Contact (LastName = 'a'); 
        insert contacto;
        
        Opportunity opp = new Opportunity(name = 'una opp', stageName = 'Prospecting' , closeDate = Date.today(), accountId = acc.id);
        insert opp;
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        bigDeal.Oportunidad__c = opp.id;
        insert bigDeal;
        
        Solicitud_capex__c solicitud = Build.aSolution().build();
        solicitud.Big_Deal__c = bigDeal.id;
        insert solicitud;
        
        destinatario_solicitud_capex__c destinatario = new destinatario_solicitud_capex__c(name = 'test destinatario', email__c = 'test@test.com');
        insert destinatario;
        
        SolicitudCapexController controller = new SolicitudCapexController(new ApexPages.StandardController(solicitud));
        
        Test.startTest();
        
        controller.send();
        system.assertEquals(8, controller.erroresAMostrar.size() );
        
        Test.stopTest();    
        
    }
}