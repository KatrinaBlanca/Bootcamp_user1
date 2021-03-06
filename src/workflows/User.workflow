<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CXE_Forgot_Password_BIZ_Email_Alert</fullName>
        <description>CXE Forgot Password BIZ Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Forgot_Password_BIZ</template>
    </alerts>
    <alerts>
        <fullName>CXE_Forgot_Password_INDV_Email_Alert</fullName>
        <description>CXE Forgot Password INDV Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Forgot_Password</template>
    </alerts>
    <alerts>
        <fullName>CXE_INDIV_Enrollment_Input_Password</fullName>
        <description>Email customer upon enrollment to confirm registration and input password</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Email_Verification</template>
    </alerts>
    <alerts>
        <fullName>CXE_Inactivity_of_Portal_Account_for_150_days</fullName>
        <description>CXE_Inactivity of Portal Account for 150 days</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Inactivity_of_Portal_Account</template>
    </alerts>
    <alerts>
        <fullName>CXE_Password_Reset_Biz_Email_Alert</fullName>
        <description>CXE Password Reset  Biz Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Password_Reset_BIZ</template>
    </alerts>
    <alerts>
        <fullName>CXE_Password_Reset_Indiv_Email_Alert</fullName>
        <description>CXE Password Reset  Indiv Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Password_Reset</template>
    </alerts>
    <alerts>
        <fullName>CXE_Portal_Account_Deactivation</fullName>
        <description>CXE_Portal Account Deactivation</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>R2B_Portal_Emails/CXE_Portal_Account_Deactivation</template>
    </alerts>
    <alerts>
        <fullName>CXE_PreEnrollment_BIZ</fullName>
        <description>Email to customer upon enrollment to confirm registration and input password for CBG and BIZ VIP customers. This email should also contain link to Terms and Conditions.</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Email_Verification_PreEnrolled_BIZ</template>
    </alerts>
    <alerts>
        <fullName>CXE_PreEnrollment_INDV</fullName>
        <description>Email to customer upon enrollment to confirm registration and input password for CBG and BIZ VIP customers. This email should also contain link to Terms and Conditions.</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Email_Verification_PreEnrolled</template>
    </alerts>
    <alerts>
        <fullName>Portal_Inactive_For_180_days</fullName>
        <description>Portal Inactive For 180 days</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Inactivity_of_Portal_Account_Deact</template>
    </alerts>
    <fieldUpdates>
        <fullName>CXE_PortalDormant180</fullName>
        <description>Change status to inactive</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>CXE_PortalDormant180</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CXE_User_Deactivation</fullName>
        <description>Deactivate User for not clicking verification after 30 days</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>CXE_User Deactivation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CXE_Portal Account Deactivation Confirmation</fullName>
        <actions>
            <name>CXE_Portal_Account_Deactivation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CXE_User Verification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>User.LastLoginDate</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>LAST 30 DAYS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CXE_User_Deactivation</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TestUserEmail</fullName>
        <active>false</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>testuser</fullName>
        <active>false</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>User.LastLoginDate</offsetFromField>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
