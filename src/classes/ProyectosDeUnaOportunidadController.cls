public class ProyectosDeUnaOportunidadController {
    
    Public String idOportunidad {get; set;}
    Public Opportunity oportunidad {get;set;}
    Public List<proyecto__c> proyectos {get;set;}
    Public List<WrapperProductoConProyectos> wrappersProyectos {get; set;}
    Public Double ImporteTotalProyecto {get;set;}
    
    Public Opportunity oportunidadParaMostrarValorDeLaSumaDeProyectos {get;set;}
    
    public ProyectosDeUnaOportunidadController(ApexPages.StandardController controller){
        
        idOportunidad = controller.getId();
        wrappersProyectos = new List<WrapperProductoConProyectos>();
        
        oportunidad = [select id, Dolar_Buget__c from Opportunity where id =: idOportunidad];
        
        oportunidadParaMostrarValorDeLaSumaDeProyectos = new Opportunity();
        
        proyectos = [select id, name, estado__c, id_delta__c,
                     (select id, tmi__c, name, producto__r.name, proyecto__r.id_delta__c, Proyecto__r.name, Cantidad__c, proyecto__r.estado__c, 
                      Moneda__c, PrecioFinal__c, Plazo_Contrato__c, monto_Mensual__c, Monto_One__c
                      from Asociaciones_de_producto_con_proyecto__r)
                     from proyecto__c where oportunidad__c =: idOportunidad];
        
        if(proyectos != null){
            if(proyectos.size()>0){
                crearWrapperProductoProyecto();
            }
        }
        
        ImporteTotalProyecto = 0;
        if(wrappersProyectos.size()>0){
            for(WrapperProductoConProyectos wpp: wrappersProyectos){
                if(wpp.valorTotal != null)
                ImporteTotalProyecto = ImporteTotalProyecto + wpp.valorTotal;
            }
        }
        
        oportunidadParaMostrarValorDeLaSumaDeProyectos.amount = ImporteTotalProyecto;
        
    }
    

    public void crearWrapperProductoProyecto(){
        for(Proyecto__c pr: proyectos){
            WrapperProductoConProyectos wpp = new WrapperProductoConProyectos(pr.Asociaciones_de_producto_con_proyecto__r, Oportunidad.Dolar_Buget__c, pr);
            wrappersProyectos.add(wpp);
        }
    }
    
//============================================================================================
    public class WrapperProductoConProyectos{
        
        public String productoNombre {get;set;}
        public String proyectoEstado {get;set;}
        public String proyectoNumero {get;set;}
        public List<Asociacion_de_producto_con_proyecto__c> proyectos {get; set;}
        Public Double valorTotal {get; set;}
        
        public WrapperProductoConProyectos(List<Asociacion_de_producto_con_proyecto__c> unosProyectos, Decimal valorDolar, Proyecto__c pr){
            proyectos = unosProyectos;

            productoNombre = pr.name;
            proyectoEstado = pr.estado__c;
            proyectoNumero = pr.id_delta__c;

            
            valorTotal = 0;
            for(Asociacion_de_producto_con_proyecto__c proy: unosProyectos){
                
                if(proy.monto_one__c!=null){
                    
                    if(proy.moneda__c == 'USD'){
                        
                        Double dolar = 0;
                        if(valorDolar != null){
                            dolar = valorDolar;
                        }
                        
                        valorTotal = valorTotal + (proy.monto_one__c*dolar);
                        
                    }else{
                        valorTotal = valorTotal + proy.monto_one__c;    
                    }
                    
                }
                
                if(proy.Monto_Mensual__c!=null){
                    
                    if(proy.moneda__c == 'USD'){
                        
                        Double meses = 0;
                        
                        if(proy.Plazo_contrato__c != null){
                            meses = proy.Plazo_contrato__c;
                        }
                        
                        Double dolar = 0;
                        if(valorDolar != null){
                            dolar = valorDolar;
                        }
                        
                        valorTotal = valorTotal + (dolar*proy.Monto_Mensual__c*meses);
                        
                    }else{
                        Double meses = 0;
                        
                        if(proy.Plazo_contrato__c != null){
                            meses = proy.Plazo_contrato__c;
                        }
                        
                        valorTotal = valorTotal + (proy.Monto_Mensual__c*meses);    
                    }
                    
                }
            }
            
            Asociacion_de_producto_con_proyecto__c proyectoSubTotal = new Asociacion_de_producto_con_proyecto__c();
            proyectoSubTotal.name = '  Subtotal';
            proyectoSubTotal.monto_one__c = valorTotal;
            
            proyectos.add(proyectoSubTotal);
        }
    }
}