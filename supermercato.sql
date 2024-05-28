-- MySQL dump 10.13  Distrib 8.3.0, for macos14.2 (arm64)
--
-- Host: 127.0.0.1    Database: Supermercato
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `carrello`
--

DROP TABLE IF EXISTS `carrello`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrello` (
  `id_c` int NOT NULL AUTO_INCREMENT,
  `prezzo_tot` float DEFAULT NULL,
  `username` varchar(33) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_c`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrello`
--

/*!40000 ALTER TABLE `carrello` DISABLE KEYS */;
INSERT INTO `carrello` VALUES (1,106.98,'cbc');
/*!40000 ALTER TABLE `carrello` ENABLE KEYS */;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `id_i` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `num_corsia` int DEFAULT NULL,
  `desc_prod` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `immagine_scaffale` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `immagine` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `prezzo` float DEFAULT NULL,
  PRIMARY KEY (`id_i`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (30,'acqua',NULL,NULL,'','static/media/acqua.jpeg',1),(31,'basilico',NULL,NULL,'','static/media/basilico.jpeg',3),(32,'farfalle',NULL,NULL,'','static/media/farfalle.jpeg',5),(33,'farina',NULL,NULL,'','static/media/farina.jpeg',2),(34,'penne',NULL,NULL,'','static/media/penne.jpeg',4),(35,'pesto',NULL,NULL,'','static/media/pesto.jpeg\r\n',3),(36,'pringles',NULL,NULL,'','static/media/pringles.jpeg',2.5),(37,'shampoo',NULL,NULL,'','static/media/shampoo.jpeg',2.3),(38,'spaghetti',NULL,NULL,'','static/media/spaghetti.jpeg',1.99),(39,'zucchero',NULL,NULL,'','static/media/zucchero.jpeg',1.99),(40,'mele',NULL,NULL,'','static/media/mela.jpeg',4),(41,'salmone',NULL,NULL,'','static/media/salmone.jpeg',8),(42,'olio',NULL,NULL,'','static/media/olio.jpg',12),(43,'dentifricio',NULL,NULL,'','static/media/dentifricio.png',2),(44,'detersivo omino bianco per lavatrice',NULL,NULL,'','static/media/detersivotrice.jpg',4),(45,'detersivo finish per lavastoviglie',NULL,NULL,'','static/media/detersivoviglie.jpg',3.99),(46,'birra moretti',NULL,NULL,'','static/media/birra.jpg',2.99),(47,'vino',NULL,NULL,'','static/media/vino.jpeg',5.99),(48,'vodka',NULL,NULL,'','static/media/vodka.jpeg',10.99),(49,'fazzoletti jempo',NULL,NULL,'','static/media/fazzoletti.jpeg',2.5),(50,'lattina di coca cola',NULL,NULL,'','static/media/lattina.jpg',1.59),(51,'parmigiano reggiano',NULL,NULL,'','static/media/parmigiano.jpg',7.49),(52,'pannolini',NULL,NULL,'','static/media/pannolini.jpeg',3);
/*!40000 ALTER TABLE `item` ENABLE KEYS */;

--
-- Table structure for table `riga`
--

DROP TABLE IF EXISTS `riga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `riga` (
  `id_r` int NOT NULL AUTO_INCREMENT,
  `cod_c` int DEFAULT NULL,
  `cod_i` int DEFAULT NULL,
  `quantita` int DEFAULT NULL,
  PRIMARY KEY (`id_r`),
  KEY `cod_c` (`cod_c`),
  KEY `cod_i` (`cod_i`),
  CONSTRAINT `riga_ibfk_1` FOREIGN KEY (`cod_c`) REFERENCES `carrello` (`id_c`),
  CONSTRAINT `riga_ibfk_2` FOREIGN KEY (`cod_i`) REFERENCES `item` (`id_i`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `riga`
--

/*!40000 ALTER TABLE `riga` DISABLE KEYS */;
INSERT INTO `riga` VALUES (1,1,31,8),(2,1,32,10),(3,1,30,2),(4,1,34,3),(5,1,33,4),(6,1,35,1),(7,1,39,1),(8,1,38,1),(9,1,44,1);
/*!40000 ALTER TABLE `riga` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_insert_riga` AFTER INSERT ON `riga` FOR EACH ROW BEGIN
    UPDATE carrello c
    JOIN (
        SELECT r.cod_c, SUM(i.prezzo * r.quantita) AS totale
        FROM riga r
        JOIN item i ON r.cod_i = i.id_i
        WHERE r.cod_c = NEW.cod_c
        GROUP BY r.cod_c
    ) t ON c.id_c = t.cod_c
    SET c.prezzo_tot = t.totale;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_update_riga` AFTER UPDATE ON `riga` FOR EACH ROW BEGIN
    UPDATE carrello c
    JOIN (
        SELECT r.cod_c, SUM(i.prezzo * r.quantita) AS totale
        FROM riga r
        JOIN item i ON r.cod_i = i.id_i
        WHERE r.cod_c = NEW.cod_c
        GROUP BY r.cod_c
    ) t ON c.id_c = t.cod_c
    SET c.prezzo_tot = t.totale;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `after_delete_riga` AFTER DELETE ON `riga` FOR EACH ROW BEGIN
    UPDATE carrello c
    JOIN (
        SELECT r.cod_c, SUM(i.prezzo * r.quantita) AS totale
        FROM riga r
        JOIN item i ON r.cod_i = i.id_i
        WHERE r.cod_c = OLD.cod_c
        GROUP BY r.cod_c
    ) t ON c.id_c = t.cod_c
    SET c.prezzo_tot = t.totale;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'Supermercato'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-28 10:23:12
