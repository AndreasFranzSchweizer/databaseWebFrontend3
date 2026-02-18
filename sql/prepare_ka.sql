DROP DATABASE bundesliga22;
DROP DATABASE mondial;
DROP DATABASE bundesliga;
DROP DATABASE fahrradverleih;
DROP DATABASE hotel
DROP DATABASE streamingdienst
DROP DATABASE solar

CREATE USER webfrontend WITH PASSWORD 'web';

-- Erstellen der neuen Datenbank für das Lagerverwaltungssystem
CREATE DATABASE lagerverwaltung;

-- Verbinden mit der neuen Datenbank (dieser Schritt hängt vom SQL-Client ab)
\c lagerverwaltung;

-- Erstellen der Tabelle „Bauteile“ mit zusätzlichen Feldern für sinnvolles GROUP BY
CREATE TABLE bauteile (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    kategorie TEXT,
    beschreibung TEXT,
    menge INTEGER NOT NULL,
    lagerplatz TEXT,
    letzte_beschaffung DATE,
    einzelpreis NUMERIC(5, 2)
);

-- Einfügen von Beispiel-Datensätzen in „Bauteile“
INSERT INTO bauteile (name, kategorie, beschreibung, menge, lagerplatz, letzte_beschaffung, einzelpreis) VALUES
    ('Widerstand 10kΩ', 'Widerstand', 'Standard-Widerstand für allgemeine Anwendungen', 1000, 'R1', '2024-02-15', 0.02),
    ('Kondensator 100µF', 'Kondensator', 'Elektrolytkondensator', 500, 'C3', '2024-03-05', 0.10),
    ('Transistor BC547', 'Transistor', 'NPN-Transistor', 300, 'T2', '2024-01-20', 0.15),
    ('Diode 1N4007', 'Diode', 'Standard-Gleichrichterdiode', 800, 'D5', '2024-03-01', 0.05),
    ('IC 555 Timer', 'IC', 'Timer-IC für Schaltungen', 150, 'IC1', '2023-12-15', 0.50),
    ('LED rot 5mm', 'LED', '5mm Standard-LED rot', 1200, 'L2', '2024-03-10', 0.03),
    ('Kondensator 1µF', 'Kondensator', 'Keramikkondensator', 450, 'C3', '2024-01-18', 0.07),
    ('Widerstand 220Ω', 'Widerstand', 'Niedriger Widerstand für LED-Schutz', 1000, 'R1', '2024-03-02', 0.02),
    ('MOSFET IRF540N', 'MOSFET', 'Leistungs-MOSFET', 100, 'T2', '2024-02-20', 1.25),
    ('Diode Schottky', 'Diode', 'Schottky-Diode für Gleichrichtung', 700, 'D5', '2024-03-03', 0.08);

-- Erstellen der Tabelle „Lieferanten“
CREATE TABLE lieferanten (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    kontakt TEXT
);

-- Einfügen von Beispiel-Datensätzen in „Lieferanten“
INSERT INTO lieferanten (name, kontakt) VALUES
    ('Elektronikbedarf Müller', 'service@elektronikmueller.de'),
    ('Bauteil GmbH', 'info@bauteilgmbh.de');

-- Erstellen der Tabelle „Lieferungen“
CREATE TABLE lieferungen (
    id SERIAL PRIMARY KEY,
    bauteil_id INTEGER REFERENCES bauteile(id),
    lieferant_id INTEGER REFERENCES lieferanten(id),
    datum DATE NOT NULL,
    menge INTEGER NOT NULL
);

-- Einfügen von Beispiel-Datensätzen in „Lieferungen“
INSERT INTO lieferungen (bauteil_id, lieferant_id, datum, menge) VALUES
    (1, 1, '2024-02-15', 200),
    (2, 2, '2024-03-05', 100),
    (1, 2, '2024-03-10', 150),
    (2, 1, '2024-03-12', 75);


GRANT SELECT ON ALL TABLES IN SCHEMA public TO webfrontend;
