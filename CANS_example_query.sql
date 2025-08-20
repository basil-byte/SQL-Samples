--CANS comparing most recent CANS with the most recent initial CANS


DECLARE
@StartDate datetime,
@EndDate datetime,
@Programs int,
@ExecutedByStaffId int;


SET @StartDate = '1/1/2025';
SET @EndDate = '3/31/2025';
SET @Programs = [MY TEST PROGRAM];
SET @ExecutedByStaffId = [MY TEST STAFF ID];

WITH CTE AS (--Find all CANS
select 
	cp.EnrolledDate,
	cp.RequestedDate,
	cp.DischargedDate,
	DocumentId, 
	D.ClientId,  
	EffectiveDate, 
	D.ProgramId, 
	Program = (SELECT ProgramName FROM Programs p where p.programId = D.ProgramId),
	D.ClientProgramId,
	G.AssessmentType,
[Sum of Behavioral/ Emotional Needs AN] =
	CASE WHEN ISNULL(CAST(GBEH.[Psychosis] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[ImpulsivityHyperactivity] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[Depression] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[Anxiety] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[Oppositional] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[Conduct] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[AngerControl] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[SubstanceUse] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[AdjustmenttoTrauma] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(GBEH.[EatingDisturbance] as int),0)  >= 2 THEN 1 ELSE 0 END +
--EC Form
    CASE WHEN ISNULL(CAST(ECBEH.[ImpulsivityHyperactivity] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(ECBEH.[Depression] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(ECBEH.[Anxiety] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(ECBEH.[Oppositional] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(ECBEH.[AttachmentDifficulties] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(ECBEH.[AdjustmenttoTrauma] as int),0) >= 2 THEN 1 ELSE 0 END +
    CASE WHEN ISNULL(CAST(ECBEH.[Motor] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECBEH.[Regulatory] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECBEH.[AtypicalBehaviors] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECBEH.[Aggression] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECBEH.[AutismSpectrum] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECBEH.[SleepMonths] as int),0) >= 2 THEN 1 ELSE 0 END
	,

[Sum of Cultural Factors AN] = 
	CASE WHEN ISNULL(CAST(GCUL.[CulturalFactorsLanguage] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GCUL.[TraditionsAndRituals] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GCUL.[CulturalStress] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GCUL.[CulturalDifferencesWithinTheFamily] as int),0) >= 2 THEN 1 ELSE 0 END +
--EC Form
	CASE WHEN ISNULL(CAST(ECCUL.[CulturalLanguage] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECCUL.[TraditionsAndRituals] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECCUL.[CulturalStress] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECCUL.[CulturalDifferencesWithinTheFamily] as int),0) >=2 THEN 1 ELSE 0 END
	,

[Sum of Life Domain Functioning AN] = 
	CASE WHEN ISNULL(CAST(GLF.[FamilyFunctioning] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[LivingSituation] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[SocialFunctioning] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[DevelopmentalIntellectual] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[DecisionMaking] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[SchoolBehavior] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[SchoolAchievement] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[SchoolAttendance] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[MedicalPhysical] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[SexualDevelopment] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[Sleep] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[Legal] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[Recreational] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GLF.[IndependentLivingSkills] as int),0) >= 2 THEN 1 ELSE 0 END +

	CASE WHEN ISNULL(CAST(ECLF.[FamilyFunctioning] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECLF.[EarlyEducation] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECLF.[SocialAndEmotionalFunctioning] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECLF.[DevelopmentalIntellectual] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECLF.[MedicalPhysical] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECLF.[Cognition] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECLF.[SensoryReactivity] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECLF.[FeedingElimination] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECLF.[Sleep] as int),0) >= 2 THEN 1 ELSE 0 END
	,

[Sum of Strengths AN] = 
	CASE WHEN ISNULL(CAST(GSTR.[FamilyStrengths] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[Interpersonal] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[EducationalSetting] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[TalentsAndInterests] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[SpiritualReligious] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[CulturalIdentity] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[CommunityLife] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[NaturalSupports] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[Resilience] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[Optimism] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[Vocational] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[CopingAndSavoringSkills] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[RelationshipPermanence] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(GSTR.[Resourcefulness] as int),0) >= 2 THEN 1 ELSE 0 END +

	CASE WHEN ISNULL(CAST(ECSTR.[FamilyStrength] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECSTR.[Interpersonal] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECSTR.[NaturalSupports] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECSTR.[Resiliency] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECSTR.[Playfulness] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECSTR.[FamilySpiritualReligious] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECSTR.[CreativityImagination] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECSTR.[Curiosity] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(ECSTR.[RelationshipsPermanence] as int),0) >= 2 THEN 1 ELSE 0 END
	,
	
[Sum of Caregiver Needs AN] = 
	CASE WHEN ISNULL(CAST(CRN.[Supervision] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[InvolvementWithCare] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[Knowledge] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[SocialResources] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[ResidentialStability] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[MedicalPhysical] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[MentalHealth] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[SubstanceUse] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[Developmental] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[Safety] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[FamilyStress] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[FamilyRelTotheSystem] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[LegalInvolvement] as int),0) >= 2 THEN 1 ELSE 0 END +
	CASE WHEN ISNULL(CAST(CRN.[Organization] as int),0) >= 2 THEN 1 ELSE 0 END,

	[Sum of Risk Behaviors AN] = 
		CASE WHEN ISNULL(CAST(GRSK.[SuicideRisk] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(GRSK.[NonSuicidalSelfInjuriousBehavior] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(GRSK.[OtherSelfHarm] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(GRSK.[DangerToOthers] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(GRSK.[SexualAggression] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(GRSK.[DelinquentBehavior] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(GRSK.[Runaway] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(GRSK.[IntentionalMisbehavior] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(GRSK.[SexualExploitation] as int),0) >= 2 THEN 1 ELSE 0 END +

		CASE WHEN ISNULL(CAST(REPLACE(ECRSK.[SelfHarm],'A','0') as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(ECRSK.[Exploited] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(ECRSK.[PrenatalCare] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(ECRSK.[Exposure] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(ECRSK.[LaborAndDelivery] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(ECRSK.[BirthWeight] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(ECRSK.[FailureToThrive] as int),0) >= 2 THEN 1 ELSE 0 END +
		CASE WHEN ISNULL(CAST(ECRSK.[MaternalPrimaryCaregiverAvail] as int),0) >= 2 THEN 1 ELSE 0 END,

[Trauma AN] = CASE 
	WHEN TTP.Trauma = 0 THEN 'No Risk (0 ACEs)'
	WHEN TTP.Trauma BETWEEN 1 AND 3 THEN 'Intermediate Risk (1-3 ACEs)'
	WHEN TTP.Trauma >= 4 THEN 'High Risk (4+ ACEs)'
	ELSE NULL END

from
	Documents D
	inner join
	ClientPrograms cp on D.ClientProgramId = cp.ClientProgramId and isnull(cp.RecordDeleted,'N')='N'
	left outer join
	CANSGenerals G on D.currentdocumentversionid = G.DocumentVersionId and isnull(G.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralBehavioralEmotions as GBEH on D.currentdocumentversionid = GBEH.DocumentVersionId and isnull(GBEH.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralCulturalFactorsDomains as GCUL on D.currentdocumentversionid = GCUL.DocumentVersionId and isnull(GCUL.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralLFDomains as GLF on D.currentdocumentversionid = GLF.DocumentVersionId and isnull(GLF.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralRiskBehaviors as GRSK on D.currentdocumentversionid = GRSK.DocumentVersionId and isnull(GRSK.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralStrengthsDomains as GSTR on D.currentdocumentversionid = GSTR.DocumentVersionId and isnull(GSTR.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralECBehavioralEmotions as ECBEH on D.currentdocumentversionid = ECBEH.DocumentVersionId and isnull(ECBEH.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralECCulturalFactors as ECCUL on D.currentdocumentversionid = ECCUL.DocumentVersionId and isnull(ECCUL.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralECLFDomains as ECLF on D.currentdocumentversionid = ECLF.DocumentVersionId and isnull(ECLF.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralECRiskBehaviors as ECRSK on D.currentdocumentversionid = ECRSK.DocumentVersionId and isnull(ECRSK.recorddeleted, 'N') = 'N'
	left outer join
	CANSGeneralECIndividualStrengths as ECSTR on D.currentdocumentversionid = ECSTR.DocumentVersionId and isnull(ECSTR.recorddeleted, 'N') = 'N'
	left outer join 
	CANSCaregiverResourcesNeeds as CRN on D.CurrentDocumentVersionId = CRN.DocumentVersionId and isnull(CRN.RecordDeleted, 'N') = 'N'
		AND [CaregiverNeedId] = (SELECT MIN(CRN2.[CaregiverNeedId]) 
													FROM [CANSCaregiverResourcesNeeds] CRN2
													WHERE CRN2.DocumentVersionId = CRN.DocumentVersionId)

	left outer join
	(
		SELECT
	  DOC.ClientId
	  ,[Trauma] = MAX( --If trauma is ever reported, it doesn't need to be reported again for it to remain on the record
	    IIF(TTP.SexualAbuse='Y',1,0)
      + IIF(TTP.PhysicalAbuse='Y',1,0)
      + IIF(TTP.[Neglect]='Y',1,0)
      + IIF(TTP.[EmotionalAbuse]='Y',1,0)
      + IIF(TTP.[MedicalTrauma]='Y',1,0)
      + IIF(TTP.[NaturalOrManmadeDisaster]='Y',1,0)
      + IIF(TTP.[WitnessToFamilyViolence]='Y',1,0)
      + IIF(TTP.[WitnessToCommunitySchoolViolence]='Y',1,0)
      + IIF(TTP.[WarTerrorismAffected]='Y',1,0)
      + IIF(TTP.[WitnessVictimOfCriminalActs]='Y',1,0)
      + IIF(TTP.[ParentalCriminalBehavior]='Y',1,0)
      + IIF(TTP.[DisruptionInCaregivingAttachmentLosses]='Y',1,0)
	  )

  FROM [CANSTraumaTransitionPotentials] TTP
  	JOIN Documents DOC on DOC.CurrentDocumentVersionId = TTP.DocumentVersionId
  WHERE ISNULL(TTP.[RecordDeleted],'N')='N'
  AND DOC.EffectiveDate <= @EndDate
  GROUP BY DOC.ClientId
	) as TTP on D.ClientId = TTP.ClientId

where 1=1
	and D.documentcodeid = 60142  -- CANS
	and D.status = 22   --signed
	and isnull(D.recorddeleted, 'N') = 'N'
	and CurrentDocumentVersionId = (select DocumentVersionId from DocumentVersions where CurrentDocumentVersionId = DocumentVersionId)
	AND D.EffectiveDate <= @EndDate
	AND CONVERT(int,ROUND(DATEDIFF(hour,(SELECT c.DOB FROM Clients c WHERE c.ClientId = D.ClientId),D.EffectiveDate)/8766.0,0)) BETWEEN 6 AND 20 --only show enrollments where clients are aged between 6 and 20 years old

)

--Full query
SELECT 
RecentCANS.EnrolledDate,
RecentCANS.DischargedDate,
RecentCANS.DocumentId,
RecentCANS.EffectiveDate,
RecentCANS.ClientId,
[Client Id 6 Months] = CASE
	WHEN RecentCANS.EffectiveDate >= DATEADD(month,-6,@EndDate) THEN RecentCANS.ClientId
	END,
RecentCANS.ProgramId,
RecentCANS.Program,
RecentCANS.ClinicalDataAccessGroupId,
RecentCANS.ClientProgramId,
RecentCANS.AssessmentType,

COALESCE(IniCANS.EnrolledDate,NoIniCANS.EnrolledDate) as InitialEnrolledDate,
COALESCE(IniCANS.DischargedDate,NoIniCANS.DischargedDate) as InitialDischargedDate,
COALESCE(IniCANS.DocumentId,NoIniCANS.DocumentId) as InitialDocumentId,
COALESCE(IniCANS.EffectiveDate,NoIniCANS.EffectiveDate) as InitialEffectiveDate,
COALESCE(IniCANS.ClientId,NoIniCANS.ClientId) as InitialClientId,
COALESCE(IniCANS.ProgramId,NoIniCANS.ProgramId) as InitialProgramId,
COALESCE(IniCANS.Program,NoIniCANS.Program) as InitialProgram,
COALESCE(IniCANS.ClinicalDataAccessGroupId,NoIniCANS.ClinicalDataAccessGroupId) as InitialClinicalDataAccessGroupId,
COALESCE(IniCANS.ClientProgramId,NoIniCANS.ClientProgramId) as InitialClientProgramId,

--ACTIONABLE NEEDS
[Sum of Behavioral/ Emotional Needs AN 1] = COALESCE(IniCANS.[Sum of Behavioral/ Emotional Needs AN],NoIniCANS.[Sum of Behavioral/ Emotional Needs AN]),
[Sum of Behavioral/ Emotional Needs AN Last] = RecentCANS.[Sum of Behavioral/ Emotional Needs AN],

[Sum of Cultural Factors AN 1] = COALESCE(IniCANS.[Sum of Cultural Factors AN],NoIniCANS.[Sum of Cultural Factors AN]),
[Sum of Cultural Factors AN Last] = RecentCANS.[Sum of Cultural Factors AN],

[Sum of Life Domain Functioning AN 1] = COALESCE(IniCANS.[Sum of Life Domain Functioning AN],NoIniCANS.[Sum of Life Domain Functioning AN]),
[Sum of Life Domain Functioning AN Last] = RecentCANS.[Sum of Life Domain Functioning AN],

[Sum of Strengths AN 1] = COALESCE(IniCANS.[Sum of Strengths AN],NoIniCANS.[Sum of Strengths AN]),
[Sum of Strengths AN Last] = RecentCANS.[Sum of Strengths AN],

[Sum of Risk Behaviors AN 1] = COALESCE(IniCANS.[Sum of Risk Behaviors AN],NoIniCANS.[Sum of Risk Behaviors AN]),
[Sum of Risk Behaviors AN Last] = RecentCANS.[Sum of Risk Behaviors AN],

[Sum of Caregiver Needs AN 1] =  COALESCE(IniCANS.[Sum of Caregiver Needs AN],NoIniCANS.[Sum of Caregiver Needs AN]),
[Sum of Caregiver Needs AN Last] = RecentCANS.[Sum of Caregiver Needs AN],

RecentCANS.[Trauma AN]

FROM
--Find the most recent CANS
	(select 
		CTE.*,
		MostRecentCANS = DENSE_RANK() OVER (PARTITION BY ClientId ORDER BY EffectiveDate desc)
	from CTE

	where 1=1
		and CTE.ProgramId in (@Programs) -- the filtered program only applies to the most recent CANS
		AND ISNULL(CTE.EnrolledDate,CTE.RequestedDate) <= ISNULL(@EndDate,ISNULL(CTE.EnrolledDate,CTE.RequestedDate))
		AND	ISNULL(CTE.DischargedDate,@StartDate) >= @StartDate
		AND CTE.EffectiveDate <= @EndDate
		AND CTE.EffectiveDate >= DATEADD(month,-12,@StartDate) --only including the most recent CANS within the last 12 months of the start date
) RecentCANS
left join

--Find all initial CANS
(SELECT *
FROM CTE
WHERE CTE.AssessmentType = 'I'
) IniCANS
	on IniCANS.ClientId = RecentCANS.ClientId
	and (CASE WHEN RecentCANS.AssessmentType = 'I' THEN 1 ELSE 0 END) = 0 --Only join if it's not an initial CANS
	and RecentCANS.EffectiveDate >= IniCANS.EffectiveDate --Only show initial CANS that come before the most recent CANS
	and IniCANS.EffectiveDate = (SELECT MAX(CTE.EffectiveDate) --Only show the most recent initial CANS
								from
									CTE
								where 1=1
									AND CTE.AssessmentType = 'I'
									AND IniCANS.ClientId = CTE.ClientId
									AND CTE.EffectiveDate <= RecentCANS.EffectiveDate
									)
LEFT JOIN
--Find all CANS without initial ever
(SELECT *
FROM CTE
WHERE CTE.AssessmentType <> 'I'
) NoIniCANS
	on NoIniCANS.ClientId = RecentCANS.ClientId
	and (CASE WHEN RecentCANS.AssessmentType = 'I' THEN 1 ELSE 0 END) = 0 --Only join if it's not an initial CANS
	and RecentCANS.EffectiveDate >= NoIniCANS.EffectiveDate --Only show initial CANS that come before the most recent CANS
	and NoIniCANS.EffectiveDate = (SELECT Min(CTE.EffectiveDate) --Only show the most recent initial CANS
								from
									CTE
								where 1=1
									AND CTE.AssessmentType <> 'I'
									AND NoIniCANS.ClientId = CTE.ClientId
									AND CTE.EffectiveDate < RecentCANS.EffectiveDate
									)


WHERE 1=1

and RecentCANS.MostRecentCANS = 1 --limits results to only the most recent CANS
