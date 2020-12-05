-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 05 Gru 2020, 08:34
-- Wersja serwera: 10.4.14-MariaDB
-- Wersja PHP: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `firma transportowa`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Dostępni_kierowcy` ()  NO SQL
    COMMENT 'Procedura zwracająca listę dostępnych kierowców'
SELECT id_kierowcy, imie, nazwisko, id_pojazdu, model, załadunek 
FROM kierowcy
INNER JOIN pojazdy ON kierowcy.aktualny_pojazd = pojazdy.id_pojazdu
WHERE kierowcy.aktualny_pojazd IS NOT NULL AND kierowcy.dostępny = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Hurtownie` ()  NO SQL
    COMMENT 'Procedura wyświetlająca listę hurtowni wraz z adresami'
SELECT nazwa, kod_pocztowy, ulica, miasto
FROM hurtownie
INNER JOIN adresy ON hurtownie.adres = adresy.id_adresu$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Nowe_zamówienie` (IN `sklep_id` INT(11), IN `hurtownia` INT(11), IN `towar_1` INT(11), IN `towar_2` INT(11), IN `towar_3` INT(11), IN `towar_4` INT(11))  NO SQL
    COMMENT 'Procedura służąca do dodania nowego zamówienia'
BEGIN 
	DECLARE max INT;
    IF hurtownia!=0 THEN
    INSERT INTO zamówienia (miejsce_docelowe, zysk, id_hurtowni) VALUE (sklep_id, RAND()*(1200-200)+200, hurtownia);
    SET max = (SELECT MAX(id_zamówienia) FROM zamówienia);
        IF towar_1!=0 THEN 
            INSERT INTO towary_zamowienia (id_zamówienie_towar, id_towaru) VALUE (max, towar_1); END IF; 
        IF towar_2!=0 THEN 
            INSERT INTO towary_zamowienia (id_zamówienie_towar, id_towaru) VALUE (max, towar_2); END IF; 
        IF towar_3!=0 THEN 
            INSERT INTO towary_zamowienia (id_zamówienie_towar, id_towaru) VALUE (max, towar_3); END IF; 
        IF towar_4!=0 THEN 
            INSERT INTO towary_zamowienia (id_zamówienie_towar, id_towaru) VALUE (max, towar_4); END IF;  
	END IF;   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sklepy` ()  NO SQL
    COMMENT 'Procedura wyświetlająca listę sklepów wraz z adresami'
BEGIN 
SELECT sklepy.nazwa, kod_pocztowy, ulica, miasto
FROM sklepy
INNER JOIN adresy ON sklepy.adres = adresy.id_adresu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Stwórz_towar` (IN `ttyp` VARCHAR(30) CHARSET utf8, IN `tilość` INT(11), IN `tnazwa` VARCHAR(30) CHARSET utf8, IN `twaga` INT(11))  NO SQL
    COMMENT 'Procedura do dodania nowego towaru(paczki) do bazy'
BEGIN
	INSERT INTO towary (typ, ilość, nazwa, waga)
    VALUE (ttyp, tilość, tnazwa, twaga);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Towary_zamówienia` (IN `zamówienie` INT)  NO SQL
    COMMENT 'Procedura wyświetlająca listę towarów do podanego zamówienia'
BEGIN 
SELECT towary.id_towaru, nazwa, typ, ilość, waga
FROM towary
INNER JOIN towary_zamowienia ON towary.id_towaru = towary_zamowienia.id_towaru
WHERE id_zamówienie_towar = zamówienie;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Upływ_czasu` ()  NO SQL
    COMMENT 'Procedura do symulacji upływu 7 dni '
BEGIN
	DECLARE czas DATE;
    DECLARE i INT;
    DECLARE max INT;
    SET max = (SELECT MAX(id_spedytor) FROM historia_zamowien);
    SET czas = DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 7 DAY);
    WHILE i<=max DO
    	IF Upływ_czasu2(i)<czas THEN
        	UPDATE kierowcy SET dostępny = 1 WHERE id_kierowcy = id_kierowca(i);
    UPDATE pojazdy SET dostępny = 1 WHERE id_pojazdu = id_pojazd(i);
        END IF;
		SET i = i+1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usuń zamówienie` (IN `zamówienie` INT(11))  NO SQL
    COMMENT 'Procedura usuwająca zamówienie o podanym id'
