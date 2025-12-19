#!/usr/bin/env bash
# Script de inicialización del proyecto

set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"

echo "Configurando proyecto en: $RAIZ"

# Crear entorno virtual Python si no existe
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    echo "Creado .venv"
else
    echo ".venv ya existe"
fi
source .venv/bin/activate

# Inicializar repositorio git si no existe
if [ ! -d ".git" ]; then
    git init
    echo "Repositorio git inicializado"
else
    echo "Repositorio git ya inicializado"
fi

# Crear .gitignore si no existe
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
.venv/
.local/
__pycache__/
*.pyc
.pytest_cache/
*.egg-info/
dist/
build/
.coverage
htmlcov/
EOF
    echo "Creado .gitignore"
else
    echo ".gitignore ya existe"
fi

echo ""
echo "Inicialización completa."
echo "Activar entorno virtual con: source .venv/bin/activate"
