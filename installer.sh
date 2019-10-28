sudo apt install apache2 mysql php php-mysql php-mbstring composer
sudo mkdir /var/www/keys
sudo chmod 777 /var/www/keys
sudo -u www-data openssl genrsa -out /var/www/keys/adminPrivate.key 4096
sudo -u www-data openssl genrsa -out /var/www/keys/userPrivate.key 4096
sudo -u www-data openssl rsa -in /var/www/keys/adminPrivate.key -outform PEM -pubout -out adminPublic.key
sudo -u www-data openssl rsa -in /var/www/keys/userPrivate.key -outform PEM -pubout -out userPublic.key
sudo a2enmod rewrite
sudo patch /etc/apache2.conf ./apache2.conf.patch
#DO_PATCH

echo admin1/admin1pass
echo admin2/admin2pass
echo user1/user1pass
echo user2/user2pass
