/* 
	Teil 2 - Anonyme Blöcke // logische Container
*/

/*
DO
	-- PARAMETER (zB. Konsoleneingabe)
BEGIN
	-- DEKLARATIONEN: Konstanten/Variablen/Tabellen
	-- Ausnahmebehandlung
	-- Anweisungsliste
END;
*/



/* 
	Teil 2, Übung 7

Wiederholung „Anonyme Blöcke“: Anlegen eines anonymen Blocks mit
zwei skalaren Eingabeparametern (Typ INT) und einem Ausgabeparameter 
(Typ INT). Die Werte sollen über die Konsole (Operator => ?) eingegeben 
werden (optional: Nutzen ungarischer Notation für Parameter & Variablen)

*/



DO (
	IN iv_number1 INTEGER => ?
	,IN iv_number2 INTEGER => ?

	,OUT ov_number INTEGER => ?
)
BEGIN

	ov_number = :iv_number1 + :iv_number2;
	
END;


/* 
	Teil 2, Übung 7

	Wiederholung „Anonyme Blöcke“: Anlegen eines anonymen Blocks mit
	zwei skalaren Eingabeparametern (Typ INT) und einem Ausgabeparameter 
	(Typ INT). Die Werte sollen über die Konsole (Operator => ?) eingegeben 
	werden (optional: Nutzen ungarischer Notation für Parameter & Variablen)

*/

DO (
	IN iv_number1 INT => ?
	,IN iv_number2 INTEGER => ?

	,OUT ov_number INTEGER => ?
)
BEGIN
	/* 
		Legen Sie zwei lokale Variablen innerhalb des anonymen Blocks an, zur 
		Aufnahme der Werte aus den Eingabeparametern und initialisieren Sie 
		diese mit dem Wert 0 
	*/
	DECLARE lv_nu1 INTEGER = 0;
	DECLARE lv_nu2 INTEGER = 0;
	
	/* 
		Weisen die Werte aus den Eingangsparametern den beiden lokalen 
		Variablen zu
	*/
	lv_nu1 = :iv_number1;
	lv_nu2 = :iv_number2;
	
	/*
		› Addieren Sie die Werte in den beiden lokalen Variablen
		› Geben Sie den Wert der Addition über den Ausgabeparameter auf der Konsole aus
	*/
	ov_number = :lv_nu1 + :lv_nu2;
	
	/* 
		Ausgabe des Variablenwertes per SELECT
	*/
	SELECT :ov_number AS add_ergebnis FROM dummy;

	-- Test Addition im SELECT-Statement	
	SELECT :ov_number AS add_ergebnis, :lv_nu1 + :lv_nu2 AS select_add_ergebnis FROM dummy;
	
	-- Test (Wertzugriff ohne Doppelpunkt)
	SELECT :ov_number AS add_ergebnis, lv_nu1 + lv_nu2 AS select_add_ergebnis FROM dummy;
	
END;



/* 
	Teil 2 - Tabellen
*/

DO 
BEGIN
	/* 
		Legen skalare und lokale Variablen für COUNT() Funktion an.
		Entspricht einem INTEGER. Initialisierung mit 0
	*/
	DECLARE lv_cnt INTEGER = 0;
	DECLARE lv_cnt_hana2 INTEGER = 0;
	
	-- Tabellenvariable wird angelegt und initialisiert
	lt_var = SELECT * FROM banks; -- LIMIT 5;
	
	-- Ausgabe des Inhalts der Tabellenvariable
	SELECT * FROM :lt_var;
	
	-- lv_cnt Wertzuweisung, in dem Fall Zeilenanzahl der Tabelle lt_var
	SELECT count(*) INTO lv_cnt FROM :lt_var;
	
	-- Ausgabe des Werts der lokalen Variable lv_cnt
	SELECT :lv_cnt AS cnt FROM dummy;
	
	-- lv_cnt Wertzuweisung, in dem Fall Zeilenanzahl der Tabelle lt_var (Syntax ab HANA 2.0 möglich)
	lv_cnt_hana2 = RECORD_COUNT(:lt_var);
	SELECT :lv_cnt_hana2 AS cnt_hana2 FROM dummy;

