# Arbeit Debian Webserver

## Apache Installieren
```
apt update
apt upgrade
apt install apache2
```
## Userdir aktivieren
```
sudo a2enmod userdir
sudo systemctl restart apache2
```
## Benutzer Konfigurieren
```
adduser username
mkdir /home/username/public_html

chown -R username:username /home/test/public_html
chmod 755 /home/username
chmod 755 /home/username/public_html

nano home/username/public_html/index.html
chmod 644 home/username/public_html/index.html
```
## htaccess
```
sudo nano /etc/apache2/mods-enabled/userdir.conf
```
Suche diesen Block:
```
<Directory /home/*/public_html>

Er sollte ungefähr so aussehen:

<Directory /home/*/public_html>
    AllowOverride All
    Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
    Require all granted
</Directory>
```
Wichtig ist AllowOverride All
