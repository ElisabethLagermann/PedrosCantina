--Indsætter medarbejdere i medarbejdertabellen. 


    INSERT INTO Medarbejder (Navn, Telefon, Email, Adresse, ErLeder)
    VALUES
        ('Pedro', '00000001', 'pedro@example.com', 'Testvej 1, 4000 Roskilde', 1),
        ('Jacoby', '00000002', 'jacoby@example.com', 'Testvej 2, 4000 Roskilde', 1),
        ('Anna Jensen', '00000003', 'anna.jensen@example.com', 'Testvej 3, 4000 Roskilde', 0),
        ('Mikkel Sørensen', '00000004', 'mikkel.sorensen@example.com', 'Testvej 4, 4000 Roskilde', 0),
        ('Sara Nielsen', '00000005', 'sara.nielsen@example.com', 'Testvej 5, 4000 Roskilde', 0),
        ('Jonas Larsen', '00000006', 'jonas.larsen@example.com', 'Testvej 6, 4000 Roskilde', 0),
        ('Freja Hansen', '00000007', 'freja.hansen@example.com', 'Testvej 7, 4000 Roskilde', 0),
        ('Emil Madsen', '00000008', 'emil.madsen@example.com', 'Testvej 8, 4000 Roskilde', 0),
        ('Sofie Petersen', '00000009', 'sofie.petersen@example.com', 'Testvej 9, 4000 Roskilde', 0),
        ('Noah Kristensen', '00000010', 'noah.kristensen@example.com', 'Testvej 10, 4000 Roskilde', 0),
        ('Clara Thomsen', '00000011', 'clara.thomsen@example.com', 'Testvej 11, 4000 Roskilde', 0),
        ('Oliver Poulsen', '00000012', 'oliver.poulsen@example.com', 'Testvej 12, 4000 Roskilde', 0);


  -- Opretter de to forskellige typer af vagter, der eksisterer pr dag: kl 9-14 samt 14-19:

    INSERT INTO Vagttype (Navn, StartTidspunkt, SlutTidspunkt)
    VALUES ('Formiddag', '09:00:00', '14:00:00'),
        ('Eftermiddag', '14:00:00', '19:00:00');


--Opretter 12 månedsplaner for det næste års tid. Starter oktober 2026 og slutter september 2027.

    INSERT INTO Maanedsplan (Aar, Maaned)
    VALUES
        (2026, 10),
        (2026, 11),
        (2026, 12),
        (2027, 1),
        (2027, 2),
        (2027, 3),
        (2027, 4),
        (2027, 5),
        (2027, 6),
        (2027, 7),
        (2027, 8),
        (2027, 9);

-- Opretter 62 vagter i oktober. 2 vagter pr dag over 31 dage. 

        INSERT INTO Vagt (MaanedsplanId, VagttypeId, DagPaaMaaned)
SELECT
    Maanedsplan.MaanedsplanId,
    Vagttype.VagttypeId,
    Dage.DagPaaMaaned
FROM Maanedsplan
CROSS JOIN Vagttype
CROSS JOIN (
    VALUES
        (1), (2), (3), (4), (5), (6), (7),
        (8), (9), (10), (11), (12), (13), (14),
        (15), (16), (17), (18), (19), (20), (21),
        (22), (23), (24), (25), (26), (27), (28),
        (29), (30), (31)
) AS Dage (DagPaaMaaned)
WHERE Maanedsplan.Aar = 2026
  AND Maanedsplan.Maaned = 10
  AND Vagttype.Navn IN ('Formiddag', 'Eftermiddag')
  AND NOT EXISTS (
      SELECT 1
      FROM Vagt
      WHERE Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId
        AND Vagt.VagttypeId = Vagttype.VagttypeId
        AND Vagt.DagPaaMaaned = Dage.DagPaaMaaned
  );


  --Tester, at der korrekt er skabt 2 gange vagter pr dag i oktober 2026: 
  SELECT
    Vagt.VagtId,
    Vagt.DagPaaMaaned,
    Vagttype.Navn AS Vagttype,
    Vagttype.StartTidspunkt,
    Vagttype.SlutTidspunkt
FROM Vagt
INNER JOIN Maanedsplan
    ON Vagt.MaanedsplanId = Maanedsplan.MaanedsplanId
INNER JOIN Vagttype
    ON Vagt.VagttypeId = Vagttype.VagttypeId
WHERE Maanedsplan.Aar = 2026
  AND Maanedsplan.Maaned = 10
ORDER BY Vagt.DagPaaMaaned, Vagttype.StartTidspunkt;


--Tildeler vagter til medarbejderne til oktober 2026:

INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. oktober
    (1, 2), (1, 6), -- Formiddag
    (32, 1), (32, 5), (32, 6), -- Eftermiddag

    -- 2. oktober
    (2, 1), (2, 4), (2, 9), -- Formiddag
    (33, 2), (33, 3), (33, 9), -- Eftermiddag

    -- 3. oktober
    (3, 1), (3, 4), (3, 10), -- Formiddag
    (34, 1), (34, 3), (34, 10), -- Eftermiddag

    -- 4. oktober
    (4, 2), (4, 4), (4, 11), -- Formiddag
    (35, 2), (35, 3), (35, 10), -- Eftermiddag

    -- 5. oktober
    (5, 2), (5, 4), -- Formiddag
    (36, 1), (36, 4), (36, 7), -- Eftermiddag

    -- 6. oktober
    (6, 1), (6, 6), -- Formiddag
    (37, 2), (37, 3), (37, 9), -- Eftermiddag

    -- 7. oktober
    (7, 2), (7, 8), -- Formiddag
    (38, 1), (38, 5), (38, 7), -- Eftermiddag

    -- 8. oktober
    (8, 1), (8, 4), -- Formiddag
    (39, 2), (39, 5), (39, 9), -- Eftermiddag

    -- 9. oktober
    (9, 2), (9, 3), (9, 7), -- Formiddag
    (40, 1), (40, 4), (40, 6), -- Eftermiddag

    -- 10. oktober
    (10, 2), (10, 9), (10, 11), -- Formiddag
    (41, 2), (41, 4), (41, 11), -- Eftermiddag

    -- 11. oktober
    (11, 1), (11, 4), (11, 8), -- Formiddag
    (42, 1), (42, 4), (42, 8), -- Eftermiddag

    -- 12. oktober
    (12, 1), (12, 6), -- Formiddag
    (43, 2), (43, 6), (43, 7), -- Eftermiddag

    -- 13. oktober
    (13, 2), (13, 8), -- Formiddag
    (44, 1), (44, 4), (44, 6), -- Eftermiddag

    -- 14. oktober
    (14, 1), (14, 5), -- Formiddag
    (45, 2), (45, 4), (45, 5), -- Eftermiddag

    -- 15. oktober
    (15, 2), (15, 5), -- Formiddag
    (46, 1), (46, 3), (46, 4), -- Eftermiddag

    -- 16. oktober
    (16, 1), (16, 3), (16, 6), -- Formiddag
    (47, 2), (47, 5), (47, 7), -- Eftermiddag

    -- 17. oktober
    (17, 1), (17, 6), (17, 12), -- Formiddag
    (48, 1), (48, 5), (48, 8), -- Eftermiddag

    -- 18. oktober
    (18, 2), (18, 3), (18, 10), -- Formiddag
    (49, 2), (49, 6), (49, 12), -- Eftermiddag

    -- 19. oktober
    (19, 2), (19, 4), -- Formiddag
    (50, 1), (50, 3), (50, 6), -- Eftermiddag

    -- 20. oktober
    (20, 1), (20, 4), -- Formiddag
    (51, 2), (51, 3), (51, 4), -- Eftermiddag

    -- 21. oktober
    (21, 2), (21, 3), -- Formiddag
    (52, 1), (52, 3), (52, 5), -- Eftermiddag

    -- 22. oktober
    (22, 1), (22, 7), -- Formiddag
    (53, 2), (53, 4), (53, 5), -- Eftermiddag

    -- 23. oktober
    (23, 2), (23, 3), (23, 8), -- Formiddag
    (54, 1), (54, 3), (54, 4), -- Eftermiddag

    -- 24. oktober
    (24, 2), (24, 6), (24, 11), -- Formiddag
    (55, 2), (55, 5), (55, 12), -- Eftermiddag

    -- 25. oktober
    (25, 1), (25, 4), (25, 12), -- Formiddag
    (56, 1), (56, 11), (56, 12), -- Eftermiddag

    -- 26. oktober
    (26, 1), (26, 3), -- Formiddag
    (57, 2), (57, 3), (57, 8), -- Eftermiddag

    -- 27. oktober
    (27, 2), (27, 3), -- Formiddag
    (58, 1), (58, 5), (58, 7), -- Eftermiddag

    -- 28. oktober
    (28, 1), (28, 5), -- Formiddag
    (59, 2), (59, 3), (59, 5), -- Eftermiddag

    -- 29. oktober
    (29, 2), (29, 3), (29, 4), -- Formiddag
    (60, 1), (60, 3), (60, 4), -- Eftermiddag

    -- 30. oktober
    (30, 1), (30, 7), (30, 8), -- Formiddag
    (61, 2), (61, 7), (61, 9), -- Eftermiddag

    -- 31. oktober
    (31, 1), (31, 3), (31, 10), -- Formiddag
    (62, 1), (62, 3), (62, 7); -- Eftermiddag


--Opretter vagter for november 2026 og frem til september 2027

