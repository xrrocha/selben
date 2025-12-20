# Preámbulo

![Preámbulo](img/00-preambulo.png)

Este documento articula una filosofía de trabajo para proyectos de exploración computacional, aquellos donde no hay especificaciones a priori, donde el conocimiento debe descubrirse, y donde el objetivo no es entregar funcionalidad sino comprender profundamente.

Surge de la práctica: del [proyecto Selbén](https://github.com/xrrocha/selben), un ejercicio de resolución de nombres de entidad mal transcritos sobre datos ecuatorianos de 2003. Pero trasciende ese contexto particular. Es un marco general, destilado de experiencia y enriquecido por la sabiduría de [Peter Naur](https://en.wikipedia.org/wiki/Peter_Naur) (en inglés), nuestro santo patrono metodológico.

## Una Nota Sobre el "Nosotros"

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

[Inicio](index.md) | [Siguiente: Programar Es Construir Teoría →](01-programar-es-construir-teoria.md)
