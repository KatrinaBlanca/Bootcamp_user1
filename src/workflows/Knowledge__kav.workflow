<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FAQs_Rejection_Email</fullName>
        <description>Knowledge Article Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CXE_Email_Templates/FAQs_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Knowledge_Article_Approved</fullName>
        <description>Knowledge Article Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Knowledge_Article_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Uncheck_Submit_Checkbox</fullName>
        <description>Uncheck submit checkbox in article</description>
        <field>Submit_Article__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Submit Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish</fullName>
        <action>Publish</action>
        <label>Publish</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
</Workflow>