INSERT INTO Vagt (MaanedsplanId, VagttypeId, DagPaaMaaned)
VALUES
    -- November 2026: MaanedsplanId 20, 30 dage
    (20, 1, 1), (20, 2, 1),
    (20, 1, 2), (20, 2, 2),
    (20, 1, 3), (20, 2, 3),
    (20, 1, 4), (20, 2, 4),
    (20, 1, 5), (20, 2, 5),
    (20, 1, 6), (20, 2, 6),
    (20, 1, 7), (20, 2, 7),
    (20, 1, 8), (20, 2, 8),
    (20, 1, 9), (20, 2, 9),
    (20, 1, 10), (20, 2, 10),
    (20, 1, 11), (20, 2, 11),
    (20, 1, 12), (20, 2, 12),
    (20, 1, 13), (20, 2, 13),
    (20, 1, 14), (20, 2, 14),
    (20, 1, 15), (20, 2, 15),
    (20, 1, 16), (20, 2, 16),
    (20, 1, 17), (20, 2, 17),
    (20, 1, 18), (20, 2, 18),
    (20, 1, 19), (20, 2, 19),
    (20, 1, 20), (20, 2, 20),
    (20, 1, 21), (20, 2, 21),
    (20, 1, 22), (20, 2, 22),
    (20, 1, 23), (20, 2, 23),
    (20, 1, 24), (20, 2, 24),
    (20, 1, 25), (20, 2, 25),
    (20, 1, 26), (20, 2, 26),
    (20, 1, 27), (20, 2, 27),
    (20, 1, 28), (20, 2, 28),
    (20, 1, 29), (20, 2, 29),
    (20, 1, 30), (20, 2, 30),

    -- December 2026: MaanedsplanId 30, 31 dage
    (30, 1, 1), (30, 2, 1),
    (30, 1, 2), (30, 2, 2),
    (30, 1, 3), (30, 2, 3),
    (30, 1, 4), (30, 2, 4),
    (30, 1, 5), (30, 2, 5),
    (30, 1, 6), (30, 2, 6),
    (30, 1, 7), (30, 2, 7),
    (30, 1, 8), (30, 2, 8),
    (30, 1, 9), (30, 2, 9),
    (30, 1, 10), (30, 2, 10),
    (30, 1, 11), (30, 2, 11),
    (30, 1, 12), (30, 2, 12),
    (30, 1, 13), (30, 2, 13),
    (30, 1, 14), (30, 2, 14),
    (30, 1, 15), (30, 2, 15),
    (30, 1, 16), (30, 2, 16),
    (30, 1, 17), (30, 2, 17),
    (30, 1, 18), (30, 2, 18),
    (30, 1, 19), (30, 2, 19),
    (30, 1, 20), (30, 2, 20),
    (30, 1, 21), (30, 2, 21),
    (30, 1, 22), (30, 2, 22),
    (30, 1, 23), (30, 2, 23),
    (30, 1, 24), (30, 2, 24),
    (30, 1, 25), (30, 2, 25),
    (30, 1, 26), (30, 2, 26),
    (30, 1, 27), (30, 2, 27),
    (30, 1, 28), (30, 2, 28),
    (30, 1, 29), (30, 2, 29),
    (30, 1, 30), (30, 2, 30),
    (30, 1, 31), (30, 2, 31),

    -- Januar 2027: MaanedsplanId 40, 31 dage
    (40, 1, 1), (40, 2, 1),
    (40, 1, 2), (40, 2, 2),
    (40, 1, 3), (40, 2, 3),
    (40, 1, 4), (40, 2, 4),
    (40, 1, 5), (40, 2, 5),
    (40, 1, 6), (40, 2, 6),
    (40, 1, 7), (40, 2, 7),
    (40, 1, 8), (40, 2, 8),
    (40, 1, 9), (40, 2, 9),
    (40, 1, 10), (40, 2, 10),
    (40, 1, 11), (40, 2, 11),
    (40, 1, 12), (40, 2, 12),
    (40, 1, 13), (40, 2, 13),
    (40, 1, 14), (40, 2, 14),
    (40, 1, 15), (40, 2, 15),
    (40, 1, 16), (40, 2, 16),
    (40, 1, 17), (40, 2, 17),
    (40, 1, 18), (40, 2, 18),
    (40, 1, 19), (40, 2, 19),
    (40, 1, 20), (40, 2, 20),
    (40, 1, 21), (40, 2, 21),
    (40, 1, 22), (40, 2, 22),
    (40, 1, 23), (40, 2, 23),
    (40, 1, 24), (40, 2, 24),
    (40, 1, 25), (40, 2, 25),
    (40, 1, 26), (40, 2, 26),
    (40, 1, 27), (40, 2, 27),
    (40, 1, 28), (40, 2, 28),
    (40, 1, 29), (40, 2, 29),
    (40, 1, 30), (40, 2, 30),
    (40, 1, 31), (40, 2, 31),

    -- Februar 2027: MaanedsplanId 50, 28 dage
    (50, 1, 1), (50, 2, 1),
    (50, 1, 2), (50, 2, 2),
    (50, 1, 3), (50, 2, 3),
    (50, 1, 4), (50, 2, 4),
    (50, 1, 5), (50, 2, 5),
    (50, 1, 6), (50, 2, 6),
    (50, 1, 7), (50, 2, 7),
    (50, 1, 8), (50, 2, 8),
    (50, 1, 9), (50, 2, 9),
    (50, 1, 10), (50, 2, 10),
    (50, 1, 11), (50, 2, 11),
    (50, 1, 12), (50, 2, 12),
    (50, 1, 13), (50, 2, 13),
    (50, 1, 14), (50, 2, 14),
    (50, 1, 15), (50, 2, 15),
    (50, 1, 16), (50, 2, 16),
    (50, 1, 17), (50, 2, 17),
    (50, 1, 18), (50, 2, 18),
    (50, 1, 19), (50, 2, 19),
    (50, 1, 20), (50, 2, 20),
    (50, 1, 21), (50, 2, 21),
    (50, 1, 22), (50, 2, 22),
    (50, 1, 23), (50, 2, 23),
    (50, 1, 24), (50, 2, 24),
    (50, 1, 25), (50, 2, 25),
    (50, 1, 26), (50, 2, 26),
    (50, 1, 27), (50, 2, 27),
    (50, 1, 28), (50, 2, 28),

    -- Marts 2027: MaanedsplanId 60, 31 dage
    (60, 1, 1), (60, 2, 1),
    (60, 1, 2), (60, 2, 2),
    (60, 1, 3), (60, 2, 3),
    (60, 1, 4), (60, 2, 4),
    (60, 1, 5), (60, 2, 5),
    (60, 1, 6), (60, 2, 6),
    (60, 1, 7), (60, 2, 7),
    (60, 1, 8), (60, 2, 8),
    (60, 1, 9), (60, 2, 9),
    (60, 1, 10), (60, 2, 10),
    (60, 1, 11), (60, 2, 11),
    (60, 1, 12), (60, 2, 12),
    (60, 1, 13), (60, 2, 13),
    (60, 1, 14), (60, 2, 14),
    (60, 1, 15), (60, 2, 15),
    (60, 1, 16), (60, 2, 16),
    (60, 1, 17), (60, 2, 17),
    (60, 1, 18), (60, 2, 18),
    (60, 1, 19), (60, 2, 19),
    (60, 1, 20), (60, 2, 20),
    (60, 1, 21), (60, 2, 21),
    (60, 1, 22), (60, 2, 22),
    (60, 1, 23), (60, 2, 23),
    (60, 1, 24), (60, 2, 24),
    (60, 1, 25), (60, 2, 25),
    (60, 1, 26), (60, 2, 26),
    (60, 1, 27), (60, 2, 27),
    (60, 1, 28), (60, 2, 28),
    (60, 1, 29), (60, 2, 29),
    (60, 1, 30), (60, 2, 30),
    (60, 1, 31), (60, 2, 31),

    -- April 2027: MaanedsplanId 70, 30 dage
    (70, 1, 1), (70, 2, 1),
    (70, 1, 2), (70, 2, 2),
    (70, 1, 3), (70, 2, 3),
    (70, 1, 4), (70, 2, 4),
    (70, 1, 5), (70, 2, 5),
    (70, 1, 6), (70, 2, 6),
    (70, 1, 7), (70, 2, 7),
    (70, 1, 8), (70, 2, 8),
    (70, 1, 9), (70, 2, 9),
    (70, 1, 10), (70, 2, 10),
    (70, 1, 11), (70, 2, 11),
    (70, 1, 12), (70, 2, 12),
    (70, 1, 13), (70, 2, 13),
    (70, 1, 14), (70, 2, 14),
    (70, 1, 15), (70, 2, 15),
    (70, 1, 16), (70, 2, 16),
    (70, 1, 17), (70, 2, 17),
    (70, 1, 18), (70, 2, 18),
    (70, 1, 19), (70, 2, 19),
    (70, 1, 20), (70, 2, 20),
    (70, 1, 21), (70, 2, 21),
    (70, 1, 22), (70, 2, 22),
    (70, 1, 23), (70, 2, 23),
    (70, 1, 24), (70, 2, 24),
    (70, 1, 25), (70, 2, 25),
    (70, 1, 26), (70, 2, 26),
    (70, 1, 27), (70, 2, 27),
    (70, 1, 28), (70, 2, 28),
    (70, 1, 29), (70, 2, 29),
    (70, 1, 30), (70, 2, 30),

    -- Maj 2027: MaanedsplanId 80, 31 dage
    (80, 1, 1), (80, 2, 1),
    (80, 1, 2), (80, 2, 2),
    (80, 1, 3), (80, 2, 3),
    (80, 1, 4), (80, 2, 4),
    (80, 1, 5), (80, 2, 5),
    (80, 1, 6), (80, 2, 6),
    (80, 1, 7), (80, 2, 7),
    (80, 1, 8), (80, 2, 8),
    (80, 1, 9), (80, 2, 9),
    (80, 1, 10), (80, 2, 10),
    (80, 1, 11), (80, 2, 11),
    (80, 1, 12), (80, 2, 12),
    (80, 1, 13), (80, 2, 13),
    (80, 1, 14), (80, 2, 14),
    (80, 1, 15), (80, 2, 15),
    (80, 1, 16), (80, 2, 16),
    (80, 1, 17), (80, 2, 17),
    (80, 1, 18), (80, 2, 18),
    (80, 1, 19), (80, 2, 19),
    (80, 1, 20), (80, 2, 20),
    (80, 1, 21), (80, 2, 21),
    (80, 1, 22), (80, 2, 22),
    (80, 1, 23), (80, 2, 23),
    (80, 1, 24), (80, 2, 24),
    (80, 1, 25), (80, 2, 25),
    (80, 1, 26), (80, 2, 26),
    (80, 1, 27), (80, 2, 27),
    (80, 1, 28), (80, 2, 28),
    (80, 1, 29), (80, 2, 29),
    (80, 1, 30), (80, 2, 30),
    (80, 1, 31), (80, 2, 31),

    -- Juni 2027: MaanedsplanId 90, 30 dage
    (90, 1, 1), (90, 2, 1),
    (90, 1, 2), (90, 2, 2),
    (90, 1, 3), (90, 2, 3),
    (90, 1, 4), (90, 2, 4),
    (90, 1, 5), (90, 2, 5),
    (90, 1, 6), (90, 2, 6),
    (90, 1, 7), (90, 2, 7),
    (90, 1, 8), (90, 2, 8),
    (90, 1, 9), (90, 2, 9),
    (90, 1, 10), (90, 2, 10),
    (90, 1, 11), (90, 2, 11),
    (90, 1, 12), (90, 2, 12),
    (90, 1, 13), (90, 2, 13),
    (90, 1, 14), (90, 2, 14),
    (90, 1, 15), (90, 2, 15),
    (90, 1, 16), (90, 2, 16),
    (90, 1, 17), (90, 2, 17),
    (90, 1, 18), (90, 2, 18),
    (90, 1, 19), (90, 2, 19),
    (90, 1, 20), (90, 2, 20),
    (90, 1, 21), (90, 2, 21),
    (90, 1, 22), (90, 2, 22),
    (90, 1, 23), (90, 2, 23),
    (90, 1, 24), (90, 2, 24),
    (90, 1, 25), (90, 2, 25),
    (90, 1, 26), (90, 2, 26),
    (90, 1, 27), (90, 2, 27),
    (90, 1, 28), (90, 2, 28),
    (90, 1, 29), (90, 2, 29),
    (90, 1, 30), (90, 2, 30),

    -- Juli 2027: MaanedsplanId 100, 31 dage
    (100, 1, 1), (100, 2, 1),
    (100, 1, 2), (100, 2, 2),
    (100, 1, 3), (100, 2, 3),
    (100, 1, 4), (100, 2, 4),
    (100, 1, 5), (100, 2, 5),
    (100, 1, 6), (100, 2, 6),
    (100, 1, 7), (100, 2, 7),
    (100, 1, 8), (100, 2, 8),
    (100, 1, 9), (100, 2, 9),
    (100, 1, 10), (100, 2, 10),
    (100, 1, 11), (100, 2, 11),
    (100, 1, 12), (100, 2, 12),
    (100, 1, 13), (100, 2, 13),
    (100, 1, 14), (100, 2, 14),
    (100, 1, 15), (100, 2, 15),
    (100, 1, 16), (100, 2, 16),
    (100, 1, 17), (100, 2, 17),
    (100, 1, 18), (100, 2, 18),
    (100, 1, 19), (100, 2, 19),
    (100, 1, 20), (100, 2, 20),
    (100, 1, 21), (100, 2, 21),
    (100, 1, 22), (100, 2, 22),
    (100, 1, 23), (100, 2, 23),
    (100, 1, 24), (100, 2, 24),
    (100, 1, 25), (100, 2, 25),
    (100, 1, 26), (100, 2, 26),
    (100, 1, 27), (100, 2, 27),
    (100, 1, 28), (100, 2, 28),
    (100, 1, 29), (100, 2, 29),
    (100, 1, 30), (100, 2, 30),
    (100, 1, 31), (100, 2, 31),

    -- August 2027: MaanedsplanId 110, 31 dage
    (110, 1, 1), (110, 2, 1),
    (110, 1, 2), (110, 2, 2),
    (110, 1, 3), (110, 2, 3),
    (110, 1, 4), (110, 2, 4),
    (110, 1, 5), (110, 2, 5),
    (110, 1, 6), (110, 2, 6),
    (110, 1, 7), (110, 2, 7),
    (110, 1, 8), (110, 2, 8),
    (110, 1, 9), (110, 2, 9),
    (110, 1, 10), (110, 2, 10),
    (110, 1, 11), (110, 2, 11),
    (110, 1, 12), (110, 2, 12),
    (110, 1, 13), (110, 2, 13),
    (110, 1, 14), (110, 2, 14),
    (110, 1, 15), (110, 2, 15),
    (110, 1, 16), (110, 2, 16),
    (110, 1, 17), (110, 2, 17),
    (110, 1, 18), (110, 2, 18),
    (110, 1, 19), (110, 2, 19),
    (110, 1, 20), (110, 2, 20),
    (110, 1, 21), (110, 2, 21),
    (110, 1, 22), (110, 2, 22),
    (110, 1, 23), (110, 2, 23),
    (110, 1, 24), (110, 2, 24),
    (110, 1, 25), (110, 2, 25),
    (110, 1, 26), (110, 2, 26),
    (110, 1, 27), (110, 2, 27),
    (110, 1, 28), (110, 2, 28),
    (110, 1, 29), (110, 2, 29),
    (110, 1, 30), (110, 2, 30),
    (110, 1, 31), (110, 2, 31),

    -- September 2027: MaanedsplanId 120, 30 dage
    (120, 1, 1), (120, 2, 1),
    (120, 1, 2), (120, 2, 2),
    (120, 1, 3), (120, 2, 3),
    (120, 1, 4), (120, 2, 4),
    (120, 1, 5), (120, 2, 5),
    (120, 1, 6), (120, 2, 6),
    (120, 1, 7), (120, 2, 7),
    (120, 1, 8), (120, 2, 8),
    (120, 1, 9), (120, 2, 9),
    (120, 1, 10), (120, 2, 10),
    (120, 1, 11), (120, 2, 11),
    (120, 1, 12), (120, 2, 12),
    (120, 1, 13), (120, 2, 13),
    (120, 1, 14), (120, 2, 14),
    (120, 1, 15), (120, 2, 15),
    (120, 1, 16), (120, 2, 16),
    (120, 1, 17), (120, 2, 17),
    (120, 1, 18), (120, 2, 18),
    (120, 1, 19), (120, 2, 19),
    (120, 1, 20), (120, 2, 20),
    (120, 1, 21), (120, 2, 21),
    (120, 1, 22), (120, 2, 22),
    (120, 1, 23), (120, 2, 23),
    (120, 1, 24), (120, 2, 24),
    (120, 1, 25), (120, 2, 25),
    (120, 1, 26), (120, 2, 26),
    (120, 1, 27), (120, 2, 27),
    (120, 1, 28), (120, 2, 28),
    (120, 1, 29), (120, 2, 29),
    (120, 1, 30), (120, 2, 30);

