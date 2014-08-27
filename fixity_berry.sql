-- FIXITYBERRY.SQL
--
-- Table structure for table `dirs`
--

DROP TABLE IF EXISTS `dirs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dirs` (
  `dir` varchar(1025) CHARACTER SET utf8 NOT NULL,
  `file_cnt` int(11) NOT NULL DEFAULT '0',
  `dir_cnt` int(11) NOT NULL DEFAULT '0',
  `last_session_id` varchar(50) NOT NULL,
  KEY `last_session_id` (`last_session_id`),
  KEY `dir` (`dir`(333))
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;




--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `files` (
  `filename` varchar(1025) CHARACTER SET utf8 NOT NULL,
  `hash` varchar(50) NOT NULL,
  `date_last_checked` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `firstadded_datetime` datetime NOT NULL,
  `last_session_id` varchar(50) NOT NULL,
  KEY `filename` (`filename`(333)),
  KEY `hash` (`hash`),
  KEY `last_session_id` (`last_session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

