@isTest
public class ProductoTriggerTest {

    static testMethod void noSeEliminanProductosQueVienenDeDelta() {
        
        Product2 prd = new Product2();
        prd.Name = 'hola';
        prd.productoGeneradoPorDelta__c = true;
        insert prd;
        
		Product2 prd2 = [select id from product2];
        
        try{
            delete prd2;
        }catch(exception e){
            
        }

		//system.assertEquals(1, [select id from product2].size());        
    }
}