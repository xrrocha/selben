# Selben: Una Teoría de Resolución de Entidades Ruidosas

## 1. Planteamiento del Problema

Enfrentamos un problema de **resolución de entidades ruidosas**: mapear un gran conjunto de cadenas degradadas y variantes (nombres observados) a un conjunto más pequeño de entidades canónicas (escuelas reales). Este es un mapeo de muchos a uno donde:

- **Corpus fuente**: ~385,900 cadenas de nombres distintas de transcripciones de encuestas
- **Corpus objetivo**: ~15,754 entidades canónicas de escuelas (PAE) o ~16,384 (SINEC)
- **Ratio de compresión**: ~25:1 (variantes promedio por entidad)

El objetivo no es meramente agrupar cadenas similares, sino **atribuir** cada nombre observado a su referente canónico—o reconocerlo como no atribuible.

---

## 2. El Paisaje de Datos

### 2.1 Tres Corpus, Tres Naturalezas

| Corpus | Naturaleza | Confiabilidad | Propiedad Clave |
|--------|------------|---------------|-----------------|
| `encuestas` | Nombres observados (ruidosos) | Baja | Alto volumen, alta varianza |
| `escuelas_pae` | Nombres de referencia (programa PAE) | Media | Contiene régimen (COSTA/SIERRA) |
| `tabla_sinec` | Nombres de referencia (registro oficial) | Mayor | Contiene códigos institucionales |

### 2.2 Relaciones entre Corpus

```
encuestas ──(?)──► PAE ──(10,602)──► SINEC
    │                                   │
    └──────── códigos de ubicación ─────┘
```

- **PAE ∩ SINEC**: 10,602 escuelas aparecen en ambos corpus de referencia (enlazadas por `codigo`)
- **PAE ∖ SINEC**: Escuelas en PAE no en SINEC (posiblemente escuelas de ubicaciones adyacentes)
- **SINEC ∖ PAE**: Escuelas no en el programa de alimentación
- **encuestas → ?**: El mapeo que buscamos descubrir

### 2.3 La Ubicación como Identificador Opaco

Los códigos geográficos se componen de tres niveles administrativos en un único código de **ubicación** de 6 dígitos:

```
PP CC RR → PPCCRR (ej. 090112)
```

De aquí en adelante, tratamos la ubicación como un **identificador de agrupación opaco**. Su estructura interna es irrelevante para nuestros métodos. Lo que importa: nombres observados en la misma ubicación probablemente refieren a la misma entidad.

---

## 3. Taxonomía de Ruido

Los nombres observados exhiben múltiples tipos de ruido, frecuentemente co-ocurrentes:

### 3.1 Ruido Tipográfico

| Tipo | Ejemplo | Causa |
|------|---------|-------|
| **Sustitución de carácter** | `M0NTALVO` (cero por O) | Similitud visual |
| **Transposición** | `FRANCIACO` → FRANCISCO | Error motor |
| **Omisión** | `NACINAL` → NACIONAL | Prisa |
| **Inserción** | `PASAAJE` → PASAJE | Error de duplicación |
| **Truncamiento** | `CIUDAD DE AZOGUEZ (E` | Entrada interrumpida |

### 3.2 Ruido de Límite (Proximidad de Teclado)

| Tipo | Ejemplo | Causa |
|------|---------|-------|
| **Colisión Ñ-Enter** | Nombres terminando en Ñ con envío prematuro | Teclado latino: Ñ adyacente a Enter |
| **Puntuación desplazada** | `DR,. CAMILLO` | Temporización de tecla Shift |

### 3.3 Ruido Estructural

| Tipo | Ejemplo | Causa |
|------|---------|-------|
| **Presencia de clasificador** | `SIMON BOLIVAR ESC.` | Contexto de encuesta (elegibilidad) |
| **Ausencia de clasificador** | `SIMON BOLIVAR` | Omisión o forma del corpus de referencia |
| **Variación de clasificador** | `ESC.`, `ESC`, `(ESC)`, `/ESC` | Sin estándar |
| **Permutación de orden de palabras** | `ESC. SIMON BOLIVAR` vs `SIMON BOLIVAR ESC.` | Estilo de transcripción |

