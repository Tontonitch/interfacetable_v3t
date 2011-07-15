<html>
<body>
<form action=>
<select name="nodename" size="1">
<option value="">-- select a node --</option>
<?php

// hide file extension
function filename( $filename ) {
    if (($res = strrpos($filename, '.')) !== FALSE) {
        return substr($filename, 0, $res);
    } else {
        return $filename;
    }
}

$dirname = './';
$dir = opendir($dirname);

while($file = readdir($dir)) {
        if($file != '.' && $file != 'index.php' && $file != '..' && !is_dir($dirname.$file))
        {
                echo '<option value='.$file.'>'.filename($file).'</option>';
        }
}

closedir($dir);
?>

</select>
<input type="submit" value="validate" name="ok">
</form><br>

<?php
if (isset($_GET['nodename']))
{
    $nodename=$_GET['nodename'];
    include("$nodename");
}
?>
</body>
</html>
