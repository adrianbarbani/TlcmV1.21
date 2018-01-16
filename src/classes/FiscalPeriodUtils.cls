public with sharing class FiscalPeriodUtils {
    
    public static Date getFiscalYearEndDate() {
        FiscalYearSettings[] fys = new List<FiscalYearSettings>();
        
        if(Schema.sObjectType.FiscalYearSettings.isAccessible()
        && Schema.sObjectType.FiscalYearSettings.fields.EndDate.isAccessible())
        fys = [Select EndDate From FiscalYearSettings Where StartDate <= TODAY and EndDate >= TODAY];
        
        if (fys.size()>0) {
            return fys[0].EndDate;
        } else {
            
            Date dia;
            
            if(Schema.sObjectType.Organization.isAccessible()
            && Schema.sObjectType.Organization.fields.FiscalYearStartMonth.isAccessible())
            dia = getFiscalYearEndDateFromStartMonth([select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth);
            
            return dia;
        }
    }
    public static Date getFiscalYearEndDateFromStartMonth(Integer FiscalYearStartMonth) {
        Date fiscalYearEndDate;
        
        if(system.today().month() >= FiscalYearStartMonth) {
            fiscalYearEndDate = date.newinstance(system.today().year()+ 1, FiscalYearStartMonth, 1).addDays(-1);
        } else {
            fiscalYearEndDate = date.newinstance(system.today().year(), FiscalYearStartMonth, 1).addDays(-1);
        }
        return fiscalYearEndDate;
    }
}