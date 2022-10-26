echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get install apache2 -y
apt-get install php -y
apt-get install libapache2-mod-php7.0 -y
apt-get install ca-certificates openssl -y
apt-get install unzip -y
apt-get install git -y
git clone https://github.com/Shagdovala159/modul2source.git
unzip -o /root/modul2source/\*.zip -d /root/modul2source

cp -r /root/modul2source/strix.operation.wise/. /var/www/strix.operation.wise.d03.com

service apache2 start

cp modul1/wise.d03.com.conf /etc/apache2/sites-available/wise.d03.conf
cp -r /root/modul2source/wise/. /var/www/wise.d03.com

# config untuk eden.wise.d03
cp modul1/eden.wise.d03.com.conf /etc/apache2/sites-available/eden.wise.d03.conf
cp -r /root/modul2source/eden.wise/. /var/www/eden.wise.d03.com

# config untuk strix.operation.wise.d03
cp modul1/strix.operation.wise.d03.com-15000.conf /etc/apache2/sites-available/strix.operation.wise.d03-15000.conf
cp modul1/strix.operation.wise.d03.com-15500.conf /etc/apache2/sites-available/strix.operation.wise.d03-15500.conf
cp modul1/ports.conf /etc/apache2/ports.conf
cp modul1/.htpasswd /etc/apache2/.htpasswd

cp -r /root/modul2source/strix.operation.wise/. /var/www/strix.operation.wise.d03.com

# Turn on all sites
cd /etc/apache2/sites-available
a2ensite wise.d03
a2ensite eden.wise.d03
a2ensite strix.operation.wise.d03.com-15000
a2ensite strix.operation.wise.d03.com-15500
cd /root