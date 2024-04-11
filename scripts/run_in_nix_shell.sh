# Create dir for dotfiles (in live iso)
echo "---------------------------------------"
echo "-  Running commands inside nix-shell  -"
echo "---------------------------------------"

# remove old host and copy over template
echo "Remove old host and copy over default.nix template"

# remove old host (done here too because I've had some weird behaviour)
rm -rf hosts/main
mkdir -p hosts/main
cp templates/hosts/desktop/default.nix hosts/main/default.nix

# make dir for dotfiles
echo "Move dotfiles to new root."

cd ..
cp -r NixObscurely/ /etc/dotfiles/

# cd into that dir
cd /etc/dotfiles/

# remake old host
nixos-generate-config --root /mnt --dir /etc/dotfiles/hosts/main
rm -f hosts/main/configuration.nix
git add hosts/main

# Installing NixOS
echo "----------------------"
echo "-  Installing NixOS  -"
echo "----------------------"

USER=netrunner nixos-install --root /mnt --no-root-passwd --impure --flake .#main

# move dotfiles to mounted host
echo "Move dotfiles to the mounted host"

cp -r /etc/dotfiles /mnt/etc/dotfiles

echo "------------------------------"
echo "-  Done, you can now reboot!  "
echo "------------------------------"
