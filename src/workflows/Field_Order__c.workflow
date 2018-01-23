<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_customer_upon_Service_Application_Pre_Survey_FO_Disapproved</fullName>
        <description>Email to customer upon Service Application Pre-Survey FO Disapproved</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Service_Application_Pre_Survey_FO_Non_Feasible</template>
    </alerts>
    <alerts>
        <fullName>Email_to_customer_upon_Service_Application_Pre_Survey_FO_Scheduled</fullName>
        <description>Email to customer upon Service Application Pre-Survey FO Scheduled</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Service_Application_Application_Validated</template>
    </alerts>
    <alerts>
        <fullName>Email_to_customer_upon_Service_Application_Re_Inspection_FO_Disapproved</fullName>
        <description>Email to customer upon Service Application Re/Inspection FO Disapproved</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Service_Application_Re_Inspection_FO_DIsapproved</template>
    </alerts>
    <alerts>
        <fullName>Email_to_customer_upon_Service_Application_Re_Inspection_FO_Scheduled</fullName>
        <description>Email to customer upon Service Application Re/Inspection FO Scheduled</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Service_Application_Re_Inspection_FO_Scheduled</template>
    </alerts>
    <alerts>
        <fullName>Email_to_customer_upon_Service_Application_Survey_FO_Disapproved</fullName>
        <description>Email to customer upon Service Application Survey FO Disapproved</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@meralco.com.ph</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Service_Application_Pre_Survey_FO_Non_Feasible</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Status_Inspection_FO_Disapproved</fullName>
        <description>This automatically sets the Case Status to &apos;Inspection FO Resolved - Disapproved&apos;.</description>
        <field>Status</field>
        <literalValue>Inspection FO Resolved - Disapproved</literalValue>
        <name>Case Status: Inspection FO Disapproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Inspection_FO_Generated</fullName>
        <description>This automatically updates the Case status to &apos;Inspection FO Generated&apos;.</description>
        <field>Status</field>
        <literalValue>Inspection FO Generated</literalValue>
        <name>Case Status: Inspection FO Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Inspection_FO_Scheduled</fullName>
        <description>This automatically updates the Case status to &apos;Inspection FO Scheduled&apos; once meter delivery schedule date has been set.</description>
        <field>Status</field>
        <literalValue>Inspection FO Scheduled</literalValue>
        <name>Case Status: Inspection FO Scheduled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Meter_Delivery_FO_Generated</fullName>
        <description>This automatically updates the Case status to &apos;Meter Socket Delivery FO Generated&apos; once Meter Delivery FO has been created.</description>
        <field>Status</field>
        <literalValue>Meter Socket Delivery FO Generated</literalValue>
        <name>Case Status: Meter Delivery FO Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Meter_Delivery_FO_Scheduled</fullName>
        <description>This automatically updates the Case status to &apos;Meter Delivery FO Scheduled&apos; once  meter delivery schedule date has been set.</description>
        <field>Status</field>
        <literalValue>Meter Socket Delivery FO Scheduled</literalValue>
        <name>Case Status: Meter Delivery FO Scheduled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Meter_Socket_Delivered</fullName>
        <description>This automatically sets the Case Status to &apos;Meter Socket Delivered&apos;.</description>
        <field>Status</field>
        <literalValue>Meter Socket Delivered</literalValue>
        <name>Case Status: Meter Socket Delivered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Meter_Socket_Not_Delivered</fullName>
        <description>This automatically sets the Case Status to &apos;Meter Socket Delivered&apos;.</description>
        <field>Status</field>
        <literalValue>Meter Socket Not Delivered</literalValue>
        <name>Case Status: Meter Socket Not Delivered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Pre_Survey_FO_Generated</fullName>
        <description>This automatically updates the Case status to &apos;Pre-Survey FO Generated&apos; once Survey FO has been created.</description>
        <field>Status</field>
        <literalValue>Pre-Survey FO Generated</literalValue>
        <name>Case Status: Pre-Survey FO Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Pre_Survey_FO_Scheduled</fullName>
        <description>This automatically updates the Case status to &apos;Pre-Survey FO Scheduled&apos; once Survey FO&apos;s schedule date has been populated.</description>
        <field>Status</field>
        <literalValue>Pre-Survey FO Scheduled</literalValue>
        <name>Case Status: Pre-Survey FO Scheduled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Pre_survey_FO_Feasible</fullName>
        <description>This automatically sets the Case Status to &apos;Pre-Survey FO Resolved - Feasible&apos; once survey result has been set to &apos;Feasible&apos;.</description>
        <field>Status</field>
        <literalValue>Pre-Survey FO Resolved - Feasible</literalValue>
        <name>Case Status: Pre-survey FO Feasible</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Pre_survey_FO_Not_Feasible</fullName>
        <description>This automatically sets the Case Status to &apos;Pre-Survey FO Resolved - Feasible&apos; once survey result has been set to &apos;Not Feasible&apos;.</description>
        <field>Status</field>
        <literalValue>Pre-Survey FO Resolved - Not Feasible</literalValue>
        <name>Case Status: Pre-survey FO Not Feasible</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Inspection_FO_Approved</fullName>
        <description>This automatically sets the Case Status to &apos;Inspection FO Resolved - Approved&apos;.</description>
        <field>Status</field>
        <literalValue>Inspection FO Resolved - Approved</literalValue>
        <name>Case Status to Inspection FO Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Reinspection_FO_Generated</fullName>
        <description>This automatically updates the Case status to &apos;Re-inspection FO Generated&apos;.</description>
        <field>Status</field>
        <literalValue>Re-inspection FO Generated</literalValue>
        <name>Case Status to Reinspection FO Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Reinspection_FO_Scheduled</fullName>
        <description>This automatically updates the Case status to &apos;Re-inspection FO Scheduled&apos;.</description>
        <field>Status</field>
        <literalValue>Re-inspection FO Scheduled</literalValue>
        <name>Case Status to Reinspection FO Scheduled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_SA_s_Customer_Email_to_FO</fullName>
        <description>Copy SA&apos;s Customer Email to FO</description>
        <field>Customer_Email__c</field>
        <formula>Case__r.Email_Address__c</formula>
        <name>Copy SA&apos;s Customer Email to FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_FO</fullName>
        <field>Locked_Record__c</field>
        <literalValue>1</literalValue>
        <name>Lock FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upadte_Case_Status_4</fullName>
        <field>Status</field>
        <literalValue>Pre-Survey FO Resolved - Not Feasible</literalValue>
        <name>Upadte Case Status 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Actual_Survey_Date_on_Case</fullName>
        <field>Survey_Schedule_Date__c</field>
        <formula>Schedule_Date__c</formula>
        <name>Update Actual Survey Date on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_20</fullName>
        <description>Update Case Status to Re-Inspection Generated</description>
        <field>Status</field>
        <literalValue>Re-inspection FO Generated / Scheduled</literalValue>
        <name>Update Case 20</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_21</fullName>
        <description>Mark case as pending FO</description>
        <field>Number_of_Pending_FO__c</field>
        <formula>1</formula>
        <name>Update Case 21</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Pending_FO_number</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>1</formula>
        <name>Update Case Pending FO number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_Meter_Socket_NotDeliv</fullName>
        <field>Status</field>
        <literalValue>Meter Socket Not Delivered</literalValue>
        <name>Update Case Status Meter Socket NotDeliv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_to</fullName>
        <field>Status</field>
        <literalValue>Pre-Survey FO Generated</literalValue>
        <name>Update Case Status to Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_to_Preliminary_Survey</fullName>
        <description>Update Case Status to Preliminary Survey Scheduled</description>
        <field>Status</field>
        <literalValue>Pre-Survey FO Scheduled</literalValue>
        <name>Update Case Status to Preliminary Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FO_Email</fullName>
        <description>Updates the Email field on Field Order if FO is generated from New Service Application</description>
        <field>Customer_Email__c</field>
        <formula>Customer_Email__c</formula>
        <name>Update FO - Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FO_Person_Account</fullName>
        <field>Account_Name_text__c</field>
        <formula>Case__r.Parent.Parent.Account.Name</formula>
        <name>Update FO Person Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FO_Status_Executed</fullName>
        <field>Status__c</field>
        <literalValue>Executed</literalValue>
        <name>Update FO Status - Executed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FO_Status_In_Execution</fullName>
        <field>Status__c</field>
        <literalValue>In Execution</literalValue>
        <name>Update FO Status - In Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FO_Status_Scheduled</fullName>
        <field>Status__c</field>
        <literalValue>Scheduled</literalValue>
        <name>Update FO Status - Scheduled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FO_Survey_Schedule_Date</fullName>
        <field>Schedule_Date__c</field>
        <formula>Case__r.Survey_Schedule_Date__c</formula>
        <name>Update FO Survey Schedule Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Number_of_FO_4</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>0</formula>
        <name>Update Number of FO 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prior_Status_to_Inspection_Disapp</fullName>
        <description>Update Prior Status to Re/Inspection FO Disapproved (in order not to re-send e-mail alert when SA record is updated)</description>
        <field>Prior_Status__c</field>
        <formula>&quot;Inspection FO Resolved - Disapproved&quot;</formula>
        <name>Update Prior Status to Inspection Disapp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prior_Status_to_Inspection_Schedu</fullName>
        <description>Update Prior Status to Re/Inspection FO Scheduled (in order not to re-send e-mail alert when SA record is updated)</description>
        <field>Prior_Status__c</field>
        <formula>&quot;Inspection FO Scheduled&quot;</formula>
        <name>Update Prior Status to Inspection Schedu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prior_Status_to_Pre_Survey_Sched</fullName>
        <description>Update Prior Status to Pre-Survey FO Scheduled (in order not to re-send e-mail alert when SA record is updated)</description>
        <field>Prior_Status__c</field>
        <formula>&quot;Pre-Survey FO Scheduled&quot;</formula>
        <name>Update Prior Status to Pre-Survey Sched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Responsible_Office</fullName>
        <description>Update FO&apos;s responsible office</description>
        <field>Resp_Office__c</field>
        <formula>Case__r.Responsible_Office_Lookup__r.Name</formula>
        <name>Update Responsible Office</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Responsible_Office_WF</fullName>
        <field>Resp_Office__c</field>
        <formula>SUBSTITUTE(Case__r.Responsible_Office_Lookup__r.Name, &quot;BC (CC)&quot;, &quot;SRM&quot;)</formula>
        <name>Update Responsible Office</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_Inspection_Findings_from_FO</fullName>
        <description>Update Service Application&apos;s Inspection Findings from the FO</description>
        <field>Inspection_FO_Findings__c</field>
        <formula>IF(Ready_for_Connection__c = TRUE, &quot;- Ready for Connection.&quot; &amp; BR(), &quot;&quot;) &amp; IF(SE_Not_Installed_Yet__c = TRUE, &quot;- SE not installed yet.&quot; &amp; BR(), &quot;&quot;) &amp; IF(SE_Not_Compliant__c = TRUE, &quot;- SE not compliant.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Wrong_SE_Location__c = TRUE, &quot;- Wrong SE location&quot; &amp; BR(), &quot;&quot;)</formula>
        <name>Update SA Inspection Findings from FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_Inspection_Findings_in_FO</fullName>
        <description>Update Service Application&apos;s Inspection Findings in the FO</description>
        <field>Findings_in_Free_Text__c</field>
        <formula>IF(Ready_for_Connection__c = TRUE, &quot;- Ready for Connection.&quot; &amp; BR(), &quot;&quot;) &amp; IF(SE_Not_Installed_Yet__c = TRUE, &quot;- SE not installed yet.&quot; &amp; BR(), &quot;&quot;) &amp; IF(SE_Not_Compliant__c = TRUE, &quot;- SE not compliant.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Wrong_SE_Location__c = TRUE, &quot;- Wrong SE location&quot; &amp; BR(), &quot;&quot;)</formula>
        <name>Update SA Inspection Findings in FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_Meter_Socket_Findings_from_FO</fullName>
        <description>Update Service Application&apos;s Meter Socket Findings from the FO</description>
        <field>Meter_Socket_FO_Findings__c</field>
        <formula>IF(SE_Completion_Target_Negotiated__c = TRUE, &quot;- SE Completion target negotiated.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Contact_Person_Unreachable__c = TRUE, &quot;- Contact person unreachable.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Delivery_for_Reschedule__c = TRUE, &quot;- Delivery for reschedule.&quot; &amp; BR(), &quot;&quot;) &amp; IF(For_BC_Pickup__c = TRUE, &quot;- For BC pickup.&quot; &amp; BR(), &quot;&quot;)</formula>
        <name>Update SA Meter Socket Findings from FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_Meter_Socket_Findings_in_FO</fullName>
        <description>Update Service Application&apos;s Meter Socket Findings in the FO</description>
        <field>Findings_in_Free_Text__c</field>
        <formula>IF(SE_Completion_Target_Negotiated__c = TRUE, &quot;- SE Completion target negotiated.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Contact_Person_Unreachable__c = TRUE, &quot;- Contact person unreachable.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Delivery_for_Reschedule__c = TRUE, &quot;- Delivery for reschedule.&quot; &amp; BR(), &quot;&quot;) &amp; IF(For_BC_Pickup__c = TRUE, &quot;- For BC pickup.&quot; &amp; BR(), &quot;&quot;)</formula>
        <name>Update SA Meter Socket Findings in FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_Pre_Survey_Findings_from_FO</fullName>
        <description>Update Service Application&apos;s Pre-Survey Findings from the FO</description>
        <field>Pre_Survey_FO_Findings__c</field>
        <formula>IF(Additional_Documents_for_Evaluation_Requ__c = TRUE, &quot;- Additional documents for evaluation required.&quot; &amp; BR(), &quot;&quot;) &amp; IF(ROW_Grant_for_SE_Required__c = TRUE, &quot;- ROW Grant for SE required.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Inconsistent_SA_Data_Required__c = TRUE, &quot;- Inconsistent SA data.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Extensive_modifications_to_premises_requ__c = TRUE, &quot;- Extensive modifications to premises required.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Unable_to_Locate_Given_Address__c = TRUE, &quot;- Unable to locate given address.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Add_Distribution_Facilities_Required__c = TRUE, &quot;- Additional distribution facilities required.&quot; &amp; BR(), &quot;&quot;)</formula>
        <name>Update SA Pre-Survey Findings from FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_Pre_Survey_Findings_in_FO</fullName>
        <description>Update Service Application&apos;s Pre-Survey Findings in the FO</description>
        <field>Findings_in_Free_Text__c</field>
        <formula>IF(Additional_Documents_for_Evaluation_Requ__c = TRUE, &quot;- Additional documents for evaluation required.&quot; &amp; BR(), &quot;&quot;) &amp; IF(ROW_Grant_for_SE_Required__c = TRUE, &quot;- ROW Grant for SE required.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Inconsistent_SA_Data_Required__c = TRUE, &quot;- Inconsistent SA data.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Extensive_modifications_to_premises_requ__c = TRUE, &quot;- Extensive modifications to premises required.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Unable_to_Locate_Given_Address__c = TRUE, &quot;- Unable to locate given address.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Add_Distribution_Facilities_Required__c = TRUE, &quot;- Additional distribution facilities required.&quot; &amp; BR(), &quot;&quot;)</formula>
        <name>Update SA Pre-Survey Findings in FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_Re_Inspection_Findings_from_FO</fullName>
        <description>Update Service Application&apos;s Re-inspection Findings from the FO</description>
        <field>Re_inspection_FO_Findings__c</field>
        <formula>IF(Ready_for_Connection__c = TRUE, &quot;- Ready for Connection.&quot; &amp; BR(), &quot;&quot;) &amp; IF(SE_Not_Installed_Yet__c = TRUE, &quot;- SE not installed yet.&quot; &amp; BR(), &quot;&quot;) &amp; IF(SE_Not_Compliant__c = TRUE, &quot;- SE not compliant.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Wrong_SE_Location__c = TRUE, &quot;- Wrong SE location&quot; &amp; BR(), &quot;&quot;)</formula>
        <name>Update SA Re-Inspection Findings from FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_Re_Inspection_Findings_in_FO</fullName>
        <description>Update SA Re-Inspection Findings in FO</description>
        <field>Findings_in_Free_Text__c</field>
        <formula>IF(Ready_for_Connection__c = TRUE, &quot;- Ready for Connection.&quot; &amp; BR(), &quot;&quot;) &amp; IF(SE_Not_Installed_Yet__c = TRUE, &quot;- SE not installed yet.&quot; &amp; BR(), &quot;&quot;) &amp; IF(SE_Not_Compliant__c = TRUE, &quot;- SE not compliant.&quot; &amp; BR(), &quot;&quot;) &amp; IF(Wrong_SE_Location__c = TRUE, &quot;- Wrong SE location&quot; &amp; BR(), &quot;&quot;)</formula>
        <name>Update SA Re-Inspection Findings in FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_with_Pre_survey_Feasible_Date</fullName>
        <field>Pre_Survey_FO_Feasible_Resolution_Date__c</field>
        <formula>Resolution_Date__c</formula>
        <name>Update SA with Pre-survey Feasible Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_with_Pre_survey_Schedule_Date2</fullName>
        <field>Pre_survey_Schedule_Date__c</field>
        <formula>Schedule_Date__c</formula>
        <name>Update SA with Pre-survey Schedule Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_with_Re_Inspection_Resolution</fullName>
        <description>Update SA with Re/Inspection Resolution Remark</description>
        <field>Re_Inspection_FO_Resolution_Remarks__c</field>
        <formula>Resolution_Remarks__c</formula>
        <name>Update SA with Re/Inspection Resolution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SA_with_Survey_Feasible_Date_CXE</fullName>
        <field>Survey_Resolution_Date__c</field>
        <formula>Resolution_Date__c</formula>
        <name>Update SA with Survey Feasible Date CXE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>u100</fullName>
        <field>Change_Status_By_System_Trigger__c</field>
        <literalValue>1</literalValue>
        <name>u100</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Pending_FO_number_2</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>0</formula>
        <name>update Pending FO number 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_1</fullName>
        <field>Status</field>
        <literalValue>Meter Socket Delivery FO Generated</literalValue>
        <name>update case 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_10</fullName>
        <description>Update Case status to &quot;Inspection FO Generated&quot;</description>
        <field>Status</field>
        <literalValue>Inspection FO Generated</literalValue>
        <name>update case 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_11</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>1</formula>
        <name>update case 11</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_12</fullName>
        <field>Status</field>
        <literalValue>Inspection FO Scheduled</literalValue>
        <name>update case 12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_14</fullName>
        <field>Status</field>
        <literalValue>Inspection FO Resolved - Approved</literalValue>
        <name>update case 14</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_15</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>0</formula>
        <name>update case 15</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_16</fullName>
        <field>Status</field>
        <literalValue>Inspection FO Resolved - Disapproved</literalValue>
        <name>update case 16</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_17</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>0</formula>
        <name>update case 17</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_2</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>1</formula>
        <name>update case 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_25</fullName>
        <description>update case status to re-inspect scheduled</description>
        <field>Status</field>
        <literalValue>Re-inspection FO Scheduled</literalValue>
        <name>update case 25</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_26</fullName>
        <description>Update case status to re-inspection FO approved</description>
        <field>Status</field>
        <literalValue>Re-inspection FO Resolved - Approved</literalValue>
        <name>update case 26</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_27</fullName>
        <description>reset case No of Pending FO</description>
        <field>Number_of_Pending_FO__c</field>
        <formula>0</formula>
        <name>update case 27</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_28</fullName>
        <description>Update case status to re-inspect FO disapproved</description>
        <field>Status</field>
        <literalValue>Re-inspection FO Resolved - Disapproved</literalValue>
        <name>update case 28</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_3</fullName>
        <field>Status</field>
        <literalValue>Meter Socket Delivery FO Scheduled</literalValue>
        <name>update case 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_30</fullName>
        <description>reset case number pending FO</description>
        <field>Number_of_Pending_FO__c</field>
        <formula>0</formula>
        <name>update case 30</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_4</fullName>
        <field>Status</field>
        <literalValue>Meter Socket Delivery FO Delivered</literalValue>
        <name>update case 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_5</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>0</formula>
        <name>update case 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_6</fullName>
        <field>Status</field>
        <literalValue>Meter Socket Not Delivered</literalValue>
        <name>update case 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_7</fullName>
        <field>Number_of_Pending_FO__c</field>
        <formula>0</formula>
        <name>update case 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_99</fullName>
        <field>Change_Status_By_System_Trigger__c</field>
        <literalValue>1</literalValue>
        <name>update case 99</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_status_3</fullName>
        <field>Status</field>
        <literalValue>Pre-Survey FO Resolved - Feasible</literalValue>
        <name>update case status 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_flag</fullName>
        <field>Locked_Record__c</field>
        <literalValue>1</literalValue>
        <name>update_flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CXE_Copy SA%27s Customer Email to FO</fullName>
        <actions>
            <name>Update_FO_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copy Service Application&apos;s Customer Email to FO</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Lock_FO_Once_Resolved</fullName>
        <actions>
            <name>Lock_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This ensures that users will not be able to edit a Field Order if it is already resolved.</description>
        <formula>AND  (  OR (  $RecordType.DeveloperName = &quot;CXE_Inspection_FO&quot;, $RecordType.DeveloperName =  &quot;CXE_Meter_Socket_Delivery&quot;, $RecordType.DeveloperName = &quot;CXE_Re_Inspection_FO&quot;, $RecordType.DeveloperName = &quot;CXE_Survey_FO&quot;  ),   OR (  ispickval( Pre_Survey_Result__c ,&apos;Feasible&apos;),  ispickval(Pre_Survey_Result__c,&apos;Not Feasible&apos;),  ispickval( Inspection_Result__c ,&apos;Approved&apos;),  ispickval(Inspection_Result__c,&apos;Disapproved&apos;),  ispickval( Meter_Socket_Delivery__c ,&apos;Delivered&apos;),  ispickval(Meter_Socket_Delivery__c,&apos;Not Delivered&apos;),  ispickval( Re_Inspection_Result__c ,&apos;Approved&apos;),  ispickval(Re_Inspection_Result__c,&apos;Disapproved&apos;)  )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Survey_Schedule_Date_From_Case</fullName>
        <actions>
            <name>Update_FO_Survey_Schedule_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This shall automatically copy the Survey Schedule Date from the Case to the Survey Field Order.</description>
        <formula>AND( RecordType.DeveloperName = &quot;CXE_Survey_FO&quot;,  NOT(ISBLANK(Case__r.Survey_Schedule_Date__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Update Actual Survey Date on Case</fullName>
        <actions>
            <name>Update_Actual_Survey_Date_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(ISBLANK( Schedule_Date__c )), RecordType.DeveloperName  = &quot;CXE_Survey_FO&quot;, Case__r.RecordType.DeveloperName = &quot;New_Service_Application&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Update FO Status - Executed</fullName>
        <actions>
            <name>Update_FO_Status_Executed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Scheduled Date and Resolution Date is not empty, update FO Status to Executed.</description>
        <formula>NOT(ISBLANK(Schedule_Date__c)) &amp;&amp; NOT(ISBLANK(Resolution_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Update FO Status - In Execution</fullName>
        <actions>
            <name>Update_FO_Status_In_Execution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>if Scheduled Date on Field Order is Populated and Executing Personnel is not empty, update FO Status to In Execution.</description>
        <formula>NOT(ISBLANK(Schedule_Date__c))&amp;&amp;  ISBLANK(Resolution_Date__c) &amp;&amp;  NOT(ISBLANK(Executing_Personnel_FO__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Update FO Status - Scheduled</fullName>
        <actions>
            <name>Update_FO_Status_Scheduled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>if Scheduled Date on Field Order is Populated, update FO Status</description>
        <formula>NOT(ISBLANK(Schedule_Date__c))&amp;&amp;  ISBLANK(Resolution_Date__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CXE_Update SA with Survey Resolution Date</fullName>
        <actions>
            <name>Update_SA_with_Survey_Feasible_Date_CXE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Order__c.Resolution_Date__c</field>
            <operation>greaterThan</operation>
            <value>1/1/2001</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Survey FO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.Pre_Survey_Result__c</field>
            <operation>equals</operation>
            <value>Feasible</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>New Service Application</value>
        </criteriaItems>
        <description>Update the Survey Resolution Date on related Case if Survey FO result is &quot;feasible&quot; and Survey FO resolution date is greater than 1/1/2001.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy SA%27s Customer Email to FO</fullName>
        <actions>
            <name>Copy_SA_s_Customer_Email_to_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copy Service Application&apos;s Customer Email to FO</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy SA%27s Customer Email to FO_CXE</fullName>
        <actions>
            <name>Update_FO_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copy Service Application&apos;s Customer Email to FO</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email customer when SA status %3D Pre-Survey FO Non-Feasible</fullName>
        <actions>
            <name>Email_to_customer_upon_Service_Application_Pre_Survey_FO_Disapproved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Field_Order__c.Pre_Survey_Result__c</field>
            <operation>equals</operation>
            <value>Not Feasible</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Prior_Status__c</field>
            <operation>notEqual</operation>
            <value>Pre-Survey FO Resolved - Not Feasible</value>
        </criteriaItems>
        <description>E-mail customer when 1) Case status = Pre-Survey FO Not-Feasible, AND 2) Email is not empty</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email customer when SA status %3D Pre-Survey FO Scheduled</fullName>
        <actions>
            <name>Email_to_customer_upon_Service_Application_Pre_Survey_FO_Scheduled</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Prior_Status_to_Pre_Survey_Sched</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>E-mail customer when 1) Case status = Pre-Survey FO Scheduled AND 2) Email is not empty</description>
        <formula>AND(  RecordType.Name  = &apos;Pre-Survey FO&apos;, NOT(ISNULL(Case__r.Email_Address__c)), ISCHANGED(  Schedule_Date__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email customer when SA status %3D Re%2FInspection FO Disapproved</fullName>
        <actions>
            <name>Email_to_customer_upon_Service_Application_Re_Inspection_FO_Disapproved</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Prior_Status_to_Inspection_Disapp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Field_Order__c.Inspection_Result__c</field>
            <operation>equals</operation>
            <value>Disapproved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.Re_Inspection_Result__c</field>
            <operation>equals</operation>
            <value>Disapproved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inspection FO,Re-Inspection FO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Prior_Status__c</field>
            <operation>notEqual</operation>
            <value>Inspection FO Resolved - Disapproved</value>
        </criteriaItems>
        <description>E-mail customer when 1) Field Order Schedule Date is set, AND 2) Email is not empty</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email customer when SA status %3D Re%2FInspection FO Scheduled</fullName>
        <actions>
            <name>Email_to_customer_upon_Service_Application_Re_Inspection_FO_Scheduled</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Prior_Status_to_Inspection_Schedu</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inspection FO,Re-Inspection FO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.Schedule_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Prior_Status__c</field>
            <operation>notEqual</operation>
            <value>Inspection FO Scheduled</value>
        </criteriaItems>
        <description>E-mail customer when 1) Field Order Schedule Date is set, AND 2) Email is not empty</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Inspection FO Generated</fullName>
        <actions>
            <name>Case_Status_Inspection_FO_Generated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inspection FO</value>
        </criteriaItems>
        <description>This automatically sets the Case Status to &apos;Inspection FO Generated&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Inspection FO Resolved - Approved</fullName>
        <actions>
            <name>Case_Status_to_Inspection_FO_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Inspection FO Resolved - Approved&apos;.</description>
        <formula>RecordTypeId = &quot;01228000000TYV6&quot; &amp;&amp; ISPICKVAL(Inspection_Result__c, &quot;Approved&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Inspection FO Resolved - Disapproved</fullName>
        <actions>
            <name>Case_Status_Inspection_FO_Disapproved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Inspection FO Resolved - Disapproved&apos;.</description>
        <formula>RecordTypeId = &quot;01228000000TYV6&quot; &amp;&amp; ISPICKVAL(Inspection_Result__c, &quot;Disapproved&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Inspection FO Scheduled</fullName>
        <actions>
            <name>Case_Status_Inspection_FO_Scheduled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Inspection FO Scheduled&apos; once meter delivery date has been set.</description>
        <formula>RecordTypeId = &quot;01228000000TYV6&quot; &amp;&amp;    NOT(ISBLANK(Schedule_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Meter Socket Delivered</fullName>
        <actions>
            <name>Case_Status_Meter_Socket_Delivered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Meter Socket Delivered&apos;.</description>
        <formula>$RecordType.DeveloperName = &quot;CXE_Meter_Socket_Delivery&quot; &amp;&amp; ISPICKVAL(Meter_Socket_Delivery__c, &quot;Delivered&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Meter Socket Delivery FO Generated</fullName>
        <actions>
            <name>Case_Status_Meter_Delivery_FO_Generated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Meter Socket Delivery FO Generated&apos;.</description>
        <formula>$RecordType.DeveloperName = &quot;CXE_Meter_Socket_Delivery&quot; &amp;&amp;  ISPICKVAL( Status__c , &quot;Generated&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Meter Socket Delivery FO Scheduled</fullName>
        <actions>
            <name>Case_Status_Meter_Delivery_FO_Scheduled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Meter Delivery FO Scheduled&apos; once meter delivery date has been set.</description>
        <formula>$RecordType.DeveloperName = &quot;CXE_Meter_Socket_Delivery&quot; &amp;&amp; ISPICKVAL( Status__c , &quot;Scheduled&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Meter Socket Not Delivered</fullName>
        <actions>
            <name>Case_Status_Meter_Socket_Not_Delivered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Meter Socket Not Delivered&apos;.</description>
        <formula>$RecordType.DeveloperName = &quot;CXE_Meter_Socket_Delivery&quot;  &amp;&amp; ISPICKVAL(Meter_Socket_Delivery__c, &quot;Not Delivered&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Pre-survey FO Generated</fullName>
        <actions>
            <name>Case_Status_Pre_Survey_FO_Generated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Survey FO</value>
        </criteriaItems>
        <description>This automatically sets the Case Status to &apos;Pre-Survey FO Generated&apos; once a Pre-Survey FO has been generated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Pre-survey FO Resolved - Feasible</fullName>
        <actions>
            <name>Case_Status_Pre_survey_FO_Feasible</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Pre-Survey FO Resolved - Feasible&apos; once FO&apos;s result has been set to &apos;Feasible&apos;.</description>
        <formula>RecordTypeId = &quot;01228000000TYV8&quot; &amp;&amp; ISPICKVAL(Pre_Survey_Result__c, &quot;Feasible&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Pre-survey FO Resolved - Not Feasible</fullName>
        <actions>
            <name>Case_Status_Pre_survey_FO_Not_Feasible</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Pre-survey FO Resolved - Not Feasible&apos; once FO&apos;s result has been set to &apos;Not Feasible&apos;.</description>
        <formula>RecordTypeId = &quot;01228000000TYV8&quot; &amp;&amp; ISPICKVAL(Pre_Survey_Result__c, &quot;Not Feasible&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Pre-survey FO Scheduled</fullName>
        <actions>
            <name>Case_Status_Pre_Survey_FO_Scheduled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Pre-Survey FO Scheduled&apos; once a Pre-Survey FO&apos;s Schedule Date has been populated.</description>
        <formula>RecordTypeId = &quot;01228000000TYV8&quot; &amp;&amp;    NOT(ISBLANK(Schedule_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Re-inspection FO Generated</fullName>
        <actions>
            <name>Case_Status_to_Reinspection_FO_Generated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Re-Inspection FO</value>
        </criteriaItems>
        <description>This automatically sets the Case Status to &apos;Re-inspection FO Generated&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Status to Re-inspection FO Scheduled</fullName>
        <actions>
            <name>Case_Status_to_Reinspection_FO_Scheduled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This automatically sets the Case Status to &apos;Re-inspection FO Scheduled&apos;.</description>
        <formula>RecordTypeId = &quot;01228000000TYV9&quot; &amp;&amp;    NOT(ISBLANK(Schedule_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Actual Survey Date on Case_CXE</fullName>
        <actions>
            <name>Update_Actual_Survey_Date_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Schedule_Date__c )) &amp;&amp; $RecordType.DeveloperName = &quot;CXE_Survey_FO&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update FO Status - Executed_CXE</fullName>
        <actions>
            <name>Update_FO_Status_Executed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Scheduled Date and Resolution Date is not empty, update FO Status to Executed.</description>
        <formula>NOT(ISBLANK(Schedule_Date__c)) &amp;&amp; NOT(ISBLANK(Resolution_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update FO Status - In Execution_CXE</fullName>
        <actions>
            <name>Update_FO_Status_In_Execution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>if Scheduled Date on Field Order is Populated and Executing Personnel is not empty, update FO Status to In Execution.</description>
        <formula>NOT(ISBLANK(Schedule_Date__c))&amp;&amp;  ISBLANK(Resolution_Date__c) &amp;&amp;  NOT(ISPICKVAL(Executing_Personnel_Name__c, &quot;&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update FO Status - Scheduled_CXE</fullName>
        <actions>
            <name>Update_FO_Status_Scheduled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>if Scheduled Date on Field Order is Populated, update FO Status</description>
        <formula>NOT(ISBLANK(Schedule_Date__c))&amp;&amp;  ISBLANK(Resolution_Date__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update SA with Inspection Findings</fullName>
        <actions>
            <name>Update_SA_Inspection_Findings_from_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SA_Inspection_Findings_in_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inspection FO</value>
        </criteriaItems>
        <description>Update Service Application with Inspection Findings</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update SA with Meter Socket Findings</fullName>
        <actions>
            <name>Update_SA_Meter_Socket_Findings_from_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SA_Meter_Socket_Findings_in_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Meter Socket Delivery FO</value>
        </criteriaItems>
        <description>Update Service Application with Meter Socket Findings</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update SA with Pre-Survey Findings</fullName>
        <actions>
            <name>Update_SA_Pre_Survey_Findings_from_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SA_Pre_Survey_Findings_in_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pre-Survey FO</value>
        </criteriaItems>
        <description>Update Service Application with Pre-Survey Findings</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update SA with Pre-survey Resolution Date</fullName>
        <actions>
            <name>Update_SA_with_Pre_survey_Feasible_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Field_Order__c.Resolution_Date__c</field>
            <operation>greaterThan</operation>
            <value>1/1/2001</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pre-Survey FO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.Pre_Survey_Result__c</field>
            <operation>equals</operation>
            <value>Feasible</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update SA with Pre-survey Schedule Date</fullName>
        <actions>
            <name>Update_SA_with_Pre_survey_Schedule_Date2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Field_Order__c.Schedule_Date__c</field>
            <operation>greaterThan</operation>
            <value>1/1/2001</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pre-Survey FO</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update SA with Re%2FInspection Resolution Remark</fullName>
        <actions>
            <name>Update_SA_with_Re_Inspection_Resolution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inspection FO,Re-Inspection FO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.Resolution_Remarks__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update SA with Re/Inspection Resolution Remark</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update SA with Re-Inspection Findings</fullName>
        <actions>
            <name>Update_SA_Re_Inspection_Findings_from_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SA_Re_Inspection_Findings_in_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Re-Inspection FO</value>
        </criteriaItems>
        <description>Update Service Application with Re-inspection Findings</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update SA with Survey Resolution Date_CXE</fullName>
        <actions>
            <name>Update_SA_with_Survey_Feasible_Date_CXE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Order__c.Resolution_Date__c</field>
            <operation>greaterThan</operation>
            <value>1/1/2001</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Survey FO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Order__c.Pre_Survey_Result__c</field>
            <operation>equals</operation>
            <value>Feasible</value>
        </criteriaItems>
        <description>Update the Survey Resolution Date on related Case if Survey FO result is &quot;feasible&quot; and Survey FO resolution date is greater than 1/1/2001.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>lock_record_once_its_resovled</fullName>
        <actions>
            <name>update_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND  (  OR (  $RecordType.DeveloperName = &quot;CXE_Inspection_FO&quot;, $RecordType.DeveloperName =  &quot;CXE_Meter_Socket_Delivery&quot;, $RecordType.DeveloperName = &quot;CXE_Re_Inspection_FO&quot;, $RecordType.DeveloperName = &quot;CXE_Survey_FO&quot;  ),   OR (  ispickval( Pre_Survey_Result__c ,&apos;Feasible&apos;),  ispickval(Pre_Survey_Result__c,&apos;Not Feasible&apos;),  ispickval( Inspection_Result__c ,&apos;Approved&apos;),  ispickval(Inspection_Result__c,&apos;Disapproved&apos;),  ispickval( Meter_Socket_Delivery__c ,&apos;Delivered&apos;),  ispickval(Meter_Socket_Delivery__c,&apos;Not Delivered&apos;),  ispickval( Re_Inspection_Result__c ,&apos;Approved&apos;),  ispickval(Re_Inspection_Result__c,&apos;Disapproved&apos;)  )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
