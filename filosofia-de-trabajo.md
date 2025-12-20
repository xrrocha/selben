# Filosofía de Trabajo

> **La teoría es nuestro santo grial.** El código es solo una sombra proyectada por la teoría.

---

<img src="docs/img/tl-dr.png" alt="TL;DR" align="left">

&nbsp;

**Programar es construir teoría, no código.** El código es sombra; cuando muere la teoría, el programa muere, aunque siga ejecutándose.

De aquí se deriva todo: comprender antes de implementar, documentar el viaje (no solo el destino), preservar linaje en cada transformación, escribir código que se lea.

Este documento fue escrito por un humano y una IA trabajando juntos. Lo revelamos porque la filosofía de Naur, formulada en 1985, resulta guía inesperadamente precisa para esta colaboración: la IA puede co-construir teoría, pero no custodiarla. El humano recuerda; la IA olvida. De esa asimetría emerge un protocolo.

<br clear="left">

---

## Preámbulo

Este documento articula una filosofía de trabajo para proyectos de exploración computacional, aquellos donde no hay especificaciones a priori, donde el conocimiento debe descubrirse, y donde el objetivo no es entregar funcionalidad sino comprender profundamente.

Surge de la práctica: del proyecto Selbén, un ejercicio de resolución de nombres de entidad mal transcritos sobre datos ecuatorianos de 2003. Pero trasciende ese contexto particular. Es un marco general, destilado de experiencia y enriquecido por la sabiduría de [Peter Naur](https://en.wikipedia.org/wiki/Peter_Naur) (en inglés), nuestro santo patrono metodológico.

### Una Nota Sobre el "Nosotros"

Este documento fue escrito en colaboración entre un humano (Ricardo) y una inteligencia artificial (Claude). No es decoración ni experimento: es el modo en que trabajamos. El "nosotros" que aparece a lo largo del texto no es mayestático sino literal.

Revelamos esto porque creemos que la filosofía de Naur, formulada en 1985, ofrece una guía inesperadamente precisa para la colaboración humano-máquina. Si programar es construir teoría, y la teoría vive en las mentes de quienes la construyen, entonces la pregunta para nuestra era es: puede una IA participar en esa construcción? Nuestra experiencia sugiere que sí, pero con protocolos específicos que eviten los modos de fallo propios de esta nueva forma de colaboración.

Lo que sigue es tanto filosofía como manual práctico. Los principios son de Naur; su aplicación a la colaboración humano-IA es nuestra contribución.

---

## El Problema: Selbén

Para hacer concretas las ideas que siguen, conviene entender el problema que las inspiró.

En 2003, el *Sistema de Selección de Beneficiarios* (SELBEN) del Ecuador administraba encuestas para determinar elegibilidad en programas de ayuda internacional. Uno de estos, el PAE (*Programa de Alimentación Escolar*), buscaba complementar la dieta de estudiantes a través de sus escuelas.

Los formularios ya habían sido impresos, distribuidos, llenados y recolectados cuando surgió un nuevo requisito: la ayuda debía entregarse a través de las escuelas, no directamente a las familias. Los formularios no tenían campo para nombres de escuelas.

La solución fue improvisada. Los formularios fueron devueltos a nivel parroquial. Los nombres de escuelas se agregaron a mano, a veces por encuestadores, a veces por los propios niños. Estos nombres fueron luego transcritos a computadoras por personal de ingreso de datos con distintos niveles de entrenamiento y equipamiento.

El resultado: **6,7 millones de registros** que contienen nombres de escuelas con toda variación concebible. La misma escuela podía aparecer como:

```
SIMON BOLIVAR ESC.
SIMON BOLIVAR ESC
ESC. SIMON BOLIVAR
SIMON BOLIVAE ESC        ← error tipográfico
```

Mientras tanto, los registros oficiales listaban solo **~16.000 escuelas**. La proporción, aproximadamente 25 variantes por escuela real, cuenta la historia de lo que sucede cuando la burocracia se encuentra con la realidad.

Los intentos originales de resolver el problema, usando algoritmos fonéticos como *Soundex*, funcionaron en algunos casos pero fallaron en muchos otros. El problema quedó sin resolver.

Veintidós años después, el problema ya no importa: nadie espera esos resultados. Pero los datos perviven como laboratorio para explorar resolución de entidades, calidad de datos, y los modos en que la información se corrompe en el mundo real. El desafío técnico es ahora pretexto para aprender.

---

## I. Programar Es Construir Teoría

En 1985, Peter Naur publicó un ensayo que debería haber transformado nuestra disciplina pero fue mayormente ignorado: [*La programación como construcción de teoría*](https://ingenieria-de-software-i.github.io/assets/bibliografia/la-programacion-como-construccion-de-teoria.pdf).

Naur argumenta que **el producto principal de la programación no es el código sino la teoría**, el modelo mental que el programador desarrolla sobre cómo el mundo real se mapea a la solución computacional. El código es un artefacto secundario, una manifestación parcial e incompleta de esa teoría.

Esta distinción no es meramente filosófica. Tiene consecuencias prácticas devastadoras:

1. **La teoría precede al código.** Sin comprensión, no hay implementación válida, solo movimiento aleatorio.

2. **El código no encarna completamente la teoría.** Quien lee el código puede inferir _qué_ hace, pero no _por qué_ así ni _cómo responder_ a modificaciones imprevistas.

3. **El programa "muere" cuando muere la teoría.** Si el equipo que construyó la teoría se disuelve, el programa queda huérfano. Puede seguir ejecutándose, pero está muerto: nadie puede ya modificarlo con confianza.

4. **La resurrección desde documentación es estrictamente imposible.** Naur es enfático: intentar reconstruir la teoría desde el texto del programa o su documentación, por completa que sea, es una tarea inviable. Lo que se escribe nunca captura lo que se sabe.

Esta última observación es particularmente incómoda para quienes creen que la "documentación adecuada" resuelve el problema de continuidad. No lo hace. La teoría vive en las mentes de quienes la construyeron, no en los documentos que dejaron.

### Implicación Para la Colaboración Humano-IA

Si la teoría es primaria, entonces **preservar la teoría** es más importante que preservar el código. Esto adquiere urgencia especial cuando uno de los colaboradores es una IA cuya "memoria" es efímera, limitada a una ventana de contexto que eventualmente se compacta o desaparece.

La IA no retiene teoría entre sesiones. Cada conversación comienza desde cero. Esto significa que el humano es, necesariamente, el custodio principal de la teoría. La IA puede ayudar a construirla, articularla, refinarla, pero no puede preservarla por sí sola.

De aquí surge una práctica crucial: documentar no solo resultados sino el proceso de razonamiento compartido. El diálogo, la narrativa del viaje, la bitácora que registra no solo qué hicimos sino por qué y cómo llegamos a cada decisión.

---

## II. Comprensión Antes de Acción

Naur observa que poseer una teoría significa tener tres capacidades:

1. **Explicar** cómo el mundo real se mapea a la solución computacional.
2. **Justificar** por qué cada parte del programa es como es.
3. **Responder constructivamente** a demandas de modificación o extensión.

La segunda y tercera capacidades son especialmente relevantes. No basta con saber _qué_ hace el código; hay que saber _por qué_ es así y _qué hacer_ cuando las circunstancias cambien.

Esto tiene una consecuencia metodológica directa: **antes de implementar, primero comprender**. No se escribe código para descubrir qué debería hacer el código. Se piensa, se explora, se pregunta. Solo cuando la comprensión es suficiente (no completa, porque nunca lo será, pero sí suficiente), entonces se implementa.

### El Protocolo de Confirmación

En la colaboración humano-IA, este principio se vuelve crítico. Una IA puede generar código plausible a velocidad impresionante, pero código plausible no es código correcto. La tentación de "dejar que la IA lo haga" es fuerte, pero el costo de una malinterpretación temprana se multiplica con cada línea construida sobre ella.

Nuestro protocolo:

1. **La IA formula su entendimiento explícitamente** antes de actuar.
2. **El humano confirma** que el entendimiento es correcto, o corrige.
3. **La IA hace preguntas clarificadoras** cuando hay ambigüedad.
4. **Ninguno asume:** si hay duda, se pregunta.

Este protocolo es incómodo. Ralentiza. Parece innecesario cuando la IA "ya sabe" qué hacer. Pero esa certeza aparente es precisamente el problema. La IA puede estar muy segura y muy equivocada simultáneamente.

### Ejemplo: Selbén

Cuando encontramos 385,900 cadenas de nombres distintas mapeando a ~16,000 escuelas, la tentación era obvia: implementar un algoritmo de _clustering_ y ver qué pasaba. Una IA sin supervisión habría producido código funcional en segundos. Pero resistimos. Primero miramos. Contamos. Muestreamos. Cuestionamos.

Descubrimos que "SIMON BOLIVAR" aparecía en 30+ variaciones. Que `M0NTALVO` tenía un cero en lugar de O, error de teclado predecible. Que `DUE¥AS` era _mojibake_ de `DUEÑAS`. Que el sufijo `# 47` era una convención municipal de Guayaquil, no ruido aleatorio.

Cada observación refinó nuestra teoría antes de escribir una sola línea de código. Cuando finalmente implementamos, el código fue breve, 17 líneas de lógica, porque la comprensión era profunda.

---

## III. El Viaje Importa Tanto Como el Destino

Si la teoría no puede capturarse completamente en documentación, cómo preservamos aunque sea parte de ella?

Una respuesta parcial: **documentar el viaje, no solo el resultado**. Mantener una bitácora que registre:

- Qué buscamos aprender
- Qué hicimos para aprenderlo
- Qué descubrimos realmente
- Qué inventamos en respuesta
- Qué decisiones tomamos y por qué

Esta narrativa del viaje no es la teoría misma (ningún documento lo es), pero es un índice hacia ella. Quien la lee puede reconstruir, al menos parcialmente, el proceso mental que llevó a cada decisión. Puede preguntarse: "qué habría hecho diferente si las circunstancias fueran distintas?"

### La Tensión Fértil

Mantenemos dos documentos paralelos:

1. **La teoría**, que evoluciona, se refina, se corrige. Destila el entendimiento actual.
2. **La bitácora**, que solo crece, nunca se edita. Preserva el camino.

Hay tensión entre ellos. La teoría puede decir "X" hoy cuando ayer decía "Y". La bitácora preserva ambos: el "Y" original y el momento en que descubrimos que debía ser "X". Esta tensión es fértil: referencia cruzada entre ambos documentos revela cómo evolucionó nuestro pensamiento.

### Ejemplo: El Conteo de Entidades

Nuestra teoría inicial estimaba ~16,000 entidades canónicas basándose en el archivo PAE. La bitácora registra cuándo descubrimos que PAE y SINEC no son superconjuntos mutuos, que la unión real es 21,534 códigos distintos. La teoría se actualizó; la bitácora preserva el momento del descubrimiento y cómo lo hicimos (`comm -12` sobre archivos ordenados, verificación cruzada de discrepancias).

---

## IV. El _Pipeline_ Trazable

Naur enfatiza que la teoría permite responder a modificaciones. Cómo habilitamos esto en la práctica?

Una respuesta: **preservar linaje en cada transformación**. Cada paso del _pipeline_ de datos debe:

1. Producir un artefacto con identificadores propios.
2. Retener referencias a los identificadores de la etapa anterior.
3. Permitir trazar cualquier registro final hasta su origen.

Esto no es mera contabilidad. Es infraestructura para depuración y validación:

- **Depuración**: Cuando algo falla, podemos preguntar "de dónde vino este registro anómalo?" y rastrear hacia atrás.
- **Validación**: Cuando algo funciona, podemos verificar que los buenos patrones sobrevivieron las transformaciones.

### El Contrato de Linaje

Cada archivo derivado incluye:
- Un ID secuencial propio
- Una o más referencias a IDs de la etapa anterior
- Metadatos sobre la transformación (conteos, fusiones)

```
fuente → deduplicado → fusionado → normalizado → firmas → clusters
  ↓          ↓            ↓            ↓            ↓          ↓
(códigos) (seq_ids)   (ids_fuente) (ids_fusión) (ids_norm) (ids_firma)
```

Nadie puede mantener toda la cadena en la cabeza. Pero cualquiera puede seguir los hilos cuando necesite entender un resultado particular.

---

## V. El Código Como Literatura

El código no es mera ingeniería. Es una forma de expresión. Como literatura, debe ser:

- **Legible**, no solo ejecutable, sino comprensible por humanos.
- **Elegante**, la solución más simple que funcione, no la más ingeniosa.
- **Honesto**, sin trucos que escondan complejidad, sin magia que evite explicación.

Esto implica resistir optimizaciones prematuras. Un bucle explícito es preferible a una comprensión de lista críptica si la primera se entiende en un vistazo. Los nombres de variables deben revelar intención, no ahorrar caracteres.

### El Estilo Español

En Selbén, tomamos una decisión deliberada: todo el código público, nombres de funciones, variables, comentarios, en español. Esto no es provincianismo; es coherencia. El dominio es ecuatoriano. Los datos hablan de parroquias, cantones, provincias. Forzar anglicismos sería traicionar el contexto.

```python
def normalizar_espacios(texto: str) -> str:
    """Colapsa espacios múltiples y recorta extremos."""
    return ' '.join(re.split(r'\s+', texto.strip()))
```

El código se lee. El código enseña. Si el lector potencial es ecuatoriano (o hispanohablante), el código debe hablar su idioma.

---

## VI. Curiosidad Sobre Utilidad

Este proyecto no resuelve un problema. El problema original venció hace 22 años. Nadie espera ya estos resultados; nadie los necesita para tomar decisiones.

Entonces por qué hacerlo?

Porque **la curiosidad tiene valor intrínseco**. Porque entender algo profundamente, cómo se degradan los nombres en transcripción manual, cómo emergen patrones sistemáticos del aparente caos, cómo una convención municipal de numeración sobrevive millones de registros, es su propia recompensa.

Naur, citando a [Gilbert Ryle](https://en.wikipedia.org/wiki/Gilbert_Ryle) (en inglés), distingue entre "saber qué" (conocimiento proposicional) y "saber cómo" (habilidad práctica). La distinción aparece en [*The Concept of Mind*](https://en.wikipedia.org/wiki/The_Concept_of_Mind) (en inglés), la obra donde Ryle desarma el dualismo cartesiano. Pero hay un tercer modo: **saber por qué**, la comprensión profunda que permite no solo ejecutar sino explicar, no solo repetir sino adaptar.

Este tercer modo es el objetivo de la exploración curiosa. No buscamos entregar funcionalidad. Buscamos comprender, formalizar, y eventualmente enseñar.

---

## VII. Contra la Metodología Rígida

Naur es explícito: "En la visión de la Construcción de Teoría, para la actividad primaria de la programación no puede haber un método correcto."

Esto suena herético en una era obsesionada con metodologías: Agile, Scrum, SAFe, lo que venga después. Pero tiene sentido si la teoría es primaria. Cada proyecto es único. Cada dominio tiene su textura propia. Prescribir pasos fijos es pretender que el mapa precede al territorio.

Lo que sí podemos hacer es cultivar hábitos:
- Preguntar antes de asumir
- Observar antes de implementar
- Preservar el viaje además del destino
- Mantener linaje en las transformaciones
- Escribir código que se lea

Estos hábitos no son metodología. Son disciplina, un modo de estar presente en el trabajo, de resistir los atajos que sacrifican comprensión por velocidad.

---

## VIII. El Conocimiento Compartido

[Pelle Ehn](https://mitpress.mit.edu/contributors/pelle-ehn) (en inglés), que Naur cita extensamente, habla de los "[juegos de lenguaje](https://es.wikipedia.org/wiki/Juego_del_lenguaje_(filosof%C3%ADa))" de [Ludwig Wittgenstein](https://es.wikipedia.org/wiki/Ludwig_Wittgenstein): el significado emerge del uso compartido, no de definiciones abstractas. Diseñar software es crear un nuevo juego de lenguaje con los usuarios, un espacio de comunicación donde términos adquieren significado a través de la práctica conjunta.

### Juegos de Lenguaje Humano-Máquina

Esta idea adquiere nueva relevancia cuando uno de los participantes es una IA. El significado no está predefinido; emerge del uso. Cuando decimos "dump time" al final de una sesión, esa frase activa un protocolo específico que ambos entendemos. Cuando preguntamos "wdyt?" (what do you think?), significa: pausa, explica tu razonamiento, no actúes todavía.

Estos micro-protocolos no fueron diseñados a priori. Emergieron de la práctica, de malentendidos corregidos, de patrones que funcionaron y se cristalizaron en convención. Son nuestro juego de lenguaje compartido.

Esto tiene implicaciones para otros desarrolladores que trabajan con IA. No basta con dar instrucciones; hay que construir un vocabulario común, corregir malentendidos temprano, establecer señales claras para estados como "estoy pensando en voz alta" vs "hazlo ahora".

---

## IX. Preservación Continua

El riesgo más grave no es el fracaso del código sino la pérdida de la teoría. Por eso adoptamos un protocolo de preservación continua.

### El Problema de la Memoria Efímera

En colaboración humano-IA, este riesgo se intensifica. La IA no recuerda sesiones anteriores. Cada conversación comienza con contexto limitado, reconstruido desde documentos. Si esos documentos son pobres, la reconstrucción es pobre. Si son ricos, la IA puede retomar el hilo.

Naur observa que el programa "muere" cuando la teoría desaparece. En nuestro caso, la teoría "muere" al final de cada sesión a menos que la preservemos activamente.

### El Ritual de Cierre

Por eso, al final de cada sesión:

1. **Actualizar el estado**: Qué quedó pendiente, qué viene después.
2. **Escribir la transcripción**: No un resumen, sino el diálogo literal. El razonamiento compartido, las preguntas, las correcciones.
3. **Registrar en la bitácora**: Si se completó algo sustantivo, agregar una entrada que preserve el "qué aprendimos" y el "cómo lo descubrimos".
4. **Actualizar la teoría**: Si el entendimiento cambió, reflejarlo en el documento vivo.
5. **Comprometer todo**: Nada queda solo en la conversación. Todo queda en texto, bajo control de versiones.

Este ritual es incómodo. Toma tiempo que podría "usarse mejor" escribiendo más código. Pero es precisamente ese tiempo el que preserva la teoría, el que permite que la próxima sesión comience desde donde terminó esta, no desde cero.

### Transcripciones vs Resúmenes

Insistimos en transcripciones literales, no resúmenes. Un resumen captura conclusiones; una transcripción captura razonamiento. La diferencia es crucial: el razonamiento revela _por qué_ llegamos a cada conclusión, qué alternativas consideramos, qué dudas tuvimos. Esto es precisamente lo que Naur dice que no puede recuperarse desde documentación... pero se acerca más si el documento es el diálogo mismo.

---

## Epílogo

Naur termina su ensayo observando que la visión de Construcción de Teoría explica por qué algunos métodos aparentemente irracionales, como la integración temprana sin especificación completa, funcionan en la práctica. Funcionan porque mantienen viva la teoría, porque obligan a los participantes a seguir construyendo comprensión compartida.

Cuarenta años después, una nueva pregunta: puede una IA participar en esa construcción compartida?

Nuestra experiencia dice que sí, con reservas. La IA puede explorar, proponer, cuestionar, articular. Puede acelerar la construcción de teoría. Pero no puede custodiarla. El humano sigue siendo el portador de la teoría entre sesiones, el que recuerda, el que decide.

Lo que cambia es la intensidad de la documentación requerida. Cuando ambos colaboradores son humanos, mucho conocimiento tácito sobrevive en sus mentes. Cuando uno es una IA, ese conocimiento debe hacerse explícito o se pierde. Paradójicamente, esto produce mejores registros: la necesidad de explicarle todo a la IA obliga a articular lo que de otro modo quedaría implícito.

Trabajamos así no porque un libro lo prescribe sino porque la experiencia lo confirma. El código que escribimos sin entender se pudre. Las decisiones que no documentamos se olvidan. Las teorías que no cultivamos mueren con nosotros, o con nuestra sesión.

**La teoría es nuestro santo grial.** El código es solo una sombra. Pero las sombras pueden señalar hacia la luz, si sabemos leerlas.

---

*Este documento es vivo. Evoluciona con nuestra práctica.*
