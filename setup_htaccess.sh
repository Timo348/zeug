#!/bin/bash
# ==============================================
# Skript: setup_htaccess.sh
# Zweck: Erstellt .htaccess-Datei und Passwortschutz im UserDir
# Hinweiß: Nur für Testzwecke nicht in der KA verwenden!!!
# ==============================================

USER_NAME="$1"
LOGIN_NAME="$2"

if [ -z "$USER_NAME" ] || [ -z "$LOGIN_NAME" ]; then
  echo "❗ Nutzung: sudo ./setup_htaccess.sh <Linux_Benutzer> <Login_Name>"
  echo "   Beispiel: sudo ./setup_htaccess.sh testuser webadmin"
  exit 1
fi

USER_DIR="/home/${USER_NAME}"
HTACCESS_PATH="${USER_DIR}/public_html/.htaccess"
HTPASSWD_PATH="${USER_DIR}/.htpasswd"

# .htpasswd erstellen (überschreibt falls existiert)
echo "🔐 Erstelle Passwortdatei..."
htpasswd -c "$HTPASSWD_PATH" "$LOGIN_NAME"

# .htaccess erstellen
cat > "$HTACCESS_PATH" <<EOF
AuthType Basic
AuthName "Geschützter Bereich"
AuthUserFile ${HTPASSWD_PATH}
Require valid-user
EOF

# Berechtigungen setzen
chown "${USER_NAME}:${USER_NAME}" "$HTACCESS_PATH" "$HTPASSWD_PATH"
chmod 640 "$HTACCESS_PATH" "$HTPASSWD_PATH"

# Apache neu starten
systemctl restart apache2
echo "✅ Passwortschutz aktiviert."
echo "🌐 Test: http://localhost/~${USER_NAME}"
