#!/usr/bin/env python3
"""
Deduplica escuelas agrupando por (ubicacion, nombre_normalizado).

Entrada:  id_seq, ubicacion, nombre_normalizado, codigo_escuela
Salida:   id_seq, ubicacion, nombre_normalizado, conteo, ids_escuela
"""

import csv
from collections import defaultdict
from pathlib import Path

RESULTADOS = Path(__file__).parent.parent / "results"


def deduplicar(archivo_entrada: Path, archivo_salida: Path) -> tuple[int, int]:
    """
    Agrupa filas por (ubicacion, nombre_normalizado).

    Retorna (filas_entrada, grupos_salida).
    """
    # Acumular: (ubicacion, nombre) → lista de id_seq de entrada
    grupos = defaultdict(list)

    with open(archivo_entrada, newline="", encoding="utf-8") as f:
        lector = csv.DictReader(f, delimiter="\t")
        for fila in lector:
            clave = (fila["ubicacion"], fila["nombre_normalizado"])
            grupos[clave].append(fila["id_seq"])

    filas_entrada = sum(len(ids) for ids in grupos.values())

    # Ordenar por ubicacion, luego por nombre_normalizado
    claves_ordenadas = sorted(grupos.keys())

    with open(archivo_salida, "w", newline="", encoding="utf-8") as f:
        escritor = csv.writer(f, delimiter="\t")
        escritor.writerow(["id_seq", "ubicacion", "nombre_normalizado", "conteo", "ids_escuela"])

        for id_seq, (ubicacion, nombre) in enumerate(claves_ordenadas, start=1):
            ids_origen = grupos[(ubicacion, nombre)]
            escritor.writerow([
                id_seq,
                ubicacion,
                nombre,
                len(ids_origen),
                ",".join(ids_origen)
            ])

    return filas_entrada, len(claves_ordenadas)


if __name__ == "__main__":
    for nombre in ["escuelas_pae", "tabla_sinec"]:
        entrada = RESULTADOS / f"{nombre}.tsv"
        salida = RESULTADOS / f"{nombre}-dedup.tsv"

        filas, grupos = deduplicar(entrada, salida)
        print(f"{nombre}: {filas} → {grupos} ({filas - grupos} fusionadas)")
