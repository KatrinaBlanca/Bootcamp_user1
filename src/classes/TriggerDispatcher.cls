/* 
 * Description: Trigger dispatcher, responsible for calling all the methods in the handler 
                based on trigger context, disables based on custom setting/metadata and applies
                recursion control
 * Author: Michael Lasala (Accenture)
 * Date Created: JAN-26-17
 */
public class TriggerDispatcher { 
    
    // Recursion control
    public static Boolean isRecursion = true;
    
    public static void Run(TriggerInterface handler){
        
        // Check to see if the trigger has been disabled. If it has, return
        if (handler.IsDisabled())
        return;
        
        // Recursion control
        // This is to avoid duplicate dml call
        if (isRecursion){
            // Check the current trigger context and fire the relevant methods on the trigger handler:
            // Before trigger dispatch
            if (Trigger.IsBefore ){
                if (Trigger.IsInsert)
                    handler.BeforeInsert(trigger.new);
            
                if (Trigger.IsUpdate)
                    handler.BeforeUpdate(trigger.newMap, trigger.oldMap);
            
                if (Trigger.IsDelete)
                    handler.BeforeDelete(trigger.oldMap);
            }
            
            // After trigger dispatch
            if (Trigger.IsAfter){
                if (Trigger.IsInsert)
                    handler.AfterInsert(Trigger.newMap);
            
                if (Trigger.IsUpdate)
                    handler.AfterUpdate(trigger.newMap, trigger.oldMap);
            
                if (trigger.IsDelete)
                    handler.AfterDelete(trigger.oldMap);
            
                if (trigger.isUndelete)
                    handler.AfterUndelete(trigger.oldMap);
            }
        }
    }
}