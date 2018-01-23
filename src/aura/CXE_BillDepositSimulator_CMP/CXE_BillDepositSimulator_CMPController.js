({
    /* Description: Hide modal
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     */
    hideManualSimulation : function(component, event, helper) {
    	helper.closeModalHelper(component, 'manualSimulationDiv');
        helper.closeModalHelper(component, 'backGroundSectionId');
    }, 

    /* Description: Validate update amount
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     */
    validateUpdate : function(component, event, helper) {
		helper.validateBillDepositController(component, event, helper, false);
    }, 

    /* Description: Validate calculator
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     */
    validateSimulation : function(component, event, helper) {
		helper.validateBillDepositController(component, event, helper, true);
    }, 

    /* Description: Recalulate bill deposit
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: MAR-15-17
     */
    reCalculate : function(component, event, helper) {
        helper.manualSimulationHelper(component, event, helper, true);
    },

    /* Description: Recalulate bill deposit
     * Parameters:
     * Author: Jerome To
     * Date Created: MAY-19-17
     */
    estimate : function(component, event, helper) {
        helper.estimateBillDeposit(component, event, helper);
    },

    doInit : function(component, event, helper) {       
        
        helper.getRateType(component, event, helper);
    }

})