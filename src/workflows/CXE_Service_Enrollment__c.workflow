<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CXE_Add_SIN</fullName>
        <description>CXE_Add SIN</description>
        <protected>false</protected>
        <recipients>
            <field>CXE_UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Add_SIN</template>
    </alerts>
    <alerts>
        <fullName>CXE_Add_SIN_BIZ</fullName>
        <description>Email to customer that a new service is added to My Accounts list. </description>
        <protected>false</protected>
        <recipients>
            <field>CXE_UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Add_SIN_BIZ</template>
    </alerts>
    <alerts>
        <fullName>CXE_Add_SIN_INDV</fullName>
        <description>CXE_Add SIN</description>
        <protected>false</protected>
        <recipients>
            <field>CXE_UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Add_SIN</template>
    </alerts>
    <alerts>
        <fullName>CXE_Delete_SIN_BIZ</fullName>
        <description>Email to customer that a service is deleted from My Accounts list</description>
        <protected>false</protected>
        <recipients>
            <field>CXE_UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Delete_SIN_BIZ</template>
    </alerts>
    <alerts>
        <fullName>CXE_Delete_SIN_INDV</fullName>
        <description>Email to customer that a service is deleted from My Accounts list</description>
        <protected>false</protected>
        <recipients>
            <field>CXE_UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Delete_SIN_INDV</template>
    </alerts>
    <alerts>
        <fullName>CXE_Termination_of_service_BIZ</fullName>
        <description>Email to customer that a service enrolled in the portal account was terminated</description>
        <protected>false</protected>
        <recipients>
            <field>CXE_UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Termination_of_service_BIZ</template>
    </alerts>
    <alerts>
        <fullName>CXE_Termination_of_service_INDV</fullName>
        <description>Email to customer that a service enrolled in the portal account was terminated</description>
        <protected>false</protected>
        <recipients>
            <field>CXE_UserId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>R2B_Portal_Emails/CXE_Termination_of_service</template>
    </alerts>
</Workflow>
