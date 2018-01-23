/*
 * Start Mike Verdad
 * 08/29/2017
*/
@isTest
public class CXE_PicklistFieldController_Test {

	 @isTest
    static void test_getDependentOptionsImpl2()
    {
        test.startTest();       
        	CXE_PicklistFieldController.getDependentOptionsImpl('','','');
        test.stopTest();
    }    
    
    @isTest
	static void Test_getDependentOptionsImpl3(){
            Map<String,List<String>> valueMap = CXE_PicklistFieldController.getDependentOptionsImpl('Account','ShippingCountryCode','ShippingStateCode');
            for(String contr : valueMap.keySet()){
                System.debug('CONTROLLING FIELD : ' + contr);
                System.debug('DEPENDENT VALUES ...  : ' + valueMap.get(contr));
            }
        }
 
}
// End Mike Verdad