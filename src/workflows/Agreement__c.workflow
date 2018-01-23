<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CXE_Calculate_Contracted_Capacity</fullName>
        <field>Contracted_Capacity__c</field>
        <formula>Applied_Load__c *  Demand_Factor__c</formula>
        <name>CXE Calculate Contracted Capacity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CXE_Update_Demand_Factor</fullName>
        <field>Demand_Factor__c</field>
        <formula>PSIC__r.Demand_Factor__c</formula>
        <name>CXE Update Demand Factor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CXE_Update_Load_Factor</fullName>
        <field>Load_Factor__c</field>
        <formula>PSIC__r.Load_Factor__c</formula>
        <name>CXE Update Load Factor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Email</fullName>
        <field>Case_Email__c</field>
        <formula>Case__r.Email_Address__c</formula>
        <name>Update Service Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Email_Business</fullName>
        <field>Case_Email__c</field>
        <formula>Case__r.Business_Email__c</formula>
        <name>Update Service Email_Business</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Email_Individual</fullName>
        <field>Case_Email__c</field>
        <formula>Case__r.Individual_Email__c</formula>
        <name>Update Service Email_Individual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CXE Service Calculate Contracted Capacity</fullName>
        <actions>
            <name>CXE_Calculate_Contracted_Capacity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculate Contracted Capacity based on the selected PSIC&apos;s Demand Factor and Applied Load</description>
        <formula>AND(NOT(ISNULL( PSIC__c )),  NOT(ISNULL( Applied_Load__c )),  NOT(ISNULL( PSIC__r.Demand_Factor__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE Service Update Demand Factor from PSIC</fullName>
        <actions>
            <name>CXE_Update_Demand_Factor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Service Demand Factor value based on selected PSIC&apos;s Demand Factor.</description>
        <formula>NOT(ISNULL( PSIC__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE Service Update Load Factor from PSIC</fullName>
        <actions>
            <name>CXE_Update_Load_Factor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Service Load Factor value based on selected PSIC&apos;s Load Factor.</description>
        <formula>NOT(ISNULL( PSIC__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Update Service Email</fullName>
        <actions>
            <name>Update_Service_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Service Email with Case email</description>
        <formula>NOT( ISBLANK(Case__r.Email_Address__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Update Service Email Business</fullName>
        <actions>
            <name>Update_Service_Email_Business</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Service Email with Case email</description>
        <formula>NOT(ISBLANK( Case__r.Business_Email__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Update Service Email Individual</fullName>
        <actions>
            <name>Update_Service_Email_Individual</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Service Email with Case email</description>
        <formula>NOT(ISBLANK( Case__r.Individual_Email__c  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
