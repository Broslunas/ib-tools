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

La página está en `docs/index.html`. Para publicarla: en GitHub, **Settings → Pages → Build and deployment → Deploy from a branch → `main` / `/docs`**. Quedará en https://broslunas.github.io/ib-tools/.

Los enlaces a la documentación apuntan a los `.md` del repositorio en github.com.