--Tildeler vagter til alle medarbejdere for november 2026 og frem til og med september 2027:

-- VagtTildelingId oprettes automatisk med IDENTITY.
-- Hvert par er (VagtId, MedarbejderId).
-- Brug vagt-ID'erne fra din CSV og medarbejder-ID 1-12.

-- November 2026
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. november
    (63, 2), (63, 5), (63, 9), -- Formiddag
    (64, 2), (64, 3), (64, 9), -- Eftermiddag
    -- 2. november
    (65, 2), (65, 3), -- Formiddag
    (66, 1), (66, 9), -- Eftermiddag
    -- 3. november
    (67, 1), (67, 3), (67, 6), -- Formiddag
    (68, 2), (68, 4), (68, 7), -- Eftermiddag
    -- 4. november
    (69, 2), (69, 3), (69, 4), -- Formiddag
    (70, 1), (70, 3), (70, 8), -- Eftermiddag
    -- 5. november
    (71, 1), (71, 6), (71, 9), -- Formiddag
    (72, 2), (72, 4), (72, 6), -- Eftermiddag
    -- 6. november
    (73, 2), (73, 7), (73, 8), -- Formiddag
    (74, 1), (74, 7), -- Eftermiddag
    -- 7. november
    (75, 2), (75, 6), (75, 8), -- Formiddag
    (76, 2), (76, 12), -- Eftermiddag
    -- 8. november
    (77, 1), (77, 11), (77, 12), -- Formiddag
    (78, 1), (78, 6), (78, 12), -- Eftermiddag
    -- 9. november
    (79, 1), (79, 4), (79, 5), -- Formiddag
    (80, 2), (80, 4), (80, 7), -- Eftermiddag
    -- 10. november
    (81, 2), (81, 6), (81, 8), -- Formiddag
    (82, 1), (82, 3), (82, 7), -- Eftermiddag
    -- 11. november
    (83, 1), (83, 3), (83, 7), -- Formiddag
    (84, 2), (84, 3), (84, 4), -- Eftermiddag
    -- 12. november
    (85, 2), (85, 4), -- Formiddag
    (86, 1), (86, 7), -- Eftermiddag
    -- 13. november
    (87, 1), (87, 3), (87, 4), -- Formiddag
    (88, 2), (88, 3), (88, 4), -- Eftermiddag
    -- 14. november
    (89, 1), (89, 9), (89, 10), -- Formiddag
    (90, 1), (90, 10), (90, 12), -- Eftermiddag
    -- 15. november
    (91, 2), (91, 4), (91, 11), -- Formiddag
    (92, 2), (92, 7), (92, 12), -- Eftermiddag
    -- 16. november
    (93, 2), (93, 4), (93, 5), -- Formiddag
    (94, 1), (94, 3), (94, 5), -- Eftermiddag
    -- 17. november
    (95, 1), (95, 5), (95, 6), -- Formiddag
    (96, 2), (96, 3), (96, 6), -- Eftermiddag
    -- 18. november
    (97, 2), (97, 3), (97, 5), -- Formiddag
    (98, 1), (98, 4), -- Eftermiddag
    -- 19. november
    (99, 1), (99, 7), (99, 9), -- Formiddag
    (100, 2), (100, 8), -- Eftermiddag
    -- 20. november
    (101, 2), (101, 3), -- Formiddag
    (102, 1), (102, 3), (102, 5), -- Eftermiddag
    -- 21. november
    (103, 2), (103, 3), (103, 4), -- Formiddag
    (104, 2), (104, 4), (104, 10), -- Eftermiddag
    -- 22. november
    (105, 1), (105, 4), -- Formiddag
    (106, 1), (106, 5), (106, 11), -- Eftermiddag
    -- 23. november
    (107, 1), (107, 4), (107, 8), -- Formiddag
    (108, 2), (108, 8), -- Eftermiddag
    -- 24. november
    (109, 2), (109, 8), -- Formiddag
    (110, 1), (110, 5), -- Eftermiddag
    -- 25. november
    (111, 1), (111, 5), (111, 9), -- Formiddag
    (112, 2), (112, 3), (112, 4), -- Eftermiddag
    -- 26. november
    (113, 2), (113, 4), (113, 5), -- Formiddag
    (114, 1), (114, 3), (114, 4), -- Eftermiddag
    -- 27. november
    (115, 1), (115, 6), (115, 9), -- Formiddag
    (116, 2), (116, 7), -- Eftermiddag
    -- 28. november
    (117, 1), (117, 3), (117, 10), -- Formiddag
    (118, 1), (118, 4), -- Eftermiddag
    -- 29. november
    (119, 2), (119, 10), (119, 11), -- Formiddag
    (120, 2), (120, 6), (120, 11), -- Eftermiddag
    -- 30. november
    (121, 2), (121, 3), (121, 5), -- Formiddag
    (122, 1), (122, 3), (122, 5); -- Eftermiddag

