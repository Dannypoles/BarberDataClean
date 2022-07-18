
--Create Temp Table with counts of barbers per county

SELECT BUSINESS_COUNTY, COUNT(*) AS Total
INTO #BarberCountTemp
FROM TutorialDB.dbo.TotalBarbers
GROUP BY BUSINESS_COUNTY
---------------------------------------------------------------------------------------------

--Check for null BUSINESS_COUNTY values

SELECT *
FROM TutorialDB.dbo.TotalBarbers
WHERE BUSINESS_COUNTY IS NULL
---------------------------------------------------------------------------------------------

--COUNTY matches BUSINESS_COUNTY (based on BUSINESS_COUNTY_CODE) at all null BUSINESS_COUNTY 
--values where COUNTY is not null, so we set the columns equal at null BUSINESS_COUNTY values

UPDATE TutorialDB.dbo.TotalBarbers
SET BUSINESS_COUNTY = COUNTY
    WHERE BUSINESS_COUNTY IS NULL
---------------------------------------------------------------------------------------------

--Make County values in CountyPopByRace the same as COUNTY in ltbarber

SELECT County, UPPER(SUBSTRING(County,1,LEN(County)-14)) AS CountyUP
FROM TutorialDB.dbo.CountyPopByRace

UPDATE TutorialDB.dbo.CountyPopByRace
SET County = UPPER(SUBSTRING(County,1,LEN(County)-14))
---------------------------------------------------------------------------------------------

--Create a new table containing all information from CountyPopByRace with the
--additional total barbers column

SELECT *
INTO TutorialDB.dbo.FINAL
FROM #BarberCountTemp a
FULL OUTER JOIN TutorialDB.dbo.CountyPopByRace b
ON a.BUSINESS_COUNTY = b.County
---------------------------------------------------------------------------------------------

--Delete rows where population cannot be determined (i.e, null County value)

DELETE FROM TutorialDB.dbo.FINAL
WHERE County IS NULL
---------------------------------------------------------------------------------------------

--Null values in Total column imply 0, so we replace all instances

UPDATE TutorialDB.dbo.FINAL
SET Total = ISNULL(Total, 0 )
---------------------------------------------------------------------------------------------

--Finally, we remove the BUSINESS COUNTY column since we no longer need it

ALTER TABLE TutorialDB.dbo.FINAL
DROP COLUMN BUSINESS_COUNTY
---------------------------------------------------------------------------------------------

--Check final table

SELECT *
FROM TutorialDB.dbo.FINAL
---------------------------------------------------------------------------------------------

--Finally, we export our final table using export wizard
