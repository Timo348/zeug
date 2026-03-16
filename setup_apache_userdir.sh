#!/bin/bash
# ==============================================
# Skript: setup_apache_userdir.sh
# Zweck: Installiert Apache2, aktiviert UserDir und legt Benutzer mit public_html an
# Hinweiß: Nur für Testzwecke nicht inder KA verwenden!!!
# ==============================================

# Benutzername als Parameter übergeben
USER_NAME="$1"

if [ -z "$USER_NAME" ]; then
  echo "❗ Bitte Benutzername angeben!"
  echo "   Beispiel: sudo ./setup_apache_userdir.sh testuser"
  exit 1
fi

# Apache installieren
echo "📦 Apache wird installiert..."
apt update -y && apt install -y apache2 apache2-utils

# Modul UserDir aktivieren
echo "⚙️  Aktiviere UserDir-Modul..."
a2enmod userdir
systemctl restart apache2

# Benutzer anlegen (ohne Home-Verzeichnis falls nötig, hier mit)
echo "👤 Lege Benutzer '$USER_NAME' an..."
adduser --quiet "$USER_NAME"

# Verzeichnisstruktur anlegen
echo "📁 Erstelle ~/public_html für Benutzer..."
USER_DIR="/home/${USER_NAME}/public_html"
mkdir -p "$USER_DIR"
echo "<h1>Willkommen, ${USER_NAME}</h1>" > "${USER_DIR}/index.html"

# Rechte setzen
chown -R "${USER_NAME}:${USER_NAME}" "/home/${USER_NAME}"
chmod 755 "/home/${USER_NAME}"
chmod 755 "${USER_DIR}"
chmod 644 "${USER_DIR}/index.html"

# AllowOverride prüfen und sicherstellen
USERDIR_CONF="/etc/apache2/mods-enabled/userdir.conf"
if grep -q "AllowOverride None" "$USERDIR_CONF"; then
  echo "🔧 Passe AllowOverride in userdir.conf an..."
  sed -i 's/AllowOverride None/AllowOverride All/' "$USERDIR_CONF"
fi

# Apache neu starten
systemctl restart apache2
echo "✅ Apache + UserDir für ${USER_NAME} eingerichtet."
echo "🌐 Test: http://localhost/~${USER_NAME}"