BEGIN
	DELETE FROM towary_zamowienia WHERE id_zamówienie_towar = zamówienie;
    DELETE FROM zamówienia WHERE id_zamówienia = zamówienie;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Wykonaj_zamówienie` (IN `f_kierowca` INT(11), IN `f_zamówienie` INT(11))  MODIFIES SQL DATA
    COMMENT 'Procedura służąca do wykonania zamówienia(wysłania kierowcy)'
BEGIN
    DECLARE A_kierowca INT;
    SET A_kierowca = f_kierowca;
    IF f_kierowca < 0 THEN 
    	SET A_kierowca = F_kierowca(f_zamówienie);
    END IF;
    INSERT INTO historia_zamowien ( zamówienie, kierowca, pojazd, data_rozpoczęcia, data_zakończenia)
    VALUE ( f_zamówienie, A_kierowca, F_pojazd(A_kierowca), CURRENT_TIMESTAMP, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 3 DAY));
    UPDATE kierowcy SET dostępny = 0 WHERE id_kierowcy = A_kierowca;
    UPDATE pojazdy SET dostępny = 0 WHERE id_pojazdu = F_pojazd(A_kierowca);
END$$

--
-- Funkcje
--
CREATE DEFINER=`root`@`localhost` FUNCTION `dostępny_kierowca` (`kierowca` INT(11)) RETURNS INT(2) READS SQL DATA
    COMMENT 'Funkcja zwracająca parametr dostępny konkretnego kierowcy'
RETURN (SELECT dostępny FROM kierowcy WHERE id_kierowcy = kierowca)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `F_kierowca` (`zamówienie` INT) RETURNS INT(5) NO SQL
    COMMENT 'Funkcja do automatycznego wyszukania kierowcy do obsługi zamówie'
BEGIN 
    DECLARE max INT;
    DECLARE i INT;
    SET i = 1;
    SET max = (SELECT MAX(id_kierowcy) FROM kierowcy);
   WHILE i<=max DO
    	IF (dostępny_kierowca(i) IS NOT NULL AND F_pojazd(i) IS NOT NULL AND parse_Rodzaj_pojazd(F_pojazd(i)) = Lodówka(zamówienie) AND załadunek_pojazd(F_pojazd(i)) >= waga_zamówienie(zamówienie))
        THEN RETURN i; END IF;
    	SET i = i+1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `F_pojazd` (`kierowca` INT(11)) RETURNS INT(11) NO SQL
    COMMENT 'Funkcja zwracająca id pojazdu przypisanego do kierowcy'
RETURN (SELECT aktualny_pojazd FROM kierowcy WHERE id_kierowcy = kierowca)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `id_kierowca` (`id` INT) RETURNS INT(11) NO SQL
    COMMENT 'Funkcja zwracająca id kierowcy z realizowanego zamówienia'
RETURN (SELECT kierowca FROM historia_zamowien WHERE id_spedytor = id)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `id_pojazd` (`id` INT(11)) RETURNS INT(2) NO SQL
    COMMENT 'Funkcja zwracająca id pojazdu z realizowanego zamówienia'
RETURN (SELECT pojazd FROM historia_zamowien WHERE id_spedytor = id)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Lodówka` (`zamówienie` INT(11)) RETURNS INT(2) READS SQL DATA
    COMMENT 'Funkcja ustalająca rodzaj towarów jaki może przewieść pojazd'
BEGIN
	DECLARE boi INT;
    IF Rodzaj_towar(zamówienie) = "chłodnia" THEN
    	SET boi = 1;
    ELSE 
    	SET boi = 0;
    END IF;
    RETURN boi;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `parse_Rodzaj_pojazd` (`pojazd` INT(11)) RETURNS INT(5) READS SQL DATA
    COMMENT 'Funkcja ustalająca rodzaj towarów jaki może przewieść pojazd'
