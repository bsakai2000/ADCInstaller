set -exo pipefail

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install apache2 mysql-server mysql php php-mysql php-mbstring composer make g++ nodejs
sudo mkdir /var/www/keys
sudo chmod 777 /var/www/keys
sudo -u www-data openssl genrsa -out /var/www/keys/adminPrivate.key 4096
sudo -u www-data openssl genrsa -out /var/www/keys/userPrivate.key 4096
sudo -u www-data openssl rsa -in /var/www/keys/adminPrivate.key -outform PEM -pubout -out adminPublic.key
sudo -u www-data openssl rsa -in /var/www/keys/userPrivate.key -outform PEM -pubout -out userPublic.key
sudo a2enmod rewrite
sudo patch /etc/apache2.conf ./apache2.conf.patch
git clone https://github.com/AutomaticDoorControl/AutoDoorCtrlWeb.git
cd AutoDoorCtrlWeb
npm i
cd ..
git clone https://github.com/AutomaticDoorControl/AutoDoorCtrlWebAPIPHP.git
cd AutoDoorCtrlWebAPIPHP
cd AutoDoorCtrlWebAPI/api
composer install
cd ../..
sudo npm install -g @angular/cli
cd AutoDoorCtrlWeb
ng build
cp dist/*/* /var/www/html
cd ..
cp AutoDoorCtrlWebAPIPHP/.htaccess /var/www/html
cp -r AutoDoorCtrlWebAPIPHP/api /var/www/html
sudo mysql < ./setup.mysql

echo admin1/admin1pass
echo admin2/admin2pass
echo user1/user1pass
echo user2/user2pass
