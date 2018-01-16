@isTest
public class UpdateServiceTest {

    static testMethod void InsertoUnServicioBatchYSeCreaUnProducto(){
        
        PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
        update pb;
        
        Update_Service_batch__c batch = new Update_Service_batch__c(); 
        batch.Name__c = 'Nombre';
        batch.categoria__c = 'Digital';
        batch.idDelta__c = 123;
        
        insert batch;
        
        Product2 producto = [select id, name, family, ExternalId from product2];
        
        system.assertEquals('Nombre', producto.name);
        system.assertEquals('Digital', producto.family);
        system.assertEquals('123', producto.ExternalId);
    }
    
    static testMethod void InsertoUnServicioBatchYaExistenteYNoSeDuplica(){
        
        PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
        update pb;
        
        Update_Service_batch__c batch = new Update_Service_batch__c();
        batch.Name__c = 'Nombre';
        batch.categoria__c = 'Digital';
        batch.idDelta__c = 123;
        
        insert batch;
        
        Product2 producto = [select id, name, family, ExternalId from product2];
        
        system.assertEquals('Nombre', producto.name);
        system.assertEquals('Digital', producto.family);
        system.assertEquals('123', producto.ExternalId);
        
        Update_Service_batch__c batch2 = new Update_Service_batch__c();
        batch2.Name__c = 'Nombre';
        batch2.categoria__c = 'Digital';
        batch2.idDelta__c = 123;
        
        insert batch2;
        
        List<Product2> productos = [select id, name, family, ExternalId from product2];
        
        system.assertEquals(1, productos.size());
    }
        
}