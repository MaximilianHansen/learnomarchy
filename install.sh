#!/usr/bin/env bash
#
# learnomarchy installer.
#
#   curl -fsSL https://raw.githubusercontent.com/MaximilianHansen/learnomarchy/main/install.sh | bash
#
# or, from a checkout:  ./install.sh
#
# Puts the game in ~/.local/share/learnomarchy, links ~/.local/bin/learnomarchy,
# adds a launcher entry, and offers a SUPER + ALT + L keybind. Re-run to update.
set -euo pipefail

REPO="https://github.com/MaximilianHansen/learnomarchy"
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/learnomarchy"
BIN="$HOME/.local/bin"
APPS="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
BINDINGS="$HOME/.config/hypr/bindings.lua"
KEY="SUPER + ALT + L"

say()  { printf '\e[1m✈ %s\e[0m\n' "$*"; }
warn() { printf '\e[33m! %s\e[0m\n' "$*" >&2; }
die()  { printf '\e[31m✗ %s\e[0m\n' "$*" >&2; exit 1; }
ask()  { # ask "prompt" -> 0 for yes. Reads the real terminal so `curl | bash` works.
  local a
  { printf '%s [Y/n] ' "$1" >/dev/tty && read -r a </dev/tty; } 2>/dev/null || return 1
  [[ ${a:-y} =~ ^[Yy]$ ]]
}

# ---------------------------------------------------------------- preflight
for t in hyprctl jq xdg-terminal-exec git; do
  command -v "$t" >/dev/null || die "needs '$t' — learnomarchy runs on Omarchy 4 (Hyprland)."
done
[[ -f $BINDINGS ]] || warn "no ~/.config/hypr/bindings.lua found — is this Omarchy 4? Installing anyway."

# ---------------------------------------------------------------- fetch
src=''
[[ -n ${BASH_SOURCE[0]:-} ]] && src=$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)
if [[ -n $src && -f $src/learnomarchy && -d $src/sounds && $src != "$DEST" ]]; then
  say "installing from $src"
  rm -rf "$DEST"; mkdir -p "$DEST"
  cp -r "$src/learnomarchy" "$src/sounds" "$DEST/"
else
  say "fetching $REPO"
  rm -rf "$DEST.tmp"
  git clone -q --depth 1 "$REPO" "$DEST.tmp"
  rm -rf "$DEST"; mv "$DEST.tmp" "$DEST"
fi
chmod +x "$DEST/learnomarchy"

# ---------------------------------------------------------------- link
mkdir -p "$BIN"
ln -sf "$DEST/learnomarchy" "$BIN/learnomarchy"

# ---------------------------------------------------------------- launcher entry
mkdir -p "$APPS"
cat > "$APPS/learnomarchy.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Learnomarchy
Comment=Learn to fly Omarchy — a keybind trainer that runs in your real window manager
Exec=$BIN/learnomarchy
Icon=input-keyboard
Terminal=false
Categories=Game;Education;
Keywords=omarchy;hyprland;keybind;keyboard;trainer;
DESKTOP
if command -v update-desktop-database >/dev/null; then update-desktop-database "$APPS" 2>/dev/null || true; fi

# ---------------------------------------------------------------- keybind
if [[ -f $BINDINGS ]] && ! grep -q learnomarchy "$BINDINGS"; then
  if ask "bind $KEY to launch it?"; then
    printf '\n-- learnomarchy: learn to fly Omarchy (%s)\no.bind("%s", "Learnomarchy", "%s")\n' \
      "$REPO" "$KEY" "$BIN/learnomarchy" >> "$BINDINGS"
    hyprctl reload >/dev/null 2>&1 || true
    say "bound $KEY"
  fi
fi

# ---------------------------------------------------------------- done
echo
say "installed $("$DEST/learnomarchy" --version 2>/dev/null || echo learnomarchy)"
[[ ":$PATH:" == *":$BIN:"* ]] || warn "$BIN is not on your PATH — run $BIN/learnomarchy, or log out and back in."
echo "  run:        learnomarchy"
grep -q learnomarchy "$BINDINGS" 2>/dev/null && echo "  or press:   $KEY"
echo "  uninstall:  learnomarchy --uninstall"