-- December 2026
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. december
    (123, 1), (123, 3), (123, 4), -- Formiddag
    (124, 2), (124, 4), -- Eftermiddag
    -- 2. december
    (125, 2), (125, 3), (125, 9), -- Formiddag
    (126, 1), (126, 3), (126, 7), -- Eftermiddag
    -- 3. december
    (127, 1), (127, 3), (127, 6), -- Formiddag
    (128, 2), (128, 8), -- Eftermiddag
    -- 4. december
    (129, 2), (129, 3), (129, 4), -- Formiddag
    (130, 1), (130, 6), -- Eftermiddag
    -- 5. december
    (131, 2), (131, 4), (131, 10), -- Formiddag
    (132, 2), (132, 5), -- Eftermiddag
    -- 6. december
    (133, 1), (133, 4), (133, 12), -- Formiddag
    (134, 1), (134, 3), (134, 6), -- Eftermiddag
    -- 7. december
    (135, 1), (135, 3), (135, 6), -- Formiddag
    (136, 2), (136, 4), (136, 6), -- Eftermiddag
    -- 8. december
    (137, 2), (137, 9), -- Formiddag
    (138, 1), (138, 5), (138, 7), -- Eftermiddag
    -- 9. december
    (139, 1), (139, 4), (139, 9), -- Formiddag
    (140, 2), (140, 6), (140, 9), -- Eftermiddag
    -- 10. december
    (141, 2), (141, 7), -- Formiddag
    (142, 1), (142, 5), (142, 6), -- Eftermiddag
    -- 11. december
    (143, 1), (143, 5), -- Formiddag
    (144, 2), (144, 5), -- Eftermiddag
    -- 12. december
    (145, 1), (145, 10), (145, 12), -- Formiddag
    (146, 1), (146, 10), (146, 11), -- Eftermiddag
    -- 13. december
    (147, 2), (147, 3), (147, 10), -- Formiddag
    (148, 2), (148, 8), (148, 12), -- Eftermiddag
    -- 14. december
    (149, 2), (149, 4), -- Formiddag
    (150, 1), (150, 4), (150, 8), -- Eftermiddag
    -- 15. december
    (151, 1), (151, 3), (151, 8), -- Formiddag
    (152, 2), (152, 3), (152, 8), -- Eftermiddag
    -- 16. december
    (153, 2), (153, 6), -- Formiddag
    (154, 1), (154, 3), -- Eftermiddag
    -- 17. december
    (155, 1), (155, 3), (155, 7), -- Formiddag
    (156, 2), (156, 4), (156, 7), -- Eftermiddag
    -- 18. december
    (157, 2), (157, 5), (157, 8), -- Formiddag
    (158, 1), (158, 4), (158, 5), -- Eftermiddag
    -- 19. december
    (159, 2), (159, 3), (159, 7), -- Formiddag
    (160, 2), (160, 3), (160, 11), -- Eftermiddag
    -- 20. december
    (161, 1), (161, 7), (161, 12), -- Formiddag
    (162, 1), (162, 4), (162, 12), -- Eftermiddag
    -- 21. december
    (163, 1), (163, 7), (163, 8), -- Formiddag
    (164, 2), (164, 5), (164, 9), -- Eftermiddag
    -- 22. december
    (165, 2), (165, 4), (165, 6), -- Formiddag
    (166, 1), (166, 4), (166, 6), -- Eftermiddag
    -- 23. december
    (167, 1), (167, 8), -- Formiddag
    (168, 2), (168, 3), (168, 7), -- Eftermiddag
    -- 24. december
    (169, 2), (169, 4), (169, 6), -- Formiddag
    (170, 1), (170, 5), -- Eftermiddag
    -- 25. december
    (171, 1), (171, 3), (171, 5), -- Formiddag
    (172, 2), (172, 3), (172, 8), -- Eftermiddag
    -- 26. december
    (173, 1), (173, 6), (173, 11), -- Formiddag
    (174, 1), (174, 5), (174, 11), -- Eftermiddag
    -- 27. december
    (175, 2), (175, 3), (175, 4), -- Formiddag
    (176, 2), (176, 10), (176, 11), -- Eftermiddag
    -- 28. december
    (177, 2), (177, 7), (177, 9), -- Formiddag
    (178, 1), (178, 5), (178, 8), -- Eftermiddag
    -- 29. december
    (179, 1), (179, 3), (179, 4), -- Formiddag
    (180, 2), (180, 3), (180, 5), -- Eftermiddag
    -- 30. december
    (181, 2), (181, 4), -- Formiddag
    (182, 1), (182, 4), (182, 7), -- Eftermiddag
    -- 31. december
    (183, 1), (183, 5), -- Formiddag
    (184, 2), (184, 4); -- Eftermiddag

-- Januar 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. januar
    (185, 2), (185, 6), (185, 9), -- Formiddag
    (186, 1), (186, 8), -- Eftermiddag
    -- 2. januar
    (187, 2), (187, 3), (187, 11), -- Formiddag
    (188, 2), (188, 4), -- Eftermiddag
    -- 3. januar
    (189, 1), (189, 4), (189, 10), -- Formiddag
    (190, 1), (190, 3), (190, 12), -- Eftermiddag
    -- 4. januar
    (191, 1), (191, 4), (191, 9), -- Formiddag
    (192, 2), (192, 3), (192, 8), -- Eftermiddag
    -- 5. januar
    (193, 2), (193, 3), -- Formiddag
    (194, 1), (194, 5), -- Eftermiddag
    -- 6. januar
    (195, 1), (195, 3), (195, 7), -- Formiddag
    (196, 2), (196, 3), -- Eftermiddag
    -- 7. januar
    (197, 2), (197, 5), -- Formiddag
    (198, 1), (198, 6), (198, 7), -- Eftermiddag
    -- 8. januar
    (199, 1), (199, 5), (199, 7), -- Formiddag
    (200, 2), (200, 4), (200, 6), -- Eftermiddag
    -- 9. januar
    (201, 1), (201, 3), (201, 4), -- Formiddag
    (202, 1), (202, 6), (202, 8), -- Eftermiddag
    -- 10. januar
    (203, 2), (203, 9), (203, 11), -- Formiddag
    (204, 2), (204, 4), (204, 12), -- Eftermiddag
    -- 11. januar
    (205, 2), (205, 4), (205, 7), -- Formiddag
    (206, 1), (206, 4), (206, 8), -- Eftermiddag
    -- 12. januar
    (207, 1), (207, 3), -- Formiddag
    (208, 2), (208, 3), -- Eftermiddag
    -- 13. januar
    (209, 2), (209, 3), -- Formiddag
    (210, 1), (210, 4), -- Eftermiddag
    -- 14. januar
    (211, 1), (211, 5), -- Formiddag
    (212, 2), (212, 5), (212, 6), -- Eftermiddag
    -- 15. januar
    (213, 2), (213, 5), -- Formiddag
    (214, 1), (214, 6), (214, 7), -- Eftermiddag
    -- 16. januar
    (215, 2), (215, 4), (215, 7), -- Formiddag
    (216, 2), (216, 3), (216, 12), -- Eftermiddag
    -- 17. januar
    (217, 1), (217, 4), (217, 11), -- Formiddag
    (218, 1), (218, 5), (218, 7), -- Eftermiddag
    -- 18. januar
    (219, 1), (219, 4), (219, 5), -- Formiddag
    (220, 2), (220, 4), -- Eftermiddag
    -- 19. januar
    (221, 2), (221, 3), (221, 4), -- Formiddag
    (222, 1), (222, 4), -- Eftermiddag
    -- 20. januar
    (223, 1), (223, 4), (223, 5), -- Formiddag
    (224, 2), (224, 3), (224, 6), -- Eftermiddag
    -- 21. januar
    (225, 2), (225, 5), -- Formiddag
    (226, 1), (226, 7), -- Eftermiddag
    -- 22. januar
    (227, 1), (227, 5), (227, 9), -- Formiddag
    (228, 2), (228, 5), (228, 7), -- Eftermiddag
    -- 23. januar
    (229, 1), (229, 3), (229, 11), -- Formiddag
    (230, 1), (230, 3), (230, 11), -- Eftermiddag
    -- 24. januar
    (231, 2), (231, 3), (231, 10), -- Formiddag
    (232, 2), (232, 3), (232, 10), -- Eftermiddag
    -- 25. januar
    (233, 2), (233, 3), (233, 7), -- Formiddag
    (234, 1), (234, 3), (234, 4), -- Eftermiddag
    -- 26. januar
    (235, 1), (235, 4), (235, 6), -- Formiddag
    (236, 2), (236, 3), (236, 6), -- Eftermiddag
    -- 27. januar
    (237, 2), (237, 6), (237, 8), -- Formiddag
    (238, 1), (238, 6), (238, 8), -- Eftermiddag
    -- 28. januar
    (239, 1), (239, 5), (239, 7), -- Formiddag
    (240, 2), (240, 6), (240, 7), -- Eftermiddag
    -- 29. januar
    (241, 2), (241, 4), (241, 8), -- Formiddag
    (242, 1), (242, 3), (242, 4), -- Eftermiddag
    -- 30. januar
    (243, 2), (243, 4), (243, 12), -- Formiddag
    (244, 2), (244, 10), (244, 12), -- Eftermiddag
    -- 31. januar
    (245, 1), (245, 9), (245, 10), -- Formiddag
    (246, 1), (246, 3), (246, 9); -- Eftermiddag

