/*
	Übung 1: Verbundoperatoren 
SELECT b.name, b.zipcode, b.place, a.id as accntid, a.created
FROM "SYSTEM"."BANKS" as b
INNER JOIN "SYSTEM"."ACCOUNTS" AS a
ON (b.bic = a.bnk_bic);

SELECT b.name, b.zipcode, b.place, a.id as accntid, a.created
FROM "SYSTEM"."BANKS" AS b
LEFT OUTER JOIN "SYSTEM"."ACCOUNTS" AS a
ON b.bic = a.bnk_bic;

SELECT b.name, b.zipcode, b.place, a.id as accntid, a.created
FROM "SYSTEM"."BANKS" AS b
RIGHT OUTER JOIN "SYSTEM"."ACCOUNTS" AS a
ON b.bic = a.bnk_bic;

/*
	Übung 2: Verbundoperatoren 
*/
/*
	Verbinden Sie die Tabellen bp und accounts über einen INNER JOIN (mit ON Anweisung) miteinander
*/
SELECT bp.firstname, bp.lastname, bp.zipcode, bp.place, a.id as accntid, a.bnk_bic
FROM "SYSTEM"."BP" as bp
INNER JOIN "SYSTEM"."ACCOUNTS" AS a
ON a.bp_id = bp.id;

/*
	Test
SELECT bp.firstname, bp.lastname, b.zipcode, b.place, a.id as accntid, a.bnk_bic
FROM "SYSTEM"."BANKS" AS b
INNER JOIN "SYSTEM"."ACCOUNTS" AS a
ON b.bic = a.bnk_bic
INNER JOIN "SYSTEM"."BP" as bp
ON a.bp_id = bp.id
INNER JOIN "SYSTEM"."SALDOS" as s
ON (s.accnt_id = a.id AND s.bnk_bic = a.bnk_bic);
*/

/* 
	Verbinden Sie die Tabelle bp mit der Tabelle accounts über einen LEFT OUTER JOIN miteinander
*/
SELECT bp.firstname, bp.lastname, bp.zipcode, bp.place, a.id as accntid, a.bnk_bic
FROM "SYSTEM"."BP" AS bp
LEFT OUTER JOIN "SYSTEM"."ACCOUNTS" AS a
ON bp.id = a.bp_id;

/* 
	Verbinden Sie die Tabelle bp mit der Tabelle accountsüber einen RIGHT OUTER JOIN miteinander
*/
SELECT bp.firstname, bp.lastname, bp.zipcode, bp.place, a.id as accntid, a.bnk_bic
FROM "SYSTEM"."BP" AS bp
RIGHT OUTER JOIN "SYSTEM"."ACCOUNTS" AS a
ON bp.id = a.bp_id;

/*
	Übung 3: SQL SET Operatoren, Mengenoperatoren in SQL

	Ermittlung aller BICs aus der Tabelle banks, ohne ein Konto in der Tabelle accounts per MINUS/EXCEPT Abfrage
*/

SELECT bic
FROM "SYSTEM"."BANKS"
EXCEPT 
(	SELECT bnk_bic
	FROM "SYSTEM"."ACCOUNTS")
;

/*
SELECT b.bic
FROM "SYSTEM"."BANKS" AS b
RIGHT OUTER JOIN "SYSTEM"."ACCOUNTS" AS a 
ON (b.bic = a.bnk_bic);
*/

/*
	INTERSECT über das Feld Kontonummer der Tabellen accounts und saldos
*/

SELECT a.id
FROM "SYSTEM"."ACCOUNTS" AS a
INTERSECT
(
	SELECT s.accnt_id
	FROM "SYSTEM"."SALDOS" AS s);

-- Unterscheidet sich das Ergebnis von einem INNER JOIN ... ON ...? Wie und Worin? ..... INNER JOIN enthält doppelte Daten; während INTERSECT diese entfernt
SELECT a.id
FROM "SYSTEM"."ACCOUNTS" AS a
INNER JOIN "SYSTEM"."SALDOS" AS s
ON (a.id = s.accnt_id);

