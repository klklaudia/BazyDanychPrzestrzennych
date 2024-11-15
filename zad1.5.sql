-- a) Wyświetl tylko id pracownika oraz jego nazwisko.
SELECT imie, nazwisko FROM ksiegowosc.pracownicy;

-- b) Wyświetl id pracowników, których płaca jest większa niż 1500.
SELECT p.id_pracownika 
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja ps ON w.id_pensji = ps.id_pensji
WHERE ps.kwota > 1500;

-- c) Wyświetl id pracowników nieposiadających premii, których płaca jest większa niż 2000.
SELECT p.id_pracownika
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja ps ON w.id_pensji = ps.id_pensji
JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
WHERE pr.kwota > 0
  AND ps.kwota > 2000;

-- d) Wyświetl pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’.
SELECT id_pracownika, imie, nazwisko
FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%';

-- e) Wyświetl pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’.
SELECT id_pracownika, imie, nazwisko
FROM ksiegowosc.pracownicy
WHERE nazwisko LIKE '%n%' AND imie LIKE '%a';

-- f) Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 h miesięcznie.
-- 8, bo za mało danych
SELECT imie, nazwisko, g.liczba_godzin - 8 AS nadgodziny
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.godziny g ON g.id_godziny = w.id_godziny
WHERE g.liczba_godzin > 8;

-- g) Wyświetl imię i nazwisko pracowników, których pensja zawiera się w przedziale 1500 – 3000 PLN.
SELECT imie, nazwisko, pe.kwota
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.pensja pe ON p.id_pracownika = pe.id_pensji
WHERE pe.kwota >= 1500 AND pe.kwota <= 3000;

-- h) Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.
SELECT imie, nazwisko, pe.kwota
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.godziny g ON g.id_godziny = w.id_godziny
JOIN ksiegowosc.premia pe ON pe.id_premii = w.id_premii
WHERE g.liczba_godzin > 8 and pe.kwota < 0;

-- i) Uszereguj pracowników według pensji.
SELECT p.imie, p.nazwisko, ps.kwota AS pensja
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja ps ON w.id_pensji = ps.id_pensji
ORDER BY ps.kwota DESC;

-- j) Uszereguj pracowników według pensji i premii malejąco.
SELECT p.imie, p.nazwisko, ps.kwota AS pensja, pr.kwota AS premia
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja ps ON w.id_pensji = ps.id_pensji
LEFT JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
ORDER BY ps.kwota DESC, pr.kwota DESC;

-- k) Zlicz i pogrupuj pracowników według pola ‘stanowisko’.
SELECT ps.stanowisko, COUNT(p.id_pracownika) AS liczba_pracownikow
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja ps ON w.id_pensji = ps.id_pensji
GROUP BY ps.stanowisko;
-- l) Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘kierownik’ (jeżeli takiego nie masz, to przyjmij dowolne inne).
SELECT 
    AVG(ps.kwota) AS srednia_placa,
    MIN(ps.kwota) AS minimalna_placa,
    MAX(ps.kwota) AS maksymalna_placa
FROM ksiegowosc.pensja ps
WHERE ps.stanowisko = 'Kierownik';

-- m) Policz sumę wszystkich wynagrodzeń.
SELECT SUM(COALESCE(pr.kwota, 0) + pe.kwota) AS suma_wszystkich
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
LEFT JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji;

-- f) Policz sumę wynagrodzeń w ramach danego stanowiska.
SELECT ps.stanowisko, 
       SUM(COALESCE(pr.kwota, 0) + ps.kwota) AS suma_wynagrodzenia
FROM ksiegowosc.pensja ps
JOIN ksiegowosc.wynagrodzenie w ON ps.id_pensji = w.id_pensji
LEFT JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
GROUP BY ps.stanowisko;

-- g) Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska.
SELECT ps.stanowisko, 
       COUNT(pr.id_premii) AS liczba_premii
FROM ksiegowosc.pensja ps
JOIN ksiegowosc.wynagrodzenie w ON ps.id_pensji = w.id_pensji
LEFT JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
WHERE pr.kwota > 0
GROUP BY ps.stanowisko;

-- h) Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł.
DELETE FROM ksiegowosc.pracownicy
WHERE id_pracownika IN (
    SELECT p.id_pracownika
    FROM ksiegowosc.pracownicy p
    JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
    JOIN ksiegowosc.pensja ps ON w.id_pensji = ps.id_pensji
    WHERE ps.kwota < 1200
);