<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CXE_APA_Set_isForPurging_to_True</fullName>
        <field>CXE_isForPurging__c</field>
        <literalValue>1</literalValue>
        <name>CXE APA Set isForPurging to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CXE Schedule Record For Purging</fullName>
        <active>true</active>
        <formula>ISPICKVAL(Status__c, &apos;Downloaded&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CXE_APA_Set_isForPurging_to_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Auto_Payment_Arrangement__c.Last_Downloaded_Time__c</offsetFromField>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
