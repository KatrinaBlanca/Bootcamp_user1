global class CXE_Json {

	global class PaymentDetail{
        public String serviceNum {get; set;}
        public String billId {get; set;}
        public String accountNum {get; set;}
        public String paymentAmount {get; set;}
        public String accountId {get; set;}
    }
	
	public static void response(Object obj) {
		RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(obj));
	}

	public static void text(String obj) {
		RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf('{"result": "'+obj+'"}');
	}
}