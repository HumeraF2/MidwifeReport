--create a midwifery performance report
--Please show me a count of all outcomes from the consent view against each midwive for every month from march 22
USE [TestSQL]
GO

Midwife Name, Month-Year, Count of all the different outcomes in seperate columns so like Yes No Unable to ask etc

SELECT * from [BHTS-RESEARCH2].WHMATERNITY.[dbo].[CernerMaternityEligible_BiB4All]

-- CONSENT_GIVEN = Yes, No, Not able to ask, Patient unsure

SELECT * FROM [BHTS-RESEARCH2].WHMATERNITY.[dbo].[CernerAntenatalBookings]
--Named_Midwife
--Date_of_Booking

WITH CONSENTCOUNT AS (

SELECT
		 Personnel_First_Completed_Form as Midwife, 
		 left(FORM_DT_TM,7)as Month_Year,
		 SUM(CASE WHEN [CONSENT_GIVEN_TO_BE_IN_BIB4ALL_PATIENT] = 'Yes' THEN 1 ELSE 0 END) as Yes_Count,
		 SUM(CASE WHEN [CONSENT_GIVEN_TO_BE_IN_BIB4ALL_PATIENT] = 'No' THEN 1 ELSE 0 END) as No_Count,
		 SUM(CASE WHEN [CONSENT_GIVEN_TO_BE_IN_BIB4ALL_PATIENT] = 'Not able to ask' THEN 1 ELSE 0 END) as Not_able_to_ask_Count,
		 SUM(CASE WHEN [CONSENT_GIVEN_TO_BE_IN_BIB4ALL_PATIENT] = 'Patient unsure' THEN 1 ELSE 0 END) as Patient_unsure_Count


from [BHTS-DATAWH2].[Information].[research].[MATERNITY_REPORT_BIB4ALL_CONSENT] 

GROUP BY 
Personnel_First_Completed_Form, 
left(FORM_DT_TM,7)

)

SELECT 

		Midwife,
		Month_Year,
		MAX(Yes_Count) as Yes_Count,
		MAX(No_Count)as No_Count,
		MAX(Not_able_to_ask_Count) as Not_able_to_ask_Count ,
		MAX(Patient_unsure_Count) as Patient_unsure_Count,
		SUM(Yes_Count + No_Count + Not_able_to_ask_Count + Patient_unsure_Count) as Total_Count
		
FROM CONSENTCOUNT

GROUP BY
Midwife,
Month_Year

ORDER BY
Total_Count Desc,
Midwife,
Month_Year;