BEGIN
	DECLARE f_rodzaj INT;
    IF Rodzaj_pojazd(pojazd) = "Chłodnia" THEN
    	SET f_rodzaj = 1;
    ELSE 
    	SET f_rodzaj = 0;
    END IF;
    RETURN f_rodzaj;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Rodzaj_pojazd` (`pojazd` INT) RETURNS VARCHAR(15) CHARSET utf8 NO SQL
    COMMENT 'Funkcja zwracająca rodzaj pojazdu (Tir, Van, Chłodnia)'
RETURN (SELECT rodzaj FROM pojazdy WHERE id_pojazdu = pojazd)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Rodzaj_towar` (`zamówienie` INT(11)) RETURNS VARCHAR(15) CHARSET utf8 NO SQL
    COMMENT 'Funkcja zwracająca rodzaj towarów z konkretnego zamówienia'
RETURN (SELECT DISTINCT typ FROM `towary` INNER JOIN towary_zamowienia ON towary.id_towaru = towary_zamowienia.id_towaru WHERE id_zamówienie_towar = zamowienie)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Upływ_czasu2` (`id` INT(11)) RETURNS DATE NO SQL
    COMMENT 'Funkcja zwracająca datę zakończenia realizowanego zamówienia'
RETURN (SELECT data_zakończenia FROM historia_zamowien WHERE id_spedytor = id)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `waga_zamówienie` (`zamów` INT(11)) RETURNS INT(5) NO SQL
    COMMENT 'Funkcja zwracająca łączną wagę towarów z zamówienia'
RETURN (SELECT SUM(waga)
FROM `towary`
INNER JOIN towary_zamowienia ON towary.id_towaru = towary_zamowienia.id_towaru
WHERE id_zamówienie_towar = zamów)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `załadunek_pojazd` (`pojazd` INT) RETURNS INT(15) NO SQL
    COMMENT 'Funkcja zwracająca wartość załadunek konkretnego pojazdu'
RETURN (SELECT załadunek FROM pojazdy WHERE id_pojazdu = pojazd)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `adresy`
--

CREATE TABLE `adresy` (
  `id_adresu` int(11) NOT NULL,
  `kod_pocztowy` varchar(10) COLLATE utf8mb4_polish_ci NOT NULL,
  `ulica` varchar(60) COLLATE utf8mb4_polish_ci NOT NULL,
  `miasto` varchar(20) COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `adresy`
--

INSERT INTO `adresy` (`id_adresu`, `kod_pocztowy`, `ulica`, `miasto`) VALUES
(1, '39-220', 'Bujnowskiego 3', 'Pilzno'),
(2, '39-218', 'Straszęcin 71', 'Straszęcin'),
(3, '39-200', 'Kościuszki 28', 'Dębica'),
(4, '33-100', 'Romanowicza 39', 'Tarnów'),
(5, '36-100', 'ks. Ruczki 1a', 'Kolbuszowa'),
(6, '33-100', 'Tuchowska 25', 'Tarnów'),
(7, '00-020', 'Chmielna 36', 'Warszawa'),
(8, '61-148', 'Osiedle Piastowskie 22', 'Poznań'),
(9, '20-863', 'Górska 11', 'Lublin'),
(10, '44-103', 'Beskidzka 22', 'Gliwice'),
(11, '26-610', 'Witolda 7', 'Radom'),
(12, '41-200', 'Kościelna 58', 'Sosnowiec'),
(13, '38-068', 'Bujnowskiego 67', 'Łeba'),
(14, '38-024', 'Czarnieckiego 24', 'Morawica'),
(15, '24-391', 'Piaska 45', 'Nowa Dęba'),
(16, '11-234', 'Głowackiego', 'Mielec'),
(17, '01-319', 'Rajska 15', 'Ożarów'),
(18, '07-215', 'Targowa 34c', 'Radom');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `historia_zamowien`
--

CREATE TABLE `historia_zamowien` (
  `id_spedytor` int(11) NOT NULL,
  `zamówienie` int(11) NOT NULL,
  `kierowca` int(11) NOT NULL,
  `pojazd` int(11) NOT NULL,
  `data_rozpoczęcia` datetime NOT NULL,
  `data_zakończenia` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `historia_zamowien`
--

INSERT INTO `historia_zamowien` (`id_spedytor`, `zamówienie`, `kierowca`, `pojazd`, `data_rozpoczęcia`, `data_zakończenia`) VALUES
(3, 2, 4, 3, '2020-12-02 18:55:53', '2020-12-05 18:55:53'),
(4, 13, 6, 4, '2020-12-04 11:14:54', '2020-12-07 11:14:54');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `hurtownie`
--

CREATE TABLE `hurtownie` (
  `id_hurtowni` int(11) NOT NULL,
  `adres` int(11) NOT NULL,
  `nazwa` varchar(60) COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `hurtownie`
--

INSERT INTO `hurtownie` (`id_hurtowni`, `adres`, `nazwa`) VALUES
(1, 1, 'Hurtownia elektryczna Elmix'),
(2, 4, 'PEX-POOL'),
(3, 9, 'Hurtownia Fryzjerska i Kosmetyczna ALEX'),
(4, 5, 'INS-EL Hurtownia Elektryczna'),
(5, 12, 'Eltech'),
(6, 15, 'Hurtownia Biedronka'),
(7, 16, 'Tartak Gąsówka');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kierowcy`
--

