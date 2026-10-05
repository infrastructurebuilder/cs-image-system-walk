#!/bin/sh
set -eu
for p in tmux; do rpm -q "$p" >/dev/null 2>&1 || dpkg -s "$p" >/dev/null 2>&1 || if command -v dnf >/dev/null 2>&1; then sudo dnf -y install "$p"; elif command -v yum >/dev/null 2>&1; then sudo yum -y install "$p"; elif command -v apt-get >/dev/null 2>&1; then sudo apt-get install -y "$p"; else echo "csis ensure: no dnf, yum or apt-get to install $p" >&2; false; fi || exit 1; done
printf '%s' 'cm9sZT13b3JrZXIK' | base64 -d > /tmp/.csis-ensure && ( sudo cmp -s /tmp/.csis-ensure '/etc/team-node.conf' || sudo install -m 0644 /tmp/.csis-ensure '/etc/team-node.conf' ) && rm -f /tmp/.csis-ensure
