-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 21 Lis 2020, 08:57
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
(12, '41-200', 'Kościelna 58', 'Sosnowiec');

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

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `hurtownie`
--

CREATE TABLE `hurtownie` (
  `id_hurtowni` int(11) NOT NULL,
  `zamówienia` int(11) DEFAULT NULL,
  `adres` int(11) NOT NULL,
  `nazwa` varchar(60) COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `hurtownie`
--

INSERT INTO `hurtownie` (`id_hurtowni`, `zamówienia`, `adres`, `nazwa`) VALUES
(1, 1, 1, 'Hurtownia elektryczna Elmix'),
(2, NULL, 4, 'PEX-POOL'),
(3, 2, 9, 'Hurtownia Fryzjerska i Kosmetyczna ALEX'),
(4, NULL, 5, 'INS-EL Hurtownia Elektryczna'),
(5, NULL, 12, 'Eltech');

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
(3, 542, 1, 'Robert', 'Nowacki', 20, 1),
(4, 313, 2, 'MIchał ', 'Florkiewicz', 14, 1),
(5, 1092, NULL, 'Andrzej', 'Nizioł', 32, 0),
(6, 783, 3, 'Bogusław', 'Palimąka', 19, 1),
(7, 703, 4, 'Tomasz', 'Klimczak', 22, 0),
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
(4, 'Tir', 'DAF XF105', 15000, 1),
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
(9, 'Anatolia Doner Kebab', 10);

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
(6, 'stały', 600, 'żel do włosów', 800);

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
(2, 5);

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
(2, 1, '500', 1);

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
  ADD PRIMARY KEY (`id_hurtowni`),
  ADD KEY `zamówienia` (`zamówienia`);

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
  MODIFY `id_adresu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT dla tabeli `historia_zamowien`
--
ALTER TABLE `historia_zamowien`
  MODIFY `id_spedytor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `hurtownie`
--
ALTER TABLE `hurtownie`
  MODIFY `id_hurtowni` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  MODIFY `id_sklepu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT dla tabeli `towary`
--
ALTER TABLE `towary`
  MODIFY `id_towaru` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  MODIFY `id_zamówienia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  ADD CONSTRAINT `hurtownie_ibfk_1` FOREIGN KEY (`zamówienia`) REFERENCES `zamówienia` (`id_zamówienia`),
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