-- Februar 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. februar
    (247, 1), (247, 4), (247, 5), -- Formiddag
    (248, 2), (248, 6), -- Eftermiddag
    -- 2. februar
    (249, 2), (249, 4), (249, 6), -- Formiddag
    (250, 1), (250, 4), (250, 9), -- Eftermiddag
    -- 3. februar
    (251, 1), (251, 4), (251, 6), -- Formiddag
    (252, 2), (252, 3), (252, 4), -- Eftermiddag
    -- 4. februar
    (253, 2), (253, 3), -- Formiddag
    (254, 1), (254, 3), -- Eftermiddag
    -- 5. februar
    (255, 1), (255, 3), (255, 9), -- Formiddag
    (256, 2), (256, 7), (256, 9), -- Eftermiddag
    -- 6. februar
    (257, 1), (257, 5), (257, 12), -- Formiddag
    (258, 1), (258, 7), (258, 10), -- Eftermiddag
    -- 7. februar
    (259, 2), (259, 10), (259, 11), -- Formiddag
    (260, 2), (260, 3), (260, 10), -- Eftermiddag
    -- 8. februar
    (261, 2), (261, 5), (261, 7), -- Formiddag
    (262, 1), (262, 3), (262, 5), -- Eftermiddag
    -- 9. februar
    (263, 1), (263, 3), (263, 7), -- Formiddag
    (264, 2), (264, 4), -- Eftermiddag
    -- 10. februar
    (265, 2), (265, 4), (265, 7), -- Formiddag
    (266, 1), (266, 3), (266, 7), -- Eftermiddag
    -- 11. februar
    (267, 1), (267, 4), -- Formiddag
    (268, 2), (268, 8), -- Eftermiddag
    -- 12. februar
    (269, 2), (269, 6), (269, 9), -- Formiddag
    (270, 1), (270, 3), (270, 6), -- Eftermiddag
    -- 13. februar
    (271, 2), (271, 5), (271, 10), -- Formiddag
    (272, 2), (272, 3), (272, 5), -- Eftermiddag
    -- 14. februar
    (273, 1), (273, 4), (273, 10), -- Formiddag
    (274, 1), (274, 5), (274, 12), -- Eftermiddag
    -- 15. februar
    (275, 1), (275, 3), (275, 8), -- Formiddag
    (276, 2), (276, 3), (276, 9), -- Eftermiddag
    -- 16. februar
    (277, 2), (277, 6), -- Formiddag
    (278, 1), (278, 7), (278, 9), -- Eftermiddag
    -- 17. februar
    (279, 1), (279, 4), -- Formiddag
    (280, 2), (280, 3), (280, 5), -- Eftermiddag
    -- 18. februar
    (281, 2), (281, 5), (281, 8), -- Formiddag
    (282, 1), (282, 8), -- Eftermiddag
    -- 19. februar
    (283, 1), (283, 3), -- Formiddag
    (284, 2), (284, 3), -- Eftermiddag
    -- 20. februar
    (285, 1), (285, 6), (285, 11), -- Formiddag
    (286, 1), (286, 5), (286, 11), -- Eftermiddag
    -- 21. februar
    (287, 2), (287, 4), (287, 12), -- Formiddag
    (288, 2), (288, 4), (288, 12), -- Eftermiddag
    -- 22. februar
    (289, 2), (289, 4), (289, 6), -- Formiddag
    (290, 1), (290, 6), (290, 9), -- Eftermiddag
    -- 23. februar
    (291, 1), (291, 5), (291, 8), -- Formiddag
    (292, 2), (292, 4), -- Eftermiddag
    -- 24. februar
    (293, 2), (293, 3), (293, 6), -- Formiddag
    (294, 1), (294, 4), -- Eftermiddag
    -- 25. februar
    (295, 1), (295, 5), (295, 8), -- Formiddag
    (296, 2), (296, 4), -- Eftermiddag
    -- 26. februar
    (297, 2), (297, 3), (297, 4), -- Formiddag
    (298, 1), (298, 7), (298, 8), -- Eftermiddag
    -- 27. februar
    (299, 2), (299, 3), (299, 12), -- Formiddag
    (300, 2), (300, 3), (300, 11), -- Eftermiddag
    -- 28. februar
    (301, 1), (301, 4), (301, 11), -- Formiddag
    (302, 1), (302, 3), (302, 4); -- Eftermiddag

-- Marts 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. marts
    (303, 1), (303, 3), (303, 4), -- Formiddag
    (304, 2), (304, 4), (304, 8), -- Eftermiddag
    -- 2. marts
    (305, 2), (305, 5), -- Formiddag
    (306, 1), (306, 4), -- Eftermiddag
    -- 3. marts
    (307, 1), (307, 8), (307, 9), -- Formiddag
    (308, 2), (308, 8), (308, 9), -- Eftermiddag
    -- 4. marts
    (309, 2), (309, 5), (309, 8), -- Formiddag
    (310, 1), (310, 3), (310, 9), -- Eftermiddag
    -- 5. marts
    (311, 1), (311, 7), -- Formiddag
    (312, 2), (312, 7), -- Eftermiddag
    -- 6. marts
    (313, 1), (313, 3), (313, 4), -- Formiddag
    (314, 1), (314, 3), (314, 12), -- Eftermiddag
    -- 7. marts
    (315, 2), (315, 10), (315, 11), -- Formiddag
    (316, 2), (316, 7), (316, 10), -- Eftermiddag
    -- 8. marts
    (317, 2), (317, 3), (317, 4), -- Formiddag
    (318, 1), (318, 3), (318, 4), -- Eftermiddag
    -- 9. marts
    (319, 1), (319, 3), (319, 6), -- Formiddag
    (320, 2), (320, 5), (320, 6), -- Eftermiddag
    -- 10. marts
    (321, 2), (321, 4), (321, 7), -- Formiddag
    (322, 1), (322, 6), -- Eftermiddag
    -- 11. marts
    (323, 1), (323, 3), (323, 6), -- Formiddag
    (324, 2), (324, 3), (324, 7), -- Eftermiddag
    -- 12. marts
    (325, 2), (325, 4), (325, 6), -- Formiddag
    (326, 1), (326, 7), -- Eftermiddag
    -- 13. marts
    (327, 2), (327, 3), (327, 10), -- Formiddag
    (328, 2), (328, 4), (328, 12), -- Eftermiddag
    -- 14. marts
    (329, 1), (329, 5), (329, 12), -- Formiddag
    (330, 1), (330, 4), (330, 12), -- Eftermiddag
    -- 15. marts
    (331, 1), (331, 3), -- Formiddag
    (332, 2), (332, 4), (332, 5), -- Eftermiddag
    -- 16. marts
    (333, 2), (333, 5), -- Formiddag
    (334, 1), (334, 3), (334, 5), -- Eftermiddag
    -- 17. marts
    (335, 1), (335, 3), (335, 8), -- Formiddag
    (336, 2), (336, 3), (336, 7), -- Eftermiddag
    -- 18. marts
    (337, 2), (337, 5), -- Formiddag
    (338, 1), (338, 4), (338, 9), -- Eftermiddag
    -- 19. marts
    (339, 1), (339, 3), -- Formiddag
    (340, 2), (340, 4), (340, 5), -- Eftermiddag
    -- 20. marts
    (341, 1), (341, 3), (341, 10), -- Formiddag
    (342, 1), (342, 8), (342, 11), -- Eftermiddag
    -- 21. marts
    (343, 2), (343, 3), (343, 11), -- Formiddag
    (344, 2), (344, 11), (344, 12), -- Eftermiddag
    -- 22. marts
    (345, 2), (345, 8), (345, 9), -- Formiddag
    (346, 1), (346, 4), (346, 5), -- Eftermiddag
    -- 23. marts
    (347, 1), (347, 6), -- Formiddag
    (348, 2), (348, 3), (348, 7), -- Eftermiddag
    -- 24. marts
    (349, 2), (349, 5), (349, 8), -- Formiddag
    (350, 1), (350, 6), (350, 9), -- Eftermiddag
    -- 25. marts
    (351, 1), (351, 6), -- Formiddag
    (352, 2), (352, 4), (352, 5), -- Eftermiddag
    -- 26. marts
    (353, 2), (353, 6), -- Formiddag
    (354, 1), (354, 4), (354, 6), -- Eftermiddag
    -- 27. marts
    (355, 2), (355, 4), -- Formiddag
    (356, 2), (356, 4), (356, 5), -- Eftermiddag
    -- 28. marts
    (357, 1), (357, 4), (357, 10), -- Formiddag
    (358, 1), (358, 4), (358, 11), -- Eftermiddag
    -- 29. marts
    (359, 1), (359, 5), (359, 6), -- Formiddag
    (360, 2), (360, 3), (360, 5), -- Eftermiddag
    -- 30. marts
    (361, 2), (361, 3), (361, 4), -- Formiddag
    (362, 1), (362, 3), (362, 9), -- Eftermiddag
    -- 31. marts
    (363, 1), (363, 3), -- Formiddag
    (364, 2), (364, 8); -- Eftermiddag