/*
	Verdopplung der Datenmenge der Tabelle banks per UNION Operator
*/
SELECT *
FROM "SYSTEM"."BANKS" 
UNION ALL
(
	SELECT *
	FROM "SYSTEM"."BANKS");

	
/*
	Übung 4 - SQL Aggregatfunktionen und arithmetische Operatoren

*/

-- Ermittlung des größten Saldos in der Tabelle saldos(per MAX-Funktion)
SELECT MAX(s.amount) AS GROESTER_SALDO
FROM "SYSTEM"."SALDOS" AS s;

-- Ermittlung des größten Saldos in der Tabelle saldos(per MAX-Funktion) je Konto
SELECT s.accnt_id, s.bnk_bic, MAX(s.amount) AS GROESTER_SALDO
FROM "SYSTEM"."SALDOS" AS s
GROUP BY s.accnt_id, s.bnk_bic;

-- Ermitteln der Anzahl der Salden pro Konto
SELECT s.accnt_id, s.bnk_bic, COUNT(*) AS ANZ_SALDREN
FROM "SYSTEM"."SALDOS" AS s
GROUP BY s.accnt_id, s.bnk_bic;

-- Abfrage des durchschnittlichen Kontostands (AVG-Wert) pro Konto
SELECT s.accnt_id, s.bnk_bic, AVG(s.amount) AS AVG_SALDO
FROM "SYSTEM"."SALDOS" AS s
GROUP BY s.accnt_id, s.bnk_bic;

-- Ältestes und aktuellstes Saldodatum in einer einzigen Abfrage pro Konto
SELECT MIN(s.SLDDATE) AS oldest, MAX(s.SLDDATE) AS newest
FROM "SYSTEM"."SALDOS" AS s;

-- Berechnung des Monatszinses pro Konto mit einem Jahreszinssatz von 1% auf die Einlagen für den Monat Oktober 2019
SELECT s.accnt_id, s.bnk_bic, s.SLDDATE, s.amount, ROUND(s.amount*1/12,2) AS "Zinsen pro Monat"
FROM "SYSTEM"."SALDOS" AS s
WHERE s.SLDDATE = (SELECT ADD_DAYS (TO_DATE('2019-11-01', 'YYYY-MM-DD'), -1) "last day of september" FROM DUMMY)

-- Berechnung des Monatszinses pro Konto mit einem Jahreszinssatz von 1% auf die Einlagen für den Monat September 2019
SELECT s.accnt_id, s.bnk_bic, s.SLDDATE, s.amount, ROUND(s.amount*1/12,2) AS "Zinsen pro Monat"
FROM "SYSTEM"."SALDOS" AS s
WHERE s.SLDDATE = (SELECT ADD_DAYS (TO_DATE('2019-10-01', 'YYYY-MM-DD'), -1) "last day of september" FROM DUMMY);


/*
	Übung 5: Fensterfunktionen

*/

