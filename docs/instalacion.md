# Instalación paso a paso

Esta guía te lleva desde cero hasta tener `genmake`, `run` y `estilo` funcionando. Tarda unos cinco minutos.

## Qué necesitas

- Una terminal de Linux. Normalmente, la de la **máquina virtual de prácticas**.
- `g++` y `make` (en la VM de prácticas ya están).
- `git` **o** `curl`, para descargar las herramientas.
- Opcional, para el comando `estilo`: `clang-format` y `cpplint`. El instalador te ofrece instalarlos.

### Comprueba que lo tienes

Copia estas líneas en la terminal. Cada una debe mostrar un número de versión:

```bash
g++ --version
make --version
git --version
```

Si alguna dice `command not found`, instálala con `sudo apt install g++ make git` (te pedirá la contraseña de sudo).

## Paso 1. Descarga las herramientas

Elige **una** de estas dos formas.

### Opción A: clonar el repositorio (recomendada)

```bash
git clone https://github.com/Broslunas/ib-tools.git
cd ib-tools
```

Es la mejor opción porque después puedes actualizar con un solo comando.

### Opción B: una línea con curl

No hace falta clonar nada. Salta al paso 2 con este comando, que descarga y ejecuta el instalador:

```bash
curl -fsSL https://raw.githubusercontent.com/Broslunas/ib-tools/main/install.sh | bash
```

> Es buena costumbre mirar un script antes de ejecutarlo. Puedes leerlo en [install.sh](../install.sh): copia tres archivos a `~/.local/bin` y añade esa carpeta al `PATH`.

## Paso 2. Ejecuta el instalador

Si has clonado el repositorio:

```bash
./install.sh
```

![Salida del instalador](img/01-instalacion.png)

El instalador hace esto, en orden:

1. **Te pregunta tu nombre y tu correo de la universidad.** Se guardan en `~/.config/ib-tools/config` y se usan en la cabecera (`@author`) de los archivos que crea `genmake`. Solo se piden la primera vez.
2. **Copia `genmake`, `run` y `estilo`** a `~/.local/bin`.
3. **Añade `~/.local/bin` al `PATH`** en tu `~/.bashrc`, si hacía falta.
4. **Te ofrece instalar `clang-format` y `cpplint`**, que usa el comando `estilo`. Responde `s` y escribe la contraseña de sudo cuando la pida (no se ve mientras la escribes, es normal). Si respondes `n`, `genmake` y `run` funcionan igual y `estilo` te avisará de qué le falta.

## Paso 3. Abre una terminal nueva

Para que el sistema encuentre los comandos nuevos, cierra la terminal y abre otra. Si no quieres cerrarla, ejecuta:

```bash
source ~/.bashrc
```

## Paso 4. Comprueba que funciona

```bash
which genmake run estilo
```

Debe mostrar tres rutas dentro de `~/.local/bin`. Haz ahora una prueba completa:

```bash
mkdir ~/prueba && cd ~/prueba
genmake -y
ls
```

Tiene que crear un `Makefile` y un archivo `prueba_main.cc`. Si es así, ya está todo listo. Puedes borrar la carpeta de prueba con `cd .. && rm -r prueba`.

Siguiente paso: [cómo se usa genmake](genmake.md).

## Actualizar a una versión nueva

Si instalaste clonando el repositorio:

```bash
cd ib-tools
git pull
./install.sh
```

Si usaste curl, vuelve a ejecutar la misma línea del paso 1. Tus datos (nombre y correo) se conservan.

## Cambiar tu nombre o tu correo

Edita el archivo de configuración:

```bash
nano ~/.config/ib-tools/config
```

Verás dos líneas, `IB_NOMBRE=...` y `IB_EMAIL=...`. Cámbialas, guarda (`Ctrl+O`, Enter) y sal (`Ctrl+X`). Los archivos que ya creaste no cambian; solo los nuevos.

## Desinstalar

Desde la carpeta del repositorio:

```bash
./install.sh --desinstalar
```

Borra los tres comandos de `~/.local/bin`. Tus datos siguen en `~/.config/ib-tools/config`; bórralos a mano si quieres (`rm -r ~/.config/ib-tools`).

## ¿Algo ha ido mal?

Mira [Problemas frecuentes](problemas.md).
