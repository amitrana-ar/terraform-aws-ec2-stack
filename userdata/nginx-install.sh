#!/bin/bash
sudo apt update && sudo apt upgrade -y 
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo touch /var/www/html/index.html
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo echo "<h1><center>This Nginx created using the terraform</center></h1>" > /var/www/html/index.html