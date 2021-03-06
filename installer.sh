set -euxo pipefail

#install dependencies
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y apache2 mysql-server php php-mysql php-mbstring composer make g++ nodejs zip

#enable apache2 rewritemod
sudo a2enmod rewrite
#path apache2.conf to enable htacess
sudo patch /etc/apache2/apache2.conf ./apache2.conf.patch
#delete index.html that ships with apache (it comes with root priveleges so needs to be deleted rather than overwritten later)
sudo rm /var/www/html/index.html

#install ADC API to local folder and install dependencies
git clone https://github.com/AutomaticDoorControl/AutoDoorCtrlWebAPIPHP.git
cd AutoDoorCtrlWebAPIPHP/api
composer install
cd ../..

#install ADC Web to local folder and install dependencies
git clone https://github.com/AutomaticDoorControl/AutoDoorCtrlWeb.git
cd AutoDoorCtrlWeb
npm i

#replace https://rpiadc.com with local ip
sed -i "s/https:\/\/rpiadc.com/http:\/\/$(ip addr | grep -oP "(\d{1,3}\.){3}\d{1,3}" | grep -vP "255$|127\.0\.0\.1" | tail -n1)/" ./src/app/globals.ts

#install angular/cli globally
sudo npm install -g @angular/cli

#build ADC Web
ng build --prod

#copy ADC Web to /var/www/html as www-data
sudo -u www-data cp dist/*/* /var/www/html
cd ..

#copy ADC API to /var/www/html as www-data
sudo -u www-data cp AutoDoorCtrlWebAPIPHP/.htaccess /var/www/html
sudo -u www-data cp -r AutoDoorCtrlWebAPIPHP/api /var/www/html

#restart apache2
sudo service apache2 restart

#setup the SQL database
sudo mysql < ./setup.sql

#generate and add doors to database
chmod +x addDoor.sh
composer install
./addDoor.sh D1 "Door One" 42.726979 -73.677847 | sudo mysql
./addDoor.sh D2 "Door Two" 42.731463 -73.678025 | sudo mysql
