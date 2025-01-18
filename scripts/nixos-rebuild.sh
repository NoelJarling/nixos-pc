#!/usr/bin/env bash
set -e # Exit on non-zero status

# cd into config dir
pushd /etc/nixos

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --flake path:/etc/nixos/$(hostname)#default &>log/nixos-rebuild.log || (cat log/nixos-rebuild.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
echo "NixOS Rebuilt OK!"