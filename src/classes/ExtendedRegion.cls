public with sharing class ExtendedRegion{

    public Region__C Region {get;set;}
    
    public List< Industry_Trend__c > Trends {get;set;}
    
    
    public ExtendedRegion(Region__C region, List<Industry_Trend__c> Trends){
    
        this.Region = region;
        
        this.Trends = Trends;
    
    }
}