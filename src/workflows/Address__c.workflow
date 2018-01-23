<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Integ_V10_Outbound_Message</fullName>
        <description>This will be updated if the Case Status is Contract Finalized, Application Ready for Connection, Pending Energization and every time Service Address is created.</description>
        <field>Integ_V10_Outbound_Message_Send_Date__c</field>
        <formula>Now()</formula>
        <name>V10_Outbound Message</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CXE Address Service Application %28Application Approved%29</fullName>
        <actions>
            <name>Integ_V10_Outbound_Message</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Multi_Meter</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>This will send Outbound Message to Castiron if the case Status is Contract Finalized and Service address is created</description>
        <formula>(ISPICKVAL(Service__r.Case__r.Status,&apos;Contract Finalized&apos;)  || ISPICKVAL(Service__r.Case__r.Status,&apos;Application Ready for Connection&apos;) || ISPICKVAL(Service__r.Case__r.Status,&apos;Pending Energization&apos;) )  &amp;&amp; ISPICKVAL(Type__c, &apos;Service&apos;)  &amp;&amp; Service__c &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CXE Address Service Application_retriggered</fullName>
        <active>true</active>
        <description>This will retrigger Outbound Message to Castiron if the outboand failed (CSM-1331)</description>
        <formula>AND(Integ_V10_Create_Status__c == &quot;F&quot;, CONTAINS( Integ_V10_Create_Status_Description__c , &apos;Service Unavailable&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Multi_Meter</name>
                <type>OutboundMessage</type>
            </actions>
            <offsetFromField>Address__c.Integ_V10_Retrigger_time_5min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CXE Address Service Application_retriggered1</fullName>
        <active>false</active>
        <description>This will retrigger Outbound Message to Castiron if the outboand failed (CSM-1331)</description>
        <formula>AND(Integ_V10_Create_Status__c == &quot;F&quot;, CONTAINS( Integ_V10_Create_Status_Description__c , &apos;Service Unavailable&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
