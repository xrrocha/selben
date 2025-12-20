# Reconocimiento de Datos y Alcance Inicial

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
