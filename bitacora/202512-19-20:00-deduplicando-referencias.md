# Deduplicando Archivos de Referencia

**Marca temporal:** 2025-12-19T20:00:00

**Resumen:** Implementamos el segundo paso del _pipeline_ trazable: deduplicación. Colapsamos registros que comparten `(ubicacion, nombre_normalizado)` idénticos, preservando linaje hacia los registros fuente.

---

### Lo Que Buscamos Aprender

¿Cuántos nombres duplicados existen dentro de cada ubicación en los archivos normalizados? ¿Cómo preservamos la trazabilidad cuando múltiples registros colapsan en uno?

### Lo Que Hicimos

1. **Exploramos duplicados** — Encontramos que ambos archivos contienen registros con `(ubicacion, nombre_normalizado)` idénticos pero diferentes `codigo_escuela`.

2. **Cuantificamos el problema:**
   - PAE: 15,753 → 15,612 pares únicos (141 duplicados)
   - SINEC: 16,383 → 15,669 pares únicos (714 duplicados)

3. **Implementamos `bin/deduplicar.py`** — Script que agrupa por `(ubicacion, nombre_normalizado)`, cuenta ocurrencias, y preserva la lista de `id_seq` originales.

### Lo Que Aprendimos

- Los duplicados son reales: múltiples códigos de escuela pueden tener el mismo nombre normalizado en la misma ubicación.
- Ejemplo concreto: `ENRIQUETA CORDERO DAVILA` en ubicación `010151` aparece dos veces con diferentes códigos de escuela.
- SINEC tiene 5× más duplicados que PAE (714 vs 141)—posiblemente reflejando fusiones históricas de escuelas o registros administrativos redundantes.

### Lo Que Inventamos

**El contrato de deduplicación:**

| Campo | Descripción |
|-------|-------------|
| `id_seq` | ID secuencial nuevo (global) |
| `ubicacion` | Código de 6 dígitos (sin cambio) |
| `nombre_normalizado` | Ahora único dentro de cada ubicación |
| `conteo` | Cuántos registros originales se fusionaron |
| `ids_escuela` | Lista separada por comas de `id_seq` fuente |

El campo `ids_escuela` es crítico: preserva el linaje. Cuando un registro deduplicado se propaga al siguiente paso del _pipeline_, podemos trazar hacia atrás exactamente qué registros normalizados lo generaron.

### Próximos Pasos

Fusionar los dos archivos deduplicados en una referencia consolidada. Entonces podremos responder definitivamente: ¿cuál es el conteo verdadero de entidades?

---

### Reflexión

Segundo paso del _pipeline_ completado. El patrón se repite: agrupar, contar, preservar linaje. Cada transformación deja rastro. Los archivos `-dedup.tsv` ahora esperan en `results/`, listos para la fusión.
