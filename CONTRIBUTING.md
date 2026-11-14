# Para quien mantiene el repositorio

## Pruebas

```bash
bash tests/run-tests.sh
```

Se ejecutan solas en GitHub Actions con cada push y pull request.

## Publicar una versión

1. Cambia el número en `VERSION` y añade las novedades a `CHANGELOG.md`.
2. Commit y push a `main`.
3. Crea y sube la etiqueta (debe coincidir con `VERSION`):

   ```bash
   git tag v1.2.0
   git push --tags
   ```

GitHub Actions ejecuta las pruebas y crea la release con la lista de cambios. `ib-update` y el aviso de versión nueva leen el archivo `VERSION` de `main`.

## Página web

La web está publicada en https://tools.broslunas.com (Coolify, build pack Static, carpeta base `/docs`).

`docs/index.html` se genera, no se edita a mano:

```bash
python3 site/capture.py "$PWD" site/sessions.json   # opcional: vuelve a capturar las sesiones reales de la terminal
python3 site/build.py                                # genera docs/index.html
```

- `site/template.html`: la página (estilos, textos en español e inglés y animaciones).
- `site/sessions.json`: salidas reales de los comandos que reproduce la terminal animada.
- `site/changelog.json`: las novedades que salen en la web, en los dos idiomas.

Cuando cambies `VERSION`, añade la versión a `site/changelog.json` y vuelve a ejecutar `site/build.py`.
