trigger UpdateServiceTrigger on SCP_Certa_GC__Update_Service_batch__c (before insert) {
    
    if(trigger.isBefore && trigger.isInsert){
        //IFB_S425_UpdateService
        
        Pricebook2 listaDePrecioTelecom;
        Pricebook2 listaDePrecioActiva = [select id, name from Pricebook2 where isStandard=true limit 1];
        List<Pricebook2> listasDePreciosTelecom = [select id, name, isActive from Pricebook2 where name = 'Telecom' limit 1];
        
        if(listasDePreciosTelecom.size() == 0){
            listaDePrecioTelecom = new Pricebook2();
            listaDePrecioTelecom.name = 'Telecom';
            listaDePrecioTelecom.isActive = true;
            insert listaDePrecioTelecom;   
        }else{
            listaDePrecioTelecom = listasDePreciosTelecom[0];
            system.debug(listaDePrecioTelecom);
        }
        
        list<Product2> productosAInsertar = new List<Product2>();
        list<PricebookEntry> entradas = new List<PricebookEntry>();
        list<PricebookEntry> entradasTelecom = new List<PricebookEntry>();
        
        List<Product2> productosYaExistentes = [select id, ExternalId from product2 where productoGeneradoPorDelta__c = true limit 5000];
        map<String, Product2> mapaDeProductosYaExistentes = new Map<String,Product2>();
        for(Product2 producto: productosYaExistentes){
            mapaDeProductosYaExistentes.put(producto.ExternalId, producto);
        }
        
        for(Update_Service_batch__c batch : Trigger.new){
            
            if(mapaDeProductosYaExistentes.get(String.valueOf(batch.idDelta__c)) == null ){
                Product2 producto = new Product2();
                producto.name = batch.Name__c;
                producto.family = batch.categoria__c;
                producto.ExternalId = String.valueOf(batch.idDelta__c);
                producto.IsActive = true;
                producto.productoGeneradoPorDelta__c = true;
                
                productosAInsertar.add(producto);
            }
        }
        
        insert productosAInsertar;
        system.debug(productosAInsertar);
        
        for(Product2 producto : productosAInsertar){
            PricebookEntry entradaDelProductoALaListaDePreciosStandar = new PricebookEntry();
            entradaDelProductoALaListaDePreciosStandar.Product2Id = producto.id;
            entradaDelProductoALaListaDePreciosStandar.PriceBook2Id = listaDePrecioActiva.id;
            entradaDelProductoALaListaDePreciosStandar.isActive = true;
            entradaDelProductoALaListaDePreciosStandar.UnitPrice = 0;
            //entradaDelProductoALaListaDePreciosStandar.UseStandardPrice = true;
            
            PricebookEntry entradaDelProductoALaListaDePreciosTelecom = new PricebookEntry();
            entradaDelProductoALaListaDePreciosTelecom.Product2Id = producto.id;
            entradaDelProductoALaListaDePreciosTelecom.PriceBook2Id = listaDePrecioTelecom.id;
            entradaDelProductoALaListaDePreciosTelecom.isActive = true;
            entradaDelProductoALaListaDePreciosTelecom.UnitPrice = 0;
            //entradaDelProductoALaListaDePreciosTelecom.UseStandardPrice = true;
            
            entradas.add(entradaDelProductoALaListaDePreciosStandar);
            entradasTelecom.add(entradaDelProductoALaListaDePreciosTelecom);
        }
        
        system.debug(entradas);
        insert entradas;
        insert entradasTelecom;
    }
}