CREATE TABLE `kierowcy` (
  `id_kierowcy` int(11) NOT NULL,
  `staż` int(11) NOT NULL,
  `aktualny_pojazd` int(11) DEFAULT NULL,
  `imie` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL,
  `nazwisko` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL,
  `marża` float NOT NULL,
  `dostępny` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `kierowcy`
--

INSERT INTO `kierowcy` (`id_kierowcy`, `staż`, `aktualny_pojazd`, `imie`, `nazwisko`, `marża`, `dostępny`) VALUES
(3, 542, 11, 'Robert', 'Nowacki', 20, 1),
(4, 313, 3, 'MIchał ', 'Florkiewicz', 14, 1),
(5, 1092, NULL, 'Andrzej', 'Nizioł', 32, 0),
(6, 783, 4, 'Bogusław', 'Palimąka', 19, 0),
(7, 703, 10, 'Tomasz', 'Klimczak', 22, 0),
(8, 245, NULL, 'Robert', 'Freder', 13, 1),
(9, 603, NULL, 'Artur', 'Wiesławczyk', 25, 1),
(10, 555, NULL, 'Lesław', 'Bierut', 23, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pojazdy`
--

CREATE TABLE `pojazdy` (
  `id_pojazdu` int(11) NOT NULL,
  `rodzaj` varchar(15) COLLATE utf8mb4_polish_ci NOT NULL,
  `model` varchar(50) COLLATE utf8mb4_polish_ci NOT NULL,
  `załadunek` int(11) NOT NULL,
  `dostępny` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `pojazdy`
--

INSERT INTO `pojazdy` (`id_pojazdu`, `rodzaj`, `model`, `załadunek`, `dostępny`) VALUES
(1, 'Tir', 'Ford F-Max', 20000, 1),
(2, 'Tir', 'Scania R450', 18000, 1),
(3, 'Van ', 'Renault Trafic', 2000, 1),
(4, 'Tir', 'DAF XF105', 15000, 0),
(5, 'Tir', 'MAN 26.310', 10000, 1),
(6, 'Tir', 'MAN 12.220 TGL', 4500, 0),
(7, 'Tir', 'MAN 26.310', 10000, 1),
(8, 'Tir', 'MAN 12.220 TGL', 4500, 1),
(9, 'Van ', 'Opel Vivaro', 1500, 1),
(10, 'Van', 'Opel Movano', 2200, 1),
(11, 'Chłodnia', 'Iveco Eurocargo 120E19', 12000, 0),
(12, 'Chłodnia', 'Mercedes Benz Actros 2542', 26000, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `sklepy`
--

CREATE TABLE `sklepy` (
  `id_sklepu` int(11) NOT NULL,
  `nazwa` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL,
  `adres` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `sklepy`
--

INSERT INTO `sklepy` (`id_sklepu`, `nazwa`, `adres`) VALUES
(1, 'Biedronka', 2),
(2, 'Media Expert', 3),
(3, 'Ardexim', 11),
(4, 'Elmer', 8),
(5, 'Salon Agata', 7),
(6, 'Empik', 6),
(9, 'Anatolia Doner Kebab', 10),
(10, 'Jubilatka', 13),
(11, 'Firma \"Nizioł\"', 14),
(12, 'Taurus', 17),
(13, 'Nihao', 18);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `towary`
--

CREATE TABLE `towary` (
  `id_towaru` int(11) NOT NULL,
  `typ` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL,
  `ilość` int(11) NOT NULL,
  `nazwa` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL,
  `waga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `towary`
--

INSERT INTO `towary` (`id_towaru`, `typ`, `ilość`, `nazwa`, `waga`) VALUES
(1, 'chłodnia', 20, 'mięso wołowe', 500),
(2, 'chłodnia', 28, 'kiełbasa swojska', 540),
(3, 'stały', 300, 'drewno', 5000),
(4, 'stały', 200, 'stalowe pręty', 3000),
(5, 'stały', 100, 'żarówki', 100),
(6, 'stały', 600, 'żel do włosów', 800),
(7, 'stały', 15, 'kamery', 100),
(8, 'chłodnia', 500, 'żel do włosów', 2000),
(9, 'stały', 472, 'baterie', 315),
(10, 'stały', 210, 'skrętka rj45 2m', 80),
(11, 'chłodnia', 25, 'pierogi ruskie', 400),
(12, 'chłodnia', 300, 'frytki karbowane', 300),
(13, 'chłodnia', 100, 'lody waniliowe', 150),
(14, 'stały', 245, 'vegeta', 30),
(15, 'stały', 40, 'farba do włosów', 28),
(16, 'stały', 30, 'nożyczki', 5),
(17, 'stały', 50, 'maszynka do golenia', 100),
(18, 'stały', 500, 'cisiowianka gazowana', 600),
(19, 'chłodnia', 800, 'masło', 1000),
(20, 'chłodnia', 368, 'monte', 55);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `towary_zamowienia`
--

CREATE TABLE `towary_zamowienia` (
  `id_zamówienie_towar` int(11) NOT NULL,
  `id_towaru` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `towary_zamowienia`
--

INSERT INTO `towary_zamowienia` (`id_zamówienie_towar`, `id_towaru`) VALUES
(1, 1),
(1, 2),
(2, 5),
(3, 4),
(13, 3),
(13, 4),
(13, 5),
(13, 6),
(14, 13),
(14, 11),
(14, 1),
(15, 5),
(15, 15),
(16, 11),
(16, 20),
(16, 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zamówienia`
--

CREATE TABLE `zamówienia` (
  `id_zamówienia` int(11) NOT NULL,
  `miejsce_docelowe` int(11) NOT NULL,
  `zysk` decimal(11,0) NOT NULL,
  `id_hurtowni` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `zamówienia`
--

INSERT INTO `zamówienia` (`id_zamówienia`, `miejsce_docelowe`, `zysk`, `id_hurtowni`) VALUES
(1, 9, '1000', 2),
(2, 1, '500', 1),
(3, 5, '766', 1),
(13, 3, '530', 3),
(14, 2, '904', 5),
(15, 1, '944', 3),
(16, 5, '1059', 6);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `adresy`
--
ALTER TABLE `adresy`
  ADD PRIMARY KEY (`id_adresu`);

--
-- Indeksy dla tabeli `historia_zamowien`
--
ALTER TABLE `historia_zamowien`
  ADD PRIMARY KEY (`id_spedytor`),
  ADD KEY `zamówienie` (`zamówienie`),
  ADD KEY `kierowca` (`kierowca`),
  ADD KEY `pojazd` (`pojazd`);

--
-- Indeksy dla tabeli `hurtownie`
--
ALTER TABLE `hurtownie`
  ADD PRIMARY KEY (`id_hurtowni`);

--
-- Indeksy dla tabeli `kierowcy`
--
ALTER TABLE `kierowcy`
  ADD PRIMARY KEY (`id_kierowcy`),
  ADD KEY `aktualny_pojazd` (`aktualny_pojazd`);

--
-- Indeksy dla tabeli `pojazdy`
--
ALTER TABLE `pojazdy`
  ADD PRIMARY KEY (`id_pojazdu`);

--
-- Indeksy dla tabeli `sklepy`
--
ALTER TABLE `sklepy`
  ADD PRIMARY KEY (`id_sklepu`),
  ADD KEY `adres` (`adres`);

--
-- Indeksy dla tabeli `towary`
--
ALTER TABLE `towary`
  ADD PRIMARY KEY (`id_towaru`);

--
-- Indeksy dla tabeli `towary_zamowienia`
--
ALTER TABLE `towary_zamowienia`
  ADD KEY `id_towaru` (`id_towaru`),
  ADD KEY `id_zamówienia` (`id_zamówienie_towar`) USING BTREE;

--
-- Indeksy dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  ADD PRIMARY KEY (`id_zamówienia`),
  ADD KEY `miejsce_docelowe` (`miejsce_docelowe`),
  ADD KEY `id_hurtowni` (`id_hurtowni`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `adresy`
--
ALTER TABLE `adresy`
  MODIFY `id_adresu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT dla tabeli `historia_zamowien`
--
ALTER TABLE `historia_zamowien`
  MODIFY `id_spedytor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `hurtownie`
--
ALTER TABLE `hurtownie`
  MODIFY `id_hurtowni` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT dla tabeli `kierowcy`
--
ALTER TABLE `kierowcy`
  MODIFY `id_kierowcy` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT dla tabeli `pojazdy`
--
ALTER TABLE `pojazdy`
  MODIFY `id_pojazdu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT dla tabeli `sklepy`
--
ALTER TABLE `sklepy`
  MODIFY `id_sklepu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT dla tabeli `towary`
--
ALTER TABLE `towary`
  MODIFY `id_towaru` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  MODIFY `id_zamówienia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `historia_zamowien`
--
ALTER TABLE `historia_zamowien`
  ADD CONSTRAINT `historia_zamowien_ibfk_1` FOREIGN KEY (`zamówienie`) REFERENCES `zamówienia` (`id_zamówienia`),
  ADD CONSTRAINT `historia_zamowien_ibfk_2` FOREIGN KEY (`kierowca`) REFERENCES `kierowcy` (`id_kierowcy`),
  ADD CONSTRAINT `historia_zamowien_ibfk_3` FOREIGN KEY (`pojazd`) REFERENCES `pojazdy` (`id_pojazdu`);

--
-- Ograniczenia dla tabeli `hurtownie`
--
ALTER TABLE `hurtownie`
  ADD CONSTRAINT `hurtownie_ibfk_2` FOREIGN KEY (`adres`) REFERENCES `adresy` (`id_adresu`);

--
-- Ograniczenia dla tabeli `kierowcy`
--
ALTER TABLE `kierowcy`
  ADD CONSTRAINT `kierowcy_ibfk_1` FOREIGN KEY (`aktualny_pojazd`) REFERENCES `pojazdy` (`id_pojazdu`);

--
-- Ograniczenia dla tabeli `sklepy`
--
ALTER TABLE `sklepy`
  ADD CONSTRAINT `sklepy_ibfk_1` FOREIGN KEY (`adres`) REFERENCES `adresy` (`id_adresu`);

--
-- Ograniczenia dla tabeli `towary_zamowienia`
--
ALTER TABLE `towary_zamowienia`
  ADD CONSTRAINT `towary_zamowienia_ibfk_1` FOREIGN KEY (`id_towaru`) REFERENCES `towary` (`id_towaru`),
  ADD CONSTRAINT `towary_zamowienia_ibfk_2` FOREIGN KEY (`id_zamówienie_towar`) REFERENCES `zamówienia` (`id_zamówienia`);

--
-- Ograniczenia dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  ADD CONSTRAINT `zamówienia_ibfk_2` FOREIGN KEY (`miejsce_docelowe`) REFERENCES `sklepy` (`id_sklepu`),
  ADD CONSTRAINT `zamówienia_ibfk_3` FOREIGN KEY (`id_hurtowni`) REFERENCES `hurtownie` (`id_hurtowni`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