SELECT ACCNT_ID,BNK_BIC,TO_CHAR(SLDDATE,'YYYYMM') AS CALMONTH, AMOUNT,
SUM(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM')) AS SALDO
FROM TRANSACTIONS;

-- Zählen von Kontobewegungen innerhalb eines Monats
SELECT ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') AS CALMONTH, AMOUNT,
COUNT(*) OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM')) AS COUNTER
FROM TRANSACTIONS;

-- Zählen von Kontobewegungen innerhalb eines Monats und Nummerierung der Zeilen sortiert nach Betrag
SELECT ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') AS CALMONTH, AMOUNT,
COUNT(*) OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM')) AS COUNTER,
ROW_NUMBER () OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') ORDER BY AMOUNT) AS ROWNUMBER
FROM TRANSACTIONS;
--ORDER BY AMOUNT;

-- Kumulierte Kontobewegungen innerhalb eines Monats
SELECT ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') as CALMONTH, AMOUNT,
SUM(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM')) AS KUMSALDO,
ROW_NUMBER () OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM')) AS ROWNUMBER
FROM TRANSACTIONS;

SELECT ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') as CALMONTH, AMOUNT,
SUM(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') ORDER BY SLDDATE) AS KUMSALDO,
ROW_NUMBER () OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM')) AS ROWNUMBER
FROM TRANSACTIONS;

SELECT ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') as CALMONTH, AMOUNT,
SUM(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM')) AS KUMSALDO
FROM TRANSACTIONS;

SELECT ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') as CALMONTH, AMOUNT,
SUM(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC, TO_CHAR(SLDDATE,'YYYYMM') ORDER BY SLDDATE) AS KUMSALDO
FROM TRANSACTIONS;

-- Abfrage des durchschnittlichen Betrags pro Bewegung (AVG-Wert) pro Konto per Window-FunctionAVG aus der Tabelle transaction

SELECT ACCNT_ID, BNK_BIC, AMOUNT, 
AVG(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC) AS AVGAMOUNT
FROM "SYSTEM"."TRANSACTIONS" AS T;

-- Wie errechnet sich die Summe (SUM-Wert) aller Einzelbewegungen pro Konto als Saldo?
SELECT ACCNT_ID, BNK_BIC,  
SUM(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC) AS TOTALAMOUNT
FROM "SYSTEM"."TRANSACTIONS" AS T;

-- AVG und SUM
SELECT ACCNT_ID, BNK_BIC,
AVG(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC) AS AVGAMOUNT,
SUM(AMOUNT) OVER (PARTITION BY ACCNT_ID, BNK_BIC) AS TOTALAMOUNT,
COUNT(*) OVER (PARTITION BY ACCNT_ID, BNK_BIC) AS COUNTER
FROM "SYSTEM"."TRANSACTIONS" AS T;
-- doppelte zeilen entfernen?


/*
	Übung 6: Anonyme Blöcke

*/

DO ( IN in_firstname NVARCHAR(40) => ?
	,IN in_lastname NVARCHAR(40) => 'Mustermann'
	,OUT ex_fullname NVARCHAR(100)=> ? )
BEGIN
-- Konkatenieren der Eingaben per string concatenation operator ||
	ex_fullname = :in_lastname || ', ' || :in_firstname;
END;


/*
	Schreiben Sie einen Anonymen Block, der die ID aus der Tabelle BP als 
	Eingabeparameter entgegennimmt und den zur ID gehörenden 
	Geschäftspartnernamen konkateniert in der Form Nachname,Vorname
	ausgibt
*/

DO (IN iv_id INT => ?)
BEGIN
	SELECT lastname || ', ' || firstname AS name
	FROM "SYSTEM"."BP" AS bp
	WHERE bp.id = iv_id;
END;


/*
	Schreiben Sie einen Anonymen Block der für die Kontonummer 200100 den durchschnittlichen Kontostand (Tbl. SALDO) berechnet und ausgibt
*/

DO (IN in_acc_id INT => ?)
BEGIN
	SELECT AVG(AMOUNT) as "AVG Saldo"
	FROM "SYSTEM"."SALDOS" AS s
	WHERE s.accnt_id = in_acc_id;
END;

-- https://help.sap.com/viewer/de2486ee947e43e684d39702027f8a94/2.0.02/en-US/dec9d68044bd49bcbb45c990ba49c81d.html
DO (IN in_acc_id INT => 200100,
	OUT out_avg_amnt DOUBLE => ? )
BEGIN
	T1 =	SELECT AVG(AMOUNT) as "AVG Saldo"
			FROM "SYSTEM"."SALDOS" AS s
	 		WHERE s.accnt_id = in_acc_id;
--	out_avg_amnt = SELECT * FROM :T1;
END;
