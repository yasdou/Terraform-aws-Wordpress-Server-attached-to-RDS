#!/bin/bash
HOMEDIR=/home/ec2-user

yum update -y

amazon-linux-extras install lamp-mariadb10.2-php7.2

echo Installing packages...
echo Please ignore messages regarding SELinux...
yum install -y \
httpd \
mariadb-server \
php \
php-gd \
php-mbstring \
php-mysqlnd \
php-xml \
php-xmlrpc \
jq

MYSQL_ROOT_PASSWORD=pass
echo $MYSQL_ROOT_PASSWORD > $HOMEDIR/MYSQL_ROOT_PASSWORD
chown ec2-user $HOMEDIR/MYSQL_ROOT_PASSWORD

echo Starting database service...
sudo systemctl start mariadb
sudo systemctl enable mariadb

echo Setting up basic database security...
mysql -u root <<DB_SEC
UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
DB_SEC

echo Configuring Apache...
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

echo Starting Apache...
sudo systemctl start httpd
sudo systemctl enable httpd

echo installing wordpress and creating mysqluser
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz -C /home/ec2-user
sudo systemctl start mariadb
cd ..

sudo cp /home/ec2-user/wordpress/wp-config-sample.php /home/ec2-user/wordpress/wp-config.php
sudo sed -i "s/database_name_here/WPDatabase/" /home/ec2-user/wordpress/wp-config.php
sudo sed -i "s/username_here/root/" /home/ec2-user/wordpress/wp-config.php
sudo sed -i "s/password_here/12345678/" /home/ec2-user/wordpress/wp-config.php
sudo sed -i "s/localhost/${rdsendpoint}/" /home/ec2-user/wordpress/wp-config.php

sudo cp -r /home/ec2-user/wordpress/* /var/www/html/
sudo systemctl restart httpd