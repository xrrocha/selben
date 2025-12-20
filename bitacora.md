# Selben: un Viaje de Descubrimiento e Invención

## Estableciendo los Fundamentos

**Marca temporal:** 2025-12-19T00:00:00

**Resumen:** Se establecen los fundamentos filosóficos y metodológicos para esta exploración—un enfoque donde la teoría precede a la implementación, la comprensión antecede a la acción, y el viaje se valora tanto como el destino.

---

### Filosofía Central

Este proyecto es parte descubrimiento, parte invención. No hay especificaciones a priori—solo lo que los datos semilla revelan, y aun eso debe descubrirse.

Los principios rectores:

1. **La teoría es el santo grial.** El código es solo una sombra proyectada por la teoría. El código emana de la teoría pero no la encarna completamente.

2. **El viaje importa tanto como el destino.** Cada tarea completada se registra en detalle: qué buscamos aprender, qué hicimos para aprenderlo, qué descubrimos, qué inventamos en respuesta.

3. **La comprensión precede a la acción.** Antes de implementar, primero entender. Preguntas clarificadoras antes de código.

4. **Linaje de datos desde el inicio.** Los datos semilla residen en `data/`. Los datos derivados se acumulan en `results/`. El código de soporte vive en `src/` y `test/`.

### Estructura Documental

- **`teoria.md`** — documento en constante evolución que destila la comprensión actual
- **`bitacora.md`** — diario de solo-agregar que preserva el camino

Existe una tensión interesante: la teoría evoluciona, el diario solo crece. La teoría destila; el diario preserva. Referencia cruzada cuando la teoría cambia significativamente.

---

### Reflexión

Y así comienza. Las reglas de compromiso están establecidas: la teoría guía, el código sigue, y cada paso queda registrado. El destino es la comprensión; el camino, documentado en estas páginas, es cómo llegaremos.

---

## Reconocimiento de Datos y Alcance Inicial

**Marca temporal:** 2025-12-19T01:30:00

**Resumen:** Exploramos los tres conjuntos de datos semilla, descubrimos su estructura y relaciones, catalogamos la taxonomía de ruido en nombres de escuelas transcritos, formulamos una teoría inicial y diseñamos un _pipeline_ trazable de preprocesamiento para consolidar los datos de referencia oficiales antes de abordar el corpus de encuestas más ruidoso.

---

### Lo Que Buscamos Aprender

La pregunta fundamental: ¿con qué estamos tratando? Antes de cualquier código, antes de cualquier algoritmo, necesitábamos entender la forma, escala y carácter de nuestros datos.

### Lo Que Hicimos

1. **Escaneamos `data/`** — Encontramos tres archivos delimitados por tabuladores: `encuestas.txt` (212MB, 6.7M filas), `escuelas_pae.txt` (1.1MB, 15.7K filas), `tabla_sinec.txt` (803KB, 16.4K filas).

2. **Sondamos la estructura** — Examinamos encabezados, muestreamos filas, analizamos valores únicos. Descubrimos códigos de ubicación, clasificadores institucionales y las relaciones entre archivos.

3. **Examinamos el ruido** — Muestreamos nombres de escuelas de encuestas para presenciar el caos de primera mano: `SIMON BOLIVAR` apareciendo en 30+ variaciones, errores tipográficos como `M0NTALVO` (cero por O), `BOLIVAE` (errata), artefactos de teclado como `DR,. CAMILLO`.

4. **Cuantificamos el problema** — 385,900 cadenas de nombres distintas mapeando a ~16,000 entidades canónicas. Ratio de compresión ~25:1.

5. **Descubrimos una anomalía** — 14,464 IDs de encuesta se solapan con códigos de escuela. ¿Coincidencia o señal? Anotado para investigación futura.

### Lo Que Aprendimos

- **Los corpus de referencia no son dorados.** PAE y SINEC discrepan: diferentes códigos, diferentes atribuciones de ubicación, nombres duplicados dentro de la misma ubicación.
- **El ruido es sistemático.** Los errores tipográficos siguen patrones (proximidad de teclado, confusión fonética, colisión Ñ-Enter del teclado latino).
- **Los clasificadores (ESC, COL, JARD) son artefactos de encuesta** ausentes en nombres oficiales.
- **La ubicación restringe el problema** — un nombre es ambiguo globalmente pero frecuentemente único localmente.

### Lo Que Inventamos

**El _Pipeline_ Trazable** — una metodología donde cada transformación preserva el linaje:

1. **Archivo #1**: SINEC deduplicado → `(seq_id, ubicacion, nombre, conteo, codigos)`
2. **Archivo #2**: PAE deduplicado → misma estructura
3. **Archivo #3**: Fusionado → añade `en_sinec`, `en_pae`, y listas de IDs fuente
4. **Archivo #4+**: Transformaciones subsiguientes (normalización, firmas, agrupamiento) cada una enlaza a etapas previas

Esto permite tanto depuración (¿por qué falló esto?) como validación (¿sobreviven los buenos patrones?).

### Decisiones Tomadas

- **La ubicación es opaca**: Componemos códigos de ubicación de 6 dígitos y olvidamos su significado interno.
- **Nombres preservados exactamente** en etapa de deduplicación; normalización diferida.
- **Todo en mayúsculas**, siempre.
- **Salida a `results/`**, estructura de directorios a emerger orgánicamente.
- **Archivos planos delimitados por tabuladores** como nuestro formato estándar.

### Próximos Pasos

Implementar el _pipeline_ de preprocesamiento: deduplicar SINEC, deduplicar PAE, fusionar en archivo de referencia consolidado. Entonces podremos responder la pregunta abierta: ¿cuál es el conteo verdadero de entidades?

---

### Reflexión

Resistimos el impulso de codificar. En cambio, miramos. Contamos. Muestreamos. Cuestionamos. Los datos se revelaron no como un problema a resolver sino como un paisaje a mapear. El documento de teoría, nacido hoy, es esquelético—pero tiene huesos. El diseño del _pipeline_, trazado en servilleta antes que teclado, asegura que no perderemos el camino de regreso.

---

## Normalizando Nombres Oficiales de Escuelas

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

---

## Deduplicando Archivos de Referencia

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
