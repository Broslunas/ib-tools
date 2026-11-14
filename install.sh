#!/usr/bin/env bash
# Instalador de ib-tools: genmake, run, estilo, ib-config, ib-update.
# ib-tools installer (works for any university).
#
# Uso:
#   ./install.sh                instala (o actualiza) los comandos
#   ./install.sh --desinstalar  borra los comandos de ~/.local/bin
#   ./install.sh --actualizar   actualiza sin volver a preguntar nada (lo usa ib-update)
#
# También funciona sin clonar el repositorio:
#   curl -fsSL https://raw.githubusercontent.com/Broslunas/ib-tools/main/install.sh | bash

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/Broslunas/ib-tools/main"
COMANDOS=(genmake run estilo ib-config ib-update)

bin="$HOME/.local/bin"
config="${XDG_CONFIG_HOME:-$HOME/.config}/ib-tools/config"

# Lee de la terminal también cuando el script llega por una tubería (curl | bash)
preguntar() {
  local entrada=/dev/stdin
  [[ -t 0 ]] || entrada=/dev/tty
  read -rp "$1" "$2" <"$entrada"
}

# ---------- Desinstalar ----------
if [[ "${1:-}" == "--desinstalar" ]]; then
  for c in "${COMANDOS[@]}"; do
    rm -f "$bin/$c"
  done
  echo "Comandos borrados de $bin."
  echo "Tus datos siguen en $config (bórralo a mano si quieres)."
  exit 0
fi

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  sed -n '2,11p' "${BASH_SOURCE[0]:-/dev/null}" 2>/dev/null | sed 's/^# \{0,1\}//'
  exit 0
fi

echo "== Instalador de ib-tools =="

actualizar=0
[[ "${1:-}" == "--actualizar" ]] && actualizar=1

# ---------- Origen de los comandos: carpeta bin/ del repo o descarga ----------
origen=""
descarga=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  carpeta="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [[ -d "$carpeta/bin" ]]; then
    origen="$carpeta/bin"
  fi
fi

if [[ -z "$origen" ]]; then
  if ! command -v curl >/dev/null; then
    echo "Error: hace falta curl (sudo apt install curl) o clonar el repositorio." >&2
    exit 1
  fi
  descarga="$(mktemp -d)"
  trap 'rm -rf "$descarga"' EXIT
  echo "Descargando los comandos de $REPO_RAW ..."
  for c in "${COMANDOS[@]}"; do
    curl -fsSL "$REPO_RAW/bin/$c" -o "$descarga/$c"
  done
  origen="$descarga"
fi

# ---------- Instalación ----------
mkdir -p "$bin"
for c in "${COMANDOS[@]}"; do
  cp "$origen/$c" "$bin/$c"
  chmod +x "$bin/$c"
done
echo "Instalados en $bin: ${COMANDOS[*]}"

# Versión instalada (para ib-update)
mkdir -p "$(dirname "$config")"
if [[ -f "$origen/../VERSION" ]]; then
  cp "$origen/../VERSION" "$(dirname "$config")/version"
else
  curl -fsSL "$REPO_RAW/VERSION" -o "$(dirname "$config")/version" 2>/dev/null || true
fi

# ---------- Tu perfil (nombre, universidad, asignatura...) ----------
if [[ $actualizar -eq 0 ]]; then
  echo
  "$bin/ib-config"
fi

# ---------- PATH ----------
nuevo_path=0
if [[ ":$PATH:" != *":$bin:"* ]]; then
  if ! grep -qs '\.local/bin' "$HOME/.bashrc"; then
    printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
    echo "Añadido ~/.local/bin al PATH en ~/.bashrc"
  fi
  nuevo_path=1
fi

# ---------- Herramientas para 'estilo' (opcional) ----------
faltan=()
command -v clang-format >/dev/null || faltan+=(clang-format)
if ! command -v cpplint >/dev/null && [[ ! -x "$bin/cpplint" ]]; then
  faltan+=(cpplint)
fi

if [[ ${#faltan[@]} -gt 0 && $actualizar -eq 0 ]]; then
  echo
  echo "Para el comando 'estilo' faltan: ${faltan[*]}"
  if command -v apt-get >/dev/null; then
    resp=""
    preguntar "¿Instalarlos ahora? Te pedirá la contraseña de sudo. [s/N] " resp
    if [[ "$resp" =~ ^[sSyY]$ ]]; then
      if [[ " ${faltan[*]} " == *" clang-format "* ]]; then
        sudo apt-get install -y clang-format || echo "Aviso: no se pudo instalar clang-format."
      fi
      if [[ " ${faltan[*]} " == *" cpplint "* ]]; then
        command -v pipx >/dev/null || sudo apt-get install -y pipx || true
        if command -v pipx >/dev/null; then
          pipx install cpplint || echo "Aviso: no se pudo instalar cpplint."
        else
          pip3 install --user cpplint 2>/dev/null \
            || pip3 install --user --break-system-packages cpplint \
            || echo "Aviso: no se pudo instalar cpplint."
        fi
      fi
    else
      echo "Vale. 'genmake' y 'run' funcionan igual; 'estilo' los necesitará."
    fi
  else
    echo "Instálalos con tu gestor de paquetes (clang-format y cpplint)."
  fi
fi

echo
echo "Listo. Comandos:"
echo "  genmake [nombre]   crea Makefile y archivos del ejercicio, preguntando paso a paso"
echo "  run [args]         recompila y ejecuta el programa del Makefile"
echo "  estilo [-f]        revisa (y con -f corrige) el estilo del código"
echo "  ib-config          cambia tu perfil (nombre, universidad, asignatura...)"
echo "  ib-update          actualiza ib-tools a la última versión"
if [[ "$nuevo_path" -eq 1 ]]; then
  echo
  echo "Abre una terminal nueva o ejecuta: source ~/.bashrc"
fi
