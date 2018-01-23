/**
 * @author Aard-Jan van Kesteren
 * @description Util methods.

    @author sopon.srisummasheep@accenture.com
    @description 
        - add trigger activation method.
 */
public class Util {

    private static final String OPPORTUNITY_ID_PREFIX = '006';
    private static final String QUOTE_ID_PREFIX = '0Q0';
    
    public static Boolean isOpportunityId(Id id) {
        return String.valueOf(id).startsWith(OPPORTUNITY_ID_PREFIX);
    }
    
    public static Boolean isQuoteId(Id id) {
        return String.valueOf(id).startsWith(QUOTE_ID_PREFIX);
    }   
    
    public static String formatRate(Decimal value) {
        return formatRate(value, false);
    }
    
    public static String formatRate(Decimal value, Boolean alwaysTruncate) {
        
        if (!alwaysTruncate && value < 1) {
            decimal s=((value==null)?0:value.stripTrailingZeros());
            return 'PHP ' + s.toPlainString() ;
        } else {
            String s = (((value==null)?0:value.setScale(2) )+ 0.001 ).format();
            return 'PHP ' + s.substring(0,s.length()-1) ;
        }
        
        // return '€ ' + value.stripTrailingZeros().toPlainString();
        // TODO: Somehow arrange that 0.2 => €0.20
    }
    
    public static String formatPercentage(Decimal value) {
        return value + ' %';
    }
    



    /*
    @author sopon.srisummasheep@accenture.com
    */
    public static Boolean is_active(String key){
        List<Trigger_Setting__mdt> setting = [
            select  Id, Inactive_For__c, Label, DeveloperName
            from    Trigger_Setting__mdt
            where   DeveloperName = :key
        ];

        if(setting == null || setting.size() == 0 || setting.get(0).Inactive_For__c == null || setting.get(0).Inactive_For__c == ''){
            return true;
        }
        else{
            Id profile_id = UserInfo.getProfileId();
            Set<String> inactive = new Set<String>(setting.get(0).Inactive_For__c.split('\n'));
            return !(inactive.contains('ALL') || inactive.contains(UserInfo.getUserName()) || inactive.contains(profile_id + '') );
        }
    }
}