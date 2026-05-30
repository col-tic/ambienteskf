#!/bin/bash
# install.sh — hydra-veil core installer

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

for _lib in ui log input network steps; do
    _path="$LIB_DIR/${_lib}.sh"
    if [ ! -f "$_path" ]; then
        echo "[ERROR] Missing lib: $_path" >&2
        exit 1
    fi
    source "$_path"
done

for arg in "$@"; do
    case "$arg" in
        --no-log) LOG_ENABLED="false" ;;
        --local)  FORCE_ENV="local"   ;;
    esac
done

_log_init

clear
print_header "HYDRA-VEIL CORE INSTALLER" "v1.0.0"
printf "  ${DIM}%s${RESET}\n" "Simplified Privacy"
printf "  ${DIM}%s${RESET}\n" "$(date '+%Y-%m-%d %H:%M:%S')  —  $(uname -n)"
print_divider

print_section "Pre-flight"
log_info "User:        ${USER}"
log_info "Home:        ${HOME}"
log_info "Install dir: ${HV_CORE_HOME}"
require_internet
print_divider

echo ""
label_info "hydra-veil core se instalará en:"
printf "  ${BCYAN}%s${RESET}\n\n" "$HV_CORE_HOME"
label_warn "sudo es requerido para sing-box, wrapper y sudoers."
echo ""
if ! ask_confirm "Continuar con la instalación?"; then
    log_warn "Instalación cancelada."
    exit 0
fi
echo ""
print_divider

step_clone_repo
step_create_env
step_python_env
step_singbox
step_wrapper
step_sudoers

echo ""
print_divider
printf "${BGREEN}"
cat << 'EOF'
                     _
          _        _|_|   _
         | \_    _| |   _/ |
         |   \__|___|__/   |
         |    | _   _ |    |
         |    || | | ||    |
          \_  || | | ||  _/
            \_||_| |_||_/
        ______|       |______
      _/                     \_
    _/   S I M P L I F I E D   \_
  _/        P R I V A C Y        \_
 |    _____               _____    |
 |  _/     |_           _|     \_  |
 |_/         |_       _|         \_|
               \_____/

EOF
printf "${RESET}"
print_divider
echo ""
label_ok "hydra-veil core instalado correctamente"
label_ok "Todos los steps completados"
echo ""
label_info "Activar entorno:"
printf "  ${CYAN}source %s/.venv/bin/activate${RESET}\n" "$HV_CORE_HOME"
echo ""
label_info "Wrapper disponible en:"
printf "  ${CYAN}sudo /usr/local/bin/hydraveil-singbox <config.json> start${RESET}\n"
echo ""
log_file_path
echo ""
print_divider
echo ""