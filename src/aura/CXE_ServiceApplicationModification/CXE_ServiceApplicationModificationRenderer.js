({
	afterRender: function(cmp, helper) {
		this.superAfterRender();
        
  //       $('.CXE_availAMC input:radio').change(function() {
  //           if ($(this).is(':checked') && $(this).val() == 'Yes') {
  //               $('.CXE_serviceApplicationAccreditedYes').removeClass("slds-hide");
  //               if ($('.CXE_serviceApplicationAccreditedNo').hasClass("slds-hide")) {

  //               } else {
  //                   $('.CXE_serviceApplicationAccreditedNo').addClass("slds-hide");
  //               }
  //           }

  //           if ($(this).is(':checked') && $(this).val() == 'No') {
  //               $('.CXE_serviceApplicationAccreditedNo').removeClass("slds-hide");
  //               if ($('.CXE_serviceApplicationAccreditedYes').hasClass("slds-hide")) {

  //               } else {
  //                   $('.CXE_serviceApplicationAccreditedYes').addClass("slds-hide");
  //               }
  //           }

  //       });
        
		// $('.CXE_modificationChoice').change(function() {
		// 	if ($('#radio-300').is(':checked')) {
		// 		$('.CXE_serviceModChoices').removeClass('slds-hide');
		// 		$('.CXE_contractModChoices').addClass('slds-hide');
		// 		$('.CXE_contractModAddChoice').addClass('slds-hide');
		// 	}

		// 	if ($('#radio-301').is(':checked')) {
		// 		$('.CXE_contractModChoices').removeClass('slds-hide');
		// 		$('.CXE_serviceModChoices').addClass('slds-hide');
		// 		$('.CXE_contractModAddChoice').removeClass('slds-hide');
		// 	}
		// });

		// $('#CXE_serviceApplicationForm--TermsAndCondition').click(function() {
		// 	if ($(this).is(':checked')) {
		// 		$('.CXE_trueBut').removeClass('slds-hide');
		// 		$('.CXE_falseBut').addClass('slds-hide');
		// 	}

		// 	else {
		// 		$('.CXE_falseBut').removeClass('slds-hide');
		// 		$('.CXE_trueBut').addClass('slds-hide');
		// 	}
		// });

		// $('.slds-tabs_scoped__link').click(function() {
  //           //$('.slds-tabs_scoped__link').parent().removeClass('slds-is-active');
  //           if ($(this).attr('id') == 'modify-tab-scoped-5__item' || $(this).attr('id') == 'termination-tab-scoped-5__item' || $(this).attr('id') == 'recontract-tab-scoped-5__item' || $(this).attr('id') == 'new-tab-scoped-5__item') {
  //               return false;
  //           }
            
  //           if ($('#modify-tab-scoped-5__item').parent().hasClass('slds-is-active') || $('#termination-tab-scoped-5__item').parent().hasClass('slds-is-active') || $('#recontract-tab-scoped-5__item').parent().hasClass('slds-is-active') || $('#new-tab-scoped-5__item').parent().hasClass('slds-is-active') ) {
  //               $('slds-tabs_scoped__link').click(function() {
  //                   return false;
  //               });
  //           }
            
  //           else {
  //               $('.slds-tabs_scoped__item').removeClass('slds-is-active');
  //               $(this).parent().addClass('slds-is-active');
  //               var idOfContent = $(this).attr('id');
  //             //alert(a);
  //             $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
  //             $(".slds-tabs_scoped__content[aria-labelledby="+idOfContent+"]").removeClass('slds-hide').addClass('slds-show');
  //           }
  //       });

		// $('.CXE_button-toPage1').click(function() {
  //           $('.slds-tabs_scoped__item').removeClass('slds-is-active');
  //           $('#modify-tab-scoped-1__item').parent().addClass('slds-is-active');
  //           $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
  //           $('#modify-tab-scoped-1').removeClass('slds-hide').addClass('slds-show');
  //       });
        
  //       $('.CXE_button-toPage2').click(function() {
  //           $('.slds-tabs_scoped__item').removeClass('slds-is-active');
  //           $('#modify-tab-scoped-2__item').parent().addClass('slds-is-active');
  //           $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
  //           $('#modify-tab-scoped-2').removeClass('slds-hide').addClass('slds-show');
  //       });
        
  //       $('.CXE_button-toPage3').click(function() {
  //           $('.slds-tabs_scoped__item').removeClass('slds-is-active');
  //           $('#modify-tab-scoped-3__item').parent().addClass('slds-is-active');
  //           $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
  //           $('#modify-tab-scoped-3').removeClass('slds-hide').addClass('slds-show');
  //       });
        
  //       $('.CXE_button-toPage4').click(function() {
  //           $('.slds-tabs_scoped__item').removeClass('slds-is-active');
  //           $('#modify-tab-scoped-4__item').parent().addClass('slds-is-active');
  //           $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
  //           $('#modify-tab-scoped-4').removeClass('slds-hide').addClass('slds-show');
  //       });
        
  //       $('.CXE_button-toPage5').click(function() {
  //           $('.slds-tabs_scoped__item').removeClass('slds-is-active');
  //           $('#modify-tab-scoped-5__item').parent().addClass('slds-is-active');
  //           $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
  //           $('#modify-tab-scoped-5').removeClass('slds-hide').addClass('slds-show');
  //       });
	}
})