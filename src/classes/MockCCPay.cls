@isTest
global class MockCCPay implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"isPaid": false, "createdAt": "2017-12-27T05:50:22.000Z", "amount": 1012, "requestReferenceNumber": "CXE000000000002954", "description": "Charge for willbyers@yopmail.com", "paymentTokenId": "GIqHxpa8uGQBgD7axJnXgUgGRnoug43PuzR7O9E6dt4fQg0bJNsyOvzdbVaB7oB6Q3tugvvQYs2Rqr84dUx6O7fUCaIHIDxc01mbvaPf4ZNjv2Lu9lr0FUugTh9FG0aRza94GMTBZFSQAlxjXvWoJlgfavNRmdUCNLIQRHE", "currency": "PHP", "id": "3dcc8fdf-f3ba-4db8-8130-ca4bca5d65f0", "verificationUrl": "https://sandbox-checkout-v2.paymaya.com/checkout?id=490d8df2-3a6f-4e1e-a82c-1503b96a6751&auto=Y&ct=GIqHxpa8uGQBgD7axJnXgUgGRnoug43PuzR7O9E6dt4fQg0bJNsyOvzdbVaB7oB6Q3tugvvQYs2Rqr84dUx6O7fUCaIHIDxc01mbvaPf4ZNjv2Lu9lr0FUugTh9FG0aRza94GMTBZFSQAlxjXvWoJlgfavNRmdUCNLIQRHE", "status": "PENDING_PAYMENT", "updatedAt": "2017-12-27T05:50:22.000Z"}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;

    }

}