END;


/* 
	Teil 2, Übung 8 - Tabellen
*/

/*

	› Weisen Sie die Inhalte der Tabelle bp einer „normalen“ Tabellenvariablen zu
	› Bilden Sie einen LEFT JOIN zw. der Tabellenvariablen für bp und der Tabelle 
	  accounts mit passender ON Anweisung anhand der Schlüsselbeziehung
	› Weisen Sie das Resultat dieser Abfrage einer weiteren Tabellenvariable zu

*/

DO 
BEGIN
	
	/* 
		› Weisen Sie die Inhalte der Tabelle bp einer „normalen“ Tabellenvariablen zu
	*/
	lt_bp = SELECT * FROM bp;
	
	/*
		› Bilden Sie einen LEFT JOIN zw. der Tabellenvariablen für bp und der Tabelle 
		  accounts mit passender ON Anweisung anhand der Schlüsselbeziehung
	*/
	lt_join_result = SELECT b.*, a.id AS accnt_id, a.bnk_bic FROM :lt_bp AS b LEFT JOIN accounts AS a ON b.id = a.bp_id;
	
	SELECT * FROM :lt_join_result;


END;


/* 
	Teil 2, Übung 8 - Tabellen
*/

/*

	› Weisen Sie die Inhalte der Tabelle bp einer „normalen“ Tabellenvariablen zu
	› Bilden Sie einen LEFT JOIN zw. der Tabellenvariablen für bp und der Tabelle 
	  accounts mit passender ON Anweisung anhand der Schlüsselbeziehung
	› Weisen Sie das Resultat dieser Abfrage einer weiteren Tabellenvariable zu
	› Legen Sie einen einfachen Tabellentyp im Catalog an. Struktur: 
	  firstname NVARCHAR(20), lastname NVARCHAR(20), bnk_bic NVARCHAR(11), id INT
	› Fügen Sie das JOIN Resultat (oben bereits in Tabellenvariable abgelegt) 
	  einer DML Tabellenvariable hinzu und geben Sie das Ergebnis aus

*/

-- TableType abgelegt unter:  Catalog - SYSTEM - Procedures - Table Types
CREATE TYPE tt_ddl AS TABLE (firstname NVARCHAR(20), lastname NVARCHAR(20), bnk_bic NVARCHAR(11), id INT);

DO 
BEGIN
	
	/*
		› Legen Sie einen einfachen Tabellentyp im Catalog an. Struktur: 
	  	  firstname NVARCHAR(20), lastname NVARCHAR(20), bnk_bic NVARCHAR(11), id INT
	*/
	DECLARE lt_ddl TABLE (firstname NVARCHAR(20), lastname NVARCHAR(20), bnk_bic NVARCHAR(11), id INT);
	-- DECLARE lt_ddl tt_ddl; -- NOT WORKING
	
	
	/* 
		› Weisen Sie die Inhalte der Tabelle bp einer „normalen“ Tabellenvariablen zu
	*/
	lt_bp = SELECT * FROM bp;
	
	/*
		› Bilden Sie einen LEFT JOIN zw. der Tabellenvariablen für bp und der Tabelle 
		  accounts mit passender ON Anweisung anhand der Schlüsselbeziehung
	*/
	lt_join_result = SELECT b.*, a.id AS accnt_id, a.bnk_bic FROM :lt_bp AS b LEFT JOIN accounts AS a ON b.id = a.bp_id;
	
	SELECT * FROM :lt_join_result;

	/*
		› Fügen Sie das JOIN Resultat (oben bereits in Tabellenvariable abgelegt) 
	  	  einer DML Tabellenvariable hinzu und geben Sie das Ergebnis aus
	*/
	
	INSERT INTO :lt_ddl (SELECT firstname, lastname, bnk_bic, id FROM :lt_join_result);
--	INSERT INTO :lt_ddl (SELECT firstname, lastname, bnk_bic, ROW_NUMBER() OVER (ORDER BY accnt_id) AS id FROM :lt_join_result);
	
	SELECT * FROM :lt_ddl;

END;

DROP TYPE tt_ddl;



