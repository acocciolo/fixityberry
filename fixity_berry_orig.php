<?php
// fixity_berry.php
// Checks the fixity of USB mounted drives.  Designed to work on Raspberry Pi.
// Requires that USBMount be installed with some tweaks.


mysql_select_db("fixity_berry");

function dir_in_db($dir, &$file_cnt = NULL, &$dir_cnt = NULL)
{
	global $session_id;
	
	$dir = str_replace ("'", "\'", $dir); 
	
	$result = mysql_query ("SELECT file_cnt, dir_cnt FROM dirs WHERE dir = '$dir'");
    if (mysql_num_rows($result) == 0)
    	return false;
    $file_cnt = mysql_result($result, 0, 0);
    $dir_cnt = mysql_result($result, 0, 1);
    
    mysql_query("UPDATE dirs SET last_session_id = '$session_id' WHERE dir = '$dir'");
    if (mysql_affected_rows() != 1)
    	return false;
    
    
    return true;
}

function add_dir_to_db($dir, $file_cnt, $dir_cnt)
{
	global $session_id;
	
	$dir = str_replace ("'", "\'", $dir); 
	
	mysql_query("INSERT INTO dirs (dir,file_cnt,dir_cnt,last_session_id) VALUES ('$dir',$file_cnt,$dir_cnt,'$session_id')");
    if (mysql_affected_rows() == 1)
    	return true;
    return false;
}

function file_in_db($fname)
{
	global $session_id;
	
	$fname = str_replace ("'", "\'", $fname); 
	
	$result = mysql_query ("SELECT hash FROM files WHERE filename = '$fname'");
    if (mysql_num_rows($result) == 0)
    	return false;
    $hash = mysql_result($result, 0, 0);
    	
    	
    mysql_query("UPDATE files SET last_session_id = '$session_id' WHERE filename = '$fname'");
    
    if (mysql_affected_rows() != 1)
    	return false;
     
    return $hash;
    
}

function hashMatch($hash_db, $file)
{
	global $errors_found;
	global $message;
	
	$hash  = md5_file ($file ) ;
	
    if ($hash === $hash_db)
    	return true;
    	
    if (!$hash)
    {
    	$errors_found = true;
    	$message .= "Unable to create hash for file: $file\n";
    }	
    
    return false;
}

function add_file_to_db ($fname)
{
	global $session_id;
	global $errors_found;
	global $message;
	
	$hash  = md5_file ($fname ) ;
	
	$fname = str_replace ("'", "\'", $fname); 
	
	if (!$hash)
	{
		$errors_found = true;
		$message .= "Unable to create file fixity for file; not added to database: $fname\n";
	}
	else
	{
		mysql_query("INSERT INTO files (filename,hash,firstadded_datetime,last_session_id) VALUES ('$fname','$hash', '" . date('Y-m-d H:i:s') . "','$session_id')");
    	if (mysql_affected_rows() >= 1)
    		return $hash;
    	else
    		die ("Unable to add $fname to database");		
	}

    return false;
}



function fixityCheck($path)
{
	global $file_cnt_check;
	global $file_cnt_add;
	global $dir_cnt;
	global $message;
	global $errors_found;
	global $first_time_run ;
	
	$local_file_cnt_check = 0;
	$local_dir_cnt = 0;
	$local_file_cnt_add = 0;
	
	# ignore . files that are hidden
	$scan = preg_grep('/^([^.])/', scandir($path));
	
    foreach($scan as $file)
    {
    	$fullname = $path . "/" . $file;
        if (!is_dir($fullname))
        {
        	$hash = file_in_db ($fullname);
            
            if (!$hash)
            {
            	$hash = add_file_to_db($fullname);
        
            	$local_file_cnt_add++;
                if ($hash && !$first_time_run)
           			$message .= "WARNING - File added for checking: $fullname\n";
            }
            else
            {
            	if (!hashMatch ($hash, $fullname))
            	{
                	$message .= "WARNING - Checksum does not match for file: $fullname\n";
					$errors_found = true;                	
                }
				$local_file_cnt_check++;    
            }
            
           // for performance checking only
           // echo $hash . "\n";
           
           
        }
        else if (!($file == "." || $file == ".."))
        {
        	fixityCheck ($fullname);
            $local_dir_cnt++;
        }
    }
    if (!dir_in_db($path, $db_file_cnt, $db_dir_cnt))
    {
    	if (!add_dir_to_db ($path, $local_file_cnt_check+$local_file_cnt_add, $local_dir_cnt))
        	die ("Unable to add dir to database.");
    }
    else
    {
    	if (($local_file_cnt_check+$local_file_cnt_add) != $db_file_cnt)
    	{
        	$message .= "WARNING - database indicates that number of files in this directory has changed; updating database: $path\n";
        	$errors_found = true;
        	
        	$new_cnt = $local_file_cnt_check+$local_file_cnt_add;
        	
        	mysql_query ("UPDATE dirs SET file_cnt = $new_cnt WHERE dir = '$path'");
        }
        if ($local_dir_cnt != $db_dir_cnt)
        {
        	$message .= "WARNING - database indicates that number of directories in this directory has changed; updating database: $path\n";
    		$errors_found = true;
    		
    		mysql_query("UPDATE dirs SET dir_cnt = $local_dir_cnt WHERE dir = '$path'");
    	}
    }
    
    $file_cnt_check += $local_file_cnt_check;
    $file_cnt_add += $local_file_cnt_add;
    $dir_cnt += $local_dir_cnt;
    
    return true;
}

