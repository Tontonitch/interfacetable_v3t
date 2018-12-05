<html>
<head>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<script>
    $(document).ready(function(){
        $("#nodeselect").submit();
    });
</script>
</head>
<body>
<form id="nodeselect" action=>
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

function nodename( $filename ) {
    $filename = filename( $filename );
    //$filename = preg_replace("/(Q..)/", pack("H2",substr("$1",1,3)), $filename);
    //temporary basic decoding
    $filename = preg_replace("/(Q2D)/", "-", $filename);
    $filename = preg_replace("/(Q2E)/", ".", $filename);
    $filename = preg_replace("/(Q5F)/", "_", $filename);
    $filename = preg_replace("/(Q51)/", "Q", $filename);
    $filename = preg_replace("/(Q20)/", " ", $filename); 
    if (($res = strrpos($filename, '-Interface')) !== FALSE) {
        return substr($filename, 0, $res);
    } else {
        return $filename;
    }
}

$dirname = './';
$dir = opendir($dirname);
$array_files = array();
while($file = readdir($dir)) {
    if($file != '.' && $file != 'index.php' && $file != '.index.php.swp' && $file != '..' && !is_dir($dirname.$file)) {
        #echo '<option value='.$file.'>'.nodename($file).'</option>';
        $array_files[$file] = nodename($file);
    }
}
if (!empty($array_files)) {
    asort($array_files);
}
foreach ($array_files as $key => $val) {
    echo '<option value='.$key.'>'.$val.'</option>';
}

closedir($dir);
?>

</select>
<input type="submit" value="go" name="go">
</form><br>

<?php
if (isset($_GET['nodename']) and !empty($_GET['nodename'])) {
    $nodename=$_GET['nodename'];
    include("$nodename");
}
?>
</body>
</html>
