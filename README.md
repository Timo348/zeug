# Spickzettel: Apache .htaccess, Nmap, Wireshark

## 1. Apache + .htaccess Passwortschutz

### 1.1 Apache installieren und Userdir aktivieren

```bash
sudo apt-get update
sudo apt-get install apache2

sudo a2enmod userdir
sudo systemctl restart apache2

sudo chmod +x /home/test
1.2 User „test“ und Testseite
bash
sudo adduser test
su - test

mkdir -p ~/public_html
echo "Hallo, das ist geschützt" > ~/public_html/index.html
Aufruf im Browser:
http://SERVER-IP/~test/

1.3 .htaccess in public_html
bash
cd ~/public_html
nano .htaccess
Inhalt:

text
AuthType Basic
AuthName "Passwortgeschuetzter Bereich"
AuthUserFile /home/test/public_html/.htpasswd
require valid-user
1.4 .htpasswd anlegen
bash
cd ~/public_html

# nur beim ersten Mal -c verwenden
htpasswd -c /home/test/public_html/.htpasswd test
# Passwort eingeben

# weiterer User ohne -c
# htpasswd /home/test/public_html/.htpasswd user2
1.5 Typische Fehler
Falscher Pfad in AuthUserFile

.htaccess im falschen Verzeichnis

chmod +x /home/test vergessen

Apache nach Änderungen nicht neu geladen (systemctl restart apache2)

2. Nmap – minimaler Portscan
2.1 Installation
bash
sudo apt-get install nmap
2.2 Wichtige einfache Befehle
Standard‑Scan (Top‑Ports):

bash
nmap 192.168.0.10
Ports 1–200 scannen:

bash
nmap -p 1-200 192.168.0.10
Mit Service‑Erkennung:

bash
nmap -sV -p 1-200 192.168.0.10
2.3 Wichtige Portzustände
open – Port offen, Dienst antwortet

closed – Port erreichbar, aber kein Dienst

filtered – Filter/Firewall, keine klare Antwort

3. Wireshark – Basics
3.1 Capture starten
Wireshark öffnen

Interface wählen (z. B. eth0 oder wlan0)

Capture starten (blauer Button)

3.2 Anzeige‑Filter (Display Filter)
Oben in der Filterzeile:

text
tcp              # alle TCP-Pakete
http             # nur HTTP
ip.addr == 192.168.0.10
tcp.port == 80
Wirken nur auf die Anzeige, nicht auf den Mitschnitt.

3.3 Capture‑Filter (vor Start)
Im Interface‑Fenster im Feld „Capture Filter“:

text
tcp port 80
host 192.168.0.10
tcp port 80 and host 192.168.0.10
Reduziert, was überhaupt aufgezeichnet wird.

3.4 HTTP Basic Auth sichtbar machen (Bezug zu .htaccess)
Ablauf:

Wireshark Capture auf Server oder Client starten

Im Browser http://SERVER-IP/~test/ aufrufen

Login mit User test durchführen

In Wireshark Display Filter http setzen

HTTP‑Request auswählen und im Header nach Authorization: Basic ... suchen

Merksatz: Basic Auth sendet Benutzername/Passwort nur Base64‑kodiert, also praktisch im Klartext → mit Wireshark problemlos lesbar.

4. Kurz‑Merker für die Klausur
.htaccess liegt im zu schützenden Verzeichnis

AuthUserFile zeigt auf die .htpasswd mit User/Passwort

htpasswd -c nur zum Erstanlegen der Datei

Nmap: nmap -p 1-200 ZIELIP für einfachen Portscan

Wireshark: Display Filter = Anzeige, Capture Filter = Aufzeichnung

Basic Auth über HTTP ist unsicher, weil es im Klartext mitgeschnitten werden kann
