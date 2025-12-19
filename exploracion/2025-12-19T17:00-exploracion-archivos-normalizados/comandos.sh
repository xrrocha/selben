#!/usr/bin/env bash
# Comandos de exploración: Análisis de archivos normalizados
# Fecha: 2025-12-19
# Contexto: Examinamos results/escuelas_pae.tsv y results/tabla_sinec.tsv
#           para descubrir patrones que extiendan la teoría.

set -euo pipefail
cd "$(dirname "$0")/../.."

# =============================================================================
# 1. Conteo básico de registros
# =============================================================================

wc -l results/escuelas_pae.tsv results/tabla_sinec.tsv
# Resultado:
#    15754 results/escuelas_pae.tsv
#    16384 results/tabla_sinec.tsv

# =============================================================================
# 2. Patrón "# NÚMERO" (convención de Guayaquil)
# =============================================================================

# Contar escuelas con sufijo # NÚMERO
echo "=== Escuelas con sufijo # NÚMERO ==="
grep -E '# [0-9]+' results/tabla_sinec.tsv | wc -l   # 2288
grep -E '# [0-9]+' results/escuelas_pae.tsv | wc -l  # 1541

# Distribución por provincia (primeros 2 dígitos de ubicacion)
echo "=== Distribución por provincia (SINEC) ==="
grep -E '# [0-9]+' results/tabla_sinec.tsv | cut -f2 | cut -c1-2 | sort | uniq -c | sort -rn
# 2231 09  <- 97.5% en Guayas!
#   14 08
#   13 12
#   ...

echo "=== Distribución por provincia (PAE) ==="
grep -E '# [0-9]+' results/escuelas_pae.tsv | cut -f2 | cut -c1-2 | sort | uniq -c | sort -rn

# =============================================================================
# 3. Entradas "SIN NOMBRE"
# =============================================================================

echo "=== Conteo SIN NOMBRE ==="
grep -i 'SIN NOMBRE' results/escuelas_pae.tsv | wc -l   # 827
grep -i 'SIN NOMBRE' results/tabla_sinec.tsv | wc -l    # 313

# Patrones de SIN NOMBRE con localidad
grep -E 'SIN NOMBRE.*-' results/escuelas_pae.tsv | head -10

# =============================================================================
# 4. Artefactos de codificación
# =============================================================================

echo "=== Artefactos de codificación (¥ por Ñ) ==="
grep '¥' results/escuelas_pae.tsv | head -20
grep '¥' results/tabla_sinec.tsv | wc -l  # 0 - solo PAE tiene este problema

# Verificar Ñ correcta en SINEC
grep -E 'Ñ|ñ' results/tabla_sinec.tsv | head -5

# =============================================================================
# 5. Marcador (INDIGENA)
# =============================================================================

echo "=== Escuelas marcadas INDIGENA ==="
grep -i 'INDIGENA' results/tabla_sinec.tsv | wc -l  # 434
grep -i 'INDIGENA' results/escuelas_pae.tsv | wc -l # 329

# Ejemplos
grep -E '\(INDIGENA\)' results/tabla_sinec.tsv | head -10

# =============================================================================
# 6. Solapamiento de códigos entre PAE y SINEC
# =============================================================================

echo "=== Solapamiento de códigos ==="
comm -12 \
  <(cut -f4 results/escuelas_pae.tsv | tail -n+2 | sort) \
  <(cut -f4 results/tabla_sinec.tsv | tail -n+2 | sort) \
  | wc -l
# Resultado: 10602 códigos compartidos

# =============================================================================
# 7. Análisis de discrepancias (Python)
# =============================================================================

python3 << 'PYTHON'
import csv

# Cargar ambos archivos
pae = {}
with open('results/escuelas_pae.tsv') as f:
    for row in csv.DictReader(f, delimiter='\t'):
        pae[row['codigo_escuela']] = (row['ubicacion'], row['nombre_normalizado'])

sinec = {}
with open('results/tabla_sinec.tsv') as f:
    for row in csv.DictReader(f, delimiter='\t'):
        sinec[row['codigo_escuela']] = (row['ubicacion'], row['nombre_normalizado'])

# Calcular solapamiento
overlap = set(pae.keys()) & set(sinec.keys())
pae_only = set(pae.keys()) - set(sinec.keys())
sinec_only = set(sinec.keys()) - set(pae.keys())

print(f"PAE solamente: {len(pae_only)}")           # 5151
print(f"SINEC solamente: {len(sinec_only)}")       # 5781
print(f"Solapamiento: {len(overlap)}")             # 10602
print(f"Unión (cota superior): {len(pae.keys() | sinec.keys())}")  # 21534

# Contar discrepancias entre códigos compartidos
name_mismatches = sum(1 for c in overlap if pae[c][1] != sinec[c][1])
loc_mismatches = sum(1 for c in overlap if pae[c][0] != sinec[c][0])

print(f"\nDiscrepancias de nombre: {name_mismatches}/{len(overlap)}")  # 785
print(f"Discrepancias de ubicación: {loc_mismatches}/{len(overlap)}")  # 465

# Mostrar ejemplos de discrepancias de nombre
print("\n=== Ejemplos de discrepancias de nombre ===")
count = 0
for code in sorted(overlap):
    p_loc, p_name = pae[code]
    s_loc, s_name = sinec[code]
    if p_name != s_name:
        print(f'{code}: PAE="{p_name}" vs SINEC="{s_name}"')
        count += 1
        if count >= 10:
            break
PYTHON

# =============================================================================
# 8. Distribución por provincia (cobertura)
# =============================================================================

echo "=== Distribución por provincia (PAE) ==="
awk -F'\t' 'NR>1 {print $2}' results/escuelas_pae.tsv | cut -c1-2 | sort | uniq -c | sort -rn

echo "=== Distribución por provincia (SINEC) ==="
awk -F'\t' 'NR>1 {print $2}' results/tabla_sinec.tsv | cut -c1-2 | sort | uniq -c | sort -rn

# Provincias en PAE pero no en SINEC
echo "=== Provincias solo en PAE ==="
comm -23 \
  <(awk -F'\t' 'NR>1 {print $2}' results/escuelas_pae.tsv | cut -c1-2 | sort -u) \
  <(awk -F'\t' 'NR>1 {print $2}' results/tabla_sinec.tsv | cut -c1-2 | sort -u)
# Resultado: 15, 20, 23
