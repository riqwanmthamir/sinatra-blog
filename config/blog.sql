-- MySQL dump 10.13  Distrib 5.6.20, for osx10.8 (x86_64)
--
-- Host: localhost    Database: blog
-- ------------------------------------------------------
-- Server version	5.6.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (9,'Forget VP of Devil’s Advocacy. Where’s your BS Filter?','There are a million reasons why a piece of innovation fails. In some cases, it’s great technology that just didn’t get the marketing gas it needed to make it mainstream. And sometimes, the product is just way ahead of its times. But most often, innovations fail because they just plain suck.','riqwan','2014-08-07 17:07:23'),(10,'Announcing Flow Maps: Using germ.io for Life, the Universe and Everything','Our purpose at germ.io is simple: to help you get your ideas to execution. But sometimes when you’re in the thick of things, it’s easy to lose perspective. It’s called “getting lost in your thoughts”, and the only way you can get  home is if you took few a  steps back and looked at the big picture.','riqwan','2014-08-07 17:07:42'),(11,'Building your Product in Public: Omega Halftime Review','Exactly 93 days ago, we decided to go with a product launch cycle that would make the hardest LEAN methodology veterans go queasy in their stomach. No MVP, no private betas. Instead, we decided to launch germ.io as we built it, and we’ve been calling this our Omega launch.','vikram','2014-08-07 17:08:16'),(12,'How Important is the Idea?','Every project goes through an “ideation” phase where you nail the “what’s” and “how’s”, and an execution phase where you actually get stuff done. Ideas are cheap, fleeting things; by itself a business idea is worth less than a half-eaten sandwich. At least you can eat the sandwich.','vikram','2014-08-07 17:08:33'),(13,'How we’re using germ.io to germ germ.io','We launched the heart and soul of germ.io Omega earlier this week: Flows. I’ve personally been excited about this part from even before we launched, so over the past few days I’ve gone a bit crazy. A flow is a lot like a project you want to work on. ','gautham','2014-08-07 17:09:27'),(29,'Where The Flow is an Omega?','You’ve heard of beta releases. You’ve probably even heard of alpha releases. So where does an Omega release come from? Long story short, we’re still building germ.io, but we didn’t want to keep your ideas waiting that long.','kanna','2014-08-14 13:36:18'),(30,'What germ.io is Not (and a bit of what it is)','Sometimes it’s just as critical to explain what a product is not, as it is to explain what it does. So when we are busy building a solution to help you Get Things Done, and talk to','kanna','2014-08-14 13:39:35'),(31,'Getting from Ideas to Execution','Our vision for what we’re trying to do at germ.io is actually pretty simple: build a product that’ll help you get your genius thoughts from being just “a good idea” into something solid – something you actually do.','kanna','2014-08-14 13:40:17'),(33,'test post','test post','gautham_email_again','2014-08-14 13:48:42');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'riqwan','riqwan@germ.io','$2a$10$mMKMCJJwL5vqRKJ.mPvqMO','$2a$10$mMKMCJJwL5vqRKJ.mPvqMOYpd61z8X51oNxOSnXGhYKkrpWj2ASxy',1,NULL),(2,'vikram','sidegeeks@gmail.com','$2a$10$CsX2YziWFh0IeZJUTPWHQe','$2a$10$CsX2YziWFh0IeZJUTPWHQeoLHV/svWPTwfIjTWq.1JFtSMHVVf2Rm',1,NULL),(3,'gautham','bigpistas@gmail.com','$2a$10$s0E3d0NQfKW0CFFdP9qmnu','$2a$10$s0E3d0NQfKW0CFFdP9qmnuKxKvG4M2TIlXZBk.NR6rdtQqcL7f3N2',1,NULL),(48,'kanna','riqwan@germ.io','$2a$10$9bDVef69hVEyA26zHzbroO','$2a$10$9bDVef69hVEyA26zHzbroOBaByS7c8igTpqqfWF8/cPJZMqccJxOO',1,'2qQkS2USDdgwPmI0AMT-7g'),(49,NULL,NULL,'$2a$10$G6db6LjiOt5yN/owHFTwhu','$2a$10$G6db6LjiOt5yN/owHFTwhuEwLmCmqijwBe/.23FWamvlQTnk5RyCS',0,'M3RQ3uCHN9gGsrSPtKTPSA'),(50,'gautham123','gautham@germ.io','$2a$10$wY3zUO6p2bgEmCTF3cTb3O','$2a$10$wY3zUO6p2bgEmCTF3cTb3O535ZecM71ByJMhagrI6eDDTSjBzSq2u',0,'SNl1zx1VYqVTHhM3XhpVTw'),(51,'gautham_email_test','riqwan@germ.io','$2a$10$4ChHY6D5F3iL61.2qY8cVO','$2a$10$4ChHY6D5F3iL61.2qY8cVOrXelsRpd18RVMuPIerl951KCehZgQRG',1,'f74xslhmwXVXJ1iU6InFag'),(52,'gautham_email_again','riqwan@germ.io','$2a$10$g.A9NHChGXzLDssHTbNj3e','$2a$10$g.A9NHChGXzLDssHTbNj3enk7.AqG1GMoHrpYhLS9G3qM7w8fX06.',1,'JsypEU6jWcIqhSFYEL3AWw'),(54,'kant','rmthamir@outlook.com','$2a$10$AufV9pvH2Y4uHCrSzzkv.e','$2a$10$AufV9pvH2Y4uHCrSzzkv.e5D3lJ/YNwBREOEDA8fDI.LoCDNIVNIm',0,'nN6rDrSeVpGTRNE6xDTlQg'),(55,'kannat','riqwan@germ.io','$2a$10$lgkTvmZHm62SvqC6ExY7UO','$2a$10$lgkTvmZHm62SvqC6ExY7UOY7abbdIyyHb6RQFhil/jkSe7E5wO7Zq',0,'qmI6B2UPLyAZ9GxcuK17IA');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-08-16 13:24:16
