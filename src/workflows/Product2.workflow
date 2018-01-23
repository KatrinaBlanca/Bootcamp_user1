<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Uncheck_Active_Product</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Uncheck Active Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Active_Field</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Update Active Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Archived Product cannot be Active</fullName>
        <actions>
            <name>Uncheck_Active_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Archived_Product__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Commerical Product End Date</fullName>
        <actions>
            <name>Update_Active_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>End_Date__c &lt;  TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
