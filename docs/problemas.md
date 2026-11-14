# Problemas frecuentes

## `genmake: command not found` (o `run`, o `estilo`)

La terminal todavía no conoce la carpeta donde están los comandos. Prueba, por orden:

1. Abre una terminal nueva, o ejecuta `source ~/.bashrc`.
2. Comprueba que están instalados: `ls ~/.local/bin`. Deben aparecer `genmake`, `run` y `estilo`. Si no, vuelve a ejecutar `./install.sh`.
3. Comprueba el `PATH`: `echo $PATH`. Debe incluir `/home/tu-usuario/.local/bin`. Si no, añádelo con:

   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
   ```

## `Error: faltan tus datos (nombre y correo)`

`genmake` no encuentra tu archivo de configuración y no está en una terminal interactiva. Ejecuta `./install.sh` otra vez, o crea el archivo a mano:

```bash
mkdir -p ~/.config/ib-tools
cat > ~/.config/ib-tools/config <<'EOF'
IB_NOMBRE='Tu Nombre Apellidos'
IB_EMAIL=tu.correo@ull.edu.es
EOF
```

## `estilo` dice que no encuentra `cpplint` o `clang-format`

Instálalos:

```bash
sudo apt install clang-format pipx
pipx install cpplint
```

Cierra y abre la terminal. `pipx` deja `cpplint` en `~/.local/bin`, donde `estilo` lo busca.

## `error: externally-managed-environment` al instalar cpplint

Es normal en Ubuntu recientes: `pip` no deja instalar paquetes sueltos. Usa `pipx` como en el punto anterior, no `pip`.

## `multiple definition of 'main'` al compilar

Hay dos archivos `.cc` con un `main()` en la misma carpeta. El Makefile compila **todos** los `.cc`, así que solo puede haber uno. Usa una carpeta por ejercicio, o borra o renombra el archivo sobrante.

## `genmake` dice que un archivo ya existe y no lo toca

Es a propósito: `genmake` nunca sobrescribe tus `.cc` ni tus `.h`. Si de verdad quieres empezar de cero, borra tú el archivo y vuelve a ejecutarlo.

## Las funciones por defecto no aparecen en el `main`

Ocurre si `<nombre>_main.cc` ya existía: `genmake` no lo toca y te avisa de que añadas tú las llamadas a `PrintProgramPurpose` y `CheckCorrectParameters`. Las funciones sí estarán en `<nombre>.cc` y `<nombre>.h`.

## `./install.sh: Permission denied`

El instalador no tiene permiso de ejecución. Ejecútalo así: `bash install.sh`, o dale permiso con `chmod +x install.sh`.

## `error: undefined reference to ...` al compilar

El compilador no encuentra la definición de una función. Revisa que:

- la función está escrita en un `.cc` de esa carpeta (no solo declarada en el `.h`),
- su nombre y sus parámetros coinciden con los del prototipo,
- el `.cc` está en la misma carpeta que el `Makefile`.

## Quiero cambiar mi nombre o mi correo

Mira [Cambiar tu nombre o tu correo](instalacion.md#cambiar-tu-nombre-o-tu-correo).

## Sigo atascado

Abre un [issue](https://github.com/Broslunas/ib-tools/issues) con el comando que ejecutaste y el mensaje completo que te salió.
