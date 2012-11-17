<?php
    
    session_start() ;
    
    $dbuser="root";
    $dbname="experiment";
    $dbpass="";
    $dbserver="localhost";
    
    $con = mysql_connect($dbserver,$dbuser,$dbpass);
    if (!$con){ die('Could not connect: ' . mysql_error()); }
    mysql_select_db($dbname, $con);
    
    $sql_query = "SELECT topicb, activityb from pertopiccommunicationbuffer order by activityb DESC LIMIT 20" ;
    
    
    $result = mysql_query($sql_query) or trigger_error(mysql_error().$sql_query);
    
    echo "{ \"cols\": [ {\"id\":\"\",\"label\":\"topic\",\"pattern\":\"\",\"type\":\"string\"},{\"id\":\"\",\"label\":\"activity\",\"pattern\":\"\",\"type\":\"number\"}], \"rows\": [  ";
    
    while($row = mysql_fetch_array($result)){
        echo "{\"c\":[{\"v\":\"" . $row['topicb'] . "\",\"f\":null},{\"v\":\"" . $row['activityb'] . "\",\"f\":null}]}, ";
    }    
    
    
    echo " ] }";
    ?>