# Arbeit Debian Webserver

## Netzwerkkonfiguration
### Backup der Netzwerk interfaces
```
cp /etc/network/interfaces /etc/network/interfaces_backup
```
### interfaces auf Statische IP statt dhcp ändern
```
nano /etc/network/interfaces
```
``` interfaces
auto enp0s3
iface enp0s3 inet static
address 10.16.raumnummer.pcnummer+200/8
gateway 10.16.1.245
```
```
systemctl restart networking
```
```
nano /etc/resolv.conf
```
``` resolv.conf
nameserver 10.16.1.253
```

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
## htaccess Konfigurieren
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
Apache Neustarten (systemctl restart apache2)
### htaccess Datei erstellen
```
nano /home/test/public_html/.htaccess
```
```
AuthType Basic
AuthName "Geschützter Bereich"
AuthUserFile /home/test/.htpasswd
Require valid-user
```
### Passwortdatei erstellen
Tool installieren (falls fehlt):
```
sudo apt install apache2-utils
```
Dann Benutzer für Login anlegen:
```
sudo htpasswd -c /home/test/.htpasswd testuser
```
Passwort eingeben.
Apache Neustarten (systemctl restart apache2)
## Testen
http://localhost/~username
