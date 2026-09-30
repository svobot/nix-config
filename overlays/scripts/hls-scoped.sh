#!/usr/bin/env bash

set -euo pipefail

# hie-bios spawns cabal/ghc children that outlive haskell-language-server;
# stopping the scope once it exits is what actually reaps them.
unit="hls-$$-$RANDOM"

stop_unit() {
	systemctl --user --quiet stop "$unit.scope" 2>/dev/null || true
}
trap stop_unit EXIT
trap 'exit 143' TERM
trap 'exit 130' INT
trap 'exit 129' HUP

systemd-run --user --scope --quiet --unit "$unit" -- haskell-language-server-wrapper "$@" <&0 &
child=$!
wait "$child"
