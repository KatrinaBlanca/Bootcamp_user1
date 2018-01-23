/**  
* @author       : Jerome To
* @date         : 06/27/2017  
* @description  : Trigger for creating sharing rules for Opportunity using Manager Groups
*/ 
trigger OpportunityTrigger on Opportunity (after insert, after update) 
{
    if(trigger.isInsert || trigger.isUpdate)
    {
        List<OpportunityShare> shares  = new List<OpportunityShare>();
    //  List<OpportunityShare> sharesToDelete = new List<OpportunityShare>();
        Set<id> opptyIds = new Set<id>();
        // Get Manager group related to the current user
        List<Group> managerGroup = [ select id from group where type='Manager' and RelatedId= :UserInfo.getUserId()];
        System.debug('managerGroup:' + managerGroup);
        if (managerGroup.size()>0)
        {
            for(Opportunity claim : trigger.new){
                System.debug('managerGroup[0].Id:' + managerGroup[0].Id);
                OpportunityShare newShare = new OpportunityShare();
                newShare.OpportunityId = claim.Id;
                newShare.UserOrGroupId = managerGroup[0].Id;
                newShare.OpportunityAccessLevel = 'Read';
                //newShare.RowCause = Schema.OpportunityShare.Rowcause.Rule;
                shares.add(newShare);
                opptyIds.add(claim.Id);
                
            }

    //      sharesToDelete = [SELECT Id FROM OpportunityShare WHERE OpportunityId IN :opptyIds AND RowCause = 'ImplicitChild'];

    //      System.debug('sharesToDelete:' + sharesToDelete);
    //      if(!sharesToDelete.isEmpty()){

    //          List<Database.DeleteResult> deleteResults = Database.Delete(sharesToDelete, false);

    //          for(Database.DeleteResult sr : deleteResults) {
    //              if(!sr.isSuccess()){
    //              // Get the first save result error
    //              //Database.Error err = sr.getErrors()[0];
    //              // Check if the error is related to a trivial access level
    //              // Access levels equal or more permissive than the object's default 
    //              // access level are not allowed. 
    //              // These sharing records are not required and thus an insert exception is 
    //              // acceptable. 
    //              System.debug(StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION + ':' + String.join(sr.getErrors(), ','));
    //              } else {
    //                  System.debug('Deleted Successfully!');
    //              }
    //          }
                
    //          //Database.Delete(sharesToDelete, false);
    //          //System.debug('under Database.Delete');

    //      }

    //      // Insert sharing records and capture save result 
    //      // The false parameter allows for partial processing if multiple records are passed 
    //      // into the operation 
    //      System.debug('shares:' + shares);
            Database.SaveResult[] lsr = Database.insert(shares, false);

            Integer i=0;

            // Process the save results
            for(Database.SaveResult sr : lsr){
                if(!sr.isSuccess()){
                    // Get the first save result error
                    Database.Error err = sr.getErrors()[0];

                    // Check if the error is related to a trivial access level
                    // Access levels equal or more permissive than the object's default 
                    // access level are not allowed. 
                    // These sharing records are not required and thus an insert exception is 
                    // acceptable. 
                    if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                         &&  err.getMessage().contains('AccessLevel'))){
                             // Throw an error when the error is not related to trivial access level.
                             trigger.newMap.get(shares[i].OpportunityId).
                                 addError(
                                     'Unable to grant sharing access due to following exception: '
                                     + err.getMessage());
                         }
                }
                i++;
            }           
        }

        
    }
}