### 3.4 Ruido de Espacios en Blanco

| Tipo | Ejemplo | Causa |
|------|---------|-------|
| **Espacios múltiples** | `SIMON  BOLIVAR` | Rebote de teclado, formateo |
| **Iniciales/finales** | ` SIMON BOLIVAR ` | Entrada descuidada |
| **Espacios faltantes** | `BOLIVAR.ESC` | Prisa |

### 3.5 Ruido Semántico

| Tipo | Ejemplo | Causa |
|------|---------|-------|
| **Nombres de marcador de posición** | `SIN NOMBRE ESC` | Desconocido al momento de entrada |
| **Prefijos numéricos** | `1BLANCA MARTINEZ` | Artefacto de entrada de datos |
| **Formas abreviadas** | `FCO` → FRANCISCO | Restricciones de espacio |

---

## 4. Observaciones Estructurales

### 4.1 _Tokens_ Clasificadores

El contexto de encuesta introdujo **clasificadores institucionales** ausentes de registros oficiales:

| _Token_ | Significado | Español |
|---------|-------------|---------|
| `ESC` | Escuela primaria | Escuela |
| `COL` | Escuela secundaria | Colegio |
| `JARD` / `JAR` | Jardín de infantes | Jardín |

**Perspectiva clave**: Eliminar clasificadores de nombres observados debería aumentar alineación con corpus de referencia. Sin embargo, los clasificadores llevan **señal semántica** (nivel educativo) que puede ayudar en desambiguación.

### 4.2 Distribución de Frecuencia de Nombres

Nombres base de alta frecuencia (héroes nacionales, fechas, santos) crean **riesgo de colisión**:

- `SIMON BOLIVAR`: aparece en casi toda ubicación
- `JUAN MONTALVO`: igualmente
- `10 DE AGOSTO`, `24 DE MAYO`: fechas patrióticas

Sin restricción de ubicación, estos nombres son ambiguos. Con ella, se vuelven resolubles.

### 4.3 Los Corpus de Referencia No Son Dorados

Los archivos PAE y SINEC mismos contienen:
- Capitalización inconsistente
- Diacríticos faltantes (aunque menos que encuestas)
- Formas abreviadas
- Direcciones en blanco o parciales
- Nombres duplicados dentro de la misma ubicación

**Implicación**: La resolución de entidades no es emparejar cadenas ruidosas con objetivos perfectos, sino alinear dos distribuciones ruidosas de varianza diferente.

---

## 5. Marco Teórico

### 5.1 La Función de Emparejamiento

Buscamos una función:

```
M: nombre_observado × ubicación → {entidad_canónica ∪ ∅}
```

Donde `∅` representa "no atribuible."

### 5.2 Descomposición de Similitud

La similitud de cadenas puede descomponerse en:

1. **Similitud fonética**: ¿Suenan igual? (_Soundex_, _Metaphone_)
2. **Similitud ortográfica**: ¿Se ven igual? (Distancia de edición, _Jaro-Winkler_)
3. **Similitud de _tokens_**: ¿Comparten _tokens_? (_Jaccard_, _TF-IDF_)
4. **Similitud estructural**: ¿Siguen el mismo patrón? (Posición de clasificador, longitud)

Ninguna medida única es suficiente. El problema demanda **similitud compuesta** con pesos aprendidos o ajustados.

### 5.3 El Modo de Fallo de _Soundex_

_Soundex_ agrupa por clase fonética, colapsando:
- `BOLIVAR` y `BOLIVAE` ✓ (agrupación correcta)
- `BOLIVAR` y `BELIVAR` ✓ (correcto)
- Pero también nombres no relacionados compartiendo esqueletos fonéticos

_Soundex_ es **alta recuperación, baja precisión**. Sobre-agrupa, creando falsos positivos que requieren desambiguación secundaria.

### 5.4 Estrategia de Bloqueo

Dados ~385,900 × ~16,000 comparaciones potenciales (~6 mil millones), el emparejamiento por fuerza bruta es inviable. Requerimos **bloqueo**:

