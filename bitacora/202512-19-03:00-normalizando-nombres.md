# Normalizando Nombres Oficiales de Escuelas

**Marca temporal:** 2025-12-19T03:00:00

**Resumen:** Implementamos el primer paso concreto de nuestro _pipeline_ trazable: normalizar los dos registros oficiales de escuelas (PAE y SINEC) en un formato consistente con IDs secuenciales, códigos de ubicación estandarizados y nombres con espacios en blanco normalizados—todo mientras mantenemos la procedencia hacia los códigos originales de escuela.

---

### Lo Que Buscamos Aprender

Cómo transformar nuestros dos conjuntos de datos de referencia en una estructura uniforme adecuada para deduplicación y fusión posteriores, sin perder la capacidad de trazar cada registro hasta su fuente.

### Lo Que Hicimos

1. **Examinamos estructuras de entrada** — PAE tiene `cod_parr` como ubicación de 6 dígitos precompuesta; SINEC tiene enteros separados `PROV`/`CAN`/`PARR` que requieren concatenación con relleno de ceros.

2. **Diseñamos esquema de salida** — Cuatro columnas: `id_seq` (ID secuencial), `ubicacion` (PPCCRR de 6 dígitos), `nombre_normalizado` (nombre con espacios colapsados), `codigo_escuela` (código original para trazabilidad).

3. **Implementamos `src/normalize_official_names.py`** — Un procesador de flujo que lee y escribe registro por registro, evitando acumulación en memoria. Normalización de espacios mediante recorte → división en `\s+` → reunión.

4. **Generamos archivos normalizados** — `results/escuelas_pae.tsv` (15,753 registros) y `results/tabla_sinec.tsv` (16,383 registros).

### Lo Que Aprendimos

Esta exploración produjo perspectivas en dos niveles: el enfoque de implementación mismo, y descubrimientos inesperados sobre los datos.

#### Sobre la Implementación

- La disciplina de flujo (leer-procesar-escribir por registro) no es solo eficiente en memoria—impone un modelo mental más claro de la transformación como una función pura sobre registros.
- Nombres de columnas en español que funcionan como identificadores válidos de Python (`id_seq`, `ubicacion`, `nombre_normalizado`, `codigo_escuela`) tienden un puente entre documentación y código.

#### Sobre los Datos Mismos (Exploración Post-Normalización)

Después de generar los archivos normalizados, los examinamos sistemáticamente para entender qué había producido el _pipeline_. Los hallazgos fueron sustanciales:

