# Autocompletado (Tab) para los comandos de ib-tools. Se carga desde ~/.bashrc.
_ib_opciones() {
  local cur="${COMP_WORDS[COMP_CWORD]}" opts="$1"
  COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}
_ib_genmake()  { _ib_opciones "-y -h"; }
_ib_nuevo()    { _ib_opciones "-y -h"; }
_ib_config()   { _ib_opciones "--ver --show --ruta --path -h"; }
_ib_update()   { _ib_opciones "--version -h"; }
_ib_estilo() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "-f -q --sin-color -h" -- "$cur"))
  else
    COMPREPLY=($(compgen -f -X '!*.@(cc|h)' -- "$cur"))
  fi
}
complete -F _ib_genmake genmake
complete -F _ib_nuevo nuevo
complete -F _ib_config ib-config
complete -F _ib_update ib-update
complete -F _ib_estilo estilo
