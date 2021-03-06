-- DML TO RUN FROM MSSQL DBMS
-- Populates RAW Data to Mysql linked/staging database already created 
-- Run Second
-- Staging Database Scripts to populate DDL scripts created from MySQL 
-- Staging Database Scripts to RUN after running the DDLs in Mysql
-- 1. Demographics/Registration  DML

exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY (IQCARE_OPENMRS, 'SELECT Person_Id, First_Name, Middle_Name, Last_Name, Nickname, DOB, Exact_DOB, Sex, UPN, Encounter_Date, Encounter_ID, National_id_no, Patient_clinic_number
, Birth_certificate, Birth_notification, Hei_no, Passport, Alien_Registration, Phone_number, Alternate_Phone_number,
Postal_Address,Email_Address, County, Sub_county, Ward,Village, Landmark, Nearest_Health_Centre, Next_of_kin, Next_of_kin_phone, Next_of_kin_relationship
, Next_of_kin_address, Marital_Status, Occupation, Education_level, Dead, Death_date, Consent, Consent_decline_reason, voided FROM migration_st.st_demographics')

SELECT distinct
  P.Id as Person_Id,
  CAST(DECRYPTBYKEY(P.FirstName) AS VARCHAR(50)) AS First_Name,
  CAST(DECRYPTBYKEY(P.MidName) AS VARCHAR(50)) AS Middle_Name,
  CAST(DECRYPTBYKEY(P.LastName) AS VARCHAR(50)) AS Last_Name,
  CAST(DECRYPTBYKEY(P.NickName) AS VARCHAR(50)) AS Nickname,
format(cast(ISNULL(P.DateOfBirth, PT.DateOfBirth) as date),'yyyy-MM-dd') AS DOB,
 NULL Exact_DOB,
  Sex = (SELECT (case when ItemName = 'Female' then 'F' when ItemName = 'Male' then 'M' else '' end) FROM LookupItemView WHERE MasterName = 'GENDER' AND ItemId = P.Sex),
  UPN =(select top 1 pdd.IdentifierValue from (select pid.PatientId,pid.IdentifierTypeId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag from PatientIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Patient')pdd on pdd.Id=pid.IdentifierTypeId  ) pdd where pdd.PatientId = PT.Id and pdd.[Code]='CCCNumber' and pdd.DeleteFlag=0 order by pdd.CreateDate desc ),
 format(cast(PT.RegistrationDate as date),'yyyy-MM-dd') AS Encounter_Date,
  NULL Encounter_ID,
  National_id_No =(select top 1 pdd.IdentifierValue from (select pid.PersonId,pid.IdentifierId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name] from PersonIdentifier pid
inner join (
select id.Id,id.[Name] as [Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Person')pdd on pdd.Id=pid.IdentifierId ) pdd where pdd.PersonId = P.Id and pdd.[Name]='NationalID'),
 Patient_clinic_number=(select top 1 pdd.IdentifierValue from (select pid.PatientId,pid.IdentifierTypeId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag from PatientIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Patient')pdd on pdd.Id=pid.IdentifierTypeId  ) pdd where pdd.PatientId = PT.Id and pdd.[Code]='CCCNumber' and pdd.DeleteFlag=0 order by pdd.CreateDate desc ),
  
  Birth_certificate=(select top 1 pdd.IdentifierValue from (select pid.PersonId,pid.IdentifierId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag from PersonIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Person')pdd on pdd.Id=pid.IdentifierId  ) pdd where pdd.PersonId = P.Id and pdd.[Name]='BirthCertificate' and pdd.DeleteFlag=0 order by pdd.CreateDate desc),
Birth_notification=(select top 1 pdd.IdentifierValue from (select pid.PersonId,pid.IdentifierId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag from PersonIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Person')pdd on pdd.Id=pid.IdentifierId  ) pdd where pdd.PersonId = P.Id and pdd.[Name]='BirthNotification' and pdd.DeleteFlag=0 order by pdd.CreateDate desc),
Hei_no=(select top 1 pdd.IdentifierValue from (select pid.PatientId,pid.IdentifierTypeId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag from PatientIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Patient')pdd on pdd.Id=pid.IdentifierTypeId  ) pdd where pdd.PatientId = PT.Id and pdd.[Code]='HEIRegistration' and pdd.DeleteFlag=0 order by pdd.CreateDate desc ),
Passport=(select top 1 pdd.IdentifierValue from (select pid.PersonId,pid.IdentifierId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag from PersonIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Person')pdd on pdd.Id=pid.IdentifierId  ) pdd where pdd.PersonId = P.Id and pdd.[Name]='Passport' and pdd.DeleteFlag=0 order by pdd.CreateDate desc),
Alien_Registration=(select top 1 pdd.IdentifierValue from (select pid.PersonId,pid.IdentifierId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag from PersonIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Person')pdd on pdd.Id=pid.IdentifierId  ) pdd where pdd.PersonId = P.Id and pdd.[Name]='AlienRegistration' and pdd.DeleteFlag=0 order by pdd.CreateDate desc),
pcv.MobileNumber as Phone_number,
pcv.AlternativeNumber as Alternate_Phone_number,
pcv.PhysicalAddress as Postal_Address,
pcv.EmailAddress as EmailAddress,
 County = (SELECT TOP 1 CountyName FROM County WHERE CountyId = PL.County),
 Sub_county=(select TOP 1 Subcountyname from County where  SubcountyId=PL.SubCounty),
 Ward=(SELECT TOP 1 WardName from County where WardId=PL.Ward),
 PL.Village as Village,
 PL.LandMark as LandMark,
 PL.NearestHealthCentre as Nearest_Health_Centre,
 ts.Next_of_kin,
 ts.Next_of_kin_phone,
  ts.Next_of_kin_relationship,
 ts.Next_of_kin_address,

 MaritalStatus = (SELECT TOP 1 ItemName FROM LookupItemView WHERE ItemId = PM.MaritalStatusId AND MasterName = 'MaritalStatus'),
 Occupation = (SELECT TOP 1 ItemName FROM LookupItemView WHERE ItemId = PO.Occupation AND MasterName = 'Occupation'),
Education_level = (SELECT TOP 1 ItemName FROM LookupItemView WHERE ItemId = PED.EducationLevel AND MasterName = 'EducationalLevel'),
pend.Dead,
pend.DateOfDeath as Death_date,
ts.Consent,
ts.Consent_Decline_Reason,
P.DeleteFlag as Voided 
 -- into PatientDemographics
FROM Person P
  left JOIN (select * from (select * ,ROW_NUMBER() OVER(partition by PersonId order by CreateDate desc)rownum from PersonLocation where (DeleteFlag =0 or DeleteFlag is null))PLL where PLL.rownum='1') PL ON PL.PersonId = P.Id
  INNER JOIN Patient PT ON PT.PersonId = P.Id
  LEFT JOin PersonContactView pcv on pcv.PersonId=P.Id
 LEFT JOIN( select t.PersonId,t.SupporterId,t.Next_of_kin,t.Next_of_kin_phone,t.Next_of_kin_relationship,t.Next_of_kin_address,t.Consent,t.Consent_Decline_Reason from (select  pts.PersonId ,pts.SupporterId,(pt.FirstName + ' ' + pt.MiddleName + ' '  + pt.LastName) as Next_of_kin,pts.ContactCategory,pts.ContactRelationship,lts.DisplayName as Next_of_kin_relationship 
 ,pts.MobileContact as Next_of_kin_phone,pcv.PhysicalAddress as [Next_of_kin_address],pcc.Consent,pcc.Consent_Decline_Reason
,pts.CreateDate ,ROW_NUMBER() OVER(Partition by   pts.PersonId order by pts.CreateDate desc)rownum  from PatientTreatmentSupporter pts
inner join PersonView p  on pts.PersonId=p.Id
inner join PersonView pt on pt.Id=pts.SupporterId
inner join PersonContactView pcv on pcv.PersonId=pts.SupporterId
inner join LookupItemView lt on lt.ItemId=pts.ContactCategory and lt.MasterName='ContactCategory'
inner join LookupItemView lts on lts.ItemId=pts.ContactRelationship and lts.MasterName='KinRelationship'
left join(select pc.PatientId,pc.PersonId,pc.ConsentValue,lt.DisplayName as Consent,pc.[Comments] as [Consent_Decline_Reason] from PatientConsent pc
inner join LookupItem lt on lt.Id=pc.ConsentValue) pcc on pcc.PersonId=pts.SupporterId
where lt.ItemName  in ('NextofKin','EmergencyContact')) t where t.rownum='1')ts on ts.PersonId= P.Id
LEFT JOIN PatientMaritalStatus PM ON PM.PersonId = P.Id
LEFT JOIN PersonEducation PED ON PED.PersonId = P.Id
LEFT JOIN PersonOccupation PO ON PO.PersonId = P.Id
LEFT JOIN( select pend.PatientId,pend.DateOfDeath, CASE WHEN pend.ExitDate is not null then 'Yes' else 'No' end as Dead from (select pce.PatientId,CASE WHEN pce.DateOfDeath is null then pce.ExitDate else pce.DateOfDeath end as DateOfDeath,pce.ExitReason a,pce.ExitDate,lt.DisplayName,ROW_NUMBER() OVER(partition by pce.PatientId order by pce.CreateDate desc)rownum from PatientCareending  pce
inner join  LookupItemView lt on lt.ItemId=pce.ExitReason and lt.MasterName='CareEnded'
where lt.ItemName='Death'
)pend where pend.rownum='1')pend on pend.PatientId=PT.Id
-- -----------------------------2. HIV Enrollment DML ---------------------------------------------
exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY (IQCARE_OPENMRS, 'SELECT Person_Id, UPN, Encounter_Date, Encounter_ID, Patient_Type,Entry_Point,TI_Facility,Date_first_enrolled_in_care,
Transfer_in_date,Date_started_art_at_transferring_facility,Date_confirmed_hiv_positive,
Facility_confirmed_hiv_positive,Baseline_arv_use,Purpose_of_baseline_arv_use,
Baseline_arv_regimen,Baseline_arv_regimen_line,
Baseline_arv_date_last_used,
Baseline_who_stage,
Baseline_cd4_results,
Baseline_cd4_date,
Baseline_vl_results,
Baseline_vl_date,
Baseline_vl_ldl_results,
Baseline_vl_ldl_date,
Baseline_HBV_Infected,
Baseline_TB_Infected,
Baseline_Pregnant,
Baseline_Breastfeeding,
Baseline_Weight,
Baseline_Height,
Baseline_BMI,
Name_of_treatment_supporter,
Relationship_of_treatment_supporter,
Treatment_supporter_telephone,
Treatment_supporter_address,
voided
 FROM migration_st.st_hiv_enrollment')

SELECT
  P.Id as Person_Id, 
 UPN =(select top 1 pdd.IdentifierValue from (select pid.PatientId,pid.IdentifierTypeId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag from PatientIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Patient')pdd on pdd.Id=pid.IdentifierTypeId  ) pdd where pdd.PatientId = PT.Id and pdd.[Code]='CCCNumber' and pdd.DeleteFlag=0 order by pdd.CreateDate desc ),
  format(cast(PE.EnrollmentDate as date),'yyyy-MM-dd') AS Encounter_Date,
  NULL Encounter_ID,
  PatientType=(select itemName from LookupItemView where MasterName='PatientType' and itemId=PT.PatientType),
  ent.Entry_point, 
  pti.FacilityFrom AS TI_Facility,
  PE.EnrollmentDate as Date_First_enrolled_in_care,
  bas.TransferInDate as Transfer_In_Date,
  bas.ARTInitiationDate as Date_started_art_at_transferring_facility,
  bas.HIVDiagnosisDate as Date_Confirmed_hiv_positive,
  bas.FacilityFrom as Facility_confirmed_hiv_positive,
  bas.HistoryARTUse as Baseline_arv_use,
  parv.Purpose  as Purpose_of_Baseline_arv_use, 
  bas.CurrentTreatmentName as Baseline_arv_regimen,
  bas.RegimenName as Baseline_arv_regimen_line,
  parv.DateLastUsed as Baseline_arv_date_last_used,
  bas.EnrollmentWHOStageName as Baseline_who_stage,
  bas.CD4Count as Baseline_cd4_results,
  bas.EnrollmentDate as Baseline_cd4_date,
  bas.BaselineViralload as Baseline_vl_results,
  bas.BaselineViralloadDate as Baseline_vl_date,
  NULL as Baseline_vl_ldl_results,
  NULL as Baseline_vl_ldl_date,
  bas.HBVInfected  as Baseline_HBV_Infected,
  bas.TBinfected as Baseline_TB_Infected,
  bas.Pregnant as Baseline_Pregnant,
  bas.BreastFeeding as Baseline_BreastFeeding,
  bas.[Weight] as Baseline_Weight,
  bas.[Height] as Baseline_Height,
  bas.BMI as Baseline_BMI,
  treatmentl.Name_of_treatment_supporter,
  treatmentl.Relationship_of_treatment_supporter,
  treatmentl.Treatment_supporter_telephone,
  treatmentl.Treatment_supporter_address,  
  0 as Voided
FROM Person P
 INNER JOIN (select * from (select  *,ROW_NUMBER() OVER(partition by PersonId order by CreateDate desc)rownum from PersonLocation where (DeleteFlag =0 or DeleteFlag is null))PLL where PLL.rownum='1') PL ON PL.PersonId = P.Id
  INNER JOIN Patient PT ON PT.PersonId = P.Id
  INNER JOIN PatientEnrollment PE ON PE.PatientId = PT.Id
  INNER JOIN PatientIdentifier PI ON PI.PatientId = PT.Id AND PI.PatientEnrollmentId = PE.Id
  INNER JOIN Identifiers I on PI.IdentifierTypeId=I.Id
  left  join (select ent.PatientId,ent.Entry_point from (select se.PatientId,se.EntryPointId,lt.DisplayName as Entry_point,ROW_NUMBER() OVER(partition
by se.PatientId order by CreateDate desc)rownum from ServiceEntryPoint  se
inner join LookupItem lt on lt.Id=se.EntryPointId
where se.DeleteFlag <> 1)ent where ent.rownum='1')ent on ent.PatientId=PT.Id
left join(select * from (select * ,ROW_NUMBER() OVER(partition by ph.PatientId order by PatientMasterVisitId desc)rownum
 from PatientARVHistory  ph)parv where parv.rownum=1)parv on parv.PatientId=PT.Id
  left join mst_Patient mst on mst.Ptn_Pk=PT.ptn_pk
  left join PatientTransferIn pti on pti.PatientId =PT.Id
  left join (select pts.PersonId,pts.SupporterId,CAST(DECRYPTBYKEY(pts.MobileContact)AS VARCHAR(100)) as Treatment_supporter_telephone,
pt.FirstName + ' ' + pt.MiddleName + ' ' + pt.LastName as Name_of_treatment_supporter,
pcv.PhysicalAddress as Treatment_supporter_address ,rel.[Name]  as Relationship_of_treatment_supporter
 from PatientTreatmentSupporter pts
 left join Patient pat on pat.PersonId=pts.PersonId
inner join PersonView pt on pt.Id=pts.SupporterId 
left join PersonContactView pcv on pcv.PersonId=pts.SupporterId
left join  LookupItem lt on lt.Id=pts.ContactCategory
left join PersonRelationship prl on prl.PersonId =pts.SupporterId and prl.PatientId =pat.Id
left join LookupItem rel on rel.Id=prl.RelationshipTypeId
where (lt.Name='TreatmentSupporter' or pts.ContactCategory=1))treatmentl on treatmentl.PersonId=P.Id
  left join (select * from(select * ,ROW_NUMBER() OVER(partition by PatientId order by PatientMasterVisitId)rownum from PatientBaselineView)rte
where rte.rownum=1) bas on bas.PatientId=PT.Id
  LEFT OUTER JOIN (
                    SELECT
                      PatientId,
                      ExitReason,
                      ExitDate
                    FROM dbo.PatientCareending where deleteflag=0
                    UNION
                    SELECT dbo.Patient.Id AS PatientId
                      ,CASE (SELECT TOP 1 Name FROM mst_Decode WHERE CodeID=23 AND ID = (SELECT TOP 1 PatientExitReason FROM dtl_PatientCareEnded WHERE Ptn_Pk = dbo.Patient.ptn_pk AND CareEnded=1))
                       WHEN 'Lost to follow-up'
                         THEN (SELECT TOP 1 ItemId FROM LookupItemView WHERE MasterName = 'CareEnded' AND ItemName = 'LostToFollowUp')
                       WHEN 'HIV Negative'
                         THEN (SELECT TOP 1 ItemId FROM LookupItemView WHERE MasterName = 'CareEnded' AND ItemName = 'HIV Negative')
                       WHEN 'Death'
                         THEN (SELECT TOP 1 ItemId FROM LookupItemView WHERE MasterName = 'CareEnded' AND ItemName = 'Death')
                       WHEN 'Confirmed HIV Negative'
                         THEN (SELECT TOP 1 ItemId FROM LookupItemView WHERE MasterName = 'CareEnded' AND ItemName = 'Confirmed HIV Negative')
                       WHEN 'Transfer to ART'
                         THEN (SELECT TOP 1 ItemId FROM LookupItemView WHERE MasterName = 'CareEnded' AND ItemName = 'Transfer Out')
                       WHEN 'Transfer to another LPTF'
                         THEN (SELECT TOP 1 ItemId FROM LookupItemView WHERE MasterName = 'CareEnded' AND ItemName = 'Transfer Out')
                       WHEN 'Discharged at 18 months'
                         THEN (SELECT TOP 1 ItemId FROM LookupItemView WHERE MasterName = 'CareEnded' AND ItemName = 'Confirmed HIV Negative')
                       WHEN 'Transfered out'
                         THEN (SELECT TOP 1 ItemId FROM LookupItemView WHERE MasterName = 'CareEnded' AND ItemName = 'Transfer Out')
                       END AS ExitReason,
                      CareEndedDate
                    FROM dbo.dtl_PatientCareEnded
                      INNER JOIN dbo.Patient ON dbo.dtl_PatientCareEnded.Ptn_Pk = dbo.Patient.ptn_pk
                    WHERE dbo.Patient.Id NOT IN (SELECT PatientId FROM dbo.PatientCareending where deleteflag=0)
                  ) AS ptC ON PT.Id = ptC.PatientId
WHERE PI.IdentifierTypeId = 1 and PE.ServiceAreaId=1 

-- 3. Triage Encounter 
exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY (IQCARE_OPENMRS, 'SELECT Person_Id, Encounter_Date, Visit_reason, Systolic_pressure, Diastolic_pressure
,Respiratory_rate, Pulse_rate, Oxygen_saturation, Weight, Height, Temperature, BMI, Muac, Weight_for_age_zscore
,Weight_for_height_zscore, BMI_Zscore, Head_Circumference, Nutritional_status, Last_menstrual_period, Nurse_comments, Voided FROM migration_st.st_triage')
SELECT
  P.Id,  
  format(cast(PM.VisitDate as date),'yyyy-MM-dd') AS Encounter_Date,
  NULL Visit_reason,
  PV.BPSystolic as Systolic_pressure,
  PV.BPDiastolic as Diastolic_pressure,
  PV.RespiratoryRate,
  PV.HeartRate as Pulse_rate,
  PV.SpO2 as Oxygen_saturation,
  Weight = PV.Weight,
  PV.Height,
  PV.Temperature, 
  PV.BMI as BMI,
  PV.Muac as Muac,
  PV.WeightForAge as Weight_for_age_zscore,
  PV.WeightForHeight as Weight_for_height_zscore,
  PV.BMIZ as BMI_Zscore,
  PV.HeadCircumference as Head_Circumference,
  NUll as Nutritional_status,
  lmp.LMP as Last_menstrual_period,
  NUll as Nurse_Comments,
  PV.DeleteFlag as Voided
FROM Person P
  INNER JOIN Patient PT ON PT.PersonId = P.Id
  INNER JOIN PatientVitals PV ON PV.PatientId = PT.Id
  INNER JOIN PatientMasterVisit PM ON PM.PatientId = PT.Id
  INNER JOIN PatientEnrollment PE ON PE.PatientId = PT.Id
  INNER JOIN PatientIdentifier PI ON PI.PatientId = PT.Id AND PI.PatientEnrollmentId = PE.Id
  INNER JOIN Identifiers I on PI.IdentifierTypeId=I.Id
  LEFT JOIN (select lm.PatientId,lm.LMP  from(select pid.PatientId,pid.PatientMasterVisitId,pid.LMP,ROW_NUMBER() OVER(Partition by pid.PatientId order by pid.PatientMasterVisitId desc)rownum
 from PregnancyIndicator pid
 where pid.LMP is not null)lm where lm.rownum='1') lmp on lmp.PatientId =PT.Id

-- order by First_Name

-- 4. HTS Initial Test
exec pr_OpenDecryptedSession;
insert into OpenQuery(IQCare_OPENMRS,'Select Person_Id,Encounter_Date,Encounter_ID,Pop_Type,Key_Pop_Type,
  Priority_Pop_Type,Patient_disabled,Disability,
Ever_Tested,Self_Tested,HTS_Strategy,HTS_Entry_Point,
Consented,Tested_As,TestType,Test_1_Kit_Name,Test_1_Lot_Number,Test_1_Expiry_Date,Test_1_Final_Result,
Test_2_Kit_Name,Test_2_Lot_Number,Test_2_Expiry_Date,Test_2_Final_Result,Final_Result,Result_given,Couple_Discordant,Tb_Screening_Results,Remarks,Voided from migration_st.st_hts_initial')

select P.Id as Person_Id,  
  hr.VisitDate as Encounter_Date,
  NULL Encounter_ID,
  PopType.PopulationType as Pop_Type,
  kpop.Population_Type as Key_Pop_Type ,
  prio.Population_Type as Priority_Pop_Type,
  Patient_disabled = (SELECT (case when hr.Disability != '' then 'Yes' else 'No' end)),
  hr.Disability,
  hr.TestedBefore as Ever_Tested,
  hr.clientSelfTestesd as Self_Tested,
  hr.StrategyHTS as HTS_Strategy,
  hr.[TestEntryPoint] as HTS_Entry_Point,
  hr.Consent as Consented,
  hr.ClientTestedAs as TestedAs,
  hr.TestType,
  hr.TestKitName1 as Test_1_Kit_Name,
  hr.TestKitLotNumber1 as Test_1_Lot_Number,
  hr.TestKitExpiryDate1 as Test_1_Expiry_Date,
  hr.FinalTestOneResult as Test_1_Final_Result,
  hr.TestKitName_2 as Test_2_Kit_Name,
  hr.TestKitLotNumber_2 as Test_2_Lot_Number,
  hr.TestKitExpiryDate_2 as Test_2_Expiry_Date,
  hr.FinalResultTestTwo as Test_2_Final_Result,
  hr.finalResultHTS as Final_Result,
  hr.FinalResultsGiven as Result_given,
  hr.CoupleDiscordant as Couple_Discordant,
  hr.TBScreeningHTS as TB_SCreening_Results,
  hr.Remarks as Remarks, 
  0 as Voided
 from HTS_LAB_Register hr
inner join Patient pat on pat.Id=hr.PatientID
inner join Person P on P.Id=pat.PersonId
 INNER JOIN PatientIdentifier PI ON PI.PatientId = hr.PatientID
left join(
select t.PersonId,t.PopulationType,t.Population_Type,t.CreateDate from (
select pp.Id,pp.PersonId,pp.PopulationType,pp.PopulationCategory,lt.DisplayName as Population_Type,pp.CreateDate,ROW_NUMBER() OVER(partition
by pp.PersonId order by pp.CreateDate desc) rownum
 from PatientPopulation pp
left join LookupItemView lt on lt.ItemId=pp.PopulationCategory
where (DeleteFlag=0 or DeleteFlag is null)
and pp.PopulationType ='Key Population'
)t where rownum='1')kpop on kpop.PersonId=P.Id
left join(select pr.PersonId,pr.PopulationType,pr.Population_Type,pr.CreateDate from (select pr.Id,pr.PersonId,pr.PriorityId as PopulationCategory,
(select DisplayName from  LookupMaster where Name = 'PriorityPopulation') as PopulationType ,
(select l.DisplayName from LookupItem l where l.Id=pr.PriorityId) as Population_Type,pr.CreateDate,
ROW_NUMBER() OVER(partition
by pr.PersonId order by pr.CreateDate desc) rownum
from PersonPriority pr
)pr where rownum='1'
)prio on prio.PersonId=P.Id
left Join(select t.PersonId,t.PopulationType,t.Population_Type,t.CreateDate from (
select pp.Id,pp.PersonId,pp.PopulationType,pp.PopulationCategory,lt.DisplayName as Population_Type,pp.CreateDate,ROW_NUMBER() OVER(partition
by pp.PersonId order by pp.CreateDate desc) rownum
 from PatientPopulation pp
left join LookupItemView lt on lt.ItemId=pp.PopulationCategory
where (DeleteFlag=0 or DeleteFlag is null)

)t where rownum='1')PopType on PopType.PersonId=P.Id


-- 5. HTS Retest Test
exec pr_OpenDecryptedSession;
insert into OpenQuery(IQCare_OPENMRS,'Select Person_Id,Encounter_Date,Encounter_ID,Pop_Type,Key_Pop_Type,
  Priority_Pop_Type,Patient_disabled,Disability,
Ever_Tested,Self_Tested,HTS_Strategy,HTS_Entry_Point,
Consented,Tested_As,TestType,Test_1_Kit_Name,Test_1_Lot_Number,Test_1_Expiry_Date,Test_1_Final_Result,
Test_2_Kit_Name,Test_2_Lot_Number,Test_2_Expiry_Date,Test_2_Final_Result,Final_Result,Result_given,Couple_Discordant,Tb_Screening_Results,Remarks,Voided from migration_st.st_hts_retest')

select P.Id as Person_Id, 
  hr.VisitDate as Encounter_Date,
  NULL Encounter_ID,
  PopType.PopulationType as Pop_Type,
  kpop.Population_Type as Key_Pop_Type ,
  prio.Population_Type as Priority_Pop_Type,
  Patient_disabled = (SELECT (case when hr.Disability != '' then 'Yes' else 'No' end)),
  hr.Disability,
  hr.TestedBefore as Ever_Tested,
  hr.clientSelfTestesd as Self_Tested,
  hr.StrategyHTS as HTS_Strategy,
  hr.[TestEntryPoint] as HTS_Entry_Point,
  hr.Consent as Consented,
  hr.ClientTestedAs as TestedAs,
  hr.TestType,
  hr.TestKitName1 as Test_1_Kit_Name,
  hr.TestKitLotNumber1 as Test_1_Lot_Number,
  hr.TestKitExpiryDate1 as Test_1_Expiry_Date,
  hr.FinalTestOneResult as Test_1_Final_Result,
  hr.TestKitName_2 as Test_2_Kit_Name,
  hr.TestKitLotNumber_2 as Test_2_Lot_Number,
  hr.TestKitExpiryDate_2 as Test_2_Expiry_Date,
  hr.FinalResultTestTwo as Test_2_Final_Result,
  hr.finalResultHTS as Final_Result,
  hr.FinalResultsGiven as Result_given,
  hr.CoupleDiscordant as Couple_Discordant,
  hr.TBScreeningHTS as TB_SCreening_Results,
  hr.Remarks as Remarks, 
  0 as Voided
 from HTS_LAB_Register hr
inner join Patient pat on pat.Id=hr.PatientID
inner join Person P on P.Id=pat.PersonId
 INNER JOIN PatientIdentifier PI ON PI.PatientId = hr.PatientID
left join(
select t.PersonId,t.PopulationType,t.Population_Type,t.CreateDate from (
select pp.Id,pp.PersonId,pp.PopulationType,pp.PopulationCategory,lt.DisplayName as Population_Type,pp.CreateDate,ROW_NUMBER() OVER(partition
by pp.PersonId order by pp.CreateDate desc) rownum
 from PatientPopulation pp
left join LookupItemView lt on lt.ItemId=pp.PopulationCategory
where (DeleteFlag=0 or DeleteFlag is null)
and pp.PopulationType ='Key Population'
)t where rownum='1')kpop on kpop.PersonId=P.Id
left join(select pr.PersonId,pr.PopulationType,pr.Population_Type,pr.CreateDate from (select pr.Id,pr.PersonId,pr.PriorityId as PopulationCategory,
(select DisplayName from  LookupMaster where Name = 'PriorityPopulation') as PopulationType ,
(select l.DisplayName from LookupItem l where l.Id=pr.PriorityId) as Population_Type,pr.CreateDate,
ROW_NUMBER() OVER(partition
by pr.PersonId order by pr.CreateDate desc) rownum
from PersonPriority pr
)pr where rownum='1'
)prio on prio.PersonId=P.Id
left Join(select t.PersonId,t.PopulationType,t.Population_Type,t.CreateDate from (
select pp.Id,pp.PersonId,pp.PopulationType,pp.PopulationCategory,lt.DisplayName as Population_Type,pp.CreateDate,ROW_NUMBER() OVER(partition
by pp.PersonId order by pp.CreateDate desc) rownum
 from PatientPopulation pp
left join LookupItemView lt on lt.ItemId=pp.PopulationCategory
where (DeleteFlag=0 or DeleteFlag is null)

)t where rownum='1')PopType on PopType.PersonId=P.Id

-- 6. HTS Client Tracing

-- 7. HTS Client Referral

-- 8. HTS Client Linkage

-- 9. HTS Contact Listing



-- 10. Patient programs
exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY(IQCARE_OPENMRS,'Select Person_Id,Encounter_Date,Encounter_ID,Program,Date_Enrolled,Date_Completed   
from migration_st.st_program_enrollment')

select 
  P.Id as Person_Id, 
  pe.Enrollment as Encounter_Date,
  NULL as Encounter_ID,
  sa.Code as Program,
  pe.Enrollment as Date_Enrolled,
  pe.ExitDate as Date_Completed 
from Person P

INNER JOIN Patient PT ON PT.PersonId = P.Id
INNER JOIN 
(select pce.PatientId,pce.ServiceAreaId,pce.Enrollment,pce.ExitDate from(select pce.PatientId,pce.ReenrollmentDate as Enrollment,pce.ServiceAreaId,CASE WHEN 
pce.ExitDate > pce.ReenrollmentDate then pce.ExitDate else NULL end as ExitDate  from(
select pe.PatientId,pe.Id,pe.CareEnded,pce.Active,pce.DeleteFlag,pe.EnrollmentDate,pe.ServiceAreaId
,pce.ExitDate,pce.ExitReason,pre.ReenrollmentDate from PatientEnrollment pe
inner join PatientCareending pce on pce.PatientId=pe.PatientId
inner join PatientReenrollment pre on pre.PatientId=pce.PatientId
left join LookupItem lti on lti.Id=pce.ExitReason
and pce.PatientEnrollmentId=pe.Id
where pce.DeleteFlag='1'
)pce
union 
select pce.PatientId,pce.EnrollmentDate as Enrollment,pce.ServiceAreaId,pce.ExitDate from(
select  pe.PatientId,pe.CareEnded,pe.ServiceAreaId,pe.EnrollmentDate,pce.ExitDate,pce.DeleteFlag
  from PatientEnrollment  pe 
left join PatientCareending pce on pce.PatientId = pe.PatientId
left join LookupItem lti on lti.Id=pce.ExitReason
and pce.PatientEnrollmentId=pe.Id
)pce)pce )pe on pe.PatientId=PT.Id
INNER JOIN ServiceArea sa on sa.Id=pe.ServiceAreaId
INNER JOIN PatientIdentifier PI ON PI.PatientId = PT.Id 



-- 11. Patient discontinuation
exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY(IQCARE_OPENMRS,'Select Person_Id,Encounter_Date,Encounter_ID,Program,Date_Enrolled,Date_Completed,
Care_Ending_Reason,Facility_Transfered_To,Death_Date 
from migration_st.st_program_discontinuation')

select 
P.Id as Person_Id,
pe.Enrollment as Encounter_Date,
NULL as Encounter_ID,
sa.Code as Program,
pe.Enrollment as Date_Enrolled,
pe.ExitDate as Date_Completed,
pe.ExitReasonValue as Care_Ending_Reason,
pe.TransferOutfacility as Facility_Transfered_To,
pe.DateOfDeath as Death_Date
from Person P

INNER JOIN Patient PT ON PT.PersonId = P.Id
INNER JOIN 
(select pce.PatientId,pce.ServiceAreaId,pce.Enrollment,pce.ExitDate,pce.ExitReasonValue,pce.TransferOutfacility,pce.DateOfDeath from(select pce.PatientId,pce.ReenrollmentDate as Enrollment,pce.ServiceAreaId,CASE WHEN 
pce.ExitDate > pce.ReenrollmentDate then pce.ExitDate else NULL end as ExitDate,pce.ExitReasonValue,pce.TransferOutfacility,pce.DateOfDeath from(
select pe.PatientId,pe.Id,pe.CareEnded,pce.Active,pce.DeleteFlag,pe.EnrollmentDate,pe.ServiceAreaId
,pce.ExitDate,pce.ExitReason,lti.DisplayName as ExitReasonValue,pce.TransferOutfacility,pre.ReenrollmentDate,pce.DateOfDeath from PatientEnrollment pe
inner join PatientCareending pce on pce.PatientId=pe.PatientId
inner join PatientReenrollment pre on pre.PatientId=pce.PatientId
left join LookupItem lti on lti.Id=pce.ExitReason
and pce.PatientEnrollmentId=pe.Id
where pce.DeleteFlag='1'
)pce
union 
select pce.PatientId,pce.EnrollmentDate as Enrollment,pce.ServiceAreaId,pce.ExitDate,pce.ExitReasonValue,pce.TransferOutfacility,pce.DateOfDeath from(
select pe.PatientId,pe.CareEnded,pe.ServiceAreaId,pe.EnrollmentDate,pce.ExitDate,lti.DisplayName as ExitReasonValue,pce.TransferOutfacility,pce.DeleteFlag,pce.DateOfDeath
from PatientEnrollment pe 
left join PatientCareending pce on pce.PatientId = pe.PatientId
left join LookupItem lti on lti.Id=pce.ExitReason
and pce.PatientEnrollmentId=pe.Id
)pce)pce )pe on pe.PatientId=PT.Id
INNER JOIN ServiceArea sa on sa.Id=pe.ServiceAreaId
INNER JOIN PatientIdentifier PI ON PI.PatientId = PT.Id 
WHERE pe.ExitDate is not null

-- 12. IPT Screening
exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY (IQCARE_OPENMRS, 'SELECT Person_Id, Encounter_Date,Encounter_ID,Yellow_urine,Numbness,Yellow_eyes,Tenderness,IPT_Start_Date
 FROM migration_st.st_ipt_screening')

 select p.PersonId,
pmv.VisitDate as EncounterDate
,NULL as Encounter_ID
,CASE WHEN pipt.YellowColouredUrine =0 then 'No' when pipt.YellowColouredUrine=1 then 'Yes'
else NULL
 end as Yellow_urine
 ,CASE WHEN pipt.Numbness =0 then 'No' when pipt.Numbness=1 then 'Yes'
else NULL
 end as Numbness
 ,CASE WHEN pipt.YellownessOfEyes =0 then 'No' when pipt.YellownessOfEyes=1 then 'Yes'
else NULL
 end as Yellow_eyes,
 CASE WHEN pipt.AbdominalTenderness =0 then 'No' when pipt.AbdominalTenderness=1 then 'Yes'
else NULL
 end as Tenderness
,pipt.IptStartDate as IPT_Start_Date

from PatientIptWorkup pipt
inner join PatientMasterVisit pmv on pmv.Id=pipt.PatientMasterVisitId
inner join Patient p on p.Id=pipt.PatientId

-- 13. IPT Program Enrollment
exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY (IQCARE_OPENMRS, 'SELECT Person_Id,Encounter_Date,Encounter_ID,IPT_Start_Date,Indication_for_IPT,IPT_Outcome,Outcome_Date
 FROM migration_st.st_ipt_program')


select p.PersonId,
pmv.VisitDate as EncounterDate
,NULL as Encounter_ID
,pipt.IptStartDate as IPT_Start_Date,
NULL as Indication_for_IPT,
ltv.ItemDisplayName as IPT_Outcome
,pio.IPTOutComeDate as Outcome_Date

from PatientIptWorkup pipt
inner join PatientMasterVisit pmv on pmv.Id=pipt.PatientMasterVisitId
inner join Patient p on p.Id=pipt.PatientId
left join PatientIptOutcome pio on pio.PatientId=pipt.PatientId
and pio.PatientMasterVisitId=pipt.PatientMasterVisitId
left join LookupItemView ltv on ltv.itemId=pio.IptEvent 
and ltv.MasterName='IptOutcome'

-- 14. IPT Program Followup
exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY (IQCARE_OPENMRS, 'SELECT Person_Id,Encounter_Date,Encounter_ID,IPT_due_date,Date_collected_ipt,Weight,Hepatotoxity,Hepatotoxity_Action,Peripheral_neuropathy,Peripheralneuropathy_Action,
Rash,Rash_Action,Adherence,AdheranceMeasurement_Action,IPT_Outcome,Outcome_Date
 FROM migration_st.st_ipt_followup')

  select p.PersonId
,pmv.VisitDate as EncounterDate
,NULL as Encounter_ID
,pipt.IptDueDate as Ipt_due_date
,pipt.IptDateCollected as Date_collected_ipt
,pipt.[Weight] as [Weight]
,CASE WHEN pipt.Hepatotoxicity =0 then 'No' when pipt.Hepatotoxicity=1 then 'Yes'
else NULL
 end as Hepatotoxity,
 HepatotoxicityAction as Hepatotoxity_Action,
 CASE WHEN pipt.Peripheralneoropathy =0 then 'No' when pipt.Peripheralneoropathy=1 then 'Yes'
else NULL
end as Peripheralneoropathy
,pipt.PeripheralneoropathyAction as Peripheralneuropathy_Action
 ,CASE WHEN pipt.Rash =0 then 'No' when pipt.Rash=1 then 'Yes'
else NULL
 end as Rash,
 pipt.RashAction as Rash_Action,
 ltv.DisplayName as Adherence,
 pipt.AdheranceMeasurementAction as AdheranceMeasurement_Action,
 lto.ItemDisplayName as IPT_Outcome,
 pio.IPTOutComeDate as Outcome_Date
from  PatientIpt pipt
inner join PatientMasterVisit pmv on pmv.Id=pipt.PatientMasterVisitId
inner join Patient p on p.Id=pipt.PatientId
left join LookupItemView ltv on ltv.ItemId=pipt.AdheranceMeasurement
left join PatientIptOutcome pio on pio.PatientId = pipt.PatientId and pio.PatientMasterVisitId=pipt.PatientMasterVisitId
and ltv.MasterName='AdheranceMeasurement'
left join LookupItemView lto on lto.itemId=pio.IptEvent 
and ltv.MasterName='IptOutcome'

-- 15. Regimen History
exec pr_OpenDecryptedSession;
INSERT INTO OPENQUERY (IQCARE_OPENMRS,
'select  Person_Id, Encounter_Date,Encounter_ID,                   
  Program,                         
  Regimen ,                         
  Regimen_Name,                     
  Regimen_Line,                     
  Date_Started,                     
  Date_Stopped,            
  Regimen_Discontinued,             
  Date_Discontinued,                
  Reason_Discontinued,              
  RegimenSwitchTo,	
  CurrentRegimen,				
  Voided,                           
  Date_voided                    
from migration_st.st_regimen_history')

 select p.Id  as Person_Id,part.DispensedByDate as Encounter_Date
, 'NULL' as Encounter_ID,
 pstart.TreatmentProgram as Program,
 NULL as Regimen,
 pstart.Regimen as Regimen_Name,
 pstart.RegimenLine as Regimen_Line,
 pstart.DispensedByDate as Date_Started, 
  pr.VisitDate as Date_Stopped
 ,CASE WHEN pr.VisitDate is not null then pstart.Regimen else NULL end  as Regimen_Discontinued
 ,pr.VisitDate as [Date_Discontinued],
 pr.TreatmentReason  as Reason_Discontinued
,pr.Regimen as RegimenSwitchTo
 ,part.Regimen as CurrentRegimen
 ,0 as Voided
 ,NULL as Date_Voided
  from (select distinct PatientId from PatientTreatmentTrackerView pt)ptr 
  inner join Patient pt on pt.Id=ptr.PatientId
left join Person p on p.Id =pt.PersonId
left join (
select  pts.PatientId,lt.DisplayName as [Regimen],pts.RegimenLine,pts.TreatmentStatus,pts.DispensedByDate,pts.VisitDate,pts.TreatmentProgram from (select tv.PatientId,tv.RegimenId,tv.Regimen,tv.RegimenLine,tv.TreatmentStatusId,tv.TreatmentStatus,tv.DispensedByDate,tv.VisitDate,dc.[Name] as TreatmentProgram,
ROW_NUMBER() OVER(partition by tv.PatientId order by tv.PatientMasterVisitId desc)rownum
 from PatientTreatmentTrackerView tv
 left join ord_PatientPharmacyOrder pho on pho.PatientMasterVisitId =tv.PatientMasterVisitId
 left join mst_Decode dc on dc.ID =pho.ProgID
 )pts 
 inner join LookupItem lt on lt.Id=pts.RegimenId
 where pts.rownum =1
 )part on part.PatientId=pt.Id
left join(select  pts.PatientId,lt.DisplayName as [Regimen],pts.RegimenLine,pts.TreatmentStatus,pts.DispensedByDate,pts.VisitDate,pts.TreatmentProgram from (select tv.PatientId,tv.RegimenId,tv.Regimen,tv.RegimenLine,tv.TreatmentStatusId,tv.TreatmentStatus,tv.DispensedByDate,tv.VisitDate,
ROW_NUMBER() OVER(partition by tv.PatientId order by tv.PatientMasterVisitId asc)rownum, dc.[Name] as TreatmentProgram
 from PatientTreatmentTrackerView tv
  left join ord_PatientPharmacyOrder pho on pho.PatientMasterVisitId =tv.PatientMasterVisitId
   left join mst_Decode dc on dc.ID =pho.ProgID
 )pts 
 inner join LookupItem lt on lt.Id=pts.RegimenId
 where pts.rownum =1
)pstart  on pstart.PatientId=pt.Id
left join(
select pr.PatientId,pr.RegimenLine,pr.Regimen,pr.TreatmentStatus,pr.VisitDate,pr.DispensedByDate,pr.TreatmentReason from (select p.PatientId,p.RegimenId,p.RegimenLine,ltr.DisplayName as [Regimen],p.TreatmentReason,p.TreatmentStatus,p.TreatmentStatusId,p.VisitDate,p.DispensedByDate,ROW_NUMBER() 
 OVER(Partition by p.PatientId order by p.PatientMasterVisitId desc)rownum  from PatientTreatmentTrackerView   p
inner join LookupItem lt on lt.Id=p.TreatmentStatusId
inner join LookupItem ltr on ltr.Id=p.RegimenId
left join LookupItem lts on lts.Id =p.TreatmentStatusReasonId
where lt.[Name]='DrugSwitches')pr  where pr.rownum='1'
)pr on pr.PatientId=pt.Id

-- 16. HIV Follow up
exec pr_OpenDecryptedSession;
insert into OpenQuery(IQCare_OPENMRS,'Select Person_Id,Encounter_Date,Encounter_ID,
  Visit_scheduled,          
  Visit_by,          
  Visit_by_other,   
  Nutritional_status,        
  Population_type,       
  Key_population_type,       
  Who_stage,      
  Presenting_complaints,
  Complaint,  
  Duration,
  Onset_Date,
  Clinical_notes,
  Has_known_allergies,      
  Allergies_causative_agents,
  Allergies_reactions,
  Allergies_severity,      
  Has_Chronic_illnesses_cormobidities,
  Chronic_illnesses_name,
  Chronic_illnesses_onset_date, 
  Has_adverse_drug_reaction,
  Medicine_causing_drug_reaction, 
  Drug_reaction,
  Drug_reaction_severity,     
  Drug_reaction_onset_date,  
  Drug_reaction_action_taken, 
  Vaccinations_today,
  Vaccine_Stage,
  Vaccination_Date,
  Last_menstrual_period,      
  Pregnancy_status,
  Wants_pregnancy ,
  Pregnancy_outcome, 
  Anc_number,               
  Anc_profile,               
  Expected_delivery_date,    
  Gravida,   
  Parity,                 
  Family_planning_status,    
  Family_planning_method ,   
  Reason_not_using_family_planning,  
  General_examinations_findings ,
  System_review_finding,
  Skin,    
  Skin_finding_notes,        
  Eyes,       
  Eyes_finding_notes,        
  ENT,      
  ENT_finding_notes,         
  Chest,        
  Chest_finding_notes,       
  CVS,      
  CVS_finding_notes,         
  Abdomen,                   
  Abdomen_finding_notes,  
  CNS,               
  CNS_finding_notes,      
  Genitourinary,           
  Genitourinary_finding_notes,
  Diagnosis,             
  Treatment_plan,           
  Ctx_adherence,            
  Ctx_dispensed,            
  Dapsone_adherence,       
  Dapsone_dispensed,        
  Morisky_forget_taking_drugs,   
  Morisky_careless_taking_drugs, 
  Morisky_stop_taking_drugs_feeling_worse,  
  Morisky_stop_taking_drugs_feeling_better,  
  Morisky_took_drugs_yesterday,    
  Morisky_stop_taking_drugs_symptoms_under_control, 
  Morisky_feel_under_pressure_on_treatment_plan,
  Morisky_how_often_difficulty_remembering,
  Arv_adherence,      
  Condom_provided,        
  Screened_for_substance_abuse,
  Pwp_disclosure,       
  Pwp_partner_tested,      
  Cacx_screening,           
  Screened_for_sti,         
  Stability,              
  Next_appointment_date,    
  Next_appointment_reason,  
  Appointment_type,       
  Differentiated_care,     
  Voided 
  FROM migration_st.st_hiv_followup')

  select  P.Id as Person_Id,
   format(cast(pmv.VisitDate as date),'yyyy-MM-dd') AS Encounter_Date
,NULL as Encounter_ID
 , CASE WHEN pmv.VisitScheduled='0' then 'No' when pmv.VisitScheduled='1' then 'Yes' end as Visit_scheduled,
ltv.[Name] as Visit_by,
NULL Visit_by_other
,psc.ItemDisplayName as Nutritional_status,
pop.PopulationType as Population_type,
pop.Population_Type as Key_population_type,
pws.WHO_Stage as Who_stage,
 CASE WHEN pres.PresentingComplaint is null then 'No' else 'Yes' end as Presenting_complaints,
pres.PresentingComplaint as Complaint,
NULL as Duration,
NULL as Onset_Date,
cl.ClinicalNotes as Clinical_notes,
CASE WHEN paa.Has_Known_allergies is null then 'No' else paa.Has_Known_allergies end as Has_Known_allergies,
paa.Allergies_causative_agents,
paa.Allergies_reactions,
paa.Allergies_severity,
chr.Has_Chronic_illnesses_cormobidities,
chr.Chronic_illnesses_name,
chr.Chronic_illnesses_onset_date,
CASE WHEN paa.Has_Known_allergies is null then 'No' else paa.Has_Known_allergies end as Has_adverse_drug_reaction,
paa.Allergies_causative_agents as Medicine_causing_drug_reaction,
paa.Allergies_reactions as Drug_reaction,
paa.Allergies_severity as Drug_reaction_severity,
paa.OnsetDate as Drug_reaction_onset_date,
NULL as Drug_reaction_action_taken,
vss.Vaccinations_today,
vss.VaccineStage as Vaccine_Stage,
vss.VaccineDate as Vaccine_Date,
pov.LMP as Last_menstrual_period,
pov.PregnancyStatus as Pregnancy_status,
pov.PlanningGetPregnant as Wants_pregnancy,
pov.Outcome as Pregnancy_outcome,
panc.IdentifierValue as Anc_number,
pov.Anc_profile,
pov.EDD  as Expected_delivery_date,
pov.Gravidae as Gravida,
pov.Parity as Parity,
pfm.FamilyPlanningStatus as Family_planning_status,
pfm.FamilyPlanningMethod as Family_planning_method,
pfm.Reason_not_using_family_planning,
ge.Exam as General_examinations_findings,
CASE when srs.System_review_finding is null then 'No' else srs.System_review_finding end as System_review_finding,
sk.Findings as Skin,
sk.FindingsNotes as Skin_finding_notes,
ey.Findings as Eyes,
ey.FindingsNotes as Eyes_Finding_notes,
ent.Findings as ENT,
ent.FindingsNotes as ENT_finding_notes,
ch.Findings as Chest,
ch.FindingsNotes as Chest_finding_notes,
cvs.Findings as CVS,
cvs.FindingsNotes as CVS_finding_notes,
ab.Findings as Abdomen,
ab.FindingsNotes as Abdomen_finding_notes,
cns.Findings as CNS,
cns.FindingsNotes as CNS_finding_notes,
gn.Findings as Genitourinary,
gn.FindingsNotes as Genitourinary_finding_notes,
pd.Diagnosis as Diagnosis,
pd.ManagementPlan as Treatment_plan,
ctx.ScoreName as Ctx_adherence,
CASE when ctx.VisitDate  is not null then 'Yes' else' No' end as Ctx_dispensed,
NULL as Dapson_adherence,
NULL as Dapsone_dispensed,
adass.Morisky_forget_taking_drugs,
adass.Morisky_careless_taking_drugs,
adass.Morisky_stop_taking_drugs_feeling_worse,
adass.Morisky_stop_taking_drugs_feeling_better,
adass.Morisky_took_drugs_yesterday,
adass.Morisky_stop_taking_drugs_symptoms_under_control,
adass.Morisky_feel_under_pressure_on_treatment_plan,
adass.Morisky_how_often_difficulty_remembering,
adv.ScoreName as Arv_adherence,
phdp.Condom_Provided,
phdp.Screened_for_substance_abuse,
phdp.Pwp_Disclosure,
phdp.Pwp_partner_tested,
cacx.ScreeningValue  as Cacx_Screening,
phdp.Screened_for_sti,
pcc.Stability as Stability,
 format(cast(papp.Next_appointment_date as date),'yyyy-MM-dd') AS Next_appointment_date,
papp.Next_appointment_reason,
papp.Appointment_type,
pdd.DifferentiatedCare as Differentiated_care,
'0' as Voided   

  from Person P
   INNER JOIN Patient PT ON PT.PersonId = P.Id
  INNER JOIN PatientEncounter pe on pe.PatientId=PT.Id
   inner join 
LookupItem lt  on lt.Id=pe.EncounterTypeId
inner join PatientMasterVisit pmv on pmv.Id=pe.PatientMasterVisitId
inner join mst_User u on u.UserID=pe.CreatedBy
inner join LookupItem ltv on ltv.Id=pmv.VisitBy
left join (
select pvs.Patientid,pvs.PatientMasterVisitId,pmv.VisitDate,
pvs.[Weight] ,pvs.[Height],pvs.BPSystolic as Systolic_pressure,
pvs.BPDiastolic as Diastolic_pressure,
pvs.Temperature,pvs.HeartRate as Pulse_rate,
pvs.RespiratoryRate as Respiratory_rate,
pvs.SpO2 as Oxygen_Saturation,
pvs.BMI as BMI,
pvs.Muac as Muac
from PatientVitals pvs 
inner join  PatientMasterVisit pmv on pvs.PatientMasterVisitId=pmv.Id
 inner join Patient p on p.Id=pmv.PatientId
 )pvs on pvs.PatientId=pe.PatientId
 and pvs.PatientMasterVisitId=pe.PatientMasterVisitId
left join (select psc.PatientId,psc.PatientMasterVisitId,psc.ItemDisplayName,psc.DeleteFlag,psc.Active from( select  psc.PatientId,psc.PatientMasterVisitId ,psc.ScreeningTypeId,(select [Name] from LookupMaster where Id =psc.ScreeningTypeId) as MasterName
  ,psc.ScreeningValueId,(select DisplayName from LookupItem where Id=psc.ScreeningValueId) as ItemDisplayName,psc.DeleteFlag,psc.Active
   from PatientScreening psc
   )psc where psc.MasterName='NutritionStatus' and (psc.DeleteFlag=0 or psc.DeleteFlag is null))
   psc on psc.PatientMasterVisitId=pe.PatientMasterVisitId and psc.PatientId =pe.PatientId
  left Join(select t.PersonId,t.PopulationType,t.Population_Type,t.CreateDate from (
select pp.Id,pp.PersonId,pp.PopulationType,pp.PopulationCategory,lt.DisplayName as Population_Type,pp.CreateDate,ROW_NUMBER() OVER(partition
by pp.PersonId order by pp.CreateDate desc) rownum
 from PatientPopulation pp
left join LookupItemView lt on lt.ItemId=pp.PopulationCategory
where (DeleteFlag=0 or DeleteFlag is null))t where t.rownum=1) pop on pop.PersonId=P.Id
left join (select * from(select pws.PatientId,pws.PatientMasterVisitId,pws.WHOStage,ltv.itemName as WHO_Stage,ROW_NUMBER() OVER(partition by
pws.PatientId,pws.PatientMasterVisitId order by pws.PatientMasterVisitId)rownum from PatientWHOStage pws
inner join LookupItemView ltv on ltv.MasterName='WHOStage' and pws.WHOStage=ltv.ItemId)pw where pw.rownum=1
)pws on pws.PatientId=pe.PatientMasterVisitId and pws.PatientId=pe.PatientId
left join (select PatientId,PatientMasterVisitId,PresentingComplaintsId,PresentingComplaint from (select  PatientId,PatientMasterVisitId,PresentingComplaintsId,CreatedBy,CreatedDate,lt.DisplayName as PresentingComplaint,
ROW_NUMBER() OVER(partition by PatientId,PatientMasterVisitId order by CreatedDate desc)rownum
 from PresentingComplaints pres
 inner join LookupItem lt on lt.Id=pres.PresentingComplaintsId
 ) pre where rownum='1')pres on pres.PatientId=pe.PatientId and pres.PatientMasterVisitId=pe.PatientMasterVisitId
 left join(select t.PatientId,t.PatientMasterVisitId,t.ClinicalNotes from(select PatientId,PatientMasterVisitId ,ClinicalNotes,NotesCategoryId,DeleteFlag ,CreateDate,Active,ROW_NUMBER() OVER(partition by PatientId,PatientMasterVisitId order by CreateDate desc )rownum
 from PatientClinicalNotes where 
 NotesCategoryId is null and (DeleteFlag is null or DeleteFlag=0)) t where t.rownum='1')cl on cl.PatientId=pe.PatientId and cl.PatientMasterVisitId=pe.PatientMasterVisitId
 left join PatientIcf pic on pic.PatientId=pe.PatientId and pic.PatientMasterVisitId =pe.PatientMasterVisitId
left join(select pic.PatientId,pic.PatientMasterVisitId,pic.SputumSmear,CASE WHEN ltv.itemName = 'Ordered'
 then ltv.ItemName else NULL end as Spatum_smear_Ordered,
 CASE when  ltv.ItemName != 'Ordered' then ltv.DisplayName
else NULL end as Spatum_smear_result,
  pic.ChestXray,
CASE when glv.itemName='Ordered' then glv.DisplayName else NULL end as 
Genexpert_ordered,
CASE when  glv.ItemName != 'Ordered' then glv.DisplayName
else NULL end as Geneexpert_result,
CASE when clv.itemName='Ordered' then clv.DisplayName else NULL end as 
Chest_xray_ordered
,CASE when  clv.ItemName != 'Ordered' then clv.DisplayName
else NULL end as Chest_xray_result
,pic.GeneXpert,glv.DisplayName
from PatientIcfAction pic
left join LookupItemView ltv on ltv.ItemId=pic.SputumSmear and ltv.MasterName='SputumSmear'
left join LookupItemView glv on glv.ItemId=pic.GeneXpert and glv.MasterName='GeneExpert'
left Join LookupItemView clv on clv.ItemId=pic.ChestXray and clv.MasterName='ChestXray')
picf on picf.PatientId=pe.PatientId and picf.PatientMasterVisitId=pe.PatientMasterVisitId
left join(select psc.Patientid,psc.PatientMasterVisitId ,psc.ScreeningValueId,lt.[Name],lti.DisplayName as  Tb_Status
 from PatientScreening psc
 inner join LookupItem lt on lt.Id= psc.ScreeningValueId
 inner join LookupMasterItem lti on lti.LookupItemId=lt.Id
 inner join LookupMaster lm on lm.Id=lti.LookupMasterId
  where lm.[Name] ='TBFindings' and (psc.DeleteFlag = 0 or psc.DeleteFlag is null))ptb on
  ptb.PatientId=pe.PatientId and ptb.PatientMasterVisitId=pe.PatientMasterVisitId
  left join (select * from (select *,ROW_NUMBER() OVER(partition by PatientId,PatientMasterVisitId order by PatientMasterVisitId desc)rownum from PatientIcfAction where DeleteFlag is null or DeleteFlag =0)pia where pia.rownum=1)pia on pia.PatientId =pe.PatientId
  and pia.PatientMasterVisitId=pe.PatientMasterVisitId
  left join (select tt.PatientId,tt.PatientMasterVisitId,tt.TBRxEndDate,tt.TBRxStartDate,tt.RegimenId,li.DisplayName as [RegimenName] from (select tt.PatientId,tt.PatientMasterVisitId,tt.TBRxStartDate,tt.TBRxEndDate,tt.RegimenId,ROW_NUMBER() OVER(partition by tt.PatientId,tt.PatientMasterVisitId order by tt.PatientMasterVisitId desc)rownum from TuberclosisTreatment tt)tt
  inner join LookupItem li on li.Id=tt.RegimenId
   where tt.rownum=1)trx on trx.PatientId=pe.PatientId and trx.PatientMasterVisitId=pe.PatientMasterVisitId
left join(select * from (select PatientId,PatientMasterVisitId,OnsetDate ,AllergenName as Allergies_causative_agents,ReactionName as Allergies_reactions,'Yes' as Has_Known_allergies,
SeverityName as Allergies_severity,ROW_NUMBER() OVER(partition by PatientId,PatientMasterVisitId order by  PatientMasterVisitId desc)rownum

 from PatientAllergyView)pav where pav.rownum =1)paa on paa.PatientId=pe.PatientId and paa.PatientMasterVisitId =pe.PatientMasterVisitId
 left join (select * from (select PatientId,PatientMasterVisitId ,ChronicIllness as Chronic_illnesses_name,
OnsetDate as Chronic_illnesses_onset_date ,'Yes' as Has_Chronic_illnesses_cormobidities,
ROW_NUMBER() OVER(partition by PatientId,PatientMasterVisitId order by  PatientMasterVisitId desc)rownum

 from PatientChronicIllnessView)pav where pav.rownum =1
)chr on chr.PatientId =pe.PatientId and chr.PatientMasterVisitId =pe.PatientMasterVisitId
left join(
 select  distinct  vs.PatientId,vs.PatientMasterVisitId,vs.PeriodId,vs.Vaccinations_today,lti.DisplayName as VaccineStage,vs.VaccinationStage,vs.VaccineStageId,vs.VaccineDate from (select v.PatientId,v.PatientMasterVisitId,v.Vaccine,lt.DisplayName as [Vaccinations_today],CASE WHEN 
 isNumeric(v.VaccineStage) =1  then v.VaccineStage else NULL end as VaccineStage ,v.VaccineStageId,ltt.DisplayName as [VaccinationStage],v.PeriodId,v.VaccineDate from Vaccination v
 left join LookupItem ltt on ltt.Id=v.VaccineStageId
 left join LookupItem lt on lt.Id=v.Vaccine) vs
 left join LookupItem lti on lti.id=vs.VaccineStage )vss on vss.PatientId=pe.PatientId and vss.PatientMasterVisitId=pe.PatientMasterVisitId
 left join (
SELECT        dbo.PregnancyIndicator.Id,dbo.Pregnancy.Gravidae,dbo.Pregnancy.Parity, dbo.PregnancyIndicator.PatientId, dbo.PregnancyIndicator.PatientMasterVisitId, dbo.PregnancyIndicator.LMP, dbo.PregnancyIndicator.EDD,CASE WHEN dbo.PregnancyIndicator.ANCProfile='1' then 'Yes' when dbo.PregnancyIndicator.ANCProfile='0' then 'No' end as Anc_Profile,

                             (SELECT        TOP (1) DisplayName
                               FROM            dbo.LookupItemView
                               WHERE        (ItemId = dbo.PregnancyIndicator.PregnancyStatusId) AND (MasterName = 'PregnancyStatus')) AS PregnancyStatus,
                             (SELECT        TOP (1) DisplayName
                               FROM            dbo.LookupItemView AS LookupItemView_1
                               WHERE        (ItemId = dbo.Pregnancy.Outcome)) AS Outcome,
							   PregnancyIndicator.PregnancyStatusId,
							   Pregnancy.Outcome OutcomeStatus,
							   PregnancyIndicator.PlanningToGetPregnant,
							   lt.[Name] as [PlanningGetPregnant]
							
FROM            dbo.Pregnancy  inner JOIN
                         dbo.PregnancyIndicator ON dbo.PregnancyIndicator.PatientId = dbo.Pregnancy.PatientId AND dbo.PregnancyIndicator.PatientMasterVisitId = dbo.Pregnancy.PatientMasterVisitId
						 left join LookupItem lt on lt.Id=PregnancyIndicator.PlanningToGetPregnant)pov on pov.PatientId =pe.PatientId and pov.PatientMasterVisitId=pe.PatientMasterVisitId
left join( select * from (select pid.PatientId,pid.IdentifierTypeId,pid.IdentifierValue,pdd.Code,pdd.DisplayName,pdd.[Name],pid.CreateDate,pid.DeleteFlag,ROW_NUMBER() OVER(partition by pid.PatientId order by pid.CreateDate desc) rownum from PatientIdentifier pid
inner join (
select id.Id,id.[Name],id.[Code],id.[DisplayName]  from Identifiers id
inner join  IdentifierType it on it.Id =id.IdentifierType
where it.Name='Patient')pdd on pdd.Id=pid.IdentifierTypeId  where pdd.[Code]= 'ANCNumber'
and (pid.DeleteFlag is null or pid.DeleteFlag =0))pidd where pidd.rownum ='1')panc on panc.PatientId=pe.PatientId
left join(select p.PatientId,p.PatientMasterVisitId,p.FamilyPlanningStatusId,ltr.DisplayName as [Reason_not_using_family_planning],lt.[DisplayName] as FamilyPlanningStatus,ltf.DisplayName as FamilyPlanningMethod from  PatientFamilyPlanning p
left join PatientFamilyPlanningMethod pfm on pfm.PatientFPId=p.Id
left join LookupItem ltf on ltf.Id =pfm.FPMethodId
inner join LookupItem lt on lt.Id =p.FamilyPlanningStatusId
left join LookupItem ltr on ltr.Id=p.ReasonNotOnFPId
)pfm on pfm.PatientId=pe.PatientId and pfm.PatientMasterVisitId=pe.PatientMasterVisitId
left join(select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e
)ex where ex.ExaminationType='GeneralExamination'
)ex where ex.rownum ='1') ge on ge.PatientId=pe.PatientId and ge.PatientMasterVisitId =pe.PatientMasterVisitId
left join(select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' and Ex.Exam='Eyes'

)ex 
where ex.rownum ='1'
)ey on ey.PatientId =pe.PatientId and ey.PatientMasterVisitId=pe.PatientMasterVisitId

left join(select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' and Ex.Exam='Skin'

)ex 
where ex.rownum ='1'
)sk on sk.PatientId =pe.PatientId and sk.PatientMasterVisitId=pe.PatientMasterVisitId
left join(select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' and Ex.Exam='Chest'

)ex 
where ex.rownum ='1'
)ch on ch.PatientId =pe.PatientId and ch.PatientMasterVisitId=pe.PatientMasterVisitId
left join(select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' and Ex.Exam='ENT'

)ex 
where ex.rownum ='1'
)ent on ent.PatientId =pe.PatientId and ent.PatientMasterVisitId=pe.PatientMasterVisitId



left join(select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' and Ex.Exam='CVS'

)ex 
where ex.rownum ='1'
)cvs on cvs.PatientId =pe.PatientId and cvs.PatientMasterVisitId=pe.PatientMasterVisitId

left join(select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' and Ex.Exam='Abdomen'

)ex 
where ex.rownum ='1'
)ab on ab.PatientId =pe.PatientId and ab.PatientMasterVisitId=pe.PatientMasterVisitId

left join(select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' and Ex.Exam='CNS'

)ex 
where ex.rownum ='1'
)cns on cns.PatientId =pe.PatientId and cns.PatientMasterVisitId=pe.PatientMasterVisitId
left join (select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' and Ex.Exam like 'Genito-urinary'

)ex 
where ex.rownum ='1'

)gn on gn.PatientId =pe.PatientId and gn.PatientMasterVisitId=pe.PatientMasterVisitId

left join (select * from (SELECT *,ROW_NUMBER() OVER(partition by ex.PatientMasterVisitId,ex.PatientId order by ex.CreateDate desc)rownum FROM(SELECT       
    Id,
    PatientMasterVisitId,
    PatientId,
    ExaminationTypeId,
	(SELECT top 1 l.Name FROM LookupMaster l WHERE l.Id=e.ExaminationTypeId) ExaminationType,
	ExamId, 
	(SELECT top 1 l.DisplayName FROM LookupItem l WHERE l.Id=e.ExamId) Exam,
	DeleteFlag,
	CreateBy,	  
	CreateDate,
	FindingId, 
	(SELECT top 1 l.ItemName FROM LookupItemView l WHERE l.ItemId=e.FindingId) Findings,
    FindingsNotes,'Yes' as System_review_finding
FROM            dbo.PhysicalExamination e

)ex where ex.ExaminationType='ReviewOfSystems' 

)ex 
where ex.rownum ='1'
)
srs on srs.PatientId =pe.PatientId and srs.PatientMasterVisitId=pe.PatientMasterVisitId


left join(select  * from (select * ,ROW_NUMBER() OVER(partition by pd.PatientId
,pd.PatientMasterVisitId order by pd.CreateDate desc)rownum from (select pd.PatientId,pd.PatientMasterVisitId,pd.ManagementPlan ,ic.[Name] as Diagnosis,pd.CreateDate from (
select   pd.PatientId,pd.PatientMasterVisitId,CASE WHEN isNumeric(pd.Diagnosis)= 0 then NULL else pd.Diagnosis end as Diagnosis,pd.ManagementPlan,pd.CreateDate from PatientDiagnosis pd
where pd.LookupTableFlag= 0 and pd.DeleteFlag is null or pd.DeleteFlag=0 
)pd 
inner join mst_ICDCodes ic on ic.Id=pd.Diagnosis
union all
select   pd.PatientId,pd.PatientMasterVisitId,pd.ManagementPlan,pd.Diagnosis,
pd.CreateDate from PatientDiagnosis pd
where pd.LookupTableFlag= 1 and pd.DeleteFlag is null or pd.DeleteFlag =0
and ISNUMERIC(pd.Diagnosis) =0
union all

select pd.PatientId,pd.PatientMasterVisitId,pd.ManagementPlan,lt.DisplayName as [Diagnosis],pd.CreateDate from (
select   pd.PatientId,pd.PatientMasterVisitId,pd.ManagementPlan,pd.Diagnosis,
pd.CreateDate from PatientDiagnosis pd
where pd.LookupTableFlag= 1 and pd.DeleteFlag is null or pd.DeleteFlag =0
and ISNUMERIC(pd.Diagnosis) =1)pd inner join LookupItem lt on lt.Id=pd.Diagnosis

 )pd)pd where pd.rownum =1)pd on pd.PatientId=pe.PatientId and pd.PatientMasterVisitId=pe.PatientMasterVisitId

 left join(select * from (select ao.Id,ao.PatientId,ao.PatientMasterVisitId,ao.Score,ROW_NUMBER() OVER(partition by ao.PatientId,
 ao.PatientMasterVisitId order by ao.CreateDate desc)rownum,
ao.AdherenceType,lm.[Name] as AdherenceTypeName, lti.DisplayName as ScoreName ,ao.DeleteFlag,pmv.VisitDate from AdherenceOutcome  ao
inner join  LookupMaster  lm on lm.Id=ao.AdherenceType
inner join LookupItem lti on lti.Id=ao.Score
inner join PatientMasterVisit pmv on pmv.Id =ao.PatientMasterVisitId
WHERE lm.[Name]='ARVAdherence' and (ao.DeleteFlag is null or ao.DeleteFlag  =0))adv where adv.rownum ='1')adv
on adv.PatientId =pe.PatientId and adv.PatientMasterVisitId=pe.PatientMasterVisitId

 left join(select * from (select ao.Id,ao.PatientId,ao.PatientMasterVisitId,ao.Score,ROW_NUMBER() OVER(partition by ao.PatientId,
 ao.PatientMasterVisitId order by ao.CreateDate desc)rownum,
ao.AdherenceType,lm.[Name] as AdherenceTypeName, lti.DisplayName as ScoreName ,ao.DeleteFlag,pmv.VisitDate from AdherenceOutcome  ao
inner join  LookupMaster  lm on lm.Id=ao.AdherenceType
inner join LookupItem lti on lti.Id=ao.Score
inner join PatientMasterVisit pmv on pmv.Id =ao.PatientMasterVisitId
WHERE lm.[Name]='CTXAdherence' and (ao.DeleteFlag is null or ao.DeleteFlag  =0))adv where adv.rownum ='1')ctx
on ctx.PatientId =pe.PatientId and ctx.PatientMasterVisitId=pe.PatientMasterVisitId

left join(select * from (select  a.PatientId,a.PatientMasterVisitId,case when a.ForgetMedicine=0 then 'No' when a.ForgetMedicine='1' then 'Yes' end  as  Morisky_forget_taking_drugs,
CASE WHEN a.CarelessAboutMedicine= 0 then 'No' WHEN a.CarelessAboutMedicine ='1' then 'Yes' end  as Morisky_careless_taking_drugs,
CASE WHEN a.FeelWorse= 0 then 'No' WHEN a.FeelWorse='1' then 'Yes' end  as Morisky_stop_taking_drugs_feeling_worse,
CASE WHEN a.FeelBetter= 0 then 'No'  when a.FeelBetter ='1' then 'Yes' end  as Morisky_stop_taking_drugs_feeling_better,
CASE WHEN a.TakeMedicine =0 then 'No' when a.TakeMedicine ='1' then 'Yes' end as Morisky_took_drugs_yesterday,
CASE WHEN a.StopMedicine=0 then 'No' when a.StopMedicine ='1' then 'Yes' end  as Morisky_stop_taking_drugs_symptoms_under_control,
CASE WHEN a.UnderPressure=0 then 'No' when a.UnderPressure ='1' then 'Yes' end  as Morisky_feel_under_pressure_on_treatment_plan,
CASE WHEN a.DifficultyRemembering=0 then 'Never/Rarely' 
WHEN a.DifficultyRemembering=0.25 then 'Once in a while'
WHEN a.DifficultyRemembering=0.5 then 'Sometimes'
WHEN a.DifficultyRemembering=0.75 then 'Usually'
WHEN a.DifficultyRemembering=1 then 'All the Time' end 
 as Morisky_how_often_difficulty_remembering ,ROW_NUMBER() OVER(partition by a.PatientId,a.PatientMasterVisitId order by a.Id desc)rownum
 from AdherenceAssessment a where Deleteflag =0 )
 ad where ad.rownum='1')adass on adass.PatientId=pe.PatientId and adass.PatientMasterVisitId=pe.PatientMasterVisitId
 left join (select  * from (select   pd.PatientId,pd.PatientMasterVisitId,CASE when pcd.DisplayName is not null then 'Yes' else 'No' end  as Condom_Provided,pd.DeleteFlag ,
CASE when SA.DisplayName  is not null then 'Yes' else' No' end as Screened_for_substance_abuse,
CASE when dis.DisplayName is not null then 'Yes' else 'No' end  as Pwp_Disclosure,
CASE when pt.DisplayName is not null then 'Yes' else 'No' end  as  Pwp_partner_tested,
CASE when st.DisplayName is not null then 'Yes' else 'No' end  as  Screened_for_sti
,ROW_NUMBER() OVER(partition by pd.PatientId,pd.PatientMasterVisitId order by pd.Id desc)rownum
from 
 PatientPHDP pd
 left  join (select pd.PatientId,pd.PatientMasterVisitId,pd.Phdp ,l.DisplayName from 
 PatientPHDP pd  inner join LookupItem l on l.Id=pd.Phdp and l.[Name]='CD')pcd on pcd.PatientMasterVisitId=pd.PatientMasterVisitId 
 left  join (select pd.PatientId,pd.PatientMasterVisitId,pd.Phdp ,l.DisplayName from 
 PatientPHDP pd  inner join LookupItem l on l.Id=pd.Phdp and l.[Name]='SA')SA on SA.PatientMasterVisitId=pd.PatientMasterVisitId
 left join (select pd.PatientId,pd.PatientMasterVisitId,pd.Phdp ,l.DisplayName from 
 PatientPHDP pd  inner join LookupItem l on l.Id=pd.Phdp and l.[Name]='DIS')dis on dis.PatientMasterVisitId=pd.PatientMasterVisitId
left  join (select pd.PatientId,pd.PatientMasterVisitId,pd.Phdp ,l.DisplayName from PatientPHDP pd  inner join LookupItem l on l.Id=pd.Phdp and l.[Name]='STI')st on st.PatientMasterVisitId=pd.PatientMasterVisitId
 left join (select pd.PatientId,pd.PatientMasterVisitId,pd.Phdp ,l.DisplayName from 
 PatientPHDP pd  inner join LookupItem l on l.Id=pd.Phdp and l.[Name]='PT')pt on pt.PatientMasterVisitId=pd.PatientMasterVisitId
  --left join LookupItem lt on lt.Id=pd.Phdp and lt.[Name]='SA'

 where  pd.DeleteFlag is null  or pd.DeleteFlag=0)pd where pd.rownum= '1') phdp on  phdp.PatientId=pe.PatientId and  phdp.PatientMasterVisitId=pe.PatientMasterVisitId
 left join(select pa.PatientId,pa.PatientMasterVisitId,pa.AppointmentReason as Next_appointment_reason,pa.Appointment_type,pa.AppointmentDate as Next_appointment_date from(select pa.PatientId,pa.PatientMasterVisitId,pa.AppointmentDate,pa.DifferentiatedCareId ,pa.ReasonId,li.DisplayName as AppointmentReason,ROW_NUMBER() OVER(partition by pa.PatientId,pa.PatientMasterVisitId order by pa.CreateDate desc)rownum ,lt.DisplayName as Appointment_type,pa.DeleteFlag,pa.ServiceAreaId,pa.CreateDate from PatientAppointment pa
inner join LookupItem li on li.Id =pa.ReasonId
inner join LookupItem lt on lt.Id=pa.DifferentiatedCareId 

where pa.DeleteFlag is null or pa.DeleteFlag= 0
)pa where  pa.rownum =1
)papp on papp.PatientId=pe.PatientId and papp.PatientMasterVisitId=pe.PatientMasterVisitId
left join(select * from (select pc.PatientId,pc.PatientMasterVisitId,CASE WHEN  pc.Categorization =2 then 'Unstable' WHEN pc.Categorization =1 then 'Stable' end as Stability
,ROW_NUMBER( )OVER(partition by pc.PatientId ,pc.PatientMasterVisitId order by pc.id desc)rownum   from PatientCategorization pc)pc where pc.rownum=1)pcc on pcc.PatientId=pe.PatientId
and pcc.PatientMasterVisitId=pe.PatientMasterVisitId
left join(select pad.PatientId,pad.PatientMasterVisitId,'Yes'   as DifferentiatedCare from PatientArtDistribution pad where DeleteFlag = 0 or DeleteFlag is null)pdd
on pdd.PatientId =pe.PatientId and pdd.PatientMasterVisitId=pe.PatientMasterVisitId
left join(select * from (select psc.PatientId,psc.PatientMasterVisitId,lm.[DisplayName] as ScreeningType,psc.DeleteFlag,psc.VisitDate,psc.ScreeningDate,psc.CreateDate,
lt.DisplayName as ScreeningValue,ROW_NUMBER() OVER(partition by psc.PatientId,psc.PatientMasterVisitId  order by psc.CreateDate desc)rownum
 from PatientScreening  psc
 inner join LookupMaster lm on lm.[Id] =psc.ScreeningTypeId
 inner join LookupItem lt on  lt.Id=psc.ScreeningValueId
 where lm.[Name] ='CacxScreening' and (psc.DeleteFlag is null or psc.DeleteFlag =0))psc where psc.rownum='1')cacx on cacx.PatientId=pe.PatientId and
 cacx.PatientMasterVisitId=pe.PatientMasterVisitId
 where lt.[Name]='ccc-encounter' 
 

 