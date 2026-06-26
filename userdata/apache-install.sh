#!/bin/bash
sudo apt update && sudo apt upgrade -y 
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo touch /var/www/html/index.html
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo echo "<h1><center>This apache created using the terraform</center></h1>" > /var/www/html/index.html