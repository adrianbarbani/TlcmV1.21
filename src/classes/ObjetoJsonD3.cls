public with sharing class ObjetoJsonD3 {
    
    public String name {get; set;}
    public String parent {get; set;}
    public String level {get; set;}
    public String type {get; set;}
    
    public List<ObjetoJsonD3> children {get;set;}
    
    public ObjetoJsonD3(){
        
    }
}