# Install Notes
- Install Guide / Formatting: https://nixos.org/manual/nixos/stable/#sec-installation
- nixos-generate-config --root /mnt
- sudo rm /mnt/etc/nixos/configuration.nix
- git clone git@github.com:NoelJarling/nixos-pc.git .
- nixos-install
- nixos-enter --root /mnt -c "passwd noel"