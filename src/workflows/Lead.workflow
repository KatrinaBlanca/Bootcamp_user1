<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Address_from_Lead_Concat</fullName>
        <field>Address_from_Lead__c</field>
        <formula>Street_No__c &amp; &apos; &apos; &amp; Unit_No__c &amp; &apos; &apos; &amp; Street_Name__c &amp; &apos; &apos; &amp; Subdivision__c &amp; &apos; &apos; &amp; Barangay__c &amp; &apos; &apos; &amp; TEXT(City_Municipality__c) &amp; &apos; &apos; &amp; TEXT(Province__c)</formula>
        <name>Address from Lead Concat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Address from Lead Concat</fullName>
        <actions>
            <name>Address_from_Lead_Concat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Concatenation of House No + Unit No + Street Name Subdivision + Barangay + City + Province</description>
        <formula>OR ( ISNEW(), ISCHANGED( City_Municipality__c ), ISCHANGED( Province__c ), ISCHANGED( Subdivision__c ), ISCHANGED( Barangay__c ), ISCHANGED( Street_Name__c ), ISCHANGED( Street_No__c ), ISCHANGED( Unit_No__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
