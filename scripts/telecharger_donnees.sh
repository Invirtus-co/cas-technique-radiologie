#!/usr/bin/env bash
# Télécharge l'Indiana University Chest X-ray Collection (OpenI, NLM) dans ./data
# ~1,4 Go à télécharger, ~1,5 Go une fois décompressé.
# Le serveur OpenI ne permet pas de reprendre un téléchargement interrompu : en cas de coupure,
# le script recommence le fichier depuis le début (jusqu'à 5 tentatives).
set -euo pipefail
DEST="${1:-data}"
BASE="https://openi.nlm.nih.gov/imgs/collections"
mkdir -p "$DEST/png"; cd "$DEST"

telecharger() {  # $1 = fichier, $2 = taille attendue en octets
  for i in 1 2 3 4 5; do
    if [ -f "$1" ] && [ "$(wc -c < "$1" | tr -d ' ')" = "$2" ]; then return 0; fi
    rm -f "$1"; echo "  tentative $i…"
    curl -fL --progress-bar -o "$1" "$BASE/$1" || true
  done
  [ "$(wc -c < "$1" | tr -d ' ')" = "$2" ] || { echo "✗ échec du téléchargement de $1"; exit 1; }
}

echo "→ Comptes rendus (1 Mo)"; telecharger NLMCXR_reports.tgz 1112632
tar -xzf NLMCXR_reports.tgz
echo "→ Images PNG (1,4 Go)"; telecharger NLMCXR_png.tgz 1360814128
tar -xzf NLMCXR_png.tgz -C png
echo "✓ $(ls ecgen-radiology | wc -l | tr -d ' ') comptes rendus, $(ls png | wc -l | tr -d ' ') images dans $DEST/"
echo "  Vous pouvez supprimer les archives : rm $DEST/*.tgz"
