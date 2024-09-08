USE [Mini Project];
GO


DROP TABLE IF EXISTS Quali_Rev;
CREATE TABLE Quali_Rev (
	Rev1_ID INT PRIMARY KEY,
	Purchase_Freq VARCHAR(255) NOT NULL,
	Purchase_Cat VARCHAR(255) NOT NULL,
	Reco_Freq1 VARCHAR (255) NOT NULL,
	Cart_Compl_Freq VARCHAR (255) NOT NULL,
	Rev_Left VARCHAR (255) NOT NULL,
	Rev_Reliability VARCHAR (255) NOT NULL,
	Rev_Help VARCHAR (255) NOT NULL,
	Reco_Help VARCHAR (255) NOT NULL,
	Serv_Appr VARCHAR (255) NOT NULL,
	Improv_Area VARCHAR (255) NOT NULL
);

INSERT INTO Quali_Rev 
SELECT
	Costumer_ID,
	Purchase_Frequency,
	Purchase_Categories,
	Personalized_Recommendation_Frequency1,
	Cart_Completion_Frequency,
	Review_Left,
	Review_Reliability,
	Review_Helpfulness,
	Recommendation_Helpfulness,
	Service_Appreciation,
	Improvement_Areas
FROM dbo.ads_amazon_rev


DROP TABLE IF EXISTS Quanti_Rev;
CREATE TABLE Quanti_Rev (
	Rev2_ID INT PRIMARY KEY,
	Rev_Importance FLOAT NOT NULL,
	Reco_Freq2 FLOAT NOT NULL,
	Rating_Accu FLOAT NOT NULL,
	Shopping_Satis FLOAT NOT NULL,
	FOREIGN KEY (Rev2_ID) REFERENCES dbo.Quali_Rev(Rev1_ID)
);

INSERT INTO Quanti_Rev
SELECT
	Costumer_ID,
	Customer_Reviews_Importance,
	[Personalized_Recommendation_Frequency ],
	[Rating_Accuracy ],
	Shopping_Satisfaction
FROM dbo.ads_amazon_rev


/** Checks for duplicate rows*/
SELECT
	a.Cart_Compl_Freq,
	a.Improv_Area,
	a.Purchase_Freq,
	a.Reco_Freq1,
	a.Reco_Help,
	a.Rev_Help,
	a.Rev_Left,
	a.Rev_Reliability,
	b.Rating_Accu,
	b.Reco_Freq2,
	b.Rev_Importance,
	b.Shopping_Satis,
	COUNT(*) [Cnt Duplicate Rows]
FROM Quali_Rev a
JOIN Quanti_Rev b
ON a.Rev1_ID = b.Rev2_ID
GROUP BY a.Cart_Compl_Freq,
	a.Improv_Area,
	a.Purchase_Freq,
	a.Reco_Freq1,
	a.Reco_Help,
	a.Rev_Help,
	a.Rev_Left,
	a.Rev_Reliability,
	b.Rating_Accu,
	b.Reco_Freq2,
	b.Rev_Importance,
	b.Shopping_Satis
HAVING COUNT(*) > 1;


/** Handling null and blank values change into 'Unassigned'*/
UPDATE Quali_Rev 
SET
	Cart_Compl_Freq = COALESCE(NULLIF(Cart_Compl_Freq, ''), 'Unassigned'),
	Improv_Area = COALESCE(NULLIF(Improv_Area, ''), 'Unassigned'),
	Purchase_Freq = COALESCE(NULLIF(Purchase_Freq, ''), 'Unassigned'),
	Reco_Freq1 = COALESCE(NULLIF(Reco_Freq1, ''), 'Unassigned'),
	Reco_Help = COALESCE(NULLIF(Reco_Help, ''), 'Unassigned'),
	Rev_Help = COALESCE(NULLIF(Rev_Help, ''), 'Unassigned'),
	Rev_Left = COALESCE(NULLIF(Rev_Left, ''), 'Unassigned'),
	Rev_Reliability = COALESCE(NULLIF(Rev_Reliability, ''), 'Unassigned');

UPDATE Quanti_Rev
SET
	Rating_Accu = COALESCE(Rating_Accu, 0),
	Reco_Freq2 = COALESCE(Reco_Freq2, 0),
	Rev_Importance = COALESCE(Rev_Importance, 0),
	Shopping_Satis = COALESCE(Shopping_Satis, 0);

