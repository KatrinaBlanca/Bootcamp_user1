@isTest
private class CXE_Heroku_Model_Test {
	
	private static testMethod void Test(){

		CXE_Heroku_Model.PaymentDetail PD = new CXE_Heroku_Model.PaymentDetail();
		CXE_Heroku_Model.allocation alloc = new CXE_Heroku_Model.allocation();
		CXE_Heroku_Model.Bill_note bn = new CXE_Heroku_Model.Bill_note();
		CXE_Heroku_Model.Payment_Transaction pt = new CXE_Heroku_Model.Payment_Transaction();
		CXE_Heroku_Model.Payment_Transaction_Item pti = new CXE_Heroku_Model.Payment_Transaction_Item();
		CXE_Heroku_Model.BillDetail bd = new CXE_Heroku_Model.BillDetail();
		CXE_Heroku_Model.ConglomerateDetail cd = new CXE_Heroku_Model.ConglomerateDetail();
		CXE_Heroku_Model.ConglomerateDisplay cd2 = new CXE_Heroku_Model.ConglomerateDisplay();
		CXE_Heroku_Model.BillSummary bs = new CXE_Heroku_Model.BillSummary();
		CXE_Heroku_Model.BillDtlWrapper bdw = new CXE_Heroku_Model.BillDtlWrapper(bd);
	}
	
}