**1. El Conteo Verdadero de Entidades (Respondiendo Pregunta Abierta #1)**

Comparando `codigo_escuela` entre ambos archivos:

| Métrica | Conteo |
|---------|--------|
| Solo PAE | 5,151 |
| Solo SINEC | 5,781 |
| Solapamiento (por código) | 10,602 |
| **Unión (cota superior)** | **21,534** |

La estimación de la teoría de "~15,754 (PAE) o ~16,384 (SINEC)" los trataba separadamente. El panorama combinado revela potencialmente 21,534 códigos de escuela distintos—aunque algunos códigos no solapados pueden referirse a la misma escuela física registrada diferentemente.

**2. La Divergencia del Corpus de Referencia Es Más Profunda de lo Esperado**

Entre las 10,602 escuelas que comparten el mismo `codigo_escuela` en ambos archivos:
- **785 discrepancias de nombre** (7.4%) — mismo código de escuela, diferente nombre
- **465 discrepancias de ubicación** (4.4%) — mismo código, diferente parroquia

Ejemplos de discrepancias de nombre revelan causas sistemáticas:

| PAE | SINEC | Causa |
|-----|-------|-------|
| `TRANQUILINO MONTESDEOCA DUE¥AS` | `TRANQUILINO MONTESDEOCA DUEÑAS` | Divergencia de codificación |
| `SIN NOMBRE (SAN JOSE DE CHAZO)` | `SEGUNDO MELCHOR ESTRADA GARCIA` | Deriva temporal (la escuela recibió nombre) |
| `RUMIÑAHUI` | `RUMI AHUI` | Corrupción de espacios |
| `EUGENIO ESPEJO` | `EUGENIO ESPEJO (CERRO PRIETO)` | Adición de calificador |
| `BATALLA DE TIOCAJAS` | `BATALLA DE TIOCAJAS (INDIGENA)` | Marcador de clasificación |
| `VICTOR MANUEL RENDON` | `24 DE JULIO` | Renombre completo (¡mismo código!) |

Las discrepancias de ubicación son típicamente parroquias adyacentes (ej. `130601` vs `130603`)—probablemente cambios de límites administrativos o entrada de datos en diferentes momentos.

**3. Nueva Categoría de Ruido: Artefactos de Codificación**

La taxonomía de ruido de la teoría necesita una nueva categoría. PAE sufre de corrupción de codificación ausente en SINEC:

| Artefacto | Ejemplo | Causa Probable |
|-----------|---------|----------------|
| `¥` por `Ñ` | `NIÑO` → `NI¥O`, `DUEÑAS` → `DUE¥AS` | _Mojibake_ Windows-1252 → UTF-8 |
| `Ø` por `º` | `Nº 465` → `NØ 465` | Mismo problema de codificación |
| `Ø` por `0` | `10 DE DICIEMBRE` → `1Ø DE DICIEMBRE` | Corrupción de dígito |

Encontramos 20+ instancias de `¥` en PAE, cero en SINEC. Esta es corrupción unilateral que requiere preprocesamiento antes de cualquier emparejamiento.

**4. El Patrón `# NÚMERO` Es Geográfico, No Aleatorio**

Ambos archivos contienen escuelas con sufijos `# NÚMERO` (ej. `SIMON BOLIVAR # 47`):
- SINEC: 2,288 escuelas (14%)
- PAE: 1,541 escuelas (10%)

Pero esto no es ruido aleatorio—es una **convención municipal de Guayaquil**:
- **97.5% de las entradas `# NÚMERO` de SINEC están en provincia 09 (Guayas)**
- Misma concentración geográfica en PAE

Esto es desambiguación sistemática, no error de transcripción. La normalización debería preservar o extraer estos números como metadatos, no eliminarlos como ruido.

**5. Sesgo Sistemático de Cobertura**

PAE y SINEC no solo discrepan en detalles—**sirven a diferentes poblaciones**:

| Fortalezas PAE | Fortalezas SINEC |
|----------------|------------------|
| Provincias amazónicas (15, 21, 23): 1,093 escuelas | Guayaquil urbano (09): 1,463 más que PAE |
| Enfoque rural/programa de alimentación | Registro oficial (todas las escuelas) |
| Provincias 15, 20, 23 presentes | Provincias 15, 20, 23 ausentes |

PAE es el programa de alimentación escolar—sobre-representa áreas rurales, indígenas y de bajos ingresos. SINEC es el registro oficial—incluye escuelas privadas urbanas que no necesitan asistencia alimentaria. **Ninguno es superconjunto del otro.**

**6. El Marcador `(INDIGENA)`**

SINEC etiqueta 434 escuelas con sufijo `(INDIGENA)`; PAE tiene 329. Estas son escuelas bilingües/interculturales que sirven a comunidades indígenas, frecuentemente con nombres en kichwa (`INTI RAYMI`, `RUMIÑAHUI`, `PACHA MAMA`). Estos metadatos de clasificación podrían ayudar en la desambiguación—las escuelas indígenas siguen diferentes patrones de nomenclatura.

#### Observación Metodológica

Estos hallazgos emergieron de sondeo sistemático: contando líneas, aplicando _grep_ a patrones, uniendo por códigos, comparando campos. Cada comando fue una prueba de hipótesis. Los archivos normalizados, aunque "solo" versiones con espacios colapsados de los originales, se convirtieron en un lente a través del cual estructura más profunda se hizo visible.

Los comandos usados:
```bash
# Solapamiento de entidades
comm -12 <(cut -f4 archivo1 | sort) <(cut -f4 archivo2 | sort) | wc -l

# Discrepancias de nombre entre códigos compartidos
python3 -c "..." # unir por código, comparar nombres

# Distribución de patrón
grep -E '# [0-9]+' archivo | cut -f2 | cut -c1-2 | sort | uniq -c

# Artefactos de codificación
grep '¥' archivo | head -20
```

Este es el método: interrogar los datos con preguntas precisas, dejar que las respuestas guíen la siguiente pregunta.

### Lo Que Inventamos

**El contrato de normalización**: cada archivo normalizado lleva:
- Un ID secuencial sintético (para referencia interna durante esta etapa del _pipeline_)
- Un código de ubicación estandarizado (la clave opaca de 6 dígitos)
- Un nombre con separación de palabras garantizada por espacio simple
- El identificador original (para trazar de vuelta a la fuente)

Este contrato se propagará a través de etapas subsiguientes del _pipeline_.

### Decisiones Técnicas

- **`ubicacion` sobre `localizacion`** — más natural para ubicación geográfica en español.
- **Delimitado por tabuladores, UTF-8, sin retornos de carro** — consistente con convenciones del proyecto.
- **Línea de encabezado con identificadores en español** — auto-documentado, amigable al código.

### Próximos Pasos

Deduplicación: colapsar registros con idénticos (ubicacion, nombre_normalizado) dentro de cada archivo, rastreando multiplicidades y códigos originales. Luego fusionar los dos archivos en una referencia consolidada.

---

### Reflexión

Nuestro primer código. Diecisiete líneas de lógica, rodeadas de ceremonia. El patrón de flujo se sintió correcto—cada registro entra, se transforma, sale. Sin acumulación, sin estado oculto. Los archivos de salida ahora residen en `results/`, listos para la siguiente etapa. El _pipeline_ ha comenzado a fluir.
