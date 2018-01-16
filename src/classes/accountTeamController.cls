public class accountTeamController {
    
    public String idCuenta {get;set;}
    public List<AccountTeamMember> miembros {get;set;}
    
    public accountTeamController(ApexPages.StandardController controller){
        idCuenta = controller.getId();
        
        miembros = [select id, user.name, teamMemberRole from AccountTeamMember where accountId =: idCuenta];
    }

}