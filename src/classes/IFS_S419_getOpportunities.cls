global class IFS_S419_getOpportunities {
    
    webservice static wrapperResponse getOpportunities(String cuit_Req, String idClienteLegado){
        
        if(cuit_Req == null || idClienteLegado == null){
            throw new serviceSoapException('Los campos cuit_Req e idClienteLegado son obligatorios');
        }
        
        wrapperResponse response = new wrapperResponse();
        List<Account> cuentas = new List<Account>();
        Decimal cuit = Decimal.valueOf(cuit_Req);
        List<Opportunity> oportunidades = new List<Opportunity>();
        cuentas = [select id, cuit__c from Account where cuit__c =: cuit and idClienteLegado__c =: idClienteLegado limit 1];
        if(cuentas.size()>0){
            Id cuenta_ID = cuentas[0].id;
            oportunidades = [select id, Account.id, name, Estado_de_la_oportunidad__c from Opportunity where Account.id =: cuenta_ID and Account.idClienteLegado__c =: idClienteLegado];
            if(oportunidades.size()<1){
                response.codError='02';
                response.descError = 'No hay oportunidades para ese cliente';
            }else{
                for(Opportunity op : oportunidades){
                    wrapperOportunidades wop =  new wrapperOportunidades();
                    wop.Id_op=op.id;
                    wop.Description_op=op.name;
                    wop.estado_oportunidad=op.Estado_de_la_oportunidad__c;
                    response.listaOportunidades.add(wop);
                }
                response.codError='00';
                response.descError = 'OK';
            }    
        } else {
            response.codError='03';
            response.descError = 'Cliente inexistente';
        }
        return response;
    }
    
    global class wrapperResponse{
        webservice List<wrapperOportunidades> listaOportunidades;
        webservice String codError;
        webservice String descError;
        
        public wrapperResponse(){
           listaOportunidades = new List<wrapperOportunidades>();
        }
    }
    
    global class wrapperOportunidades{
        webservice String Id_op;
        webservice String Description_op;
        webservice String estado_oportunidad;
    }
}