#!/usr/bin/env bash
# Pruebas de ib-tools. Uso: tests/run-tests.sh   (desde cualquier carpeta)
set -uo pipefail

raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HOME; HOME="$(mktemp -d)"
export PATH="$raiz/bin:$PATH" NO_COLOR=1 LANG=es_ES.UTF-8
unset XDG_CONFIG_HOME XDG_DATA_HOME
mkdir -p "$HOME/.config/ib-tools"
cat > "$HOME/.config/ib-tools/config" <<'CFG'
IB_LANG=es
IB_NOMBRE='Ana Pérez'
IB_EMAIL=ana@ejemplo.edu
IB_UNIVERSIDAD='Universidad de Ejemplo'
IB_ASIGNATURA=Programación
IB_CURSO=2026-2027
CFG

fallos=0
ok()  { echo "  ok   $1"; }
mal() { echo "  FALLA $1"; fallos=$((fallos + 1)); }
prueba() { # prueba "descripción" comando...
  local d="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$d"; else mal "$d"; fi
}

echo "Sintaxis"
for f in "$raiz"/bin/* "$raiz/install.sh" "$raiz/completion/ib-tools.bash"; do
  prueba "bash -n $(basename "$f")" bash -n "$f"
done

echo "genmake -y"
t="$(mktemp -d)"; cd "$t"
prueba "crea archivos" genmake cuadrado -y
[[ -f Makefile && -f cuadrado_main.cc ]] && ok "Makefile y main" || mal "Makefile y main"
grep -q 'Universidad de Ejemplo' cuadrado_main.cc && ok "cabecera con perfil" || mal "cabecera con perfil"
grep -q '@author Ana Pérez ana@ejemplo.edu' cuadrado_main.cc && ok "@author" || mal "@author"
prueba "compila" make
prueba "nombre no válido falla" bash -c '! genmake "a b" -y'

echo "genmake interactivo con funciones"
t="$(mktemp -d)"; cd "$t"
printf 'ej\n\ns\n\ns\n2\na\nb\nhace algo\n\n' | genmake >/dev/null 2>&1
[[ -f ej.cc && -f ej.h && -f ej_main.cc ]] && ok "archivos de funciones" || mal "archivos de funciones"
grep -q 'kCorrectNumber = 2' ej_main.cc && ok "kCorrectNumber" || mal "kCorrectNumber"
grep -q '<a> <b>' ej.cc && ok "modo de uso" || mal "modo de uso"
prueba "compila con funciones" make
echo "// mío" >> ej.cc
prueba "no toca archivos existentes" bash -c 'genmake ej -y >/dev/null; grep -q "// mío" ej.cc'

echo "nuevo"
t="$(mktemp -d)"; cd "$t"
prueba "nuevo crea carpeta" nuevo ejemplo -y
[[ -f ejemplo/Makefile ]] && ok "Makefile dentro" || mal "Makefile dentro"

echo "run y estilo"
cd ejemplo
sed -i 's/  return 0;/  std::cout << "hola\\n";\n  return 0;/' ejemplo_main.cc
salida="$(run 2>&1)"
[[ "$salida" == *"hola"* && "$salida" == *"código 0"* ]] && ok "run ejecuta" || mal "run ejecuta"
prueba "estilo --sin-color funciona" bash -c 'estilo --sin-color; [[ $? -le 1 ]]'

echo "ib-config"
prueba "--ver" ib-config --ver
prueba "--ruta" ib-config --ruta

echo
if [[ $fallos -eq 0 ]]; then echo "Todo correcto."; else echo "$fallos prueba(s) fallaron."; fi
exit $((fallos > 0))
