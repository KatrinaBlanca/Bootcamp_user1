/* 
 * Description: Interface which lists all methods each trigger handler should implement.
 * Author: Michael Lasala (Accenture)
 * Date Created: JAN-26-17
 */
public interface TriggerInterface {
    
    //All trigger contexts
    void BeforeInsert(List<SObject> newList);
    
    void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap);
    
    void BeforeDelete(Map<Id, SObject> oldMap);
    
    void AfterInsert(Map<Id, SObject> newMap);
    
    void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap);
    
    void AfterDelete(Map<Id, SObject> oldMap);
    
    void AfterUndelete(Map<Id, SObject> oldMap);
    
    //Trigger disabling
    Boolean IsDisabled();
    
}