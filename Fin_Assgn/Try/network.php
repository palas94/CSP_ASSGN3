<?php
    
    session_start() ;
    
    $dbuser="root";
    $dbname="assignment";
    $dbpass="";
    $dbserver="localhost";
    
    $con = mysql_connect($dbserver,$dbuser,$dbpass);
    if (!$con){ die('Could not connect: ' . mysql_error()); }
    mysql_select_db($dbname, $con);
    
    $sql_query = "SELECT id , name ,location FROM Datanode2" ;
    $sql_query2 = "SELECT * FROM Modedges" ;
    
    $result = mysql_query($sql_query) or trigger_error(mysql_error().$sql_query);
    $result2 = mysql_query($sql_query2) or trigger_error(mysql_error().$sql_query);
    
    echo " {\"nodes\":[ ";
    
    $count=0;
    
    while($row = mysql_fetch_array($result)){
        
        $refer = $row['location'] ;
        
        if ( $refer != $check) {
            $count++ ;
        }
        
        echo "{\"name\":\""  .  $row['name'] . "\" , \"group\": $count }, ";
        
        $check = $row['location'] ;
    }    
    
    echo " ] , \"links\": [ ";
    
  while($row = mysql_fetch_array($result2)){
            echo "{\"source\":"  .  $row['fromedge'] . " ,  \"target\":"  .  $row['toedge'] . "}, ";
            
        }
    
    
    
    echo "]}" ;
    
    ?>