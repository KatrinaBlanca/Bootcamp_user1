global with sharing class test12
{
	@AuraEnabled
    Global static contact test(Id conid)
    {
        contact c = [select Firstname from contact where Id =:conid];
        return c;
    }
}