-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 23, 2024 alle 23:20
-- Versione del server: 10.4.32-MariaDB
-- Versione PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `supermercato`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `carrello`
--

CREATE TABLE `carrello` (
  `id_c` int(11) NOT NULL,
  `prezzo_tot` float DEFAULT NULL,
  `username` varchar(33) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `carrello`
--

INSERT INTO `carrello` (`id_c`, `prezzo_tot`, `username`) VALUES
(1, 42.98, 'cbc');

-- --------------------------------------------------------

--
-- Struttura della tabella `item`
--

CREATE TABLE `item` (
  `id_i` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `num_corsia` int(11) DEFAULT NULL,
  `desc_prod` varchar(500) DEFAULT NULL,
  `immagine_scaffale` varchar(255) NOT NULL,
  `immagine` varchar(50) DEFAULT NULL,
  `prezzo` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `item`
--

INSERT INTO `item` (`id_i`, `nome`, `num_corsia`, `desc_prod`, `immagine_scaffale`, `immagine`, `prezzo`) VALUES
(30, 'acqua', NULL, NULL, '', 'static/media/acqua.jpeg', 1),
(31, 'basilico', NULL, NULL, '', 'static/media/basilico.jpeg', 3),
(32, 'farfalle', NULL, NULL, '', 'static/media/farfalle.jpeg', 5),
(33, 'farina', NULL, NULL, '', 'static/media/farina.jpeg', 2),
(34, 'penne', NULL, NULL, '', 'static/media/penne.jpeg', 4),
(35, 'pesto', NULL, NULL, '', 'static/media/pesto.jpeg\r\n', 3),
(36, 'pringles', NULL, NULL, '', 'static/media/pringles.jpeg', 2.5),
(37, 'shampoo', NULL, NULL, '', 'static/media/shampoo.jpeg', 2.3),
(38, 'spaghetti', NULL, NULL, '', 'static/media/spaghetti.jpeg', 1.99),
(39, 'zucchero', NULL, NULL, '', 'static/media/zucchero.jpeg', 1.99),
(40, 'mele', NULL, NULL, '', 'static/media/mela.jpeg', 4),
(41, 'salmone', NULL, NULL, '', 'static/media/salmone.jpeg', 8),
(42, 'olio', NULL, NULL, '', 'static/media/olio.jpg', 12),
(43, 'dentifricio', NULL, NULL, '', 'static/media/dentifricio.png', 2),
(44, 'detersivo omino bianco per lavatrice', NULL, NULL, '', 'static/media/detersivotrice.jpg', 4),
(45, 'detersivo finish per lavastoviglie', NULL, NULL, '', 'static/media/detersivoviglie.jpg', 3.99),
(46, 'birra moretti', NULL, NULL, '', 'static/media/birra.jpg', 2.99),
(47, 'vino', NULL, NULL, '', 'static/media/vino.jpeg', 5.99),
(48, 'vodka', NULL, NULL, '', 'static/media/vodka.jpeg', 10.99),
(49, 'fazzoletti jempo', NULL, NULL, '', 'static/media/fazzoletti.jpeg', 2.5),
(50, 'lattina di coca cola', NULL, NULL, '', 'static/media/lattina.jpg', 1.59),
(51, 'parmigiano reggiano', NULL, NULL, '', 'static/media/parmigiano.jpg', 7.49),
(52, 'pannolini', NULL, NULL, '', 'static/media/pannolini.jpeg', 3);

-- --------------------------------------------------------

--
-- Struttura della tabella `riga`
--

CREATE TABLE `riga` (
  `id_r` int(11) NOT NULL,
  `cod_c` int(11) DEFAULT NULL,
  `cod_i` int(11) DEFAULT NULL,
  `quantita` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `riga`
--

INSERT INTO `riga` (`id_r`, `cod_c`, `cod_i`, `quantita`) VALUES
(1, 1, 31, 3),
(2, 1, 32, 3),
(3, 1, 30, 2),
(4, 1, 34, 2),
(5, 1, 33, 1),
(6, 1, 35, 1),
(7, 1, 39, 1),
(8, 1, 38, 1);

--
-- Trigger `riga`
--
DELIMITER $$
CREATE TRIGGER `after_delete_riga` AFTER DELETE ON `riga` FOR EACH ROW BEGIN
    UPDATE carrello c
    JOIN (
        SELECT r.cod_c, SUM(i.prezzo * r.quantita) AS totale
        FROM riga r
        JOIN item i ON r.cod_i = i.id_i
        WHERE r.cod_c = OLD.cod_c
        GROUP BY r.cod_c
    ) t ON c.id_c = t.cod_c
    SET c.prezzo_tot = t.totale;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_riga` AFTER INSERT ON `riga` FOR EACH ROW BEGIN
    UPDATE carrello c
    JOIN (
        SELECT r.cod_c, SUM(i.prezzo * r.quantita) AS totale
        FROM riga r
        JOIN item i ON r.cod_i = i.id_i
        WHERE r.cod_c = NEW.cod_c
        GROUP BY r.cod_c
    ) t ON c.id_c = t.cod_c
    SET c.prezzo_tot = t.totale;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_riga` AFTER UPDATE ON `riga` FOR EACH ROW BEGIN
    UPDATE carrello c
    JOIN (
        SELECT r.cod_c, SUM(i.prezzo * r.quantita) AS totale
        FROM riga r
        JOIN item i ON r.cod_i = i.id_i
        WHERE r.cod_c = NEW.cod_c
        GROUP BY r.cod_c
    ) t ON c.id_c = t.cod_c
    SET c.prezzo_tot = t.totale;
END
$$
DELIMITER ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `carrello`
--
ALTER TABLE `carrello`
  ADD PRIMARY KEY (`id_c`);

--
-- Indici per le tabelle `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id_i`);

--
-- Indici per le tabelle `riga`
--
ALTER TABLE `riga`
  ADD PRIMARY KEY (`id_r`),
  ADD KEY `cod_c` (`cod_c`),
  ADD KEY `cod_i` (`cod_i`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `carrello`
--
ALTER TABLE `carrello`
  MODIFY `id_c` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `item`
--
ALTER TABLE `item`
  MODIFY `id_i` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT per la tabella `riga`
--
ALTER TABLE `riga`
  MODIFY `id_r` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `riga`
--
ALTER TABLE `riga`
  ADD CONSTRAINT `riga_ibfk_1` FOREIGN KEY (`cod_c`) REFERENCES `carrello` (`id_c`),
  ADD CONSTRAINT `riga_ibfk_2` FOREIGN KEY (`cod_i`) REFERENCES `item` (`id_i`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
