#!/usr/bin/env bash
# sync_corpus.sh
#
# Copies the latest MedEase-Utils corpus into the App backend and re-indexes.
#
# Usage (from MedEase-Meta root):
#   ./sync_corpus.sh
#
# What it does:
#   1. Copies MedEase-Utils/scraping/output/emory_das_data_latest.json
#      → MedEase-App/backend/src/rag/corpus/
#   2. Runs the ChromaDB indexer inside the backend conda env
#
# Prerequisites:
#   - conda env "medease-backend" exists with chromadb + openai installed
#   - OPENAI_API_KEY (or equivalent) present in MedEase-App/backend/.env

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_ROOT/MedEase-Utils/scraping/output/emory_das_data_latest.json"
DEST_DIR="$REPO_ROOT/MedEase-App/backend/src/rag/corpus"
BACKEND_DIR="$REPO_ROOT/MedEase-App/backend"

# ── 1. Validate source ─────────────────────────────────────────────────────
if [[ ! -f "$SRC" ]]; then
  echo "ERROR: corpus not found at $SRC"
  echo "Run the MedEase-Utils scraper first."
  exit 1
fi

# ── 2. Copy ────────────────────────────────────────────────────────────────
echo "Copying corpus..."
cp "$SRC" "$DEST_DIR/emory_das_data_latest.json"
echo "  → $DEST_DIR/emory_das_data_latest.json"

# ── 3. Re-index ────────────────────────────────────────────────────────────
echo "Re-indexing ChromaDB..."
cd "$BACKEND_DIR"

if conda run -n medease-backend python -m src.rag.indexer; then
  echo "Done. RAG index is up to date."
else
  echo ""
  echo "Indexer failed. If the conda env is unavailable, run manually:"
  echo "  cd $BACKEND_DIR"
  echo "  conda activate medease-backend"
  echo "  python -m src.rag.indexer"
  exit 1
fi
