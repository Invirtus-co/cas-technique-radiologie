#!/usr/bin/env bash
# Télécharge l'Indiana University Chest X-ray Collection (OpenI, NLM) dans ./data
# ~1,4 Go à télécharger, ~1,5 Go une fois décompressé.
set -euo pipefail
DEST="${1:-data}"
BASE="https://openi.nlm.nih.gov/imgs/collections"
mkdir -p "$DEST/png"
cd "$DEST"
echo "→ Comptes rendus (1 Mo)"
curl -fL --retry 5 -C - -o NLMCXR_reports.tgz "$BASE/NLMCXR_reports.tgz"
tar -xzf NLMCXR_reports.tgz
echo "→ Images PNG (1,4 Go, reprise automatique si interrompu)"
curl -fL --retry 5 -C - -o NLMCXR_png.tgz "$BASE/NLMCXR_png.tgz"
tar -xzf NLMCXR_png.tgz -C png
echo "✓ $(ls ecgen-radiology | wc -l | tr -d ' ') comptes rendus, $(ls png | wc -l | tr -d ' ') images dans $DEST/"
echo "  Vous pouvez supprimer les .tgz : rm $DEST/*.tgz"
