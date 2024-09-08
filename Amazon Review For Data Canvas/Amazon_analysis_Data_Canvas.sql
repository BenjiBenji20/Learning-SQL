USE [Mini Project];
GO

/** PROBLEM*/
/** Counting ff data scores to have visual understanding to the data*/
SELECT
	Shopping_Satis,
	COUNT(*) [Satisfactiion Cnt]
FROM Quanti_Rev
GROUP BY Shopping_Satis;


-- Count serv. appre.
SELECT 
	Serv_Appr,
	COUNT(*) [Serv Appr Cnt]
FROM Quali_Rev
GROUP BY Serv_Appr;


-- Count pur. cat.
SELECT 
	Purchase_Cat,
	COUNT(*) [Purchase Cat Cnt]
FROM Quali_Rev
GROUP BY Purchase_Cat;


-- Count pur. freq.
SELECT 
	Purchase_Freq,
	COUNT(*) [Purchase Freq Cnt]
FROM Quali_Rev
GROUP BY Purchase_Freq;


-- Count rev. left
SELECT
	Rev_Left,
	COUNT(*) [Rev Left Cnt]
FROM Quali_Rev
GROUP BY Rev_Left;


-- Count Improv Area
SELECT
	Improv_Area,
	COUNT(*) cnt
FROM Quali_Rev
GROUP BY Improv_Area;

-- Count reco. helpfulness
SELECT
	Reco_Help,
	COUNT(*) cnt
FROM Quali_Rev
GROUP BY Reco_Help;



/** Check for the averages based on satisfaction*/
-- Comparing each columns to the Shopping_Satisfaction to see the 
SELECT -- check if there is any difference in satisfaction between customers who left reviews and those who didn't.
	Rev_Left,
	COUNT(*) Cnt,
	AVG(Shopping_Satis) [Average Satisfaction]
FROM Quali_Rev a
JOIN Quanti_Rev b
ON a.Rev1_ID = b.Rev2_ID
GROUP BY Rev_Left;



SELECT -- compute the average satisfaction for each level of recommendation helpfulness.
	Reco_Help,
	COUNT(*) Cnt,
	AVG(Shopping_Satis) [Average Satisfaction]
FROM Quali_Rev a
JOIN Quanti_Rev b
ON a.Rev1_ID = b.Rev2_ID
GROUP BY Reco_Help;



SELECT -- To see how different areas needing improvement correlate with customer satisfaction.
	Improv_Area,
	COUNT(*) Cnt,
	AVG(Shopping_Satis) [Average Satisfaction]
FROM Quali_Rev a
JOIN Quanti_Rev b
ON a.Rev1_ID = b.Rev2_ID
GROUP BY Improv_Area;



SELECT -- Does personalized req freq affects the satisfaction of costumer?
	Reco_Freq1,
	COUNT(*) Cnt,
	AVG(Shopping_Satis) [Average Satisfaction]
FROM Quali_Rev a
JOIN Quanti_Rev b
ON a.Rev1_ID = b.Rev2_ID
GROUP BY Reco_Freq1;



SELECT -- Costumer satisfaction affects by cart completion
	Cart_Compl_Freq,
	COUNT(*) Cnt,
	AVG(Shopping_Satis) [Average Satisfaction]
FROM Quali_Rev a
JOIN Quanti_Rev b
ON a.Rev1_ID = b.Rev2_ID
GROUP BY Cart_Compl_Freq;



-- identifying desatisfied costumer
SELECT
	a.Rev1_ID,
	Purchase_Cat,
	Purchase_Freq,
	Shopping_Satis,
	Improv_Area
FROM Quali_Rev a
JOIN Quanti_Rev b
ON a.Rev1_ID = b.Rev2_ID
WHERE Shopping_Satis < 3;



-- Count of bellow and above 3 satisfied costumers
SELECT
	COUNT(*) [Cnt of Above 3 Shopping Satisfaction],
	(SELECT
		COUNT(*)
	FROM Quanti_Rev
	WHERE Shopping_Satis < 3) [Cnt of Below 3 Above 3 Shopping Satisfaction]
FROM Quanti_Rev
WHERE Shopping_Satis >= 3;