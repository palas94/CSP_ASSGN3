<?php
    
    session_start() ;
    
    $dbuser="root";
    $dbname="experiment";
    $dbpass="";
    $dbserver="localhost";
    
    $con = mysql_connect($dbserver,$dbuser,$dbpass);
    if (!$con){ die('Could not connect: ' . mysql_error()); }
    mysql_select_db($dbname, $con);
    
    $sql_query = "SELECT * FROM locationlist" ;
    $sql_query2 = "SELECT * FROM bigedgelog" ;
    
    $result = mysql_query($sql_query) or trigger_error(mysql_error().$sql_query);
    $result2 = mysql_query($sql_query2) or trigger_error(mysql_error().$sql_query);
    
    echo " {\"nodes\":[ ";
    
    
    while($row = mysql_fetch_array($result)){
        echo "{\"name\":\""  .  $row['location'] . "\" , \"group\": \"1\"  }, ";
    }    
    
    echo " ] , \"links\": [ ";
    
    while($row = mysql_fetch_array($result2)){
        $h1 =   intval($row['fedge'] ) ;
        $h1 -= 1 ;
        $h2 =   intval($row['tedge'] ) ;
        $h2 -= 1 ;
        echo "{\"source\":"  .  $h1 . " ,  \"target\":"  .  $h2 . " , \"value\":"  .  $row['count'] . "}, ";
        
    }
    
    
    
    echo "]}" ;
    
    ?>