1. **Bloqueo por ubicación**: Solo comparar dentro de misma ubicación (+ contiguas)
2. **Bloqueo fonético**: Solo comparar dentro de clase _soundex_
3. **Bloqueo por _token_**: Solo comparar si comparten al menos un _token_ no-_stopword_

El bloqueo intercambia recuperación por tratabilidad. El arte está en elegir bloques que preserven emparejamientos verdaderos.

---

## 6. Hipótesis para Investigación

### H1: Extracción de Clasificadores
Extraer y normalizar clasificadores (ESC, COL, JARD) como características separadas mejorará el emparejamiento al:
- Reducir ruido en el nombre propio
- Proveer señal de nivel educativo para desambiguación

### H2: Suficiencia de Restricción de Ubicación
Para nombres de alta frecuencia (SIMON BOLIVAR, etc.), la restricción de ubicación sola puede ser suficiente para atribución única.

### H3: Los Patrones de Erratas Son Sistemáticos
Las erratas no son aleatorias sino siguen patrones:
- Sustituciones de teclas adyacentes
- Confusiones fonéticas comunes (B/V, C/S/Z, I/Y)
- Omisiones predecibles (letras silentes, consonantes repetidas)

Aprender estos patrones habilita **corrección generativa** en lugar de mero emparejamiento por similitud.

### H4: Co-ocurrencia de _Tokens_
Si los _tokens_ A y B frecuentemente co-ocurren en nombres de referencia, observar A solo puede predecir B (ej. "JUAN" → "MONTALVO" en contexto).

### H5: Frecuencia como Señal
Los _tokens_ de nombre raros llevan más poder discriminativo que los comunes. Una ponderación tipo _TF-IDF_ puede mejorar precisión de emparejamiento.

---

## 7. Preguntas Abiertas

1. **¿Cuál es el número verdadero de entidades?** PAE y SINEC se solapan pero no completamente. ¿Cuál es la unión?

2. **¿Cómo deberíamos manejar "SIN NOMBRE"?** Estos son marcadores de posición legítimos pero irresolubles.

3. **¿Cuál es el presupuesto de error?** En agrupamiento, ¿qué es peor:
   - ¿Fusionar dos escuelas distintas (falso positivo)?
   - ¿Mantener una escuela como dos grupos (falso negativo)?

4. **¿Podemos aprender reglas de corrección de pares alineados?** Si encontramos emparejamientos de alta confianza, ¿podemos extraer reglas de transformación?

---

## 8. Principios Metodológicos

1. **Teoría antes que código**: Implementamos solo lo que entendemos.
2. **Refinamiento incremental**: Comenzar con enfoques simples, medir, mejorar.
3. **Preservar incertidumbre**: Cuando no estamos seguros, abstenerse de atribuir en lugar de adivinar.
4. **Explicabilidad**: Cada decisión de agrupamiento debe ser trazable a una razón.

---

## 9. El _Pipeline_ Trazable

### 9.1 Principio Central

Todo artefacto derivado debe preservar punteros a sus orígenes. Cuando transformamos datos, no descartamos—enlazamos.

### 9.2 La Cadena de Derivación

```
archivos fuente (PAE, SINEC)
    ↓ deduplicar por (ubicación, nombre)
archivos deduplicados (preservando códigos originales)
    ↓ fusionar
referencia consolidada (preservando IDs de archivo fuente)
    ↓ normalizar
nombres limpios (preservando IDs consolidados)
    ↓ firma
multiconjuntos de _tokens_ canónicos (preservando IDs limpios)
    ↓ agrupar
grupos atribuidos (trazables a fuente)
```

### 9.3 Por Qué Esto Importa

- **Depuración**: Cuando una decisión de agrupamiento parece incorrecta, podemos trazarla de vuelta a los datos crudos.
- **Validación**: Podemos verificar que buenos patrones (coincidencias exactas entre archivos) sobreviven transformaciones.
- **Atribución**: El objetivo final es enlazar nombres de encuesta a códigos oficiales—el linaje habilita esto.

---

*Este documento evoluciona conforme profundiza nuestra comprensión.*
