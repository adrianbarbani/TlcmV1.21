public with sharing class SolicitudCapexController {
    
    public Solicitud_Capex__c solicitud {get; set;}
    public String idSolicitud {get; set;}
    public String enviado {get; set;}
    
    public List<String> erroresAlAgregarUnEmail{get; set;}
    public String mailExterno {get; set;}
    public String nombreEmail {get; set;}
    public Set <String> emails {get; set;}
    public List <WrapperMail> wrappersMails {get; set;}
    
    public Boolean errors {get; set;}
    public List <destinatario_solicitud_capex__c> destinatariosPorDefault {get; set;}
    public List <String> erroresAMostrar {get; set;}
    
    public SolicitudCapexController(ApexPages.StandardController controller){
        
        errors = false;
        erroresAlAgregarUnEmail = new List<String>();
        emails = new Set<String>();
        wrappersMails = new List <WrapperMail>();
        destinatariosPorDefault = new List <destinatario_solicitud_capex__c>();
        
        idSolicitud = controller.getId();
        
        if( Schema.sObjectType.Solicitud_Capex__c.isAccessible() 
         && Schema.sObjectType.Solicitud_Capex__c.fields.Optional_emails__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Operator_or_country__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.applicant_name__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Applicant_Position__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Application_Date__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Proyect_Name__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Salesforce_code__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Proyect_description__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Client_Name__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Fecha_de_Licitacion__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.FCV__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.NAV__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Total_Capex__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Requested_Capex__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Multiyear_Disposition__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Capex_Import_for_this_year__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Solicitation_Concept__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Capex_Investor_current_year__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Capex_Investor_commited__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Attach_Business_case__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Reviewed_by_management_control__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.approved_by_management_control__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Description_Not_Approved__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Aditional_information__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.OIBDA__c.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.TIR__C.isAccessible()
         && Schema.sObjectType.Solicitud_Capex__c.fields.Big_Deal__c.isAccessible()){
        
        solicitud = [SELECT ID, Optional_emails__c, Operator_or_country__c, applicant_name__c, Applicant_Position__c, Application_Date__c, 
                     Proyect_Name__c, Salesforce_code__c, Proyect_description__c, Client_Name__c, Fecha_de_Licitacion__c,
                     FCV__c, NAV__c, Total_Capex__c, Requested_Capex__c, Multiyear_Disposition__c, Capex_Import_for_this_year__c,
                     Solicitation_Concept__c, Capex_Investor_current_year__c, Capex_Investor_commited__c, Attach_Business_case__c,
                     Reviewed_by_management_control__c, approved_by_management_control__c, Description_Not_Approved__c, Aditional_information__c, 
                     OIBDA__c, TIR__C, Big_Deal__c
                     FROM Solicitud_Capex__c WHERE ID =: idSolicitud];
        
	    }
        
        Big_deals_Survey__c bigDeal = new Big_deals_Survey__c();
        
        if( Schema.sObjectType.Big_deals_Survey__c.isAccessible()
        && Schema.sObjectType.Big_deals_Survey__c.fields.Pais__c.isAccessible()
        && Schema.sObjectType.Big_deals_Survey__c.fields.Codigo_en_Sales_Force_del_proyecto__c.isAccessible()
        && Schema.sObjectType.Big_deals_Survey__c.fields.puntuacion_FCV_o_valor_total_de_contrato__c.isAccessible()
        && Schema.sObjectType.Big_deals_Survey__c.fields.puntuacion_NAV_o_ingresos_12_meses__c.isAccessible()
        && Schema.sObjectType.Big_deals_Survey__c.fields.Capex_total__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.name.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Description.isAccessible()
        && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()
        && Schema.sObjectType.Big_deals_Survey__c.fields.Oportunidad__c.isAccessible()){
        
        bigDeal = [SELECT ID, Pais__c, Codigo_en_Sales_Force_del_proyecto__c, puntuacion_FCV_o_valor_total_de_contrato__c, 
                                       puntuacion_NAV_o_ingresos_12_meses__c, Capex_total__c, Oportunidad__r.name, oportunidad__r.Description, oportunidad__r.AccountId 
                                       FROM Big_deals_Survey__c 
                                       WHERE ID =: solicitud.Big_Deal__c];
        }
        
        Account cuenta = new Account();
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() ){
        
        cuenta = [SELECT name FROM Account WHERE Id =: bigDeal.oportunidad__r.AccountId];
        
        }
        
        if(Schema.sObjectType.destinatario_solicitud_capex__c.isAccessible() && Schema.sObjectType.destinatario_solicitud_capex__c.fields.Email__c.isAccessible() &&
    	    	    Schema.sObjectType.destinatario_solicitud_capex__c.fields.name.isAccessible() ){
            destinatariosPorDefault = [SELECT ID, Email__c, name FROM destinatario_solicitud_capex__c limit 900 ];
	    }
    	    	    
        for(destinatario_solicitud_capex__c destinatario :destinatariosPorDefault){
            emails.add(destinatario.email__c);
        }
        
        //set data from bigDeal
        if (Schema.sObjectType.Solicitud_Capex__c.fields.operator_or_country__c.isUpdateable()){
            solicitud.operator_or_country__c = bigDeal.Pais__c;
        }
        
        if(solicitud.Application_Date__c == null){
            
            if (Schema.sObjectType.Solicitud_Capex__c.fields.Application_Date__c.isUpdateable()){
                solicitud.Application_Date__c = Date.today();
            }
            
        }
        
        this.getTheOptionalSemails();
        
    }
    
    public void getTheOptionalSemails() {
        
        
        List <Email_solicitud_capex__c> emailsOpcionales = new List<Email_solicitud_capex__c>();
        
        if(Schema.sObjectType.Email_solicitud_capex__c.isAccessible() && Schema.sObjectType.Email_solicitud_capex__c.fields.Name.isAccessible() &&
    	    	    Schema.sObjectType.Email_solicitud_capex__c.fields.email__c.isAccessible() ){
         emailsOpcionales = [SELECT ID, name, email__c FROM Email_solicitud_capex__c WHERE Solicitud_capex__c =: idSolicitud];
	    }
    
        for(Email_solicitud_capex__c mailOpcional : emailsOpcionales){
            WrapperMail wrppMail = new WrapperMail(mailOpcional.id, mailOpcional.name , mailOpcional.email__c);
            emails.add(mailOpcional.email__c);
            wrappersMails.add(wrppMail);    
        }
        
    }
    
    public PageReference guardarSinValidar(){
        
        if(Schema.sObjectType.Solicitud_Capex__c.isUpdateable())
        update solicitud;
        return null;
    }
    
    public PageReference send() {
        
        enviado = '';
        errors = false;
        erroresAMostrar = new List<String>();
        
        solicitud.Application_Date__c = Date.today();
        
        //listas de validaciones. ( no se pueden poner como required por que se necesita que el objeto se guarde cada vez que entremos a attachear un archivo )
        if(solicitud.applicant_name__c == null){
            erroresAMostrar.add('Nombre Solicitante: debe tener un valor.');
            errors = true;            
        }
        if(solicitud.TIR__c == null){
            erroresAMostrar.add('TIR: debe tener un valor.');
            errors = true;
        }
        if(solicitud.OIBDA__c == null){
            erroresAMostrar.add('OIBDA: debe tener un valor.');
            errors = true;            
        }
        if(solicitud.Requested_Capex__c == null){
            erroresAMostrar.add('Capex Solicitado: debe tener un valor.');
            errors = true;
        }
        if(solicitud.Multiyear_Disposition__c == null || solicitud.Multiyear_Disposition__c == ''){
            erroresAMostrar.add('Disposicion multianual: debe tener un valor.');
            errors = true;
        }
        if(solicitud.Solicitation_Concept__c == null){
            erroresAMostrar.add('Concepto solicitud: debe tener un valor.');
            errors = true;
        }
        if(solicitud.Attach_Business_case__c == null || solicitud.Attach_Business_case__c == ''){
            erroresAMostrar.add('Adjunta Business Case: debe tener un valor.');
            errors = true;            
        }
        if(solicitud.Reviewed_by_management_control__c == null || solicitud.Attach_Business_case__c == ''){
            erroresAMostrar.add('Revisado por Controlador de Gestion: debe tener un valor.');      
            errors = true;              
        }
        if(solicitud.Multiyear_Disposition__c == 'Si' && solicitud.Capex_Import_for_this_year__c == null){
            erroresAMostrar.add('Si es una disposición multianual, el importe de capex debe tener un valor.');      
            errors = true;    
        }
        
        if(!errors){
            try{
                if(Schema.sObjectType.Solicitud_Capex__c.isUpdateable())
                update solicitud;
            }catch(DMLException e){
                
                erroresAMostrar.add(e.getMessage());
                errors = true;
            }    
        }
        return null;
        
    }
    
    public PageReference enviarMail() {
        
        if(!errors){
            List<Messaging.EmailFileAttachment> mailAttachments = new List<Messaging.EmailFileAttachment>();
            
            
            PageReference pdf = Page.FormularioCapexPDF;
            // add parent id to the parameters for standardcontroller
            pdf.getParameters().put('id',solicitud.id);
            //pdf.setRedirect(true);
            
            
            // the contents of the attachment from the pdf
            Blob body;
            
            try {
                // returns the output of the page as a PDF
                body = pdf.getContentAsPDF();
                
                // need to pass unit test -- current bug  
            } catch (VisualforceException e) {
                body = Blob.valueOf('Some Text');
            }
            
            
            //attach the PDF
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Solicitud de Capex.pdf');
            attach.setInline(false);
            attach.Body = body;
            mailAttachments.add(attach);
            
            
            //attach the excel
            List<Attachment> attachments = new list<Attachment>();
            if(Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.fields.Name.isAccessible() &&
    	    	    Schema.sObjectType.Attachment.fields.body.isAccessible() ){
            attachments = [SELECT ID, body, name FROM Attachment WHERE ParentId =: idSolicitud];
    	    }
    	    
            for(Attachment attch : Attachments){
                
                Messaging.EmailFileAttachment attachExcel = new Messaging.EmailFileAttachment();
                attachExcel.setContentType('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
                attachExcel.setFileName(attch.name);
                attachExcel.setInline(false);
                attachExcel.Body = attch.body;
                mailAttachments.add(attachExcel);
            }
            
			//seteo los datos del email.              
            List <String> auxEmailsList = new List<String>(emails);
            
            List<EmailTemplate> emailTemps = new list<EmailTemplate>();
            if(Schema.sObjectType.EmailTemplate.isAccessible() 
            && Schema.sObjectType.EmailTemplate.fields.Subject.isAccessible()
            && Schema.sObjectType.EmailTemplate.fields.markup.isAccessible()
            && Schema.sObjectType.EmailTemplate.fields.developerName.isAccessible()){
                emailTemps = [SELECT Id,Subject, markup, developerName FROM EmailTemplate WHERE developerName = 'Solicitud_capex'];
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            if(emailTemps.size() > 0){
                mail.setUseSignature(false);
                mail.setSaveAsActivity(false);
                mail.setTargetObjectId(UserInfo.getUserId());
                mail.setTemplateId(emailTemps[0].id);
                mail.setToAddresses(auxEmailsList);
                mail.setFileAttachments(mailAttachments); 
            }
            // Send the email
            try {
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            } catch (EmailException e) {
                
                if(e.getMessage().contains('INVALID_EMAIL_ADDRESS')){
                    String emailErroneo = e.getMessage().substringBetween('Email address is invalid:',': [');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'El email: " ' +emailErroneo+ ' " es invalido.');
                    ApexPages.addMessage(myMsg);
                    
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    ApexPages.addMessage(myMsg);
                    
                }
                
                errors = true;
            }
            
            if(!errors){
                enviado = 'Se ha enviado la solicitud';
            }
            
        }else{
            
            //como llamo a este metodo en el on complete del action function a la hora de enviar tengo que crear aca los mensajes de error para que no desaparescan en la pantalla cuando se llame a este metodo
            for(String errorAMostrar :erroresAMostrar){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorAMostrar);
                ApexPages.addMessage(myMsg);
            }
        }
        return null;
    }
    
    public PageReference agregarMail(){
        
        Email_solicitud_capex__c emailOpcional = new Email_solicitud_capex__c();
        
        if(Schema.sObjectType.Email_solicitud_capex__c.fields.name.isCreateable()){
            emailOpcional.name = nombreEmail;
        }
        if(Schema.sObjectType.Email_solicitud_capex__c.fields.email__c.isCreateable()){
            emailOpcional.email__c = mailExterno;
        }
        if(Schema.sObjectType.Email_solicitud_capex__c.fields.Solicitud_capex__c.isCreateable()){
            emailOpcional.Solicitud_capex__c = idSolicitud;
        }
    
        try{
            
            if(Schema.sObjectType.Email_solicitud_capex__c.isCreateable())
            insert emailOpcional;      
            
        }catch(DMLException e){
            
        }
        
        
        
        if(emailOpcional.id != null){
            WrapperMail wrppMail = new WrapperMail(emailOpcional.id, nombreEmail, mailExterno);
            //
            emails.add(mailExterno);
            wrappersMails.add(wrppMail);
        }
        
        return null;
    }
    
    public PageReference eliminarMail(){
        
        List <WrapperMail> wrappersToDelete = new List<WrapperMail>(); 
        for(WrapperMail wpp : wrappersMails){
            
            if(wpp.eliminar){
                emails.remove(wpp.email);
                wrappersToDelete.add(wpp);
            }
        }
        
        List<String> idAEliminar = new List<String>();
        for(WrapperMail wpp : wrappersToDelete){
            
            idAEliminar.add(wpp.id);
            removeObjectFromList(wrappersMails, wpp);
        }
        
        
        List<Email_solicitud_capex__c> emailsABorrar = new List<Email_solicitud_capex__c>();
        
        if(Schema.sObjectType.Email_solicitud_capex__c.isAccessible() ){
            emailsABorrar = [SELECT ID FROM Email_solicitud_capex__c WHERE ID IN: idAEliminar];
        }
        
        if(Email_solicitud_capex__c.sObjectType.getDescribe().isDeletable()){
            delete emailsABorrar;
        }
        
        return null;
    }
    
    public void removeObjectFromList(List<WrapperMail> lst, WrapperMail obj) {
        for (Integer i = lst.size() - 1; i >= 0 ; --i) {
            if (lst.get(i) == obj) {
                lst.remove(i); 
            }
        }
    }
    
    public class WrapperMail{
        
        public Boolean eliminar {get; set;}
        public String email {get; set;}
        public String nombre {get; set;}
        public String id {get; set;}
        
        public WrapperMail (String unId, String name, String unEmail){
            id = unId;
            nombre = name;
            eliminar = false;
            email = unEmail;
        }
    }
}