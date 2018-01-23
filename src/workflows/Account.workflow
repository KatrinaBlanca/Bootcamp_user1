<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CXE_Email_to_CBG_RM_that_CBG_customer_is_attempting_to_enroll_a_portal_account</fullName>
        <description>Email to CBG RM that CBG customer is attempting to enroll a portal account.</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_CBG_RM_Notification_Registration</template>
    </alerts>
    <alerts>
        <fullName>CXE_Profile_Information_Update_INDV</fullName>
        <description>Email to customer that the profile information update</description>
        <protected>false</protected>
        <recipients>
            <field>CXE_PersonEmail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Successful_Profile_Info_Edit_INDV</template>
    </alerts>
    <fieldUpdates>
        <fullName>CAPS_Business_Account_Name</fullName>
        <description>CAPS Business Account Name</description>
        <field>Name</field>
        <formula>UPPER(Name)</formula>
        <name>CAPS Business Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CXE_PersonEmailtoAccountEmail</fullName>
        <field>CXE_PersonEmail__c</field>
        <formula>PersonEmail</formula>
        <name>CXE_PersonEmailtoAccountEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CXE_trigger_CBG_RM_email_SET_FALSE</fullName>
        <description>Uncheck  CXE_trigger_CBG_RM_email__c</description>
        <field>CXE_trigger_CBG_RM_email__c</field>
        <literalValue>0</literalValue>
        <name>CXE_trigger_CBG_RM_email_SET_FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Address</fullName>
        <field>Email__c</field>
        <formula>PersonEmail</formula>
        <name>Update Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Home_Phone</fullName>
        <field>PersonHomePhone</field>
        <formula>Phone</formula>
        <name>Update Home Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Biz</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CXE_Business_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>update Record Type - Biz Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_CBG_Commercial</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CXE_Business_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - CBG Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_HMB_LGU</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CXE_Business_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - HMB LGU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_VIP_Tagging</fullName>
        <field>VIP__c</field>
        <literalValue>1</literalValue>
        <name>Update VIP Tagging</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uppercase_First_Name</fullName>
        <field>FirstName</field>
        <formula>IF(NOT(ISBLANK(FirstName)),UPPER(FirstName), &apos;&apos;)</formula>
        <name>Uppercase First Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uppercase_Last_Name</fullName>
        <field>LastName</field>
        <formula>IF(NOT(ISBLANK(LastName)),UPPER(LastName), &apos;&apos;)</formula>
        <name>Uppercase Last Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uppercase_Middle_Name</fullName>
        <field>MiddleName</field>
        <formula>IF(NOT(ISBLANK(MiddleName)),UPPER(MiddleName), &apos;&apos;)</formula>
        <name>Uppercase Middle Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test1</fullName>
        <field>CXE_trigger_CBG_RM_email__c</field>
        <literalValue>0</literalValue>
        <name>test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Record_Type_RES</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CXE_Business_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>update Record Type - RES</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Biz - Commercial%2FIndustrial Account Creation on Lead Conversion</fullName>
        <actions>
            <name>Update_Record_Type_Biz</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Commercial Customer</value>
        </criteriaItems>
        <description>Upon lead conversion, Commercial Lead becomes Biz - Commercial/Industrial account record type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CBG - Commercial%2FIndustrial Account Creation on Lead Conversion</fullName>
        <actions>
            <name>Update_Record_Type_CBG_Commercial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Industrial Customer</value>
        </criteriaItems>
        <description>Upon lead conversion, Industriall Lead becomesCBG - Commercial/Industrial account record type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CXE_CAPS Business Account Name Always</fullName>
        <actions>
            <name>CAPS_Business_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CAPS Business Account Name Always</description>
        <formula>AND(OR(ISNEW(),  ISCHANGED(Name)), RecordType.DeveloperName = &apos;CXE_Business_Account&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE_PersonEmailtoAccountEmail</fullName>
        <actions>
            <name>CXE_PersonEmailtoAccountEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.PersonEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Profile_Information_Update_INDV</fullName>
        <actions>
            <name>CXE_Profile_Information_Update_INDV</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Successful_Information_Update_of_Meralco_Online_Account</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISNEW()),OR(ISCHANGED(   Salutation ),ISCHANGED(  Email_2__pc  ), ISCHANGED( PersonBirthdate ), ISCHANGED(Phone), ISCHANGED( Mobile_1__pc ), ISCHANGED(Mobile_2__pc)), CXE_isPortalContact__pc , IsPersonAccount,ISPICKVAL(LastModifiedBy.UserType, &quot;High Volume Portal&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE_trigger_CBG_RM_email</fullName>
        <actions>
            <name>CXE_Email_to_CBG_RM_that_CBG_customer_is_attempting_to_enroll_a_portal_account</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.CXE_trigger_CBG_RM_email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Email to CBG RM that CBG customer is attempting to enroll a portal account.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CXE_trigger_CBG_RM_email_SET_FALSE</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HMB - Local Government Units Account Creation on Lead Conversion</fullName>
        <actions>
            <name>Update_Record_Type_HMB_LGU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Streetlight Customer</value>
        </criteriaItems>
        <description>Upon lead conversion, Streetlight Customer Lead becomes  HMB - Local Government Units Account record type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Indicate Account RES</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_ID__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Prospect Account Creation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RES Account Creation on Lead Conversion</fullName>
        <actions>
            <name>update_Record_Type_RES</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Retail Energy Supplier</value>
        </criteriaItems>
        <description>Upon lead conversion, Retail Energy Supplier Lead becomes  RES Account record type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RES Customer Account Creation on Lead Conversion</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Industrial Customer</value>
        </criteriaItems>
        <description>Upon lead conversion, Retail Energy Supplier Lead becomes RES Customer
 account record type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Email Address</fullName>
        <actions>
            <name>Update_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the email address field being mapped to V10</description>
        <formula>ISCHANGED( PersonEmail  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Uppercase First Name%2C Middle Name and Last Name on Account</fullName>
        <actions>
            <name>Uppercase_First_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uppercase_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uppercase_Middle_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  IsPersonAccount , OR( ISNEW(),  ISCHANGED( FirstName ) ,  ISCHANGED( MiddleName ) ,  ISCHANGED( LastName )  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Successful_Information_Update_of_Meralco_Online_Account</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Successful Information Update of Meralco Online Account</subject>
    </tasks>
</Workflow>
