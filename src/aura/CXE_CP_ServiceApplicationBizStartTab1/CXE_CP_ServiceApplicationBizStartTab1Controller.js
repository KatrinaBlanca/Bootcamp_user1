({
	validateBizTab1 : function(component, event, helper) {

   	}, 

	submitTab : function(component, event, helper) {
      console.log(' >>>>>>>>>>>>>>>>>>>>>>>>>>> submitTab1: ');
        
      helper.displayTab2(component, event, helper);
	},

    doPageValidation : function(component, event, helper) {   
        var hasError = helper.validate(component, event, helper);
        component.set("v.hasErrorOnPage", hasError);
    },

    onClickNext : function(component, event, helper) {   
        helper.displayTab2(component, event, helper);
    },

    onClickHasAppliedForSomeone : function(component, event) {        
        var selected = component.find("hasAppliedForSomeone").getElement().checked;
        component.set("v.caseVar.Has_Applied_for_Someone__c", selected);
        component.set("v.isApplyingForSomeone", selected);
        if(selected == false){
          component.set("v.caseVar.Authorized_Representative_First_Name__c", '');
          component.set("v.caseVar.Authorized_Representative_Middle_Name__c", '');
          component.set("v.caseVar.Authorized_Representative_Last_Name__c", '');
          component.set("v.caseVar.Authorized_Representative_Email__c", '');
          component.set("v.caseVar.Authorized_Rep_Primary_Contact_Number__c", '');
          component.set("v.caseVar.Relationship__c", '--- None ---');
        }
    }
})