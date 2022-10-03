#!/bin/bash
yum -y update
yum -y install httpd
myip = `curl http://169.254.169.254/latest/meta-data/local-ip4`
echo "<h2>WebServer IP: $myip</h2><br> Build by Terraform using external script" >/var/www/html/index.html
sudo service httpd start
chkconfig httpd on