-- Delopgave 5: Vis SQL-forespørgsler 

-- a) Vis en månedsplan dvs. en vagtplan for en hel måned. 

-- Denne løsning tager udgangspunkt i månedsplanen for oktober 2026:

-- Løsningen udformes vha. SELECT fra tabellen [Vagt]. Herved kan jeg "joine" de andre tabeller,
-- som er relateret til [Vagt]. Det gør, jeg kan forbinde [Vagt] med [Maanedsplan] dvs. oktober 2026,
-- [Vagttype] med de to typer af vagter, der eksisterer pr dag (formiddag og eftermiddag),
-- [Vagttildeling], som systemet bruger til at uddeligere vagter til medarbejderne,
-- og sidst [Medarbejder] til at få vist info om de medarbejdere, der har vagter i oktober.

SELECT Vagt.DagPaaMaaned AS DatoOktober,--SELECT = Hvilke kolonner skal vi udvælge.
       VagtType.Navn AS Vagttype, 
       VagtType.StartTidspunkt AS VagtStart, 
       VagtType.SlutTidspunkt AS VagtSlut, 
       STRING_AGG(Medarbejder.Navn, N', ') AS Medarbejdere --Samler alle medarbejdere pr. Vagttype i én og samme kolonne.

FROM Vagt --Den primære tabel, vi arbejder ud fra, og som vi joiner de andre tabeller til.

JOIN Maanedsplan ON Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId
JOIN VagtType ON Vagt.VagtTypeId = VagtType.VagtTypeId
JOIN VagtTildeling ON Vagt.VagtId = Vagttildeling.VagtId
Join Medarbejder on VagtTildeling.MedarbejderId = Medarbejder.MedarbejderId

WHERE Maanedsplan.Aar = 2026 AND Maanedsplan.Maaned = 10 --Betingelse for, at vi får vist oktober 2026's månedsplan.

GROUP BY Vagt.DagPaaMaaned, --Resultater grupperes via disse.
         VagtType.Navn,
         VagtType.StartTidspunkt,
         VagtType.SlutTidspunkt

ORDER BY Vagt.DagPaaMaaned, -- Resultater sorteres via disse.
         VagtType.StartTidspunkt;



-- b) Vise belastningen af de enkelte medarbejdere for en måned,
-- I dette tilfælde har jeg igen valgt at kigge på oktober 2026.

-- Resultattabellen viser kun medarbejdere med vagter. 
-- Hvis der er medarbejdere, der ikke har vagter i oktober 2026, vises de ikke.
-- Det er dog ikke tilfældet, da alle medarbejdere har vagter denne måned.

SELECT Medarbejder.Navn AS Medarbejder,
       COUNT(VagtTildeling.VagtId) AS AntalVagterOktober, --Giver samlet antal vagter for oktober.
       COUNT(VagtTildeling.VagtId) * 5 AS AntalTimerOktober, --Giver samlet antal af arbejdstimer.
       STRING_AGG(Vagt.VagtId, N', ') AS VagtIdOverblik --Giver VagtId på samtlige vagter hvert enkelte medarbejder har fået tildelt i otkober.

FROM VagtTildeling

JOIN Medarbejder ON VagtTildeling.MedarbejderId = Medarbejder.MedarbejderId
JOIN Vagt ON Vagttildeling.VagtId = Vagt.VagtId
Join Maanedsplan ON Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId

WHERE Maanedsplan.Aar = 2026 AND Maanedsplan.Maaned = 10

GROUP BY Medarbejder.MedarbejderId,
         Medarbejder.Navn

ORDER BY AntalVagterOktober DESC, --Sørger for, at medarbejdere med flest vagter i oktober vises øverst i resultattabellen.
         Medarbejder.Navn;



-- c) Vise kontaktinfo for alle medarbejdere, i såfald en medarbejder er for syg til at tage sin vagt:
-- Da jeg som leder ønsker alle informationer på mine medarbejdere, gør jeg brug af SELECT *:

SELECT * FROM Medarbejder;


-- d) Vise belastningen af medarbejdere hen over året i 2026:
-- Sker ud fra samme princip som i b), dog inkluderer jeg alle måneder fra 2026
-- via Where-betingelsen. 
-- Da der kun er udfyldt månedsplaner fra oktober 2026-december 2026, er der kun et begrænset
-- timeantal tildelt til de enkelte medarbejdere i 2026.

