public class OportunidadAUpdatear {
    public String idCuenta{get;set;}
    public String idUsuario{get;set;}
    
    public OportunidadAUpdatear(String cuenta, String usuario){
        idCuenta = cuenta;
        idUsuario = usuario;
    }
}