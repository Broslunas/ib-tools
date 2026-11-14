# ib-config e ib-update

## ib-config: tu perfil

```bash
ib-config          # pregunta cada dato; Enter conserva el valor entre corchetes
ib-config --ver    # muestra el perfil guardado
ib-config --ruta   # dice dónde se guarda
```

| Dato | Para qué se usa |
| --- | --- |
| Idioma (`es`/`en`) | Idioma de los mensajes de los comandos y del texto que genera `genmake`. |
| Nombre y correo | `@author` de los archivos (obligatorios). |
| Universidad, centro, titulación | Primeras líneas de la cabecera. |
| Asignatura y curso | Última línea de la cabecera. El curso se propone según la fecha. |

Todo se guarda en `~/.config/ib-tools/config`. Solo afecta a los archivos que crees a partir de ahora.

## ib-update: actualizar

```bash
ib-update
```

Descarga la última versión del repositorio y reinstala los comandos, conservando tu perfil. Necesita `curl`.

`genmake` comprueba, como mucho una vez por semana, si hay una versión nueva y te lo recuerda con una línea al terminar. Si no hay internet, no dice nada.

`ib-update --version` muestra la versión instalada.
