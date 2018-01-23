@IsTest 
public with sharing class CXE_CP_MyProfileTab3_Test1 {
    @IsTest
    (SeeAllData=true) public static void testCXE_CP_MyProfileTab3() {
        
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
}