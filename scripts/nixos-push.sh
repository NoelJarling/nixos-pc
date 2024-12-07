#!/usr/bin/env bash
set -e # Exit on non-zero status

# cd into config dir
pushd /etc/nixos

echo "Pushing to GitHub..."

git push origin main

echo "Removing old generations..."

sudo nix-collect-garbage -d &>log/nixos-push.log

tail -n 1 log/nixos-push.log

popd