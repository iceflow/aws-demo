<?php
  $url = "http://169.254.169.254/latest/meta-data/instance-id";
  $instance_id = file_get_contents($url);

  print_r(date('Y/m/d H:i:s'));

  echo "<br/><br/>Instance ID: <b>" .$instance_id ."</b><br/>";
  $url = "http://169.254.169.254/latest/meta-data/placement/availability-zone";
  $zone = file_get_contents($url);
  echo "Zone: <b>" .$zone ."</b><br/>";


  $iipp = $_SERVER["REMOTE_ADDR"];
  echo "Client IP:".$iipp."<br/>";

  echo "<br/><b> Request HTTP header list </b><br/>";

  $headers = apache_request_headers();

  foreach ($headers as $header => $value) {
    echo "$header: $value <br />\n";
  }

  //phpinfo();
?>
