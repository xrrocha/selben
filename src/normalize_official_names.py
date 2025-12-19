#!/usr/bin/env python3
"""
Normaliza los archivos oficiales de escuelas (PAE y SINEC).

Genera archivos tab-delimited con:
- ID secuencial
- Código de ubicación (6 dígitos: PPCCRR)
- Nombre normalizado (espacios colapsados)
- Código de escuela original
"""

import re
from pathlib import Path

ENCABEZADO = 'id_seq\tubicacion\tnombre_normalizado\tcodigo_escuela\n'


def normalizar_espacios(texto: str) -> str:
    """Colapsa espacios múltiples y recorta extremos."""
    return ' '.join(re.split(r'\s+', texto.strip()))


def procesar_pae(ruta_entrada: Path, ruta_salida: Path) -> int:
    """Procesa escuelas_pae.tsv."""
    with (
        open(ruta_entrada, encoding='utf-8') as entrada,
        open(ruta_salida, 'w', encoding='utf-8', newline='') as salida,
    ):
        next(entrada)  # saltar encabezado
        salida.write(ENCABEZADO)

        for i, linea in enumerate(entrada, start=1):
            campos = linea.rstrip('\n').split('\t')
            codigo = campos[0]
            nombre = normalizar_espacios(campos[1])
            ubicacion = campos[3]  # cod_parr ya es 6 dígitos
            salida.write(f'{i}\t{ubicacion}\t{nombre}\t{codigo}\n')

        return i


def procesar_sinec(ruta_entrada: Path, ruta_salida: Path) -> int:
    """Procesa tabla_sinec.tsv."""
    with (
        open(ruta_entrada, encoding='utf-8') as entrada,
        open(ruta_salida, 'w', encoding='utf-8', newline='') as salida,
    ):
        next(entrada)  # saltar encabezado
        salida.write(ENCABEZADO)

        for i, linea in enumerate(entrada, start=1):
            campos = linea.rstrip('\n').split('\t')
            codigo = campos[0]
            nombre = normalizar_espacios(campos[1])
            prov = int(campos[2])
            can = int(campos[3])
            parr = int(campos[4])
            ubicacion = f'{prov:02d}{can:02d}{parr:02d}'
            salida.write(f'{i}\t{ubicacion}\t{nombre}\t{codigo}\n')

        return i


def main():
    raiz = Path(__file__).resolve().parent.parent
    datos = raiz / 'data'
    resultados = raiz / 'results'
    resultados.mkdir(exist_ok=True)

    n_pae = procesar_pae(datos / 'escuelas_pae.tsv', resultados / 'escuelas_pae.tsv')
    n_sinec = procesar_sinec(datos / 'tabla_sinec.tsv', resultados / 'tabla_sinec.tsv')

    print(f'PAE: {n_pae} registros')
    print(f'SINEC: {n_sinec} registros')


if __name__ == '__main__':
    main()
