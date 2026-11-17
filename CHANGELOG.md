# Cambios / Changelog

## 1.3.2
- `genmake` acepta condiciones sobre el número de argumentos (`3`, `>= 2`, `> 2; < 5`, etc.).

## 1.3.1
- `genmake` permite argumentos adicionales y solo rechaza si faltan los mínimos indicados.

## 1.3.0
- Web nueva: https://tools.broslunas.com (fuente en `site/`).
- `run` y `estilo` también hablan inglés.
- `ib-config --ver` alinea bien los campos con tildes.

## 1.2.0
- Nuevo comando `nuevo <nombre>`: crea la carpeta del ejercicio y lanza `genmake` dentro.
- Autocompletado con Tab para todos los comandos.
- Colores en `run` y `estilo` (se desactivan con `NO_COLOR=1`; `estilo --sin-color`).
- Pruebas automáticas (`tests/run-tests.sh`) y GitHub Actions.
- Plantillas de issues, página web (`docs/index.html`) y releases por etiqueta.

## 1.1.0
- Perfil completo (universidad, centro, titulación, asignatura, curso, idioma) en el instalador.
- Cabecera de los archivos construida con tu perfil; sirve para cualquier universidad.
- Nuevos comandos `ib-config` e `ib-update`.
- Mensajes y documentación en español e inglés.

## 1.0.0
- Primera versión: `genmake`, `run` y `estilo`.