-- April 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. april
    (365, 2), (365, 6), (365, 9), -- Formiddag
    (366, 1), (366, 5), -- Eftermiddag
    -- 2. april
    (367, 1), (367, 4), -- Formiddag
    (368, 2), (368, 3), (368, 8), -- Eftermiddag
    -- 3. april
    (369, 1), (369, 3), (369, 8), -- Formiddag
    (370, 1), (370, 3), (370, 8), -- Eftermiddag
    -- 4. april
    (371, 2), (371, 3), (371, 4), -- Formiddag
    (372, 2), (372, 3), (372, 10), -- Eftermiddag
    -- 5. april
    (373, 2), (373, 3), (373, 8), -- Formiddag
    (374, 1), (374, 3), (374, 7), -- Eftermiddag
    -- 6. april
    (375, 1), (375, 3), (375, 4), -- Formiddag
    (376, 2), (376, 5), -- Eftermiddag
    -- 7. april
    (377, 2), (377, 3), -- Formiddag
    (378, 1), (378, 5), (378, 7), -- Eftermiddag
    -- 8. april
    (379, 1), (379, 4), (379, 5), -- Formiddag
    (380, 2), (380, 4), (380, 5), -- Eftermiddag
    -- 9. april
    (381, 2), (381, 4), (381, 6), -- Formiddag
    (382, 1), (382, 3), (382, 7), -- Eftermiddag
    -- 10. april
    (383, 2), (383, 4), (383, 10), -- Formiddag
    (384, 2), (384, 11), (384, 12), -- Eftermiddag
    -- 11. april
    (385, 1), (385, 3), (385, 12), -- Formiddag
    (386, 1), (386, 4), (386, 12), -- Eftermiddag
    -- 12. april
    (387, 1), (387, 4), -- Formiddag
    (388, 2), (388, 8), -- Eftermiddag
    -- 13. april
    (389, 2), (389, 6), (389, 8), -- Formiddag
    (390, 1), (390, 6), (390, 9), -- Eftermiddag
    -- 14. april
    (391, 1), (391, 5), (391, 7), -- Formiddag
    (392, 2), (392, 4), -- Eftermiddag
    -- 15. april
    (393, 2), (393, 4), -- Formiddag
    (394, 1), (394, 4), (394, 7), -- Eftermiddag
    -- 16. april
    (395, 1), (395, 3), (395, 6), -- Formiddag
    (396, 2), (396, 3), -- Eftermiddag
    -- 17. april
    (397, 1), (397, 5), (397, 11), -- Formiddag
    (398, 1), (398, 12), -- Eftermiddag
    -- 18. april
    (399, 2), (399, 10), (399, 11), -- Formiddag
    (400, 2), (400, 7), (400, 11), -- Eftermiddag
    -- 19. april
    (401, 2), (401, 6), -- Formiddag
    (402, 1), (402, 4), (402, 6), -- Eftermiddag
    -- 20. april
    (403, 1), (403, 5), (403, 6), -- Formiddag
    (404, 2), (404, 4), (404, 8), -- Eftermiddag
    -- 21. april
    (405, 2), (405, 4), (405, 7), -- Formiddag
    (406, 1), (406, 4), (406, 7), -- Eftermiddag
    -- 22. april
    (407, 1), (407, 6), (407, 7), -- Formiddag
    (408, 2), (408, 3), (408, 5), -- Eftermiddag
    -- 23. april
    (409, 2), (409, 3), (409, 7), -- Formiddag
    (410, 1), (410, 3), (410, 5), -- Eftermiddag
    -- 24. april
    (411, 2), (411, 3), (411, 9), -- Formiddag
    (412, 2), (412, 5), (412, 11), -- Eftermiddag
    -- 25. april
    (413, 1), (413, 7), (413, 10), -- Formiddag
    (414, 1), (414, 10), (414, 12), -- Eftermiddag
    -- 26. april
    (415, 1), (415, 6), -- Formiddag
    (416, 2), (416, 3), (416, 4), -- Eftermiddag
    -- 27. april
    (417, 2), (417, 4), (417, 8), -- Formiddag
    (418, 1), (418, 4), -- Eftermiddag
    -- 28. april
    (419, 1), (419, 9), -- Formiddag
    (420, 2), (420, 8), (420, 9), -- Eftermiddag
    -- 29. april
    (421, 2), (421, 3), (421, 5), -- Formiddag
    (422, 1), (422, 5), -- Eftermiddag
    -- 30. april
    (423, 1), (423, 3), (423, 6), -- Formiddag
    (424, 2), (424, 4), (424, 5); -- Eftermiddag

-- Maj 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. maj
    (425, 1), (425, 6), (425, 12), -- Formiddag
    (426, 1), (426, 3), (426, 10), -- Eftermiddag
    -- 2. maj
    (427, 2), (427, 4), (427, 6), -- Formiddag
    (428, 2), (428, 5), (428, 11), -- Eftermiddag
    -- 3. maj
    (429, 2), (429, 3), (429, 7), -- Formiddag
    (430, 1), (430, 3), (430, 5), -- Eftermiddag
    -- 4. maj
    (431, 1), (431, 3), (431, 4), -- Formiddag
    (432, 2), (432, 3), (432, 4), -- Eftermiddag
    -- 5. maj
    (433, 2), (433, 6), (433, 9), -- Formiddag
    (434, 1), (434, 8), -- Eftermiddag
    -- 6. maj
    (435, 1), (435, 7), -- Formiddag
    (436, 2), (436, 3), (436, 7), -- Eftermiddag
    -- 7. maj
    (437, 2), (437, 3), (437, 5), -- Formiddag
    (438, 1), (438, 4), (438, 5), -- Eftermiddag
    -- 8. maj
    (439, 2), (439, 3), (439, 6), -- Formiddag
    (440, 2), (440, 6), (440, 7), -- Eftermiddag
    -- 9. maj
    (441, 1), (441, 4), (441, 10), -- Formiddag
    (442, 1), (442, 10), (442, 12), -- Eftermiddag
    -- 10. maj
    (443, 1), (443, 8), -- Formiddag
    (444, 2), (444, 9), -- Eftermiddag
    -- 11. maj
    (445, 2), (445, 3), -- Formiddag
    (446, 1), (446, 7), -- Eftermiddag
    -- 12. maj
    (447, 1), (447, 3), (447, 4), -- Formiddag
    (448, 2), (448, 3), (448, 7), -- Eftermiddag
    -- 13. maj
    (449, 2), (449, 3), -- Formiddag
    (450, 1), (450, 3), (450, 4), -- Eftermiddag
    -- 14. maj
    (451, 1), (451, 5), -- Formiddag
    (452, 2), (452, 5), (452, 6), -- Eftermiddag
    -- 15. maj
    (453, 1), (453, 7), (453, 11), -- Formiddag
    (454, 1), (454, 4), (454, 11), -- Eftermiddag
    -- 16. maj
    (455, 2), (455, 6), -- Formiddag
    (456, 2), (456, 6), (456, 10), -- Eftermiddag
    -- 17. maj
    (457, 2), (457, 4), -- Formiddag
    (458, 1), (458, 3), (458, 8), -- Eftermiddag
    -- 18. maj
    (459, 1), (459, 4), (459, 8), -- Formiddag
    (460, 2), (460, 3), (460, 8), -- Eftermiddag
    -- 19. maj
    (461, 2), (461, 4), (461, 5), -- Formiddag
    (462, 1), (462, 4), (462, 6), -- Eftermiddag
    -- 20. maj
    (463, 1), (463, 4), (463, 5), -- Formiddag
    (464, 2), (464, 7), -- Eftermiddag
    -- 21. maj
    (465, 2), (465, 4), (465, 5), -- Formiddag
    (466, 1), (466, 6), (466, 8), -- Eftermiddag
    -- 22. maj
    (467, 2), (467, 6), (467, 11), -- Formiddag
    (468, 2), (468, 7), (468, 12), -- Eftermiddag
    -- 23. maj
    (469, 1), (469, 3), (469, 5), -- Formiddag
    (470, 1), (470, 9), (470, 10), -- Eftermiddag
    -- 24. maj
    (471, 1), (471, 3), -- Formiddag
    (472, 2), (472, 6), (472, 7), -- Eftermiddag
    -- 25. maj
    (473, 2), (473, 4), (473, 6), -- Formiddag
    (474, 1), (474, 4), -- Eftermiddag
    -- 26. maj
    (475, 1), (475, 4), (475, 5), -- Formiddag
    (476, 2), (476, 3), (476, 4), -- Eftermiddag
    -- 27. maj
    (477, 2), (477, 5), (477, 6), -- Formiddag
    (478, 1), (478, 8), -- Eftermiddag
    -- 28. maj
    (479, 1), (479, 3), (479, 7), -- Formiddag
    (480, 2), (480, 3), (480, 8), -- Eftermiddag
    -- 29. maj
    (481, 1), (481, 3), (481, 12), -- Formiddag
    (482, 1), (482, 5), (482, 12), -- Eftermiddag
    -- 30. maj
    (483, 2), (483, 9), -- Formiddag
    (484, 2), (484, 9), (484, 11), -- Eftermiddag
    -- 31. maj
    (485, 2), (485, 9), -- Formiddag
    (486, 1), (486, 3), (486, 4); -- Eftermiddag

