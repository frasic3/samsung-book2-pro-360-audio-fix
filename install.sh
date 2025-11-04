nano install.sh
```    Copia e incolla il seguente codice al suo interno:
```bash
#!/bin/bash

# Controlla se lo script è eseguito come root
if [ "$EUID" -ne 0 ]; then
  echo "Per favore, esegui come root o con sudo."
  exit 1
fi

echo ">>> Avvio della correzione audio per Samsung Galaxy Book2 Pro 360..."

# Percorsi dei file
SCRIPT_NAME="realtek-alc298-amp-init.sh"
SERVICE_NAME="samsung-audio-fix.service"
SCRIPT_DEST_DIR="/usr/local/sbin"
SERVICE_DEST_DIR="/etc/systemd/system"

# Passo 1: Copia lo script di inizializzazione
echo ">>> Copia dello script di inizializzazione in $SCRIPT_DEST_DIR..."
cp "$SCRIPT_NAME" "$SCRIPT_DEST_DIR/"
chmod +x "$SCRIPT_DEST_DIR/$SCRIPT_NAME"

# Passo 2: Crea il file del servizio systemd
echo ">>> Creazione del servizio systemd..."
cat > "$SERVICE_DEST_DIR/$SERVICE_NAME" << EOL
[Unit]
Description=Samsung Speaker Amp Initialization Fix (950QED)
After=suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_DEST_DIR/$SCRIPT_NAME

[Install]
WantedBy=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
EOL

# Passo 3: Ricarica e attiva il servizio
echo ">>> Attivazione del servizio systemd..."
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"

echo ""
echo ">>> Correzione applicata con successo!"
echo ">>> Riavvia il computer per rendere effettive le modifiche."

exit 0
