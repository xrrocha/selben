# V. El Código Como Literatura

![Código como literatura](img/05-codigo-como-literatura.png)

El código no es mera ingeniería. Es una forma de expresión. Como literatura, debe ser:

- **Legible**, no solo ejecutable, sino comprensible por humanos.
- **Elegante**, la solución más simple que funcione, no la más ingeniosa.
- **Honesto**, sin trucos que escondan complejidad, sin magia que evite explicación.

Esto implica resistir optimizaciones prematuras. Un bucle explícito es preferible a una comprensión de lista críptica si la primera se entiende en un vistazo. Los nombres de variables deben revelar intención, no ahorrar caracteres.

---

## El Estilo Español

En Selbén, tomamos una decisión deliberada: todo el código público, nombres de funciones, variables, comentarios, en español. Esto no es provincianismo; es coherencia. El dominio es ecuatoriano. Los datos hablan de parroquias, cantones, provincias. Forzar anglicismos sería traicionar el contexto.

```python
def normalizar_espacios(texto: str) -> str:
    """Colapsa espacios múltiples y recorta extremos."""
    return ' '.join(re.split(r'\s+', texto.strip()))
```

El código se lee. El código enseña. Si el lector potencial es ecuatoriano (o hispanohablante), el código debe hablar su idioma.

---

[← Anterior](04-pipeline-trazable.md) | [Inicio](index.md) | [Siguiente →](06-curiosidad-sobre-utilidad.md)