-- Juni 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. juni
    (487, 1), (487, 4), (487, 8), -- Formiddag
    (488, 2), (488, 7), (488, 8), -- Eftermiddag
    -- 2. juni
    (489, 2), (489, 4), (489, 6), -- Formiddag
    (490, 1), (490, 3), (490, 7), -- Eftermiddag
    -- 3. juni
    (491, 1), (491, 5), (491, 7), -- Formiddag
    (492, 2), (492, 5), (492, 8), -- Eftermiddag
    -- 4. juni
    (493, 2), (493, 5), (493, 6), -- Formiddag
    (494, 1), (494, 6), (494, 9), -- Eftermiddag
    -- 5. juni
    (495, 2), (495, 3), (495, 11), -- Formiddag
    (496, 2), (496, 3), (496, 11), -- Eftermiddag
    -- 6. juni
    (497, 1), (497, 4), (497, 10), -- Formiddag
    (498, 1), (498, 4), (498, 10), -- Eftermiddag
    -- 7. juni
    (499, 1), (499, 6), -- Formiddag
    (500, 2), (500, 7), -- Eftermiddag
    -- 8. juni
    (501, 2), (501, 3), (501, 4), -- Formiddag
    (502, 1), (502, 9), -- Eftermiddag
    -- 9. juni
    (503, 1), (503, 3), -- Formiddag
    (504, 2), (504, 6), -- Eftermiddag
    -- 10. juni
    (505, 2), (505, 4), (505, 5), -- Formiddag
    (506, 1), (506, 4), (506, 5), -- Eftermiddag
    -- 11. juni
    (507, 1), (507, 5), -- Formiddag
    (508, 2), (508, 7), -- Eftermiddag
    -- 12. juni
    (509, 1), (509, 5), (509, 12), -- Formiddag
    (510, 1), (510, 4), (510, 10), -- Eftermiddag
    -- 13. juni
    (511, 2), (511, 3), (511, 11), -- Formiddag
    (512, 2), (512, 4), (512, 10), -- Eftermiddag
    -- 14. juni
    (513, 2), (513, 3), (513, 7), -- Formiddag
    (514, 1), (514, 3), (514, 5), -- Eftermiddag
    -- 15. juni
    (515, 1), (515, 3), (515, 5), -- Formiddag
    (516, 2), (516, 4), -- Eftermiddag
    -- 16. juni
    (517, 2), (517, 4), (517, 7), -- Formiddag
    (518, 1), (518, 3), -- Eftermiddag
    -- 17. juni
    (519, 1), (519, 4), (519, 5), -- Formiddag
    (520, 2), (520, 3), (520, 8), -- Eftermiddag
    -- 18. juni
    (521, 2), (521, 3), -- Formiddag
    (522, 1), (522, 3), (522, 8), -- Eftermiddag
    -- 19. juni
    (523, 2), (523, 6), (523, 10), -- Formiddag
    (524, 2), (524, 11), (524, 12), -- Eftermiddag
    -- 20. juni
    (525, 1), (525, 3), (525, 12), -- Formiddag
    (526, 1), (526, 5), (526, 12), -- Eftermiddag
    -- 21. juni
    (527, 1), (527, 3), (527, 9), -- Formiddag
    (528, 2), (528, 8), (528, 9), -- Eftermiddag
    -- 22. juni
    (529, 2), (529, 3), (529, 4), -- Formiddag
    (530, 1), (530, 3), (530, 4), -- Eftermiddag
    -- 23. juni
    (531, 1), (531, 3), (531, 7), -- Formiddag
    (532, 2), (532, 7), -- Eftermiddag
    -- 24. juni
    (533, 2), (533, 5), (533, 6), -- Formiddag
    (534, 1), (534, 6), (534, 8), -- Eftermiddag
    -- 25. juni
    (535, 1), (535, 3), (535, 4), -- Formiddag
    (536, 2), (536, 9), -- Eftermiddag
    -- 26. juni
    (537, 1), (537, 3), (537, 6), -- Formiddag
    (538, 1), (538, 7), (538, 12), -- Eftermiddag
    -- 27. juni
    (539, 2), (539, 11), -- Formiddag
    (540, 2), (540, 5), (540, 6), -- Eftermiddag
    -- 28. juni
    (541, 2), (541, 6), -- Formiddag
    (542, 1), (542, 4), -- Eftermiddag
    -- 29. juni
    (543, 1), (543, 3), (543, 4), -- Formiddag
    (544, 2), (544, 3), (544, 4), -- Eftermiddag
    -- 30. juni
    (545, 2), (545, 7), (545, 9), -- Formiddag
    (546, 1), (546, 3), (546, 4); -- Eftermiddag

-- Juli 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. juli
    (547, 1), (547, 4), (547, 5), -- Formiddag
    (548, 2), (548, 5), (548, 8), -- Eftermiddag
    -- 2. juli
    (549, 2), (549, 8), (549, 9), -- Formiddag
    (550, 1), (550, 3), (550, 4), -- Eftermiddag
    -- 3. juli
    (551, 2), (551, 6), (551, 7), -- Formiddag
    (552, 2), (552, 6), (552, 7), -- Eftermiddag
    -- 4. juli
    (553, 1), (553, 4), (553, 10), -- Formiddag
    (554, 1), (554, 3), (554, 10), -- Eftermiddag
    -- 5. juli
    (555, 1), (555, 4), -- Formiddag
    (556, 2), (556, 3), (556, 6), -- Eftermiddag
    -- 6. juli
    (557, 2), (557, 7), (557, 8), -- Formiddag
    (558, 1), (558, 8), -- Eftermiddag
    -- 7. juli
    (559, 1), (559, 3), -- Formiddag
    (560, 2), (560, 5), -- Eftermiddag
    -- 8. juli
    (561, 2), (561, 3), (561, 5), -- Formiddag
    (562, 1), (562, 3), -- Eftermiddag
    -- 9. juli
    (563, 1), (563, 3), (563, 7), -- Formiddag
    (564, 2), (564, 3), (564, 5), -- Eftermiddag
    -- 10. juli
    (565, 1), (565, 10), (565, 11), -- Formiddag
    (566, 1), (566, 7), (566, 11), -- Eftermiddag
    -- 11. juli
    (567, 2), (567, 3), (567, 4), -- Formiddag
    (568, 2), (568, 3), (568, 8), -- Eftermiddag
    -- 12. juli
    (569, 2), (569, 5), (569, 9), -- Formiddag
    (570, 1), (570, 4), (570, 9), -- Eftermiddag
    -- 13. juli
    (571, 1), (571, 8), (571, 9), -- Formiddag
    (572, 2), (572, 5), -- Eftermiddag
    -- 14. juli
    (573, 2), (573, 6), -- Formiddag
    (574, 1), (574, 3), (574, 5), -- Eftermiddag
    -- 15. juli
    (575, 1), (575, 3), (575, 7), -- Formiddag
    (576, 2), (576, 3), (576, 6), -- Eftermiddag
    -- 16. juli
    (577, 2), (577, 5), -- Formiddag
    (578, 1), (578, 7), -- Eftermiddag
    -- 17. juli
    (579, 2), (579, 4), (579, 11), -- Formiddag
    (580, 2), (580, 7), (580, 12), -- Eftermiddag
    -- 18. juli
    (581, 1), (581, 3), (581, 11), -- Formiddag
    (582, 1), (582, 5), (582, 12), -- Eftermiddag
    -- 19. juli
    (583, 1), (583, 4), -- Formiddag
    (584, 2), (584, 6), -- Eftermiddag
    -- 20. juli
    (585, 2), (585, 3), (585, 8), -- Formiddag
    (586, 1), (586, 4), (586, 7), -- Eftermiddag
    -- 21. juli
    (587, 1), (587, 3), (587, 4), -- Formiddag
    (588, 2), (588, 3), (588, 6), -- Eftermiddag
    -- 22. juli
    (589, 2), (589, 3), (589, 4), -- Formiddag
    (590, 1), (590, 4), (590, 9), -- Eftermiddag
    -- 23. juli
    (591, 1), (591, 3), (591, 6), -- Formiddag
    (592, 2), (592, 5), (592, 7), -- Eftermiddag
    -- 24. juli
    (593, 1), (593, 4), (593, 10), -- Formiddag
    (594, 1), (594, 6), (594, 8), -- Eftermiddag
    -- 25. juli
    (595, 2), (595, 11), (595, 12), -- Formiddag
    (596, 2), (596, 10), (596, 12), -- Eftermiddag
    -- 26. juli
    (597, 2), (597, 6), -- Formiddag
    (598, 1), (598, 5), (598, 6), -- Eftermiddag
    -- 27. juli
    (599, 1), (599, 7), -- Formiddag
    (600, 2), (600, 3), (600, 4), -- Eftermiddag
    -- 28. juli
    (601, 2), (601, 4), (601, 5), -- Formiddag
    (602, 1), (602, 4), (602, 5), -- Eftermiddag
    -- 29. juli
    (603, 1), (603, 4), -- Formiddag
    (604, 2), (604, 4), (604, 7), -- Eftermiddag
    -- 30. juli
    (605, 2), (605, 4), -- Formiddag
    (606, 1), (606, 6), -- Eftermiddag
    -- 31. juli
    (607, 2), (607, 4), (607, 12), -- Formiddag
    (608, 2), (608, 3), (608, 4); -- Eftermiddag