/* 
	Teil 2, Übung 9 - SAP HANA PlanViz - Query Analysis/Debugging
*/

SELECT B.BIC, B.NAME, B.ZIPCODE, B.PLACE, SL.ACCNT_ID,
BP.FIRSTNAME, BP.LASTNAME, SL.SLDDATE
FROM saldos SL
JOIN banks B
ON SL.BNK_BIC = B.BIC

JOIN accounts AC
ON SL.BNK_BIC = AC.BNK_BIC

JOIN bp as BP
ON AC.BP_ID = BP.ID

WHERE SL.BNK_BIC = 'HELADEFFXXX'--BIC als Filter
ORDER BY SL.SLDDATE;

-- SQL Query: zeigt alle Saldos (Datum) und Business Partner Details der gefilterten Bank HELADEFFXXX an...

/*
	› Zerlegen Sie die SELECT Abfrage mit Hilfe von SQL Script Tabellenvariablen 
	  in mehrere kleinere Abfragen, die BIC soll per Variable eingabebereit sein
	› Im HANA Plan Viz den Ausführungsplan aufrufen und prüfen
	  (nur über "SAP HANA PlanViz" Perspektive im SAP HANA Studio/Eclipse möglich)
*/

DO
BEGIN
	DECLARE lv_bnk_bic NVARCHAR(11) = 'HELADEFFXXX'; 
	-- zerlegung / splitting in SQL Script
	lt_sl = SELECT SL.ACCNT_ID, SL.SLDDATE, SL.BNK_BIC
			FROM saldos AS SL
			WHERE SL.BNK_BIC = :lv_bnk_bic;
			
	lt_b = 	SELECT SL.*, B.BIC, B.NAME, B.ZIPCODE, B.PLACE
			FROM banks AS B
			INNER JOIN :lt_sl AS SL
			ON SL.BNK_BIC = B.BIC;
			
	lt_ac = SELECT SL_B.*, AC.BP_ID
			FROM accounts AS AC
			INNER JOIN :lt_b AS SL_B
			ON SL_B.BNK_BIC = AC.BNK_BIC;
			
	lt_bp = SELECT SL_B_AC.*, BP.FIRSTNAME, BP.LASTNAME, BP.ID
			FROM bp AS bp
			INNER JOIN :lt_ac AS SL_B_AC
			ON SL_B_AC.BP_ID = BP.ID;
	
	--lt_sl_b = SELECT SL.*, B.* FROM :lt_sl AS SL INNER JOIN :lt_b AS b ON (SL.BNK_BIC = B.BIC);
	
	SELECT * FROM :lt_bp AS SL_B_AC_BP ORDER BY SLDDATE;
END;

/*
	mit Consolen Eingabe
*/

DO
	(IN iv_bnk_bic NVARCHAR(11) => ?)
BEGIN
	-- zerlegung / splitting in SQL Script
	lt_sl = SELECT SL.ACCNT_ID, SL.SLDDATE, SL.BNK_BIC
			FROM saldos AS SL
			WHERE SL.BNK_BIC = :iv_bnk_bic;
			
	lt_b = 	SELECT SL.*, B.BIC, B.NAME, B.ZIPCODE, B.PLACE
			FROM banks AS B
			INNER JOIN :lt_sl AS SL
			ON SL.BNK_BIC = B.BIC;
			
	lt_ac = SELECT SL_B.*, AC.BP_ID
			FROM accounts AS AC
			INNER JOIN :lt_b AS SL_B
			ON SL_B.BNK_BIC = AC.BNK_BIC;
			
	lt_bp = SELECT SL_B_AC.*, BP.FIRSTNAME, BP.LASTNAME, BP.ID
			FROM bp AS bp
			INNER JOIN :lt_ac AS SL_B_AC
			ON SL_B_AC.BP_ID = BP.ID;
	
	--lt_sl_b = SELECT SL.*, B.* FROM :lt_sl AS SL INNER JOIN :lt_b AS b ON (SL.BNK_BIC = B.BIC);
	
	SELECT * FROM :lt_bp AS SL_B_AC_BP ORDER BY SLDDATE;
END;