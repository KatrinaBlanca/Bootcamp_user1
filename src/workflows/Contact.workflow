<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CXE_Profile_Information_Update_BIZ</fullName>
        <description>Email to customer that the profile information update</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Successful_Profile_Info_Edit_BIZ</template>
    </alerts>
    <alerts>
        <fullName>CXE_Profile_Information_Update_INDV</fullName>
        <description>Email to customer that the profile information update</description>
        <protected>false</protected>
        <recipients>
            <field>Email_1__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Successful_Profile_Info_Edit_INDV</template>
    </alerts>
    <outboundMessages>
        <fullName>testContact</fullName>
        <apiVersion>39.0</apiVersion>
        <description>delete me</description>
        <endpointUrl>https://provide-ap.castiron.ibmcloud.com:443/env/Test/meco/contact</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>cxe.integ@meralco.com.ph</integrationUser>
        <name>testContact</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CXE_Profile_Information_Update_BIZ</fullName>
        <actions>
            <name>CXE_Profile_Information_Update_BIZ</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email to customer that the profile information update</description>
        <formula>AND( NOT(ISNEW()), OR(ISCHANGED( Salutation ),ISCHANGED( Email_2__c ), ISCHANGED(Phone), ISCHANGED(Birthdate ), ISCHANGED(MobilePhone),  ISCHANGED(Mobile_2__c) ), CXE_isPortalContact__c, NOT(Account.IsPersonAccount),ISPICKVAL(LastModifiedBy.UserType, &quot;High Volume Portal&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>testContact</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LastName</field>
            <operation>contains</operation>
            <value>test</value>
        </criteriaItems>
        <description>delete me</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Successful_Information_Update_of_Meralco_Online_Account</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Successful Information Update of Meralco Online Account</subject>
    </tasks>
</Workflow>