function first_time_run()
{
	$result = mysql_query ("SELECT filename from files LIMIT 1");
	if (mysql_num_rows($result) == 0)
		return true;
	return false;
}

function checkRemovals()
{
	global $errors_found;
	global $session_id;
	global $message;
	$local_error = false;
	
	
	$result = mysql_query("SELECT filename FROM files WHERE last_session_id <> '$session_id'");
	$n = mysql_num_rows($result);
	
	for ($i=0; $i < $n; $i++)
	{
		$local_error  = true;
		$fname =  mysql_result($result, $i, 0);
		$message .= "WARNING - file in database but not found on drive: $fname\n";
	}
	
	$result = mysql_query("SELECT dir FROM dirs WHERE last_session_id <> '$session_id'");
	$n = mysql_num_rows($result);
	
	for ($i=0; $i < $n; $i++)
	{
		$local_error = true;
		$dir =  mysql_result($result, $i, 0);
		$message .= "WARNING - directory in database but not found on drive: $dir\n";
	}
	
	if ($local_error)
		$errors_found = true;
		
	return $local_error;
}

// setup default variables;
$session_id = uniqid();
$startDir = "/var/run/usbmount";
$file_cnt_check = 0;
$file_cnt_add = 0;
$dir_cnt = 0;
$errors_found = false;
$message = "";

// check if first time run
$first_time_run = first_time_run();

// check all muounted dirves, except hidden
$scan = preg_grep('/^([^.])/', scandir($startDir));
foreach($scan as $file)
{
	if (!($file == "." || $file == ".."))
	{
		$fullname = $startDir . "/" . $file;
   		if (is_dir($fullname))
    		fixityCheck($fullname);
    }
}

// check that nothing in the database can't be found anymore
if (!$first_time_run)
	checkRemovals();

// prepare report
$subject = "Fixity Berry Check on " . date('Y-m-d H:i:s');
$message_start = $subject . "\n\n";

if ($first_time_run)
	$message_start .= 
	"This is your first time running Fixity Berry, so the files found on USB drives are 
being added to the database, and will be checked next time you run Fixity Berry.\n\n";

$message_start .= "Total Files Added for Checking: $file_cnt_add
Total Existing Files Checked for Fixity: $file_cnt_check
Total Directories Monitored: $dir_cnt\n";

if ($errors_found)
{
	$message_start .= 
	"WARNING - Fixity errors were found, file counts are not consistent with what was in 
the database, or there was a problem determining fixity.  Please look at 
the output below for more information.\n";
	$subject = "*WARNINGS FOUND* " . $subject;
}


if ($file_cnt_add > 0 && !$first_time_run)
{
	
	$message_start .= 
	"WARNING - Note that new files have appeared since the last time Fixity Berry was 
run (e.g., new drives, new files on existing drives, etc.).  If this is not 
something that you expected, then something malicious could be going on (e.g., 
files being added to a drive without your knowledge).  Please look at the output 
below for the files that were added.\n"; 
	if (!$errors_found)
		$subject = "*WARNINGS FOUND* " . $subject;
}

if ($message == "")
	$message = "No warnings to report- all looks good.";

$message = $message_start . "\n\nDetails Worth Mentioning:\n" . $message;

mail($email_report_to, $subject, $message, "From: fixityberry@gmail.com");

echo $message;

mysql_close();

shell_exec("sudo shutdown -h +2");

?>
