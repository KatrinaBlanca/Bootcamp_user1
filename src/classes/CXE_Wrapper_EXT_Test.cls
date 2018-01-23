/* Description: CXE_Wrapper_EXT test class
 * Author: Rom Edison Reyes
 * Date Created: JUL-13-17
 */
@isTest
private class CXE_Wrapper_EXT_Test {

static testMethod void testserviceObject(){
	CXE_Wrapper_EXT.serviceObject servObj = new CXE_Wrapper_EXT.serviceObject();
	servObj.url = 'https://myUrl.com';
	servObj.method = 'method';
	servObj.authtype = 'authtype';
	servObj.username = 'username';
	servObj.password = 'password';
	servObj.clientId = 'clientId';
	servObj.clientSecret = 'clientSecret';
	servObj.bearerTokenSessionId =  'bearerTokenSessionId';
	servObj.codeBlock = 'codeBlock';

	System.assertEquals('https://myUrl.com', servObj.url);
	System.assertEquals('method', servObj.method);
	System.assertEquals('authtype', servObj.authtype);
	System.assertEquals('username', servObj.username);
	System.assertEquals('password', servObj.password);
	System.assertEquals('clientId', servObj.clientId);
	System.assertEquals('clientSecret', servObj.clientSecret);
	System.assertEquals('bearerTokenSessionId', servObj.bearerTokenSessionId);
	System.assertEquals('codeBlock', servObj.codeBlock);
}

static testMethod void testmarketingTokenFormat(){
	CXE_Wrapper_EXT.marketingTokenFormat mtf = new CXE_Wrapper_EXT.marketingTokenFormat();
	mtf.clientId = 'clientId';
    mtf.clientSecret = 'clientSecret';

    System.assertEquals('clientId', mtf.clientId);
	System.assertEquals('clientSecret', mtf.clientSecret);
}

static testMethod void testmarketingsendSMSFormat(){
	CXE_Wrapper_EXT.marketingsendSMSFormat mssf = new CXE_Wrapper_EXT.marketingsendSMSFormat();
	mssf.mobileNumbers = new String[]{'a', 'b', 'c'};
    mssf.Subscribe = true;
	mssf.Resubscribe = true;
	mssf.Override1 = true;
	mssf.messageText = 'messageText';

	System.assert(!mssf.mobileNumbers.isEmpty());
	System.assert(mssf.Subscribe);
	System.assert(mssf.Resubscribe);
	System.assert(mssf.Override1);
	System.assertEquals('messageText', mssf.messageText);
}


}