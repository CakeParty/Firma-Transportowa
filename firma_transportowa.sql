-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 12 Lis 2020, 17:20
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
-- Struktura tabeli dla tabeli `dystans_sklep`
--

CREATE TABLE `dystans_sklep` (
  `id_dystans` int(11) NOT NULL,
  `dystans_sklep` int(11) NOT NULL,
  `id_sklepu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `hurtownie`
--

CREATE TABLE `hurtownie` (
  `id_hurtowni` int(11) NOT NULL,
  `zamówienia` int(11) NOT NULL,
  `dystans_baza` int(11) NOT NULL,
  `dystans_sklep` int(11) NOT NULL,
  `nazwa` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kierowcy`
--

CREATE TABLE `kierowcy` (
  `id_kierowcy` int(11) NOT NULL,
  `staż` int(11) NOT NULL,
  `aktualny_pojazd` int(11) NOT NULL,
  `imie` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL,
  `nazwisko` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL,
  `marża` float NOT NULL,
  `dostępny` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pojazdy`
--

CREATE TABLE `pojazdy` (
  `id_pojazdu` int(11) NOT NULL,
  `rodzaj` varchar(15) COLLATE utf8mb4_polish_ci NOT NULL,
  `towar` int(11) NOT NULL,
  `model` varchar(50) COLLATE utf8mb4_polish_ci NOT NULL,
  `załadunek` int(11) NOT NULL,
  `dostępny` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pojazdy_kierowcy`
--

CREATE TABLE `pojazdy_kierowcy` (
  `id_pojazdu` int(11) NOT NULL,
  `id_kierowcy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `sklepy`
--

CREATE TABLE `sklepy` (
  `id_sklepu` int(11) NOT NULL,
  `nazwa` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `towar`
--

CREATE TABLE `towar` (
  `id_towaru` int(11) NOT NULL,
  `typ` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL,
  `ilość` int(11) NOT NULL,
  `nazwa` varchar(30) COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zamówienia`
--

CREATE TABLE `zamówienia` (
  `id_zamówienia` int(11) NOT NULL,
  `towar` int(11) NOT NULL,
  `miejsce_docelowe` int(11) NOT NULL,
  `zysk` decimal(11,0) NOT NULL,
  `id_hurtowni` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `dystans_sklep`
--
ALTER TABLE `dystans_sklep`
  ADD PRIMARY KEY (`id_dystans`),
  ADD KEY `id_hurtowni` (`id_sklepu`);

--
-- Indeksy dla tabeli `hurtownie`
--
ALTER TABLE `hurtownie`
  ADD PRIMARY KEY (`id_hurtowni`),
  ADD KEY `zamówienia` (`zamówienia`),
  ADD KEY `dystans_sklep` (`dystans_sklep`);

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
  ADD PRIMARY KEY (`id_pojazdu`),
  ADD KEY `towar` (`towar`);

--
-- Indeksy dla tabeli `pojazdy_kierowcy`
--
ALTER TABLE `pojazdy_kierowcy`
  ADD KEY `id_kierowcy` (`id_kierowcy`),
  ADD KEY `id_pojazdu` (`id_pojazdu`,`id_kierowcy`) USING BTREE;

--
-- Indeksy dla tabeli `sklepy`
--
ALTER TABLE `sklepy`
  ADD PRIMARY KEY (`id_sklepu`);

--
-- Indeksy dla tabeli `towar`
--
ALTER TABLE `towar`
  ADD PRIMARY KEY (`id_towaru`);

--
-- Indeksy dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  ADD PRIMARY KEY (`id_zamówienia`),
  ADD KEY `id_hurtowni` (`id_hurtowni`),
  ADD KEY `towar` (`towar`),
  ADD KEY `miejsce_docelowe` (`miejsce_docelowe`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `dystans_sklep`
--
ALTER TABLE `dystans_sklep`
  MODIFY `id_dystans` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `hurtownie`
--
ALTER TABLE `hurtownie`
  MODIFY `id_hurtowni` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `kierowcy`
--
ALTER TABLE `kierowcy`
  MODIFY `id_kierowcy` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `pojazdy`
--
ALTER TABLE `pojazdy`
  MODIFY `id_pojazdu` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `sklepy`
--
ALTER TABLE `sklepy`
  MODIFY `id_sklepu` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `towar`
--
ALTER TABLE `towar`
  MODIFY `id_towaru` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  MODIFY `id_zamówienia` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `dystans_sklep`
--
ALTER TABLE `dystans_sklep`
  ADD CONSTRAINT `dystans_sklep_ibfk_1` FOREIGN KEY (`id_sklepu`) REFERENCES `sklepy` (`id_sklepu`);

--
-- Ograniczenia dla tabeli `hurtownie`
--
ALTER TABLE `hurtownie`
  ADD CONSTRAINT `hurtownie_ibfk_1` FOREIGN KEY (`zamówienia`) REFERENCES `zamówienia` (`id_zamówienia`),
  ADD CONSTRAINT `hurtownie_ibfk_2` FOREIGN KEY (`dystans_sklep`) REFERENCES `dystans_sklep` (`id_dystans`);

--
-- Ograniczenia dla tabeli `pojazdy`
--
ALTER TABLE `pojazdy`
  ADD CONSTRAINT `pojazdy_ibfk_1` FOREIGN KEY (`towar`) REFERENCES `towar` (`id_towaru`);

--
-- Ograniczenia dla tabeli `pojazdy_kierowcy`
--
ALTER TABLE `pojazdy_kierowcy`
  ADD CONSTRAINT `pojazdy_kierowcy_ibfk_1` FOREIGN KEY (`id_kierowcy`) REFERENCES `kierowcy` (`id_kierowcy`),
  ADD CONSTRAINT `pojazdy_kierowcy_ibfk_2` FOREIGN KEY (`id_pojazdu`) REFERENCES `pojazdy` (`id_pojazdu`);

--
-- Ograniczenia dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  ADD CONSTRAINT `zamówienia_ibfk_1` FOREIGN KEY (`towar`) REFERENCES `towar` (`id_towaru`),
  ADD CONSTRAINT `zamówienia_ibfk_2` FOREIGN KEY (`miejsce_docelowe`) REFERENCES `sklepy` (`id_sklepu`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
