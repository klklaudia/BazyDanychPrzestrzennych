-- Tabela pracownicy
CREATE TABLE ksiegowosc.pracownicy (
    id_pracownika SERIAL PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    adres TEXT,
    telefon VARCHAR(15),
    CONSTRAINT chk_telefon CHECK (telefon ~ '^[0-9]{9,15}$')
);

-- Tabela godziny
CREATE TABLE ksiegowosc.godziny (
    id_godziny SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    liczba_godzin SMALLINT NOT NULL CHECK (liczba_godzin > 0 AND liczba_godzin <= 24),
    id_pracownika INT NOT NULL REFERENCES ksiegowosc.pracownicy(id_pracownika) ON DELETE CASCADE
);

-- Tabela pensja
CREATE TABLE ksiegowosc.pensja (
    id_pensji SERIAL PRIMARY KEY,
    stanowisko VARCHAR(50) NOT NULL,
    kwota NUMERIC(10, 2) NOT NULL CHECK (kwota > 0)
);

-- Tabela premia
CREATE TABLE ksiegowosc.premia (
    id_premii SERIAL PRIMARY KEY,
    rodzaj VARCHAR(50) NOT NULL,
    kwota NUMERIC(10, 2) NOT NULL CHECK (kwota >= 0)
);

-- Tabela wynagrodzenie
CREATE TABLE ksiegowosc.wynagrodzenie (
    id_wynagrodzenia SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    id_pracownika INT NOT NULL REFERENCES ksiegowosc.pracownicy(id_pracownika) ON DELETE CASCADE,
    id_godziny INT NOT NULL REFERENCES ksiegowosc.godziny(id_godziny) ON DELETE CASCADE,
    id_pensji INT NOT NULL REFERENCES ksiegowosc.pensja(id_pensji) ON DELETE CASCADE,
    id_premii INT REFERENCES ksiegowosc.premia(id_premii) ON DELETE SET NULL
);

-- Tabela pracownicy
INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) VALUES
('Jan', 'Kowalski', 'ul. Kwiatowa 1, Kraków', '123456789'),
('Anna', 'Nowak', 'ul. Zielona 2, Warszawa', '987654321'),
('Marek', 'Wiśniewski', 'ul. Słoneczna 3, Gdańsk', '112233445'),
('Ewa', 'Kowalczyk', 'ul. Szkolna 4, Wrocław', '998877665'),
('Piotr', 'Zieliński', 'ul. Spacerowa 5, Poznań', '556677889'),
('Monika', 'Jankowska', 'ul. Lipowa 6, Łódź', '123123123'),
('Tomasz', 'Nowicki', 'ul. Długa 7, Szczecin', '321321321'),
('Katarzyna', 'Lewandowska', 'ul. Polna 8, Lublin', '987987987'),
('Robert', 'Kaczmarek', 'ul. Wiosenna 9, Katowice', '456456456'),
('Aleksandra', 'Piotrowska', 'ul. Jesienna 10, Białystok', '789789789');

-- Tabela godziny
INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika) VALUES
('2024-11-01', 8, 1),
('2024-11-02', 6, 1),
('2024-11-01', 8, 2),
('2024-11-02', 5, 2),
('2024-11-01', 7, 3),
('2024-11-03', 8, 4),
('2024-11-03', 4, 5),
('2024-11-01', 9, 6),
('2024-11-02', 10, 7),
('2024-11-03', 6, 8);

-- Tabela pensja
INSERT INTO ksiegowosc.pensja (stanowisko, kwota) VALUES
('Kierownik', 8000.00),
('Pracownik', 4000.00),
('Stażysta', 2000.00),
('Specjalista', 5000.00),
('Asystent', 3000.00),
('Dyrektor', 12000.00),
('Menedżer', 7000.00),
('Księgowy', 4500.00),
('Programista', 6000.00),
('Administrator', 5500.00);

-- Tabela premia
INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES
('Świąteczna', 500.00),
('Uznaniowa', 1000.00),
('Brak', 0.00),
('Rocznicowa', 800.00),
('Za wyniki', 1500.00),
('Frekwencyjna', 300.00),
('Motywacyjna', 700.00),
('Specjalna', 2000.00),
('Okolicznościowa', 600.00),
('Za projekt', 1200.00);

-- Tabela wynagrodzenie
INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2024-11-05', 1, 1, 2, 1),
('2024-11-05', 2, 3, 1, 2),
('2024-11-05', 3, 5, 3, 3),
('2024-11-06', 4, 6, 4, 4),
('2024-11-06', 5, 7, 5, 5),
('2024-11-06', 6, 8, 6, 6),
('2024-11-07', 7, 9, 7, 7),
('2024-11-07', 8, 10, 8, 8),
('2024-11-08', 9, 1, 9, 9),
('2024-11-08', 10, 2, 10, 10);

