public with sharing class MosaicCellController {

     transient public List<ExtendedEvaluation> ECList  {get; set;}

    public String getId(){
    
        return ApexPages.currentPage().getParameters().get('Id');
        
   }     


}