-- August 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. august
    (609, 1), (609, 10), (609, 12), -- Formiddag
    (610, 1), (610, 3), (610, 12), -- Eftermiddag
    -- 2. august
    (611, 1), (611, 3), (611, 5), -- Formiddag
    (612, 2), (612, 6), -- Eftermiddag
    -- 3. august
    (613, 2), (613, 3), (613, 5), -- Formiddag
    (614, 1), (614, 4), -- Eftermiddag
    -- 4. august
    (615, 1), (615, 6), (615, 7), -- Formiddag
    (616, 2), (616, 4), -- Eftermiddag
    -- 5. august
    (617, 2), (617, 4), (617, 5), -- Formiddag
    (618, 1), (618, 6), -- Eftermiddag
    -- 6. august
    (619, 1), (619, 3), -- Formiddag
    (620, 2), (620, 3), (620, 4), -- Eftermiddag
    -- 7. august
    (621, 1), (621, 4), -- Formiddag
    (622, 1), (622, 7), -- Eftermiddag
    -- 8. august
    (623, 2), (623, 4), (623, 11), -- Formiddag
    (624, 2), (624, 4), (624, 11), -- Eftermiddag
    -- 9. august
    (625, 2), (625, 5), (625, 9), -- Formiddag
    (626, 1), (626, 9), -- Eftermiddag
    -- 10. august
    (627, 1), (627, 4), (627, 8), -- Formiddag
    (628, 2), (628, 3), (628, 5), -- Eftermiddag
    -- 11. august
    (629, 2), (629, 3), (629, 7), -- Formiddag
    (630, 1), (630, 5), (630, 7), -- Eftermiddag
    -- 12. august
    (631, 1), (631, 3), (631, 8), -- Formiddag
    (632, 2), (632, 4), -- Eftermiddag
    -- 13. august
    (633, 2), (633, 3), (633, 4), -- Formiddag
    (634, 1), (634, 6), -- Eftermiddag
    -- 14. august
    (635, 2), (635, 3), -- Formiddag
    (636, 2), (636, 4), (636, 5), -- Eftermiddag
    -- 15. august
    (637, 1), (637, 3), (637, 12), -- Formiddag
    (638, 1), (638, 3), (638, 11), -- Eftermiddag
    -- 16. august
    (639, 1), (639, 4), (639, 8), -- Formiddag
    (640, 2), (640, 4), (640, 6), -- Eftermiddag
    -- 17. august
    (641, 2), (641, 4), (641, 8), -- Formiddag
    (642, 1), (642, 7), (642, 9), -- Eftermiddag
    -- 18. august
    (643, 1), (643, 9), -- Formiddag
    (644, 2), (644, 6), (644, 8), -- Eftermiddag
    -- 19. august
    (645, 2), (645, 3), (645, 4), -- Formiddag
    (646, 1), (646, 3), (646, 8), -- Eftermiddag
    -- 20. august
    (647, 1), (647, 4), (647, 8), -- Formiddag
    (648, 2), (648, 3), (648, 4), -- Eftermiddag
    -- 21. august
    (649, 1), (649, 10), (649, 11), -- Formiddag
    (650, 1), (650, 10), (650, 12), -- Eftermiddag
    -- 22. august
    (651, 2), (651, 4), (651, 12), -- Formiddag
    (652, 2), (652, 4), (652, 10), -- Eftermiddag
    -- 23. august
    (653, 2), (653, 5), (653, 7), -- Formiddag
    (654, 1), (654, 5), (654, 6), -- Eftermiddag
    -- 24. august
    (655, 1), (655, 3), (655, 5), -- Formiddag
    (656, 2), (656, 3), (656, 7), -- Eftermiddag
    -- 25. august
    (657, 2), (657, 3), (657, 6), -- Formiddag
    (658, 1), (658, 3), (658, 6), -- Eftermiddag
    -- 26. august
    (659, 1), (659, 3), (659, 4), -- Formiddag
    (660, 2), (660, 7), (660, 9), -- Eftermiddag
    -- 27. august
    (661, 2), (661, 7), -- Formiddag
    (662, 1), (662, 9), -- Eftermiddag
    -- 28. august
    (663, 2), (663, 6), (663, 11), -- Formiddag
    (664, 2), (664, 6), (664, 7), -- Eftermiddag
    -- 29. august
    (665, 1), (665, 4), (665, 10), -- Formiddag
    (666, 1), (666, 5), -- Eftermiddag
    -- 30. august
    (667, 1), (667, 8), (667, 9), -- Formiddag
    (668, 2), (668, 6), (668, 8), -- Eftermiddag
    -- 31. august
    (669, 2), (669, 5), -- Formiddag
    (670, 1), (670, 4), (670, 5); -- Eftermiddag

-- September 2027
INSERT INTO VagtTildeling (VagtId, MedarbejderId)
VALUES
    -- 1. september
    (671, 1), (671, 8), -- Formiddag
    (672, 2), (672, 3), (672, 4), -- Eftermiddag
    -- 2. september
    (673, 2), (673, 4), (673, 8), -- Formiddag
    (674, 1), (674, 4), (674, 6), -- Eftermiddag
    -- 3. september
    (675, 1), (675, 3), (675, 4), -- Formiddag
    (676, 2), (676, 3), -- Eftermiddag
    -- 4. september
    (677, 1), (677, 10), (677, 11), -- Formiddag
    (678, 1), (678, 6), (678, 12), -- Eftermiddag
    -- 5. september
    (679, 2), (679, 3), (679, 5), -- Formiddag
    (680, 2), (680, 7), -- Eftermiddag
    -- 6. september
    (681, 2), (681, 3), (681, 9), -- Formiddag
    (682, 1), (682, 3), (682, 4), -- Eftermiddag
    -- 7. september
    (683, 1), (683, 5), (683, 9), -- Formiddag
    (684, 2), (684, 4), (684, 9), -- Eftermiddag
    -- 8. september
    (685, 2), (685, 7), -- Formiddag
    (686, 1), (686, 5), (686, 6), -- Eftermiddag
    -- 9. september
    (687, 1), (687, 3), -- Formiddag
    (688, 2), (688, 3), (688, 8), -- Eftermiddag
    -- 10. september
    (689, 2), (689, 4), -- Formiddag
    (690, 1), (690, 5), (690, 7), -- Eftermiddag
    -- 11. september
    (691, 2), (691, 6), (691, 10), -- Formiddag
    (692, 2), (692, 6), (692, 11), -- Eftermiddag
    -- 12. september
    (693, 1), (693, 4), (693, 11), -- Formiddag
    (694, 1), (694, 11), (694, 12), -- Eftermiddag
    -- 13. september
    (695, 1), (695, 4), (695, 8), -- Formiddag
    (696, 2), (696, 3), -- Eftermiddag
    -- 14. september
    (697, 2), (697, 9), -- Formiddag
    (698, 1), (698, 4), (698, 8), -- Eftermiddag
    -- 15. september
    (699, 1), (699, 3), (699, 6), -- Formiddag
    (700, 2), (700, 6), (700, 7), -- Eftermiddag
    -- 16. september
    (701, 2), (701, 3), (701, 5), -- Formiddag
    (702, 1), (702, 5), (702, 6), -- Eftermiddag
    -- 17. september
    (703, 1), (703, 4), (703, 7), -- Formiddag
    (704, 2), (704, 3), (704, 5), -- Eftermiddag
    -- 18. september
    (705, 1), (705, 6), (705, 10), -- Formiddag
    (706, 1), (706, 11), -- Eftermiddag
    -- 19. september
    (707, 2), (707, 10), (707, 12), -- Formiddag
    (708, 2), (708, 10), (708, 12), -- Eftermiddag
    -- 20. september
    (709, 2), (709, 4), (709, 7), -- Formiddag
    (710, 1), (710, 3), (710, 7), -- Eftermiddag
    -- 21. september
    (711, 1), (711, 3), -- Formiddag
    (712, 2), (712, 8), -- Eftermiddag
    -- 22. september
    (713, 2), (713, 3), (713, 8), -- Formiddag
    (714, 1), (714, 6), (714, 8), -- Eftermiddag
    -- 23. september
    (715, 1), (715, 3), (715, 5), -- Formiddag
    (716, 2), (716, 3), (716, 5), -- Eftermiddag
    -- 24. september
    (717, 2), (717, 3), (717, 4), -- Formiddag
    (718, 1), (718, 4), -- Eftermiddag
    -- 25. september
    (719, 2), (719, 5), (719, 9), -- Formiddag
    (720, 2), (720, 3), (720, 12), -- Eftermiddag
    -- 26. september
    (721, 1), (721, 4), (721, 6), -- Formiddag
    (722, 1), (722, 5), (722, 7), -- Eftermiddag
    -- 27. september
    (723, 1), (723, 3), -- Formiddag
    (724, 2), (724, 3), (724, 5), -- Eftermiddag
    -- 28. september
    (725, 2), (725, 4), (725, 6), -- Formiddag
    (726, 1), (726, 4), (726, 7), -- Eftermiddag
    -- 29. september
    (727, 1), (727, 4), (727, 6), -- Formiddag
    (728, 2), (728, 4), -- Eftermiddag
    -- 30. september
    (729, 2), (729, 4), (729, 9), -- Formiddag
    (730, 1), (730, 3); -- Eftermiddag
