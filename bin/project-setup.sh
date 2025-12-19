#!/usr/bin/env bash
# Project initialization script

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Setting up project in: $ROOT"

# Create Python venv if not exists
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    echo "Created .venv"
else
    echo ".venv already exists"
fi

# Initialize git repo if not exists
if [ ! -d ".git" ]; then
    git init
    echo "Initialized git repo"
else
    echo "Git repo already initialized"
fi

# Create .gitignore if not exists
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
    echo "Created .gitignore"
else
    echo ".gitignore already exists"
fi

echo ""
echo "Initialization complete."
echo "Activate venv with: source .venv/bin/activate"