SELECT Medarbejder.Navn AS Medarbejder,
       COUNT(VagtTildeling.VagtId) AS AntalVagter2026, --Giver samlet antal vagter for oktober.
       COUNT(VagtTildeling.VagtId) * 5 AS AntalTimer2026, --Giver samlet antal arbejdstimer for 2026.
       STRING_AGG(Vagt.VagtId, N', ') AS VagtIdOverblik --Giver VagtId på samtlige vagter hvert enkelte medarbejder har fået tildelt i otkober.

FROM VagtTildeling

JOIN Medarbejder ON VagtTildeling.MedarbejderId = Medarbejder.MedarbejderId
JOIN Vagt ON Vagttildeling.VagtId = Vagt.VagtId
Join Maanedsplan ON Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId

WHERE Maanedsplan.Aar = 2026

GROUP BY Medarbejder.MedarbejderId,
         Medarbejder.Navn

ORDER BY AntalVagter2026 DESC,
         Medarbejder.Navn;


-- d) fortsat.
-- Viser desuden belastningen af medarbejdere hen over året i 2027 - stopper ved september 2027:

SELECT Medarbejder.Navn AS Medarbejder,
       COUNT(VagtTildeling.VagtId) AS AntalVagter2027, --Giver samlet antal vagter for oktober.
       COUNT(VagtTildeling.VagtId) * 5 AS AntalTimer2027,
       STRING_AGG(Vagt.VagtId, N', ') AS VagtIdOverblik --Giver VagtId på samtlige vagter hvert enkelte medarbejder har fået tildelt i otkober.

FROM VagtTildeling

JOIN Medarbejder ON VagtTildeling.MedarbejderId = Medarbejder.MedarbejderId
JOIN Vagt ON Vagttildeling.VagtId = Vagt.VagtId
Join Maanedsplan ON Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId

WHERE Maanedsplan.Aar = 2027

GROUP BY Medarbejder.MedarbejderId,
         Medarbejder.Navn

ORDER BY AntalVagter2027 DESC,
         Medarbejder.Navn;

-- e) Kan lave nye månedsplaner, og justere eksisterende planer. Jeg bruger eksempler løbende.

--LAV NY MÅNEDSPLAN:

-- Jeg opretter en ny månedsplan for oktober 2027, som endnu ikke er oprettet i systemet.

--Første trin er at oprette en ny record for oktober i min månedsplanstabel:

Insert Into Maanedsplan (Aar, Maaned)
Values (2027, 10); -- År 2027, 10. måned = oktober.
   
-- Oktober 2027 har MaanedsplanId = 130, som skal bruges i næste trin.

-- Her skal jeg nemlig oprette 2 vagter pr dag for 31 dage i oktober 2027:

