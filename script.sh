#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

DEBUG=${CHEAT_SHEAT_DEBUG:-false}
VIEWER="${CHEAT_SHEAT_VIEWER:-less}"

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cheatsh"
mkdir -p "$CACHE_DIR"

b64safe() {
    echo -n "$1" | base64 | tr -d '=' | tr '/+' '_-'
}

fetch_cache() {
    local url="$1"
    local file="$2"
    if [[ $DEBUG == "true" ]]; then
        echo "fetching $url to $file"
    fi
    if [[ ! -f "$file" ]]; then
        curl -fsSL "$url" -o "$file"
    fi
}

# Contains a list of all languages
ROOT_CACHE="$CACHE_DIR/root"
fetch_cache "https://cheat.sh/:list" "$ROOT_CACHE"

# allow user to select a lang
LANG="$(cat "$ROOT_CACHE" | fzf)"
PATH_SO_FAR="$LANG"

ENC_LIST_LANG=$(b64safe "$LANG/:list")
LANG_LIST_CACHE="$CACHE_DIR/$ENC_LIST_LANG"

ENC_OPT=$(b64safe "$LANG")
OPT_CACHE="$CACHE_DIR/$ENC_OPT"

fetch_cache "https://cheat.sh/$PATH_SO_FAR/:list" "$LANG_LIST_CACHE"

CUR_CACHE="$LANG_LIST_CACHE"
while true; do 
    if [[ -z "$(tr -d '[:space:]' < "$LANG_LIST_CACHE")" ]]; then
        fetch_cache "https://cheat.sh/$PATH_SO_FAR" "$OPT_CACHE"
        break
    fi

    OPT="$(cat "$CUR_CACHE" | fzf)"
    PATH_SO_FAR="$PATH_SO_FAR/$OPT"

    ENC_OPT=$(b64safe "$PATH_SO_FAR")
    OPT_CACHE="$CACHE_DIR/$ENC_OPT"

    if [[ "$OPT" == */ ]]; then
        fetch_cache "https://cheat.sh/$PATH_SO_FAR/:list" "$OPT_CACHE"
        CUR_CACHE="$OPT_CACHE"
    else
        fetch_cache "https://cheat.sh/$PATH_SO_FAR" "$OPT_CACHE"
        break
    fi
done

$VIEWER "$OPT_CACHE"
