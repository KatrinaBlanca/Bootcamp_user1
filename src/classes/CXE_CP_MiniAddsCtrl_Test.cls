@isTest
public class CXE_CP_MiniAddsCtrl_Test {
	
    @isTest
    static void ads(){
        String miniAdsPaperlessBillingUnsubscribe = CXE_CP_MiniAddsCtrl.MiniAddsPaperlessBillingUnsubscribe();
        String miniAddsBillSummary = CXE_CP_MiniAddsCtrl.MiniAddsBillSummary();
        String miniAddsPaperlessBillingTnC = CXE_CP_MiniAddsCtrl.miniAddsPaperlessBillingTnC();
        String miniAddsPaymentOptions = CXE_CP_MiniAddsCtrl.MIniAddsPaymentOptions();
        String MiniAddsViewBillAnytimeAnyWhere = CXE_CP_MiniAddsCtrl.MiniAddsViewBillAnytimeAnyWhere();
        
        test.startTest();
        system.assertEquals(miniAdsPaperlessBillingUnsubscribe, CXE_CP_MiniAddsCtrl.MiniAddsPaperlessBillingUnsubscribe());
        system.assertEquals(miniAddsBillSummary, CXE_CP_MiniAddsCtrl.MiniAddsBillSummary());
        system.assertEquals(miniAddsPaperlessBillingTnC, CXE_CP_MiniAddsCtrl.miniAddsPaperlessBillingTnC());
        system.assertEquals(miniAddsPaymentOptions, CXE_CP_MiniAddsCtrl.MIniAddsPaymentOptions());
        system.assertEquals(MiniAddsViewBillAnytimeAnyWhere, CXE_CP_MiniAddsCtrl.MiniAddsViewBillAnytimeAnyWhere());
        test.stopTest();
    }
}