INSERT INTO Vagt (MaanedsplanId, VagttypeId, DagPaaMaaned)
VALUES
    (130, 1, 1), -- 1. oktober, formiddag
    (130, 2, 1), -- 1. oktober, eftermiddag
    (130, 1, 2), -- 2. oktober, formiddag
    (130, 2, 2), -- 2. oktober, eftermiddag
    (130, 1, 3), -- osv. osv.
    (130, 2, 3),
    (130, 1, 4),
    (130, 2, 4),
    (130, 1, 5),
    (130, 2, 5),
    (130, 1, 6),
    (130, 2, 6),
    (130, 1, 7),
    (130, 2, 7),
    (130, 1, 8),
    (130, 2, 8),
    (130, 1, 9),
    (130, 2, 9),
    (130, 1, 10),
    (130, 2, 10),
    (130, 1, 11),
    (130, 2, 11),
    (130, 1, 12),
    (130, 2, 12),
    (130, 1, 13),
    (130, 2, 13),
    (130, 1, 14),
     (130, 2, 14),
     (130, 1, 15),
     (130, 2, 15),
     (130, 1, 16),
     (130, 2, 16),
     (130, 1, 17),
     (130, 2, 17),
     (130, 1, 18),
     (130, 2, 18),
     (130, 1, 19),
     (130, 2, 19),
     (130, 1, 20),
     (130, 2, 20),
     (130, 1, 21),
     (130, 2, 21),
     (130, 1, 22),
     (130, 2, 22),
     (130, 1, 23),
     (130, 2, 23),
     (130, 1, 24),
     (130, 2, 24),
     (130, 1, 25),
     (130, 2, 25),
     (130, 1, 26),
     (130, 2, 26),
     (130, 1, 27),
     (130, 2, 27),
     (130, 1, 28),
     (130, 2, 28),
     (130, 1, 29),
     (130, 2, 29),
     (130, 1, 30),
     (130, 2, 30),
     (130, 1, 31),
     (130, 2, 31);

 -- Nu er månedsplanen for oktober 2027 oprettet.
 -- Jeg har desuden oprettet formiddags- og eftermiddagsvagter alle 31 dage i måneden.

 -- Ønsker jeg som Pedro eller Jacoby at tildele vagter til os selv og vores medarbejdere, 
 -- gør jeg det via denne SQL-forespørgsel:

 INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES (1, 1), -- Formiddagsvagt (VagtId = 1) tildelt Pedro (MedarbejderId = 1)
       (1, 5); -- Formiddagsvagt (VagtId = 1) tildelt Sara Nielsen (MedarbejderId = 5).
                -- osv. osv.
   
 -- OPDATER EN EKSISTERENDE MÅNEDSPLAN:

 -- For at opdatere en eksisterende månedsplan kan vi gøre brug af UPDATE:

 UPDATE [TableName] -- Her angiver vi, hvilken tabel vi ønsker at opdatere i.

 SET -- Her angiver vi, hvilken ændring vi ønsker foretaget.

 WHERE -- Betingelsen for, hvad vi ønsker ændret.
 AND; -- Bruges, hvis vi skal kombinere betingelser for ændringen.

 -- Eksempler for oktober 2026:

 -- Oliver ringer syg ind til Pedro eller Jacoby, som så skal finde en erstatning (Sofie).

 UPDATE VagtTildeling

 SET MedarbejderId = 9 -- Sofies Id - skal overtage vagten.

 WHERE MedarbejderId = 12 --Olivers Id - er syg.

 AND VagtId = 
 
 (SELECT Vagt.VagtId
 
 FROM Vagt

 JOIN Maanedsplan ON Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId
      
 WHERE Vagt.DagPaaMaaned = 8 -- 8. oktober
 
 AND Vagt.VagttypeId = 2 --Eftermiddagsvagten
 AND Maanedsplan.Maaned = 10 -- Oktober
 AND Maanedsplan.Aar = 2026);

 -- Tilføj en ekstra medarbejder til en vagt.

 -- D. 19. oktober om eftermiddagen ønsker Pedro en 4. medarbejder udover Anna og Jonas.
 -- De skal nemlig betjene gæster fra en 50-års fødselsdag.
 -- Han vil gerne have tilføjet Oliver (ID = 12), da han jo var syg på en vagt tidligere på måneden.

 INSERT INTO VagtTildeling (VagtId, MedarbejderId)
 
 SELECT Vagt.VagtId, 12 -- Olivers ID

 FROM Vagt

 JOIN Maanedsplan ON Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId

 WHERE Vagt.DagPaaMaaned = 19
 
 AND Vagt.VagttypeId = 2 -- Eftermiddag
 AND Maanedsplan.Maaned = 10 --Oktober
 AND Maanedsplan.Aar = 2026;


 --Fjerne en person fra en vagt:

 -- Nu er den gal igen med vagtplanen. Gæsterne fra den 50-års fødselsdag har ringet til Pedro.
 -- De er nødt til at aflyse deres bestilling. Pedro har derfor ikke brug for 3 medarbejdere om
 -- eftermiddagen d. 19. oktober. Han vil derfor fjerne Jonas (Id = 6) fra vagten.

 DELETE FROM VagtTildeling
 
 WHERE MedarbejderId = 6 -- Jonas' id.

 AND VagtId = (

 SELECT VagtId

 FROM Vagt

 JOIN Maanedsplan ON Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId

 WHERE Vagt.DagPaaMaaned = 19
 
 AND Vagt.VagttypeId = 2 -- Eftermiddag
 AND Maanedsplan.Maaned = 10 --Oktober
 AND Maanedsplan.Aar = 2026);





