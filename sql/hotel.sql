DROP TABLE  IF EXISTS buchung,kunde,zimmerausstattung,ausstattung,zimmer;

CREATE TABLE zimmer (
    nr INT PRIMARY KEY,
    etage INT,
    betten INT
); 

CREATE TABLE ausstattung (
    id INT PRIMARY KEY ,
    "name" VARCHAR(32)
);

CREATE TABLE zimmerausstattung (
    id INT PRIMARY KEY,
    zimmernr INT REFERENCES zimmer(nr),
    ausstattid INT REFERENCES ausstattung(ID)
);

CREATE TABLE kunde (
    kundennr INT PRIMARY KEY,
    "name" VARCHAR(128)
);

CREATE TABLE buchung (
    id INT PRIMARY KEY,
    zimmer INT REFERENCES zimmer(nr),
    gast INT REFERENCES kunde(kundennr),
    von DATE,
    bis DATE
);

INSERT INTO zimmer VALUES 
(201, 1, 2),
(202, 1, 2),
(301, 2, 4),
(302, 3, 8),
(567, 4, 2),
(568, 4,4)
;

INSERT INTO ausstattung VALUES
(1, 'Minibar'),
(2, 'Playstation'),
(3, 'Soundsystem'),
(4, 'Massagesessel'),
(5, 'Nagelfeile'),
(6, 'Whirlpool');

INSERT INTO zimmerausstattung (id,zimmernr,ausstattid) VALUES
(1, 201, 1),
(2, 567, 6),
(3, 302, 4),
(4, 567, 5),
(5, 202, 1),
(6, 202,5),
(7,568,5)
;

INSERT INTO kunde VALUES
(67, 'John Doe'),
(68, 'Don Joe'),
(69, 'Linus Gates');

INSERT INTO buchung VALUES
(1, 302, 67, '2019-02-04', '2019-02-06'),
(2, 201, 68, '2019-01-10', '2019-02-19'),
(3, 302, 69, '2019-02-07', '2019-02-28'),
(4, 202, 69, '2020-02-07', '2020-02-09'),
(5, 202, 68, '2020-03-08', '2020-04-09'),
(6, 567, 68, '2020-08-08', '2020-08-09')
;

