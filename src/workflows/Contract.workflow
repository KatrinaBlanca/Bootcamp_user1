<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Non_Disconnectable_Tagging_Approval_Email</fullName>
        <description>Non-Disconnectable Tagging Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CXE_Email_Templates/Non_Disconnectable_Tagging_Approval</template>
    </alerts>
    <alerts>
        <fullName>Non_Disconnectable_Tagging_Rejection_Email</fullName>
        <description>Non-Disconnectable Tagging Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CXE_Email_Templates/Non_Disconnectable_Tagging_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Non_Disconnectable_Tagging_to_True</fullName>
        <field>Non_Disconnectable__c</field>
        <literalValue>1</literalValue>
        <name>Set Non-Disconnectable Tagging to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Associate to Case Account</fullName>
        <active>false</active>
        <description>Associate contract to the case&apos;s account</description>
        <formula>ContractNumber  &lt;&gt; NULL</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
