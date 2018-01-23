/* Description: Bitset test class
 * Author: Rom Edison Reyes
 * Date Created: JUL-13-17
 */
@isTest
private class Bitset_Test {

static testMethod void testBitset(){   
	
	Bitset bs = new Bitset();
	List <Integer> nList = new List<Integer>{1,2,3,4,5};
	List <Integer> results = bs.testBits('testBitset', nList);
	System.assert(!bs.alphaNumCharCodes.isEmpty());	  
	System.assert(!bs.base64CharCodes.isEmpty());
	System.assert(!results.isEmpty());	           
}

static testMethod void testOneCharString(){   
	
	Bitset bs = new Bitset();
	List <Integer> nList = new List<Integer>{1,2,3,4,5};
	List <Integer> results = bs.testBits('b', nList);
	System.assert(results.isEmpty());	           
}

}