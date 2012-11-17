-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 05, 2012 at 04:02 PM
-- Server version: 5.1.44
-- PHP Version: 5.3.1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `experiment`
--

-- --------------------------------------------------------

--
-- Table structure for table `Data`
--

DROP TABLE `Data` ;
DROP TABLE `pertopiccommunicationbuffer` ;
DROP TABLE `activitytimelinebuffer` ;
DROP TABLE `motionhelp` ;
DROP TABLE `motionbuffer` ;
ALTER TABLE motion DROP INDEX uniq;


/*Drop*/
CREATE TABLE IF NOT EXISTS `Data` (
  `timestamp` varchar(255) NOT NULL,
  `edges` varchar(255) NOT NULL,
  `topic` varchar(255) NOT NULL,
  PRIMARY KEY (`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

load data local infile 'C:/Users/ABHI/Desktop/server/log-comm.01.csv' replace into table Data fields terminated by ',' lines terminated by '\r\n' ;

/*Drop*/
CREATE TABLE IF NOT EXISTS `activitytimelinebuffer` (
  `dateb` varchar(255) NOT NULL PRIMARY KEY,
  `topicb` int(11) 
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `activitytimeline` (
  `date` varchar(255) NOT NULL PRIMARY KEY,
  `topic` int(11),
   `increment` int(11)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

Insert into `activitytimelinebuffer`
Select Concat ( SUBSTRING(timestamp,49,4) , "," , CASE SUBSTRING(timestamp,29,3) WHEN 'Oct' THEN 10 WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12 WHEN 'Jan' THEN 1 WHEN 'Feb' THEN 2 WHEN 'Mar' THEN 3 WHEN 'Apr' THEN 4 WHEN 'May' THEN 5 WHEN 'Jun' THEN 6 WHEN 'Jul' THEN 7 WHEN 'Aug' THEN 8 WHEN 'Sep' THEN 9  END , ',' , SUBSTRING(timestamp,33,2) ) as date , count(topic) from Data group by date;

Insert into `activitytimeline` ( `date` ,`topic`)
Select dateb , topicb from activitytimelinebuffer 
ON DUPLICATE KEY UPDATE
topic = activitytimelinebuffer.topicb + activitytimeline.increment ;
 
UPDATE `activitytimeline` SET increment = topic;

/*Drop*/
CREATE TABLE IF NOT EXISTS `pertopiccommunicationbuffer` (
  `topicb` varchar(255) NOT NULL PRIMARY KEY,
  `activityb` int(11) 
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

Insert into `pertopiccommunicationbuffer`
Select topic , count(edges) from Data group by topic;

CREATE TABLE IF NOT EXISTS `pertopiccommunication` (
  `topic` varchar(255) NOT NULL PRIMARY KEY,
  `activity` int(11),
   `increment` int(11)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

Insert into `pertopiccommunication` (topic, activity)
Select topicb , activityb from pertopiccommunicationbuffer 
ON DUPLICATE KEY UPDATE
activity = pertopiccommunicationbuffer.activityb + pertopiccommunication.increment ;
 
UPDATE `pertopiccommunication` SET increment = activity ;




/*Drop*/
CREATE TABLE IF NOT EXISTS `motionhelp` (
  `topic` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

Insert into `motionhelp`
Select topic , Concat ( SUBSTRING(timestamp,49,4) , "," , CASE SUBSTRING(timestamp,29,3) WHEN 'Oct' THEN 10 WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12 WHEN 'Jan' THEN 1 WHEN 'Feb' THEN 2 WHEN 'Mar' THEN 3 WHEN 'Apr' THEN 4 WHEN 'May' THEN 5 WHEN 'Jun' THEN 6 WHEN 'Jul' THEN 7 WHEN 'Aug' THEN 8 WHEN 'Sep' THEN 9  END , ',' , SUBSTRING(timestamp,33,2) ) as date from Data order by topic ;

/*Drop*/
CREATE TABLE IF NOT EXISTS `motionbuffer` (
  `topicb` varchar(255) NOT NULL,
  `dateb` varchar(255) NOT NULL,
  `countb` int(11)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


Insert into `motionbuffer`
SELECT topic, `date` , count(topic) FROM motionhelp group by topic, `date` ;

CREATE TABLE IF NOT EXISTS `motion` (
  `topic` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `count` int(11),
  `increment` int(11)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX uniq ON motion (`topic`, `date`);

Insert into `motion` (topic,`date`,count)
Select `topicb` , `dateb`, `countb` from `motionbuffer`
ON DUPLICATE KEY UPDATE
count = motionbuffer.countb + motion.increment ;

UPDATE `motion` SET increment = count ;
;